variable "aws_region" {
  default = "us-east-1"
}
variable "http_port" {}
variable "jenkins_port" {}
variable "ssh_port" {}
variable "env" {}
variable "key_name" {}
variable "server_instance_type" {}
variable "count" {
  default = 1
}