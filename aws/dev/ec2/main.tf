terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "my-terraform-dev"
    region         = "us-east-1"
    dynamodb_table = "terraform-dev"
    key            = "ec2/terraform.tfstate"
  }
}

provider "aws" {
  region = "${var.aws_region}"
}

provider "random" {
}

data "terraform_remote_state" "vpc" {
 backend     = "s3"

 config {
   bucket = "my-terraform-dev"
   key    = "vpc/terraform.tfstate"
   region = "${var.aws_region}"
 }
}

module "ec2" {
  source = "../../modules/compute/ec2"
  instance_count = "${var.instance_count}"
  key_name = "${var.key_name}"
  env = "${var.env}"
  public_key_path = "${var.public_key_path}"
  instance_type = "${var.server_instance_type}"
  subnets = "${data.terraform_remote_state.vpc.web_subnets}"
  security_group = ["${data.terraform_remote_state.vpc.web_sg}"]
  web_subnet_ips = "${data.terraform_remote_state.vpc.web_subnet_ips}"
}

module "elb" {
  source = "../../modules/compute/elb"
  name = "elb-${var.env}"
  subnets         = ["${data.terraform_remote_state.vpc.web_subnets}"]
  security_groups = ["${data.terraform_remote_state.vpc.web_sg}"]
  internal        = false
  listener = [
    {
      instance_port     = "${var.http_port}"
      instance_protocol = "HTTP"
      lb_port           = "${var.http_port}"
      lb_protocol       = "HTTP"
    },
    {
      instance_port     = "${var.ssh_port}"
      instance_protocol = "TCP"
      lb_port           = "${var.ssh_port}"
      lb_protocol       = "TCP"
    },
  ]
  health_check = [
    {
      target              = "HTTP:${var.http_port}/"
      interval            = 30
      healthy_threshold   = 2
      unhealthy_threshold = 2
      timeout             = 5
    },
  ]
}

module "elb_attach" {
  source = "../../modules/compute/elb_attachment"
  instance_count = "${var.instance_count}"
  elb = "${module.elb.this_elb_id}"
  instance = "${module.ec2.instances}"
}
