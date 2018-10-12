#!/bin/bash
yum update -y
yum install httpd -y
echo "Subnet for Web Server: ${app_subnets}" >> /var/www/html/index.html
service httpd start
chkconfig httpd on
