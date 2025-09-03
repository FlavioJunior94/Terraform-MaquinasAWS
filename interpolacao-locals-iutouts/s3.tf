resource "aws_s3_bucket" "this" {
    bucket = "meu-super-bucket"
  
    tags = {
        Service = "Curso Terraform"
        ManagedBy = "Terraform"
        Environment = var.environment
        Owner = "Flavio dos Santos Junior"
    }
}