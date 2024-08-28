#!/bin/bash
apt-get update -y
apt-get install -y apache2
systemctl start apache2
systemctl enable apache2
echo "<h1>This is a Test WebServer for TekSystems</h1>" > /var/www/html/index.html
