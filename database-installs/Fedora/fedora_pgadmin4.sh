#!/bin/sh
sudo systemctl start httpd
sudo systemctl enable httpd
sudo rpm -e pgadmin4-fedora-repo
sudo rpm -Uvh https://ftp.postgresql.org/pub/pgadmin/pgadmin4/yum/pgadmin4-fedora-repo-2-1.noarch.rpm
sudo dnf install pgadmin4-web
sudo dnf install pgadmin4-desktop
dnf install policycoreutils-python-utils
sudo /usr/pgadmin4/bin/setup-web.sh
