#An expression to be used multiple times within a module.

variable "myname" {
   type = string
   description = "tag my resources"
    default     = "estee"
}



/*
variable "name" {} 
variable "env" {} 

locals {
  name_prefix = "${var.name}-${var.env}"
}
…
resource "aws_security_group" "allow_ssh" {
  name = "${local.name_prefix}-allow-ssh"
}

resource "aws_s3_bucket" "assets" {
  bucket = "${local.name_prefix}-assets"
}

*/