resource "aws_s3_bucket" "mailing_list_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "Mailing list bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_object" "mailing_lists" {
  bucket = "${aws_s3_bucket.mailing_list_bucket.id}"
  key = "mailing_lists"
}
