output "vpc_id" {
  value = "${aws_vpc.this.id}"
}

output "vpc_cidr" {
  value = "${aws_vpc.this.cidr_block}"
}

output "web_subnets" {
  value = "${aws_subnet.web.*.id}"
}

output "web_sg" {
  value = "${aws_security_group.web.id}"
}

output "web_subnet_ips" {
  value = "${aws_subnet.web.*.cidr_block}"
}

output "app_subnets" {
  value = "${aws_subnet.app.*.id}"
}

output "app_sg" {
  value = "${aws_security_group.app.id}"
}

output "app_subnet_ips" {
  value = "${aws_subnet.app.*.cidr_block}"
}

output "data_subnets" {
  value = "${aws_subnet.data.*.id}"
}

output "data_sg" {
  value = "${aws_security_group.data.id}"
}

output "data_subnet_ips" {
  value = "${aws_subnet.data.*.cidr_block}"
}
