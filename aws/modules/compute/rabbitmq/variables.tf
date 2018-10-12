variable "admin_password" {
  description = "Password for 'admin' user"
}

variable "count" {
  description = "Number of RabbitMQ nodes"
  default     = 3
}

variable "dns_zonename" {}

variable "elb_security_group_ids" {
  description = "Security groups which should have access to ELB (amqp + http ports)."
  type        = "list"
}

variable "env" {}

variable "instance_type" {
  default = "t3.micro"
}

variable "rabbit_exchanges" {
  description = "Exchanges on RabbitMQ nodes"
  type        = "list"
}

variable "rabbitmq_secret_cookie" {}

variable "rabbit_users" {
  description = "Users on RabbitMQ nodes"
  type        = "list"
}

variable "aws_region" {}

variable "key_name" {}

variable "ssh_security_group_ids" {
  description = "Security groups which should have SSH access to nodes."
  type        = "list"
}

variable "subnets" {
  type        = "list"
}

variable "vpc_id" {}

variable "zone_id" {}
