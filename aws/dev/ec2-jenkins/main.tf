terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "my-terraform-dev"
    region         = "us-east-1"
    dynamodb_table = "terraform-dev"
    key            = "ec2-jenkins/terraform.tfstate"
  }
}

locals {
aws_region = "us-east-1"
elb_tier = "web"
env = "dev"
hostname = "jenkins"
instance_tier = "app"
internal = false
jenkins_port = "8080"
key_name = "Custom"
lb_name = "dso-lb"
nexus_port = "8081"
server_instance_type = "t3.large"
sonarqube_port = "9000"
}

provider "aws" {
  region = local.aws_region
}

data "aws_ami" "this" {
  owners      = ["900892206871"]
  most_recent = true
  filter {
    name   = "name"
    values = ["centos7-pci-dss-*"]
  }
}

module "elb" {
  source = "../../modules/elb"
  env = local.env
  internal = local.internal
  jenkins_port = local.jenkins_port
  lb_name = local.lb_name
  nexus_port = local.nexus_port
  sonarqube_port = local.sonarqube_port
  tier = local.elb_tier
}

module "ec2-jenkins" {
  source = "../../modules/ec2-jenkins"
  elb_security_group = module.elb.elb_security_group
  env = local.env
  hostname = local.hostname
  image_id = data.aws_ami.this.id
  instance_type = local.server_instance_type
  ssh_key_name = local.key_name
  tier = local.instance_tier
}

module "elb-attachment" {
  source = "../../modules/elb-attachment"
  elb = module.elb.elb_id
  instance = module.ec2-jenkins.jenkins_instance_id
}
