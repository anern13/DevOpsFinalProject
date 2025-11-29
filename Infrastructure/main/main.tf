
module "KP1_us-east" {
  source        = "../modules/keypair"
  providers     = { aws = aws.us-east-2 }
  key_name      = "KP1"
}


resource "local_sensitive_file" "keypair_KP1-east" {
  filename  = "${path.module}/${module.KP1_us-east.key_name}.pem"
  content   = "${module.KP1_us-east.private_key_pem}"
}


module "KP2_us-east" {    #Changed from oregon to N. Virginia
  source        = "../modules/keypair"
  providers     = { aws = aws.us-east-2 }
  key_name      = "KP2"
}


resource "local_sensitive_file" "keypair_KP2-east" {
  filename  = "${path.module}/${module.KP2_us-east.key_name}.pem"
  content   = "${module.KP2_us-east.private_key_pem}"
}



module "vpc" {
  source            = "../modules/vpc"
  providers         = { aws = aws.us-east-2 }
  vpc_name          = "Ansible_VPC"
  net_prefix        = "172.20"    #Changed from 172.30 to 172.20
  Control_Subnet_AZ = "us-east-2a"
  Managed_Subnet1_AZ = "us-east-2b" #Changed from 1 managed to 2 managed subnets
  Managed_Subnet2_AZ = "us-east-2c"
  source_ip         = var.source_ip
}

module "EC2_Control" {
  source     = "../modules/ec2"
  providers  = { aws = aws.us-east-2 }
  depends_on = [            # Changed dependencies
                  module.ec2_apps , 
                  module.KP1_us-east ,
                  module.KP2_us-east  ]
                  
  EC2_Name   = "Control_EC2"
  private_ip = "${module.vpc.Control_Subnet_Prefix}.11"    #Changed from 111 to 11
  type       = var.instance_type
  ami        = var.ec2_image_id_public
  sg_id      = module.vpc.Control_sg_id
  subnet_id  = module.vpc.Control_subnet_id
  key_name   = module.KP1_us-east.key_name
  user_data  = local.ansible_install_user_data
  }


module "ec2_apps" {
  source      = "../modules/ec2"
  count       = 3
  providers   = { aws = aws.us-east-2 }
  EC2_Name    = "EC2_app6${count.index+1}"
  private_ip  = "${module.vpc.Managed_Subnet2_Prefix}.6${count.index+1}"   # changed IP to 60.61 + 60.62
  type        = var.instance_type
  ami         = var.ec2_image_id_apps
  sg_id       = module.vpc.Managed_sg_id
  subnet_id   = module.vpc.Managed_subnet2_id     # 1 subnet for each group
  key_name    = module.KP2_us-east.key_name       # changed to KP2
  user_data   = local.app_install_user_data
  }

resource "terraform_data" "reload_apps_user_data" {
  depends_on = [module.ec2_apps]
  triggers_replace = {
    user_data_sha = sha256(local.app_install_user_data)
  }
}

# Security group for ALB to allow public HTTP/HTTPS
resource "aws_security_group" "alb_sg" {
  provider    = aws.us-east-2
  name        = "alb-public-sg"
  description = "Public ingress for ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Allow ALB to reach app instances on HTTP
resource "aws_security_group_rule" "managed_allow_alb_http" {
  provider                  = aws.us-east-2
  type                      = "ingress"
  from_port                 = 5000
  to_port                   = 5000
  protocol                  = "tcp"
  security_group_id         = module.vpc.Managed_sg_id
  source_security_group_id  = aws_security_group.alb_sg.id
}

resource "aws_lb" "web_alb" {
  provider           = aws.us-east-2
  name               = "midterm-web-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [
    module.vpc.Control_subnet_id,
    module.vpc.Managed_subnet1_id,
    module.vpc.Managed_subnet2_id
  ]
}

resource "aws_lb_target_group" "app_tg" {
  provider    = aws.us-east-2
  name_prefix = "midapp"
  port        = 5000
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = module.vpc.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  stickiness {
    enabled         = true
    type            = "lb_cookie"
    cookie_duration = 86400
  }

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 5
  }
}

resource "aws_lb_listener" "http" {
  provider          = aws.us-east-2
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "apps" {
  provider          = aws.us-east-2
  count             = length(module.ec2_apps)
  target_group_arn  = aws_lb_target_group.app_tg.arn
  target_id         = module.ec2_apps[count.index].instance_id
  port              = 5000
}


