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

apt purge evolution libreoffice gnome-nibbles \
gnome-tetravex gnome-taquin tali swell-foop five-or-more \
gnome-mines gnome-robots quadrapassel hitori gnome-2048 \
aisleriot iagno gnome-klotski lightsoff four-in-a-row gnome-mahjongg -y
apt autoremove -y

#remove conflicting package
#apt --purge remove libva2 -y

apt update
apt dist-upgrade -y
apt autoremove -y

#install useful apps (fell free to modify)
apt install kdenlive thunderbird pavucontrol \
python3-pip gcc g++ git virt-manager fish \
zsh gnome-tweak-tool \
obs-studio gimp vlc transmission flatpak \
firmware-linux blueman firmware-iwlwifi \
bridge-utils qemu-kvm tlp tlp-rdw -y
# configure flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Enable laptop battery saver service. 
systemctl start tlp
systemctl enable tlp

# Home username variable
home_user_name=$(ls /home/ | grep -wv admin)

# Configure BASHRC and home/user/bin
echo "Configuring home user bin directory"

cat <<EOT >> /home/$home_user_name/.bashrc
export PATH="/home/$(ls /home/ | grep -wv admin)/bin:$PATH"
EOT

source /home/$home_user_name/.bashrc
mkdir /home/$home_user_name/bin
chown -R $home_user_name:$home_user_name /home/$home_user_name/bin

echo "configuring pytouch"
touch /home/$home_user_name/bin/pytouch
chown $home_user_name:$home_user_name /home/$home_user_name/bin/pytouch
chmod +x /home/$home_user_name/bin/pytouch

cat <<EOT >> /home/$home_user_name/bin/pytouch
#!/usr/bin/env python3
#Author David Boh // herrboh@gmail.com
import os, sys
filename = sys.argv[2]
flag = sys.argv[1]
def createpy():
    file_ext = ".py"
    with open("{}{}".format(filename,file_ext), "w") as file:
        file.write("#!/usr/bin/env python3\n")
        file.write("\n")
        file.write("def main():")
        file.write("\n\n\n\n")
        file.write("if __name__ == '__main__':")
        file.write("\n\tmain()")
    final_name= "{}{}".format(filename,file_ext)
    os.chmod(final_name,0o755)
    print("\nFile {} has been created\n".format(final_name))
def createbash():
    file_ext = ".sh"
    with open("{}{}".format(filename,file_ext), "w") as file:
        file.write("#!/bin/sh\n")
    final_name= "{}{}".format(filename,file_ext)
    os.chmod(final_name,0o755)
    print("\nFile {} has been created\n".format(final_name))
    file.close()
    
def creation():
    """this script creates a .py or .sh file based on flags passed when exec    uted (-p or -s).Each file will be created with execute permissions and inside of each file, the first line wille include a shebang #! line argument"""
    
    file_ext = ""
# add try statement        
    if flag == '-p':
        createpy()
    elif flag == '-s':
        createbash()
    else:
        flag != '-s' or flag != '-p'
        print("\nInvalid Input\n")
# catch no parameters error. 
creation()
EOT

echo "Success. Script completed."

echo "Installing Rust"
#Installing Rust
curl --proto '=https' --tlsv1.3 https://sh.rustup.rs -sSf | sh


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

