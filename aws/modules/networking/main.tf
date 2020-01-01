data "aws_availability_zones" "available" {}

resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = { 
    Env = var.env
    Name = "vpc-${var.env}"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id =  aws_vpc.this.id

  tags = {
    Env = var.env
    Name = "igw-${var.env}"
  }
} 

resource "aws_eip" "this" {
  vpc = true

  tags = {
    Env = var.env
    Name = "natgw-ip-${var.env}"
  }
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id = aws_subnet.web.0.id
  depends_on = [aws_internet_gateway.this]
}

resource "aws_route_table" "web" {
  vpc_id =  aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Env = var.env
    Name = "web-rt-${var.env}"
  }
}

resource "aws_default_route_table" "this" {
  default_route_table_id =  aws_vpc.this.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = {
    Env = var.env
    Name = "default-rt-${var.env}"
  }
}

resource "aws_subnet" "web" {
  count = 4
  vpc_id = aws_vpc.this.id
  cidr_block = var.web_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Env = var.env
    Name = "web-subnet-${count.index + 1}-${var.env}"
  }
}

resource "aws_subnet" "app" {
  count = 4
  vpc_id = aws_vpc.this.id
  cidr_block = var.app_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Env = var.env
    Name = "app-subnet-${count.index + 1}-${var.env}"
  }
}

resource "aws_subnet" "data" {
  count = 4
  vpc_id = aws_vpc.this.id
  cidr_block = var.data_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Env = var.env
    Name = "data-subnet-${count.index + 1}-${var.env}"
  }
}

resource "aws_route_table_association" "web" {
  count = length(aws_subnet.web)
  subnet_id = aws_subnet.web.*.id[count.index]
  route_table_id = aws_route_table.web.id
}

resource "aws_route_table_association" "app" {
  count = length(aws_subnet.app)
  subnet_id = aws_subnet.app.*.id[count.index]
  route_table_id = aws_default_route_table.this.id
}

resource "aws_route_table_association" "data" {
  count = length(aws_subnet.data)
  subnet_id = aws_subnet.data.*.id[count.index]
  route_table_id = aws_default_route_table.this.id
}

resource "aws_security_group" "web" {
  name = "web-sg"
  description = "Used for access to the public web instances"
  vpc_id = aws_vpc.this.id

  #ssh
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [var.accessip]
  }

  #http
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [var.accessip]
  }

  #https
  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = [var.accessip]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
  }

 tags = {
    Env = var.env
    Name = "web-sg-${var.env}"
  }
}

resource "aws_security_group" "app" {
  name = "app_sg"
  description = "Used for access to the private app instances"
  vpc_id = aws_vpc.this.id

  #ssh
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["${var.accessip}"]
  }


  #http
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["${var.accessip}"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  tags = {
    Env = var.env
    Name = "app-sg-${var.env}"
  }

}

resource "aws_security_group" "data" {
  name = "data_sg"
  description = "Used for access to the private data instances or dbs"
  vpc_id = aws_vpc.this.id

  #ssh
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [var.accessip]
  }

  #postgres
  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    cidr_blocks = [var.accessip]
  }

  #redis
  ingress {
    from_port = 6379
    to_port   = 6379
    protocol  = "tcp"
    cidr_blocks = [var.accessip]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Env = var.env
    Name = "data-sg-${var.env}"
  }
}
