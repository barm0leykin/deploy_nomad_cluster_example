## AWS
provider "aws" {
  profile = "default"
  region  = var.region
}

resource "aws_default_vpc" "main" {
  enable_dns_support               = "true"
  enable_dns_hostnames             = "true"
  enable_classiclink               = "false"
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
      Name            = "private_subnet"
  }
}
resource "aws_subnet" "private_subnet" {
  cidr_block              = "10.0.11.0/24"
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-central-1a" #var.region #"us-east-1a"
  tags = {
      Name            = "private_subnet"
  }
}

resource "aws_key_pair" "root" {
  key_name   = "root"
  public_key = var.public_ssh_key
}

# EC2 instance
resource "aws_instance" "host" {
  for_each = var.hosts
  associate_public_ip_address = true
  ami           = each.value.ami
  instance_type = each.value.instance_type 
  key_name      = aws_key_pair.root.key_name
}

#########################
# output 
