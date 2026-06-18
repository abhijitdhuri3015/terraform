provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "us-east-2"
}

# resource "aws_instance" "example" {
#   ami           = "ami-0ea1cddefe0c4aed5"
#   instance_type = "t2.micro"

#   tags = {
#     Name = "ExampleInstance"
#   }
# }

# To create multiple instances, we can use the 'count' meta-argument. This allows us to specify how many instances we want to create, and Terraform will create that many resources based on the configuration provided.
resource "aws_instance" "example" {
    count = 3
  ami           = "ami-0ea1cddefe0c4aed5"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleInstance-${count.index + 1}"
  }
}
