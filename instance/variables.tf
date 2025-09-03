variable "aws_region" {
  type        = string
  description = ""
  #default     = "us-east-1"
  #definida agora em terraform.tfvars
}

variable "aws_profile" {
  type        = string
  description = ""
  #default     = "terraform"
  #definida agora em terraform.tfvars
}

variable "instance_ami" {
  type        = string
  description = ""
  #default     = "ami-00ca32bbc84273381"
  #definida agora em terraform.tfvars
}

variable "instance_type" {
  type        = string
  description = ""
  #default     = "t3.micro"
  #tirando o deafault, a variavel é requerida no momento do apply
}

variable "instance_tags" {
  type        = map(string)
  description = ""
  default = {
    Name    = "Amazon Linux"
    Project = " Curso AWS com Terraform"
  }
}