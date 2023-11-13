terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.23.1"
    }
  }
}

# Connect to aws.
provider "aws" {
  region = var.region
}

# Create security group.
resource "aws_security_group" "allow_22_80_8080_open" {
  name        = "open_22_80_8080"
  description = "Allow ports: 22 , 80 , 8080 open"
  dynamic "ingress" {
    for_each = var.allow_ports
    content {
    from_port   = ingress.value
    to_port     = ingress.value
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = merge( { Name = "allow_20_80_8080_open" }, var.tags )

}

# Create instance for Building.
resource "aws_instance" "build" {
  count         = var.quantity
  ami           = "ami-0fe8bec493a81c7da"
  instance_type = var.instance_type
  associate_public_ip_address = true
  tags = merge( { Name = "build" }, var.tags )
  vpc_security_group_ids = [aws_security_group.allow_22_80_8080_open.id]
  root_block_device {
    volume_size = 12
    volume_type = "gp2"
  }
  key_name = "aws___key_pair_rsa_1_"

  # Wait to ssh connect.
  provisioner "remote-exec" {
    inline = ["echo 'INSTANCE build UP !'"]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("../ansible/aws___key_pair_rsa_1_.pem")
      host        = self.public_dns
    }
  }

  provisioner "local-exec" {
    command = "echo '[LOCAL]' >> ./hosts && echo 'localhost' >> ./hosts && echo '[BUILD]' >> ./hosts && echo ${aws_instance.build[0].public_ip} >> ./hosts"  
  }
}

# Create instance for Deploy.
resource "aws_instance" "prod" {
  count         = var.quantity
  ami           = "ami-0fe8bec493a81c7da"
  instance_type = var.instance_type
  associate_public_ip_address = true
  tags = merge( { Name = "prod" }, var.tags )
  vpc_security_group_ids = [aws_security_group.allow_22_80_8080_open.id]
  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }
  key_name = "aws___key_pair_rsa_1_"

  # Wait to ssh connect.
  provisioner "remote-exec" {
    inline = ["echo 'INSTANCE prod UP !'"]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("../ansible/aws___key_pair_rsa_1_.pem")
      host        = self.public_dns
    }
  }

  provisioner "local-exec" {
    command = "echo '[PROD]' >> ./hosts && echo ${aws_instance.prod[0].public_ip} >> ./hosts"  
  }
}
