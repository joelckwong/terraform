output "jenkins_dns_name" {
  value = aws_eip.this.public_dns
}

output "jenkins_instance_id" {
  value = aws_instance.this.id
}
