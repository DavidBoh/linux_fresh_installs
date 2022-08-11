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

systemctl enable tlp
