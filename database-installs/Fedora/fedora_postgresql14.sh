#!/bin/sh
sudo dnf install -y postgresql14-server -y
sudo /usr/pgsql-14/bin/postgresql-14-setup initdb
sudo systemctl enable postgresql-14
sudo systemctl start postgresql-14
postgresql-14-setup --initdb
sudo su - postgres
echo "HINT:"
echo "psql -c \"alter user postgres with password 'PasswordHere'\""
