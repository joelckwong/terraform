data "aws_ami" "this" {
  most_recent = true
  
  filter {
    name = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name = "name"
    values = ["amzn-ami-hvm*-x86_64-gp2"]
  }
  
  most_recent = true
}

data "template_file" "this" {
  count = 4
  template = "${file("${path.module}/userdata.tpl")}"

  vars {
    app_subnets = "${element(var.app_subnet_ips, count.index)}"
  }
}

resource "aws_instance" "this" {
  count = "${var.instance_count}"
  instance_type = "${var.instance_type}"
  ami = "${data.aws_ami.this.id}"
  tags {
    Name = "web-server-${var.env}-${count.index +1}"
    Env = "${var.env}"
  }
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${var.security_group}"]
  subnet_id = "${element(var.subnets, count.index)}"
  user_data = "${data.template_file.this.*.rendered[count.index]}"
}
