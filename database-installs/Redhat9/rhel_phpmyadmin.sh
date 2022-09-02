#!/bin/sh
dnf -y install php
dnf -y install php-zip php-json php-fpm
yum -y install php-mysqlnd
systemctl enable --now php-fpm
systemctl start httpd.service
systemctl enable httpd.service
wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz
tar xvf phpMyAdmin-latest-all-languages.tar.gz
rm phpMyAdmin-latest-all-languages.tar.gz
mv phpMyAdmin-*/ /usr/share/phpmyadmin
mkdir -p /var/lib/phpmyadmin/tmp
chown -R apache:apache /var/lib/phpmyadmin
mkdir /etc/phpmyadmin/
cp /usr/share/phpmyadmin/config.sample.inc.php  /usr/share/phpmyadmin/config.inc.php
#vim /usr/share/phpmyadmin/config.inc.php
openssl rand -base64 24
# for blowfish secret
# add line $cfg['TempDir'] = '/var/lib/phpmyadmin/tmp';
#vim /etc/httpd/conf.d/phpmyadmin.conf
## Apache configuration for phpMyAdmin
#Alias /phpMyAdmin /usr/share/phpmyadmin/
#Alias /phpmyadmin /usr/share/phpmyadmin/
#
#<Directory /usr/share/phpmyadmin/>
#   AddDefaultCharset UTF-8
#
#   <IfModule mod_authz_core.c>
#     # Apache 2.4
#     Require all granted
#   </IfModule>
#   <IfModule !mod_authz_core.c>
#     # Apache 2.2
#     Order Deny,Allow
#     Deny from All
#     Allow from 127.0.0.1
#     Allow from ::1
#   </IfModule>
#</Directory>
#ip a
#ping 192.168.1.61
#vim /etc/httpd/conf.d/phpmyadmin.conf
apachectl configtest
systemctl restart httpd
semanage fcontext -a -t httpd_sys_content_t "/usr/share/phpmyadmin(/.*)?"
restorecon -Rv /usr/share/phpmyadmin
firewall-cmd --add-service=http --permanent
firewall-cmd --reload

