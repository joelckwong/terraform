data "aws_vpc" "this" {
  tags = {
    Name = "vpc-${var.env}"
  }
}

data "aws_subnet" "this" {
  vpc_id = data.aws_vpc.this.id
  tags = {
    Name = "web-subnet-${var.env}-1"
  }
}

resource "aws_security_group" "this" {
  vpc_id = data.aws_vpc.this.id
  ingress {
    from_port   = 22
    to_port     = 22
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
  vpc_security_group_ids = ["${aws_security_group.this.id}"]
  subnet_id = data.aws_subnet.this.id
  user_data = "${path.module}/userdata.tpl"
}

resource "aws_eip" "this" {
  instance = aws_instance.this.id
  vpc      = true
}
