terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "my-terraform-dev"
    region         = "us-east-1"
    dynamodb_table = "terraform-dev"
    key            = "jenkins/terraform.tfstate"
  }
}

locals {
  aws_region           = "us-east-1"
  num                  = 1
  env                  = "dev"
  key_name             = "Custom"
  server_instance_type = "t3.micro"
  instance_count       = 4
  http_port            = 80
  jenkins_port         = 8080
  ssh_port             = 22
}

provider "aws" {
  region = local.aws_region
}

provider "random" {
}

data "aws_ami" "this" {
  owners      = ["679593333241"]
  most_recent = true

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS *"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

data "aws_vpc" "this" {
  filter {
    name = "tag:Env"
    # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
    # force an interpolation expression to be interpreted as a list by wrapping it
    # in an extra set of list brackets. That form was supported for compatibility in
    # v0.11, but is no longer supported in Terraform v0.12.
    #
    # If the expression in the following list itself returns a list, remove the
    # brackets to avoid interpretation as a list of lists. If the expression
    # returns a single list item then leave it as-is and remove this TODO comment.
    values = [local.env]
  }
}

data "aws_subnet_ids" "app" {
  vpc_id = data.aws_vpc.this.id
  tags = {
    Name = "app-subnet*-${local.env}"
  }
}

data "aws_subnet_ids" "web" {
  vpc_id = data.aws_vpc.this.id
  tags = {
    Name = "web-subnet*-${local.env}"
  }
}

data "aws_security_groups" "app" {
  tags = {
    Name = "app-sg-${local.env}"
  }
}

data "aws_security_groups" "web" {
  tags = {
    Name = "web-sg-${local.env}"
  }
}

module "jenkins" {
  source          = "../../modules/compute/jenkins"
  num             = local.num
  key_name        = local.key_name
  env             = local.env
  image_id        = data.aws_ami.this.id
  instance_type   = local.server_instance_type
  subnet_ids      = data.aws_subnet_ids.app.ids
  security_groups = [data.aws_security_groups.app.ids]
  vpc_id          = data.aws_vpc.this.id
}

module "elb" {
  source          = "../../modules/compute/elb"
  name            = "elb-${local.env}"
  subnet_ids         = [data.aws_subnet_ids.web.ids]
  security_groups = [data.aws_security_groups.web.ids]
  internal        = false
  listener = [
    {
      instance_port     = local.jenkins_port
      instance_protocol = "TCP"
      lb_port           = local.http_port
      lb_protocol       = "TCP"
    },
    {
      instance_port     = local.ssh_port
      instance_protocol = "TCP"
      lb_port           = local.ssh_port
      lb_protocol       = "TCP"
    },
  ]
  health_check = [
    {
      target              = "TCP:${local.jenkins_port}"
      interval            = 30
      healthy_threshold   = 2
      unhealthy_threshold = 2
      timeout             = 5
    },
  ]
}

module "elb_attach" {
  source   = "../../modules/compute/elb_attachment"
  num      = local.num
  elb      = module.elb.this_elb_id
  instance = module.jenkins.instances
}
