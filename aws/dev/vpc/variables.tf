variable "aws_region" {
  default = "us-east-1"
}
variable "env" {}
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
