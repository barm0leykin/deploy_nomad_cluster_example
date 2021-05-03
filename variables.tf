variable "region" {
  default = "eu-central-1"
}

variable "amis" {
  #type = "map" # в 0.13 можно не писать - depricated
  default = {
    "us-east-1" = "ami-b374d5a5"
    "us-west-2" = "ami-fc0b939c"
    "eu-central-1" = "ami-0c960b947cbb2dd16" #ubuntu server 20.04
  }
}

variable vpc_cidr_block {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "CF_TOKEN" {
  default = ""
}
variable "public_ssh_key" {
  default = ""
}

###### HOSTS #######
variable "hosts" {
  #type    = "list"
  default = {
    awstest-1 = {
      hostname      = "awstest-1"
      role          = "server"
      ami           = "ami-0c960b947cbb2dd16" #var.amis[var.region] 
      instance_type = "t2.micro"
    },
    awstest-2 = {
      hostname      = "awstest-2"
      role          = "client"
      ami           = "ami-0c960b947cbb2dd16" #var.amis[var.region] 
      instance_type = "t2.micro"
    },
  }
}
