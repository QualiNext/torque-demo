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

resource "aws_s3_bucket_object" "addtag" {
  bucket = var.bucket-to-drift-id
  
  tags = {
    DriftTag        = "Woohoo"
  }
}

# output "s3_bucket_arn" {
#   value = aws_s3_bucket.bucket.arn
# }
