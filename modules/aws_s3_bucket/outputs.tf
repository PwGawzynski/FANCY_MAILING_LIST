output "bucket_id" {
  description = "Shared bucket id"
  value       = aws_s3_bucket.mailing_list_bucket.id
}

output "bucket_arn" {
  description = "Shared bucket arn"
  value = aws_s3_bucket.mailing_list_bucket.arn
}

output "mailing_lists_folder_name" {
  description = "Folder used to store mailing lists"
  value = var.mailing_lists_folder_name
}
