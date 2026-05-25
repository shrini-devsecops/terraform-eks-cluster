# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

variable "cluster_name" {
  default = "juno-uat-eks-02"
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
