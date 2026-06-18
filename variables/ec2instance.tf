provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

resource "aws_instance" "example" {
  ami           = "ami-0ea1cddefe0c4aed5"
  instance_type = lookup(var.ami_id, var.aws_region)

  tags = {
    Name = "ExampleInstance"
  }

  security_groups = var.security_group_id
}

