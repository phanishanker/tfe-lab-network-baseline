terraform {
  required_version = ">= 1.8.0"

  cloud {
    organization = "acme-platform-terraform"

    workspaces {
      name = "network-nonprod"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
