variable "env" {}
variable "key_name" {}
variable "image_id" {}

variable "count" {}
variable "instance_type" {}
variable "security_groups" {
  type = "list"
}
variable "subnets" {
  type = "list"
}
variable "vpc_id" {}
