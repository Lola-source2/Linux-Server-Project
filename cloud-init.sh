#!/bin/bash
set -e

# Update system
apt update -y
apt upgrade -y

# Install Nginx
apt install nginx -y

# Enable and start Nginx
systemctl enable nginx
systemctl start nginx

# Create web page directory and index.html
mkdir -p /var/www/html

tee /var/www/html/index.html > /dev/null <<EOF
<h1>Welcome to Nginx Web Server</h1>
<p>This is a sample web page served by Nginx on an Ubuntu server.</p>
EOF

# Create group 
sudo groupadd sysadmin
