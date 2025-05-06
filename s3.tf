resource "aws_s3_bucket" "bucket1" {
  bucket = "${var.myname}-bucket"                        #Use a globally unique name
  force_destroy = true
}