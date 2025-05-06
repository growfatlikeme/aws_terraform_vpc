# The default provider configuration
provider "aws" {
  region = "ap-southeast-1"
}


/*
# Additional provider configuration; resources can
# reference this as `aws.east`.
provider "aws" {
  alias  = "east"
  region = "us-east-1"
}
*/