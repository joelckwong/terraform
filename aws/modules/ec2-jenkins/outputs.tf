output "jenkins_dns_name" {
  value = aws_eip.this.public_dns
}
