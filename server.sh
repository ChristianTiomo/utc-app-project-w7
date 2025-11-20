#!/bin/bash

sudo yum update -y
sudo groupadd docker
sudo useradd John -aG docker 
sudo yum install git unzip wget httpd -y
#sudo yum install -y httpd 
sudo systemctl start httpd 
sudo systemctl enable httpd 
#echo '<h1>Deployed via Terraform</h1>' | sudo tee /var/www/html/index.html
sudo cd / opt
wget https://github.com/kserge2001/web-consulting/archive/refs/heads/dev.zip
unzip dev.zip
cd -r /opt/web-consulting-dev/*   /var/www/html/