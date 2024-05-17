variable "bucket_name" {
  default = "mailinglistbucketpwgawzynski"
  type    = string
}
variable "bucket_tag_name" {
  description = "Bucket tag name"
  default = "Mailing list bucket"
  type = string
}
variable "mailing_lists_folder_name" {
  description = "Folder name where mailing list are stored"
  default = "mailing_lists/"
}