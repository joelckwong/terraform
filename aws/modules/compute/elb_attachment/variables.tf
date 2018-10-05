variable "instance_count" {
  description = "Number of instances ID to place in the ELB pool"
}

variable "elb" {
  description = "The name of the ELB"
}

variable "instance" {
  description = "List of instances ID to place in the ELB pool"
  type        = "list"
}
