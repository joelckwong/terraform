#!/bin/bash
yum update -y
yum -y install yum-utils device-mapper-persistent-data lvm2 git
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum -y install docker-ce
systemctl enable docker
systemctl start docker
echo 'vm.max_map_count=262144' >> /etc/sysctl.conf sysctl -p
usermod -aG docker centos
curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
sudo -u jenkins "cd /home/centos; git clone https://github.com/joelckwong/jenkins-sonaqube-pipeline.git"
sudo -u jenkins "cd /home/centos/jenkins-sonaqube-pipeline/run.sh"
