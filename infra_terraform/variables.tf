variable "aws" {
  type = map(any)
  default = {
    region           = "eu-central-1"
    credentials_file = "~/.aws/credentials"
  }
  sensitive = true
}

variable "amis" {
  #type = "map" # в 0.13 можно не писать - depricated
  default = {
    "us-east-1"    = "ami-b374d5a5"
    "us-west-2"    = "ami-fc0b939c"
    "eu-central-1" = "ami-0c960b947cbb2dd16" #ubuntu server 20.04
  }
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "cloudflare" {
  type = map(any)
  default = {
    email   = "andreyka001@gmail.com"
    api_key = ""
    #api_key = file("~/keys/cf_dns_token")
  }
  sensitive = true
}

variable "public_ssh_key" {
  default   = ""
  sensitive = true
}

###### HOSTS #######
variable "hosts" {
  #type    = "list"
  default = {
    nomad-srv-01 = {
      hostname      = "nomad-srv-01"
      role          = "server"
      ami           = "ami-0c960b947cbb2dd16" #var.amis[var.region]
      instance_type = "t2.micro"
    },
   nomad-client-01 = {
      hostname      = "nomad-client-01"
      role          = "client"
      ami           = "ami-0c960b947cbb2dd16" #var.amis[var.region]
      instance_type = "t2.micro"
    },
  }
}
