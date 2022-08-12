#!/bin/sh

#Script for Debian fresh install. Execute as root
# Tested functional august 11 2022


# Modify /etc/apt/sources.list file for debian 11. Includes non free repos. 
echo "deb http://deb.debian.org/debian bullseye main contrib non-free" > /etc/apt/sources.list
echo "deb-src http://deb.debian.org/debian bullseye main contrib non-free" >> /etc/apt/sources.list
echo "" >> /etc/apt/sources.list
echo "deb http://deb.debian.org/debian-security/ bullseye-security main contrib non-free" >> /etc/apt/sources.list
echo "deb-src http://deb.debian.org/debian-security/ bullseye-security main contrib non-free" >> /etc/apt/sources.list
echo "" >> /etc/apt/sources.list
echo "deb http://deb.debian.org/debian bullseye-updates main contrib non-free" >> /etc/apt/sources.list
echo "deb-src http://deb.debian.org/debian bullseye-updates main contrib non-free" >> /etc/apt/sources.list
echo "" >> /etc/apt/sources.list
echo "# Visit https://wiki.debian.org/SourcesList for more info."

# update upgrade
apt update
apt dist-upgrade -y
apt autoremove -y

# remove unwanted apps (feel free to modify)
# test libreoffice-core instead of libreoffice*
apt purge evolution libreoffice* gnome-nibbles gnome-tetravex gnome-taquin tali swell-foop five-or-more gnome-mines gnome-robots quadrapassel hitori gnome-2048 aisleriot iagno gnome-klotski lightsoff four-in-a-row gnome-mahjongg -y
apt autoremove -y

#remove conflicting package
apt --purge remove libva2 -y

apt update
apt dist-upgrade -y
apt autoremove -y

#install useful apps (fell free to modify)
apt install pavucontrol python3-pip gcc g++ git virt-manager fish zsh gnome-tweak-tool obs-studio gimp vlc transmission flatpak bridge-utils qemu-kvm tlp tlp-rdw -y
# configure flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

#kdenlive thunderbird

# Enable laptop battery saver service. 
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

