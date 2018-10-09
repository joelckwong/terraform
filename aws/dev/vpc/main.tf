terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "my-terraform-dev"
    region         = "us-east-1"
    dynamodb_table = "terraform-dev"
    key            = "vpc/terraform.tfstate"
  }
}

provider "aws" {
  region = "${var.aws_region}"
}

module "networking" {
  source = "../../modules/networking"
  vpc_cidr = "${var.vpc_cidr}"
  web_cidrs = "${var.web_cidrs}"
  app_cidrs = "${var.app_cidrs}"
  data_cidrs = "${var.data_cidrs}"
  env = "${var.env}"
  accessip = "${var.accessip}"
}
