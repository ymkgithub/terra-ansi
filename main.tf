terraform {
 required_providers {
  aws = {
   source = "hashicorp/aws"
  }
 }
}

data "terraform_remote_state" "eks_vpc" {
  backend = "s3"
  config = {
    bucket         = "terra-ansi"
    key            = "backup/statefile.tfstate"
    region         = "ap-south-1"  # Change to your desired region
    encrypt        = true         # Enable encryption if needed
  }
}