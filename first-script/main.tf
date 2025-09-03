terraform {
  required_version = "1.9.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.11.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "terraform"

  #não recomendado, quando usar essas keys, nao precisa do profile acima.
  #access_key = ""
  #secret_key = ""
}

resource "aws_s3_bucket" "my-test-bucket" {
  bucket = "my-bucket-test-2302930428208"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
    Managedby   = "Terraform"
    Owner       = "Flavio dos Santos Junior"
    UpdateAt    = "2025-09-03"
  }
}

