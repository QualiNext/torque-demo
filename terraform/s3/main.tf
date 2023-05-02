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

# comment number two
# one more here
data "aws_iam_user" "input_user" {
  count = "${var.user == "none" ? 0 : 1}"
  user_name = var.user
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.name
  force_destroy = true

  # my tags
  # one more comment
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
    AMAZING_TAG = "NEW_AMAZING_VALUE"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "example" {                                                                   
    bucket = aws_s3_bucket.bucket.id
    rule {
      object_ownership = "BucketOwnerPreferred"
    } 
  }


resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [aws_s3_bucket_public_access_block.example,
                aws_s3_bucket_ownership_controls.example,
  ]
  bucket = aws_s3_bucket.bucket.id

  acl = "public-read"
}

#my comment
#my 2nd comment
#my 3rd comment
resource "aws_iam_policy" "policy" {
  count = "${var.user == "none" ? 0 : 1}"
  name        = "s3_access_${var.name}"
  path        = "/"
  description = "Policy to access S3 Module"  
  # refactor required here
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
        {
        Effect: "Allow",
        Action: ["s3:ListBucket"],
        Resource: ["arn:aws:s3:::${var.name}"]
        },
        {
        Effect: "Allow",
        Action: [
            "s3:PutObject",
            "s3:GetObject",
            "s3:DeleteObject"
        ],
        Resource: ["arn:aws:s3:::${var.name}/*"]
        }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "attachment" {  
    count = "${var.user == "none" ? 0 : 1}"
    user       = data.aws_iam_user.input_user[0].user_name 
    policy_arn = aws_iam_policy.policy[0].arn
}

resource "aws_s3_object" "example" {
  bucket = aws_s3_bucket.bucket.id
  key    = "my-example-key"
  source = "./example.txt"
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.bucket.arn
}

output "bucket_to_drift_id" {
  value = aws_s3_bucket.bucket.id
}
