terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">3.0.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_s3_object" "example" {
  bucket = var.bucket-to-drift-id
  key    = "my-example-key"
  source = "./example.txt"
  
  tags = {
    Name        = "My Example Object"
    Environment = "production"
  }
}