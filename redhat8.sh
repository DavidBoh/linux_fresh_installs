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
sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
sudo dnf groupupdate sound-and-video -y
echo "Success"

echo "dnf upgrading"
dnf clean all
dnf upgrade -y

#Install useful apps, feel free to modify
echo "Installing applications"
dnf install python3-pip -y
dnf install python3-devel -y
dnf install fish -y
dnf install zsh -y
dnf install tcsh -y
dnf install python3-pip -y
dnf install python3-devel -y 
dnf install gcc -y
dnf install git -y
dnf install mono-complete -y
dnf install nodejs -y
dnf install flatpak -y
dnf install cmake -y
dnf install mono-devel -y
dnf install tlp tlp-rdw -y
dnf install java-11-openjdk -y
dnf install java-17-openjdk -y
dnf install npm -y

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

echo "Installing Rust"
#Installing Rust
curl --proto '=https' --tlsv1.3 https://sh.rustup.rs -sSf | sh

echo "dnf upgrading"
dnf upgrade -y

echo "Installing Dotnet"
#Installing Dotnet 
dnf install dotnet-sdk-6.0 -y
dnf install aspnetcore-runtime-6.0 -y
dnf install dotnet-runtime-6.0 -y

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

#conigure pytouch
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

echo "Success. Script completed."
