resource "aws_s3_bucket" "mailing_list_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_tag_name
  }
}

resource "aws_s3_object" "mailing_lists" {
  bucket = aws_s3_bucket.mailing_list_bucket.id
  key    = var.mailing_lists_folder_name
}

