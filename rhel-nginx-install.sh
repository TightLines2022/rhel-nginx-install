#!/bin/bash
: '
This script is used to install Nginx on RHEL 9 utilizing configuration files to be inserted into 
nginx.conf during deployment.
 '

#Verify RHEL Subscription

subscription-manager register
subscription-manager auto-attach
subscription-manager attach

dnf update -y

dnf -y install nginx

#Add configuration settings from 'upstream_servers' and 'proxy_pass_location' to nginx.conf

sed -i '/http {/r upstream_servers' /etc/nginx/nginx.conf
sed -i -e'/server {/ { r proxy_pass_location' -e '; :L; n; bL;}'  /etc/nginx/nginx.conf

firewall-cmd --permanent --add-service=http

firewall-cmd --reload

#Set the httpd_can_network_connect SELinux boolean parameter to 1 to configure that SELinux allows NGINX to forward traffic.
setsebool -P httpd_can_network_connect 1

systemctl enable nginx

systemctl start nginx