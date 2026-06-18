variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "security_group_id" {
  type = list(string)
}

variable "AMIS" {
  type = map(any)
  default = {
    us-east-1 = "ami-0f40c8f97004632f9"
    us-east-2 = "ami-05692172625678b4e"
    us-west-2 = "ami-0352d5a37fb4f603f"
    us-west-1 = "ami-0f40c8f97004632f9"
  }
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "keyfiles/practice_key"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "keyfiles/practice_key.pub"
}

variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}