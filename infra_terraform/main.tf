## AWS
provider "aws" {
  profile                 = "terraform"
  region                  = var.aws.region
  shared_credentials_file = var.aws.credentials_file
}

resource "aws_default_vpc" "main" {
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "main"
  }
}

resource "aws_vpc" "main" {
  cidr_block                       = var.vpc_cidr_block #"10.0.0.0/8"
  instance_tenancy                 = "default"
  enable_dns_support               = "true"
  enable_dns_hostnames             = "true"
  assign_generated_ipv6_cidr_block = "false"
  enable_classiclink               = "false"
  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "public_subnet" {
  cidr_block              = "10.0.10.0/24"
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-central-1a" #var.region #"us-east-1a"
  tags = {
    Name = "private_subnet"
  }
}
resource "aws_subnet" "private_subnet" {
  cidr_block              = "10.0.11.0/24"
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-central-1a" #var.region #"us-east-1a"
  tags = {
    Name = "private_subnet"
  }
}

resource "aws_key_pair" "root" {
  key_name   = "id_rsa"
  #public_key = var.public_ssh_key
  public_key = file("~/.ssh/id_rsa.pub")
}

# EC2 instance
resource "aws_instance" "host" {
  for_each                    = var.hosts
  associate_public_ip_address = true
  ami                         = each.value.ami
  instance_type               = each.value.instance_type
  key_name                    = aws_key_pair.root.key_name
  // security_groups      = [ "aws_security_group.websrv_firewall.id" ]
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
    }
    # Задаём hostname
    inline = [
      "apt -y update && apt install -y python",
      "/usr/bin/hostnamectl set-hostname ${each.value.hostname}"
    ]
  }
}
