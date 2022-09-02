#!/bin/sh
dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-9-x86_64/pgdg-redhat-repo-latest.noarch.rpm
sudo dnf -qy module disable postgresql
sudo dnf install -y postgresql14-server
sudo /usr/pgsql-14/bin/postgresql-14-setup initdb
sudo systemctl enable postgresql-14
sudo systemctl start postgresql-14
# change postgres password = 
echo "HINT:"
echo "psql -c \"alter user postgres with password 'PasswordHere'\""
# modify vim /var/lib/pgsql/14/data/pg_hba.conf
# add host    all             all             192.168.122.161/24         trust
# modify /var/lib/pgsql/14/data/postgresql.conf
#add listen_addresses = '192.168.122.161, localhost'
#add port=5432
systemctl restart postgresql-14
