#!/bin/sh

#Script for RedHat 8 fresh install. Execute as root.


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
subscription-manager repos --enable codeready-builder-for-rhel-8-$(arch)-rpms
dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y
/usr/bin/crb enable
echo "Success"

# INSTALL AND CONFIG RPM FUSION, MAKE SURE TO KEEP UPDATED
echo "Installing RPM fusion"
sudo dnf install --nogpgcheck https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(rpm -E %rhel).noarch.rpm -y

sudo dnf install --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm -y

sudo subscription-manager repos --enable "codeready-builder-for-rhel-8-$(uname -m)-rpms" 

sudo dnf groupupdate core -y

echo "Success"

echo "dnf upgrading"
dnf clean all
dnf upgrade -y

#Install useful apps, feel free to modify
echo "Installing applications"
dnf install python3-pip -y
dnf install python3-devel -y
dnf install fish -y
dnf install gcc -y
dnf install git -y
dnf install mono-complete -y
dnf install cmake -y
dnf install mono-devel -y
dnf install tlp tlp-rdw -y
dnf install java-11-openjdk -y
dnf install java-17-openjdk -y
dnf install ntfs-3g -y

echo "dnf upgrading"
dnf upgrade -y


home_user_name=$(ls /home/ | grep -wv admin)

echo "Installing Go (golang)"
#Installing Go
dnf install golang -y
mkdir -p /home/$home_user_name/go
echo 'export GOPATH=/home/$(ls /home/ | grep -wv admin)/go' >> /home/$home_user_name/.bashrc

echo "dnf upgrading"
dnf upgrade -y

echo "dnf upgrading"
dnf upgrade -y

echo "dnf upgrading"
dnf upgrade -y

#-----------------------------------
# Configure BASHRC and home/user/bin
echo "Configuring home user bin directory"

cat <<EOT >> /home/$home_user_name/.bashrc
export PATH="/home/$(ls /home/ | grep -wv admin)/bin:$PATH"
EOT

source /home/$home_user_name/.bashrc
mkdir /home/$home_user_name/bin
chown -R $home_user_name:$home_user_name /home/$home_user_name/bin

#enable laptop battery optimizer service 
echo "Activating tlp battery optimizer"
systemctl enable tlp
systemctl start tlp
echo "Success"

#conigure touchpy
echo "configuring touchpy"
touch /home/$home_user_name/bin/touchpy
chown $home_user_name:$home_user_name /home/$home_user_name/bin/touchpy
chmod +x /home/$home_user_name/bin/touchpy



# Block distracting websites. Modify as needed. 
echo "Blocking distracting websites in /etc/hosts file"
cat <<EOT >> /etc/hosts
# Facebook
127.0.0.1   www.facebook.com
127.0.0.1   facebook.com
127.0.0.1   login.facebook.com
127.0.0.1   www.login.facebook.com
127.0.0.1   fbcdn.net
127.0.0.1   www.fbcdn.net
127.0.0.1   fbcdn.com
127.0.0.1   www.fbcdn.com
127.0.0.1   static.ak.fbcdn.net
127.0.0.1   static.ak.connect.facebook.com
127.0.0.1   connect.facebook.net
127.0.0.1   www.connect.facebook.net
127.0.0.1   apps.facebook.com
0.0.0.0     meta.com
0.0.0.0     www.meta.com
# Twitter
127.0.0.1   www.twitter.com
127.0.0.1   twitter.com
# IG
127.0.0.1   instagram.com
127.0.0.1   www.instagram.com
#Amazon
127.0.0.1   www.amazon.com
127.0.0.1   amazon.com
# Wasap
127.0.0.1   web.whatsapp.com
EOT

# Configure BASHRC and home/user/bin
echo "Configuring home user bin directory"

cat <<EOT >> /home/$home_user_name/.bashrc
export PATH="/home/$(ls /home/ | grep -wv admin)/bin:$PATH"
EOT

source /home/$home_user_name/.bashrc
chown -R $home_user_name:$home_user_name /home/$home_user_name/bin
chown -R $home_user_name:$home_user_name /home/$home_user_name/go

echo "Success. Script completed."
