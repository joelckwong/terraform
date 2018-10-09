variable "aws_region" {
  default = "us-east-1"
}
variable "http_port" {}
variable "ssh_port" {}
variable "env" {}
variable "key_name" {}
variable "public_key_path" {}
variable "server_instance_type" {}
variable "instance_count" {
  default = 1
}
