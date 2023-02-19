#!/bin/sh

#Script for Red Hat 9 fresh install. Execute as root.
#Tested functional August 20

#Add fastest mirror to dnf (faster dnf download)
echo "Adding fastest mirror to /etc/dnf/dnf.conf file"
echo "fastestmirror = true" >> /etc/dnf/dnf.conf
echo "Success"

#system upgrade
echo "dnf upgrading"
dnf clean all
dnf upgrade -y

#Enabling EPEL
echo "Enabling EPEL"
subscription-manager repos --enable codeready-builder-for-rhel-9-$(arch)-rpms
dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm -y
echo "Success"

# INSTALL AND CONFIG RPM FUSION, MAKE SURE TO KEEP UPDATED
echo "Installing RPM fusion"
sudo dnf install --nogpgcheck https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(rpm -E %rhel).noarch.rpm -y
sudo dnf install --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm -y
dnf groupupdate core -y
echo "Success"

echo "dnf upgrading"
dnf clean all
dnf upgrade -y

#Install useful apps, feel free to modify
echo "Installing applications"
dnf install python3-pip python3-devel fish \
mono-complete nodejs \
cmake mono-devel \
ntfs-3g transmission deja-dup vlc flatkpak \
java-11-openjdk java-17-openjdk npm -y

echo "dnf upgrading"
dnf upgrade -y

home_user_name=$(ls /home/ | grep -wv admin)

echo "Installing Go (golang)"
#Installing Go
dnf install golang -y
mkdir -p /home/$home_user_name/go
echo 'export GOPATH=/home/$(ls /home/ | grep -wv admin)/go' >> /home/$home_user_name/.bashrc


echo "dnf upgrading"
dnf upgrade

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

#-----------------------------------
# Configure BASHRC and home/user/bin
echo "Configuring home user bin directory"

cat <<EOT >> /home/$home_user_name/.bashrc
export PATH="/home/$(ls /home/ | grep -wv admin)/bin:$PATH"
EOT

source /home/$home_user_name/.bashrc
mkdir /home/$home_user_name/bin
chown -R $home_user_name:$home_user_name /home/$home_user_name/bin

#conigure pytouch
echo "configuring pytouch"
touch /home/$home_user_name/bin/pytouch
chown $home_user_name:$home_user_name /home/$home_user_name/bin/pytouch
chmod +x /home/$home_user_name/bin/pytouch

cat <<EOT >> /home/$home_user_name/bin/pytouch
#!/usr/bin/env python3
#Author David Boh // herrboh@gmail.com

EOT

echo "Success. Script completed."
