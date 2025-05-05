resource "aws_s3_bucket" "bucket1" {
  bucket = "growfatbucket"                        #Use a globally unique name
  force_destroy = true
}