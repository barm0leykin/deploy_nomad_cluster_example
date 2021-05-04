terraform {
  required_version = ">= 0.15"
  # remote terraform state on Terraform Cloud. Token: ~/.terraformrc
  // backend "remote" {
  //   organization = "barm0leykino"
  //   workspaces {
  //     name = "nomad-cluster"
  //   }
  // }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
    // tfe = {
    //   source = "hashicorp/tfe"
    // }
  }
}
