#!/bin/sh

#Script for Fedora fresh install. Execute as root

#Add fastest mirror to dnf (faster dnf download)
echo "Adding fastest mirror to /etc/dnf/dnf.conf file"
echo "fastestmirror = true" >> /etc/dnf/dnf.conf
echo "Success"

#system upgrade
echo "dnf upgrading"
dnf upgrade -y


# (optional) remove nano default editor, install vim default editor
echo "Replacing nano for VIM"
dnf remove nano-default-editor -y
dnf install vim-default-editor -y

echo "dnf upgrading"
dnf upgrade -y

# INSTALL AND CONFIG RPM FUSION, MAKE SURE TO KEEP UPDATED
echo "Installing RPM fusion"
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
sudo dnf groupupdate core -y

echo "dnf upgrading"
dnf upgrade -y

#Install useful apps, feel free to modify
echo "Installing applications"
dnf install util-linux-user deja-dup pavucontrol python3-pip python3-devel gcc g++ git thunderbird virt-manager \
fish zsh gnome-shell-extension-dash-to-dock gnome-extensions-app obs-studio gimp vlc transmission \
mediawriter bridge-utils libvirt virt-install qemu-kvm tlp tlp-rdw mono-complete nodejs curl wget \
cmake mono-devel qemu bat gparted cmatrix neofetch ipython tmux blender kdenlive \
java-latest-openjdk npm -y

#kdenlive   

echo "dnf upgrading"
dnf upgrade -y

#Enable flatpaks
echo "Enabling flatpaks"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
echo "Success"

# Home username variable
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

# Installing dev tools
echo "Installing Dev tools"
sudo dnf groupinstall "Development Tools" "Development Libraries"

#---------------------------------

gpasswd -d $home_user_name wheel


#---------------------------------

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

# Wasap
127.0.0.1   web.whatsapp.com
EOT

# Configure BASHRC and home/user/bin
echo "Configuring home user bin directory"

cat <<EOT >> /home/$home_user_name/.bashrc
export PATH="/home/$(ls /home/ | grep -wv admin)/bin:$PATH"
EOT

source /home/$home_user_name/.bashrc
mkdir /home/$home_user_name/bin
chown -R $home_user_name:$home_user_name /home/$home_user_name/bin

echo "Success. Script completed."
