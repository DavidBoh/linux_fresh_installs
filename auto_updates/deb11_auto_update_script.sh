#!/bin/bash
#script intended to be run from terminal, after adding /home/user/bin to $PATH
apt update
apt dist-upgrade -y
apt autoremove -y
apt clean all
flatpak update -y
