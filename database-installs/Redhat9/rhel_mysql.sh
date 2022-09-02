#!/bin/sh
dnf install mysql-server -y
systemctl start mysqld.service 
systemctl enable mysqld.service 
mysql_secure_installation
