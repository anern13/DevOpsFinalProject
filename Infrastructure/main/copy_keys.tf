resource "terraform_data" "copy_KP1_to_control" {
    depends_on = [  module.EC2_Control,                 # Just in case
                    module.KP1_us-east ]
    input = {
        key_checksum = sha256(local_sensitive_file.keypair_KP1-east.content)
    }
    provisioner "file" {
        source      = "${path.module}/KP1.pem"
        destination = "/home/ubuntu/KP1.pem"
        connection {
            type        = "ssh"
            user        = "ubuntu"
            private_key = module.KP1_us-east.private_key_pem
            host        = module.EC2_Control.Public_IP
    }
  }
    provisioner "remote-exec" {
        inline = [
            "chmod 0400 /home/ubuntu/KP1.pem",
            "chown ubuntu:ubuntu /home/ubuntu/KP1.pem"
        ]
       connection {
            type        = "ssh"
            user        = "ubuntu"
            private_key = module.KP1_us-east.private_key_pem
            host        = module.EC2_Control.Public_IP
    }
  }
}

resource "terraform_data" "copy_KP2_to_control" {
    depends_on = [  module.EC2_Control,                 # Just in case
                    module.KP2_us-east ]
    input = {
        key_checksum = sha256(local_sensitive_file.keypair_KP2-east.content)
    }
    provisioner "file" {
        source      = "${path.module}/KP2.pem"
        destination = "/home/ubuntu/KP2.pem"
        connection {
            type        = "ssh"
            user        = "ubuntu"
            private_key = module.KP1_us-east.private_key_pem
            host        = module.EC2_Control.Public_IP
    }
  }
    provisioner "remote-exec" {
        inline = [
            "chmod 0400 /home/ubuntu/KP2.pem",
            "chown ubuntu:ubuntu /home/ubuntu/KP2.pem"
        ]
       connection {
            type        = "ssh"
            user        = "ubuntu"
            private_key = module.KP1_us-east.private_key_pem
            host        = module.EC2_Control.Public_IP
    }
  }
}

