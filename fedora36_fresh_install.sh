#!/bin/sh

#Script for Fedora fresh install. Execute as root
#Tested functional august 11 2022

#Add fastest mirror to dnf (faster dnf download)
echo "fastestmirror = true" >> /etc/dnf/dnf.conf

#system upgrade
dnf upgrade -y

# (optional) remove nano default editor, install vim default editor
dnf remove nano-default-editor -y
dnf install vim-default-editor -y

# INSTALL AND CONFIG RPM FUSION, MAKE SURE TO KEEP UPDATED
dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
dnf groupupdate core -y
dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
dnf groupupdate sound-and-video -y

#Install useful apps, feel free to modify
dnf install pavucontrol python3-pip gcc g++ git thunderbird virt-manager fish zsh gnome-shell-extension-dash-to-dock gnome-extensions-app obs-studio gimp vlc transmission mediawriter bridge-utils libvirt virt-install qemu-kvm tlp tlp-rdw -y

#Enable flatpaks
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

#kdenlive   

#enable laptop battery saver service 
systemctl enable tlp

# Block distracting websites. Modify as needed. 

echo "# Facebook" >> /etc/hosts
echo "127.0.0.1   www.facebook.com" >> /etc/hosts
echo "127.0.0.1   facebook.com" >> /etc/hosts
echo "127.0.0.1   login.facebook.com" >> /etc/hosts
echo "127.0.0.1   www.login.facebook.com" >> /etc/hosts
echo "127.0.0.1   fbcdn.net" >> /etc/hosts
echo "127.0.0.1   www.fbcdn.net" >> /etc/hosts
echo "127.0.0.1   fbcdn.com" >> /etc/hosts
echo "127.0.0.1   www.fbcdn.com" >> /etc/hosts
echo "127.0.0.1   static.ak.fbcdn.net" >> /etc/hosts
echo "127.0.0.1   static.ak.connect.facebook.com" >> /etc/hosts
echo "127.0.0.1   connect.facebook.net" >> /etc/hosts
echo "127.0.0.1   www.connect.facebook.net" >> /etc/hosts
echo "127.0.0.1   apps.facebook.com" >> /etc/hosts
echo "0.0.0.0     meta.com" >> /etc/hosts
echo "0.0.0.0     www.meta.com" >> /etc/hosts
echo "# Twitter" >> /etc/hosts
echo "127.0.0.1   www.twitter.com" >> /etc/hosts
echo "127.0.0.1   twitter.com" >> /etc/hosts
echo "# IG" >> /etc/hosts
echo "127.0.0.1   instagram.com" >> /etc/hosts
echo "127.0.0.1   www.instagram.com" >> /etc/hosts
echo "#Amazon" >> /etc/hosts
echo "127.0.0.1   www.amazon.com" >> /etc/hosts
echo "127.0.0.1   amazon.com" >> /etc/hosts
echo "# Wasap" >> /etc/hosts
echo "127.0.0.1   web.whatsapp.com" >> /etc/hosts