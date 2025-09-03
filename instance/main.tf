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
  region  = var.aws_region
  profile = var.aws_profile

}

resource "aws_instance" "web" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  subnet_id     = "subnet-0219d85f27667657e"

  tags = var.instance_tags

}
