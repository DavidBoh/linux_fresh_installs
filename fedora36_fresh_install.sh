#!/bin/sh

#Script for Fedora fresh install. Execute as root

echo "fastestmirror = true" >> /etc/dnf/dnf.conf

dnf upgrade -y

# remove nano default editor, install vim default editor
dnf remove nano-default-editor -y
dnf install vim-default-editor -y

# RPM FUSION, MAKE SURE TO KEEP UPDATED
dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
dnf groupupdate core -y
dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
dnf groupupdate sound-and-video -y

dnf install pavucontrol python3-pip gcc g++ git thunderbird virt-manager fish zsh gnome-shell-extension-dash-to-dock gnome-extensions-app obs-studio gimp vlc transmission mediawriter bridge-utils libvirt virt-install qemu-kvm tlp tlp-rdw -y

#kdenlive   

systemctl enable tlp
