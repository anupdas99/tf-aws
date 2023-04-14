#!/bin/bash

yum update -y
yum install httpd -y
systemctl start httpd.service
systemctl enable httpd.service
echo "<h1>${server_name}</h1><p>This is my HTTP server</p>" > /var/www/html/index.html
