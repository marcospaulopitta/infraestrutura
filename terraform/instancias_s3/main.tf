provider "aws" {
  region = "sa-east-1"
}
variable "bucket_name" {
  type = string
}
resource "aws_s3_bucket" "redirecionador" {
  bucket = "bucket-redirecionador-${var.bucket_name}"

  tags = {
    Name        = "Redirecionador S3"
    Environment = "Desenvolvimento"
    Owner       = "Marcos Pitta"
  }
}

resource "aws_s3_bucket_website_configuration" "redirecionador_website" {
  bucket = aws_s3_bucket.redirecionador.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}
resource "aws_s3_bucket_public_access_block" "redirecionador_public_access_block" {
  bucket = aws_s3_bucket.redirecionador.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
  
}
resource "aws_s3_bucket_ownership_controls" "redirecionador" {
    bucket = aws_s3_bucket.redirecionador.id
    
    rule {
        object_ownership = "BucketOwnerPreferred"
    }
}
resource "aws_s3_bucket_acl" "redirecionador_acl" {
  bucket = aws_s3_bucket.redirecionador.id
  depends_on = [ 
    aws_s3_bucket_public_access_block.redirecionador_public_access_block,
    aws_s3_bucket_ownership_controls.redirecionador,
   ]
  acl = "public-read"
}
