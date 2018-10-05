variable "key_name" {}

variable "public_key_path" {}

variable "web_subnet_ips" {
  type = "list"
}

variable "instance_count" {}
variable "instance_type" {}
variable "security_group" {
  type = "list"
}
variable "subnets" {
  type = "list"
}
