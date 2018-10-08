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

resource "aws_key_pair" "this" {
  key_name = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

data "template_file" "this" {
  count = 4
  template = "${file("${path.module}/userdata.tpl")}"

  vars {
    web_subnets = "${element(var.web_subnet_ips, count.index)}"
  }
}

resource "aws_instance" "this" {
  count = "${var.instance_count}"
  instance_type = "${var.instance_type}"
  ami = "${data.aws_ami.this.id}"
  tags {
    Name = "web_server-${count.index +1}"
    Env = "${var.env}"
  }
  key_name = "${aws_key_pair.this.id}"
  vpc_security_group_ids = ["${var.security_group}"]
  subnet_id = "${element(var.subnets, count.index)}"
  user_data = "${data.template_file.this.*.rendered[count.index]}"
}
