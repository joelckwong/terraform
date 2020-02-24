data "aws_vpc" "this" {
  tags = {
    Name = "vpc-${var.env}"
  }
}

data "aws_subnet" "this" {
  vpc_id = data.aws_vpc.this.id
  tags = {
    Name = "${var.tier}-subnet-${var.env}-1"
  }
}

data "aws_security_group" "bastion" {
  tags = {
    Name = "bastion-${var.env}"
  }
}

data "template_file" "this" {
  template = "${file("${path.module}/userdata.tpl")}"
}

resource "aws_security_group" "this" {
  vpc_id = data.aws_vpc.this.id
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "this" {
  instance_type = var.instance_type
  ami = var.image_id
  tags = {
    Name = var.hostname
    Env = var.env
  }
  key_name = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.this.id, data.aws_security_group.bastion.id, var.elb_security_group]
  subnet_id = data.aws_subnet.this.id
  user_data = data.template_file.this.rendered
}
