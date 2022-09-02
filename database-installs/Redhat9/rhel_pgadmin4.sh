#!/bin/sh
sudo yum install https://ftp.postgresql.org/pub/pgadmin/pgadmin4/yum/pgadmin4-redhat-repo-2-1.noarch.rpm
yum install pgadmin4-web
/usr/pgadmin4/bin/setup-web.sh
#connect using IP

