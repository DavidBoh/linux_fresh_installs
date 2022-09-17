#!/bin/bash

apt update
apt dist-upgrade -y
apt autoremove -y

apt install gdebi-core \
build-dep python -y

apt update
apt dist-upgrade -y
apt autoremove -y

apt install libffi-dev \
libgdbm-dev libsqlite3-dev \
libssl-dev zlib1g-dev -y

export PYTHON_VERSION=3.10.7
export PYTHON_MAJOR=3

curl -O https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz
tar -xvzf Python-${PYTHON_VERSION}.tgz
cd Python-${PYTHON_VERSION}


./configure \
    --prefix=/opt/python/${PYTHON_VERSION} \
    --enable-shared \
    --enable-ipv6 \
    LDFLAGS=-Wl,-rpath=/opt/python/${PYTHON_VERSION}/lib,--disable-new-dtags

make
sudo make install

curl -O https://bootstrap.pypa.io/get-pip.py
sudo /opt/python/${PYTHON_VERSION}/bin/python${PYTHON_MAJOR} get-pip.py

sudo /opt/python/${PYTHON_VERSION}/bin/pip install virtualenv

touch /etc/profile.d/python.sh
echo "PATH=/opt/python/${PYTHON_VERSION}/bin/:$PATH" >> /etc/profile.d/python.sh

echo "***********"
echo "THIS IS HOW THE /etc/profile.d/python.sh FILE WAS CONFIGURED"
cat /etc/profile.d/python.sh

sudo update-alternatives --install /usr/bin/python3 python3 /opt/python/3.10.7/bin/python3.10 0
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 1



