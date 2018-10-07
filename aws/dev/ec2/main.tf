#------------------aws/main.tf-------------------
terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "my-terraform-dev"
    region         = "us-east-1"
    dynamodb_table = "terraform-dev"
    key            = "dev/terraform.tfstate"
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

module "ec2" {
  source = "../../modules/compute/ec2"
  instance_count = "${var.instance_count}"
  key_name = "${var.key_name}"
  public_key_path = "${var.public_key_path}"
  instance_type = "${var.server_instance_type}"
  subnets = "${module.networking.web_subnets}"
  security_group = ["${module.networking.web_sg}"]
  web_subnet_ips = "${module.networking.web_subnet_ips}"
}

module "elb" {
  source = "../../modules/compute/elb"
  name = "elb-${var.env}"
  subnets         = ["${module.networking.web_subnets}"]
  security_groups = ["${module.networking.web_sg}"]
  internal        = false
  listener = [
    {
      instance_port     = "80"
      instance_protocol = "HTTP"
      lb_port           = "80"
      lb_protocol       = "HTTP"
    },
    {
      instance_port     = "22"
      instance_protocol = "TCP"
      lb_port           = "22"
      lb_protocol       = "TCP"
    },
  ]
  health_check = [
    {
      target              = "HTTP:80/"
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
