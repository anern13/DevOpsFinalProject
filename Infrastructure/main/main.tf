
module "KP1_us-east" {
  source        = "../modules/keypair"
  providers     = { aws = aws.us-east-1 }
  key_name      = "KP1"
}


resource "local_sensitive_file" "keypair_KP1-east" {
  filename  = "${path.module}/${module.KP1_us-east.key_name}.pem"
  content   = "${module.KP1_us-east.private_key_pem}"
}


module "KP2_us-east" {    #Changed from oregon to N. Virginia
  source        = "../modules/keypair"
  providers     = { aws = aws.us-east-1 }
  key_name      = "KP2"
}


resource "local_sensitive_file" "keypair_KP2-east" {
  filename  = "${path.module}/${module.KP2_us-east.key_name}.pem"
  content   = "${module.KP2_us-east.private_key_pem}"
}



module "vpc" {
  source            = "../modules/vpc"
  providers         = { aws = aws.us-east-1 }
  vpc_name          = "Ansible_VPC"
  net_prefix        = "172.20"    #Changed from 172.30 to 172.20
  Control_Subnet_AZ = "us-east-1a"
  Managed_Subnet1_AZ = "us-east-1b" #Changed from 1 managed to 2 managed subnets
  Managed_Subnet2_AZ = "us-east-1c"
  source_ip         = var.source_ip
}

module "EC2_Control" {
  source     = "../modules/ec2"
  providers  = { aws = aws.us-east-1 }
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
  providers   = { aws = aws.us-east-1 }
  EC2_Name    = "EC2_app6${count.index+1}"
  private_ip  = "${module.vpc.Managed_Subnet2_Prefix}.6${count.index+1}"   # changed IP to 60.61 + 60.62
  type        = var.instance_type
  ami         = var.ec2_image_id_apps
  sg_id       = module.vpc.Managed_sg_id
  subnet_id   = module.vpc.Managed_subnet2_id     # 1 subnet for each group
  key_name    = module.KP2_us-east.key_name       # changed to KP2
  }


