aws_region = "us-east-1"
env = "dev"
vpc_cidr = "10.10.0.0/16"
web_cidrs = [
    "10.10.1.0/24",
    "10.10.2.0/24",
    "10.10.3.0/24",
    "10.10.4.0/24",
]
app_cidrs = [
    "10.10.10.0/24",
    "10.10.11.0/24",
    "10.10.12.0/24",
    "10.10.13.0/24"
  ]
data_cidrs = [
    "10.10.20.0/24",
    "10.10.21.0/24",
    "10.10.22.0/24",
    "10.10.23.0/24"
  ]
accessip = "0.0.0.0/0"
key_name = "dev_key"
public_key_path = "/home/jkwong/.ssh/dev.pub"
server_instance_type = "t2.micro"
instance_count = 4
