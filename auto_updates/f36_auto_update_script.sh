#!/bin/sh
#This script works as an executable icon. 
echo "****Cleaning DNF"
dnf clean all
echo "****Dnf Upgrading"
dnf upgrade -y
echo "****Updating Flatpaks"
flatpak update -y
echo "Updates successful"
echo "Press any key to close this terminal"
while [ true ] ; do
read -t 3 -n 1
if [ $? = 0 ] ; then
exit ;
fi
done
