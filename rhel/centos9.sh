#!/bin/sh

#Script for CentOs Stream 9 fresh install. Execute as root.
#Tested functional September 1st

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
dnf config-manager --set-enabled crb -y
dnf install epel-release epel-next-release -y
echo "Success"

# INSTALL AND CONFIG RPM FUSION, MAKE SURE TO KEEP UPDATED
sudo dnf install --nogpgcheck https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(rpm -E %rhel).noarch.rpm -y
sudo dnf install --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm -y
sudo dnf groupupdate core -y
sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
sudo dnf groupupdate sound-and-video -y
echo "Success"

echo "dnf upgrading"
dnf clean all
dnf upgrade -y

#Install useful apps, feel free to modify
echo "Installing applications"
dnf install python3-pip python3-devel fish \
mono-complete nodejs \
cmake mono-devel \
java-11-openjdk java-17-openjdk npm -y

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

#conigure pytouch
echo "configuring pytouch"
touch /home/$home_user_name/bin/pytouch
chown $home_user_name:$home_user_name /home/$home_user_name/bin/pytouch
chmod +x /home/$home_user_name/bin/pytouch

cat <<EOT >> /home/$home_user_name/bin/pytouch
#!/usr/bin/env python3
#Author David Boh // herrboh@gmail.com

# TO DO 
# Avoid file overwrite
# if user provides file extension (.py or .sh) make sure to delete .py part to avoid
# cases of files named file.py.py - use regexes to fix this. 
# include more flags for different types of python files, or use cases. 

import os, sys

try:
    filename = sys.argv[2]
    flag = sys.argv[1]
except:
    #Note: error type can make this piece of code work or not. 
    print("Please include params -s for sh, -p for python")
    #main function checks if the variable named 'flags' exists in global variables

def createpy():
    file_ext = ".py"
    with open("{}{}".format(filename,file_ext), "w") as file:
        file.write("#!/usr/bin/env python3\n")
        file.write("\n")
        file.write("def main():")
        file.write("\n\n")
        file.write("main()\n")

    final_name= "{}{}".format(filename,file_ext)
    os.chmod(final_name,0o755)
    print("File {} has been created".format(final_name))
    file.close()

def createpy_main():
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
    print("File {} has been created".format(final_name))
    file.close()

def createbash():
    file_ext = ".sh"
    with open("{}{}".format(filename,file_ext), "w") as file:
        file.write("#!/bin/sh\n")
    final_name= "{}{}".format(filename,file_ext)
    os.chmod(final_name,0o755)
    print("File {} has been created".format(final_name))
    file.close()

def createc():
  
    file_ext = ".c"

    with open("{}{}".format(filename,file_ext), "w") as file:
        file.write("#include <stdio.h>\n")
        file.write("#include <stdlib.h>\n")
        file.write("\n")
        file.write("int main(void){\n")
        file.write("\tputs(\"Hello, world!\");\n")
        file.write("\treturn EXIT_SUCCESS;\n")
        file.write("}\n")

    final_name = "{}{}".format(filename,file_ext)
    print("File {} has been created".format(final_name))
    file.close()
    
def creation():
    """this script creates a .py or .sh file based on flags passed when exec    uted (-p or -s).Each file will be created with execute permissions and inside of each file, the first line wille include a shebang #! line argument"""
    
    file_ext = ""

    if flag == '-p':
        createpy()
    elif flag == '-s':
        createbash()
    elif flag == '-c':
        createc()
    else:
        print("Invalid Input")

def main():
    if 'flag' and 'filename' in globals(): 
        creation()
    else:
        print("",end='')

main()
EOT

echo "Success. Script completed."
