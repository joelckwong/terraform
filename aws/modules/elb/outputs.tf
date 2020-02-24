output "elb_dns_name" {
  value       = "${element(concat(aws_elb.this.*.dns_name, list("")), 0)}"
}

output "elb_id" {
  value       = aws_elb.this.id
}
