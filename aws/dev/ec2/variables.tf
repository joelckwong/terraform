variable "aws_region" {
  default = "us-east-1"
}
# storage variables
variable "env" {}
# networking variables
variable "vpc_cidr" {}
variable "web_cidrs" {
  type = "list"
}
variable "app_cidrs" {
  type = "list"
}
variable "data_cidrs" {
  type = "list"
}
variable "accessip" {}
# compute variables
variable "key_name" {}
variable "public_key_path" {}
variable "server_instance_type" {}
variable "instance_count" {
  default = 1
}
