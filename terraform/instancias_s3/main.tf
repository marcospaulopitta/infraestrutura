provider "aws" {
  region = "sa-east-1"
}
variable "bucket_name" {
  type = string
}
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.bucket_name}"

  tags = {
    Name        = "Bucket_S3"
    Environment = "Desenvolvimento"
    Owner       = "Marcos Pitta"
  }
}

resource "aws_s3_bucket_website_configuration" "s3_bucket_website_configuration" {
  bucket = aws_s3_bucket.s3_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}
resource "aws_s3_bucket_public_access_block" "bucket_public_access_block" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
  
}
resource "aws_s3_bucket_ownership_controls" "bucket" {
  bucket = aws_s3_bucket.s3_bucket.id
    
    rule {
        object_ownership = "BucketOwnerPreferred"
    }
}
resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.s3_bucket.id
  depends_on = [ 
    aws_s3_bucket_ownership_controls.bucket,
    aws_s3_bucket_public_access_block.bucket_public_access_block
   ]
  acl = "public-read"
}
