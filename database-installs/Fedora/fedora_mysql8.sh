#!/bin/sh
sudo systemctl start httpd
sudo systemctl enable httpd
dnf install community-mysql-server
sudo systemctl start mysqld.service
sudo systemctl enable mysqld.service
sudo mysql_secure_installation
