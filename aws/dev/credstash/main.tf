terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "my-terraform-dev"
    region         = "us-east-1"
    dynamodb_table = "terraform-dev"
    key            = "credstash/terraform.tfstate"
  }
}

provider "aws" {
  region = "${var.aws_region}"
}

provider "credstash" {
  table  = "${var.env}-credential-store"
  region = "${var.aws_region}"
}

data "credstash_secret" "credstash_credentials_table" {
  name = "credstash_credentials_table"
}

data "credstash_secret" "credstash_encryption_key" {
  name = "credstash_encryption_key"
}

module "credstash-policy" {
  source = "../../modules/iam/credstash"

  environment       = "${var.env}"
  credentials_table = "${data.credstash_secret.credstash_credentials_table.value}"
  encryption_key    = "${data.credstash_secret.credstash_encryption_key.value}"
}
