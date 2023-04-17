#upgrader for DNF distros like Fedora
#!/bin/sh
dnf clean all
dnf upgrade -y
echo "cleaning dnf"
dnf clean all
echo "upgrading flatpaks"
flatpak update -y
echo "success"
