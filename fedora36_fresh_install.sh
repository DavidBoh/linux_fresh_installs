#!/bin/sh

#Script for Fedora fresh install. Execute as root

#Add fastest mirror to dnf (faster dnf download)
echo "Adding fastest mirror to /etc/dnf/dnf.conf file"
echo "fastestmirror = true" >> /etc/dnf/dnf.conf
echo "Success"

#system upgrade
echo "dnf upgrading"
dnf upgrade -y


# (optional) remove nano default editor, install vim default editor
echo "Replacing nano for VIM"
dnf remove nano-default-editor -y
dnf install vim-default-editor -y

echo "dnf upgrading"
dnf upgrade -y

# INSTALL AND CONFIG RPM FUSION, MAKE SURE TO KEEP UPDATED
echo "Installing RPM fusion"
dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
dnf groupupdate core -y
dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
dnf groupupdate sound-and-video -y

echo "dnf upgrading"
dnf upgrade -y

#Install useful apps, feel free to modify
echo "Installing applications"
dnf install util-linux-user deja-dup pavucontrol python3-pip python3-devel gcc g++ git thunderbird virt-manager \
fish zsh gnome-shell-extension-dash-to-dock gnome-extensions-app obs-studio gimp vlc transmission \
mediawriter bridge-utils libvirt virt-install qemu-kvm tlp tlp-rdw mono-complete nodejs curl wget \
cmake mono-devel qemu bat gparted \
java-latest-openjdk npm -y

#kdenlive   

echo "dnf upgrading"
dnf upgrade -y

#Enable flatpaks
echo "Enabling flatpaks"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
echo "Success"

# Home username variable
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

# Installing dev tools
echo "Installing Dev tools"
sudo dnf groupinstall "Development Tools" "Development Libraries"

#enable laptop battery optimizer service 
echo "Activating tlp battery optimizer"
systemctl enable tlp
systemctl start tlp
echo "Success"

#---------------------------------

#Configure User permissions (security)
echo "Configuring users and user permissions"
useradd -c "admin" -m -s /bin/bash admin
echo "Please introduce password for admin user"
passwd admin
sudo usermod -g wheel admin
# Make admin user invisible from login screen
touch /var/lib/AccountsService/users/admin
cat <<EOT >> /var/lib/AccountsService/users/admin
[User]
Language=
XSession=gnome
SystemAccount=true
EOT


gpasswd -d $home_user_name wheel

#TESTING
<<com
# Configure User for VM acces
echo "Configuring user for SSH access"
touch /etc/sudoers.d/filename
cat <<EOT >>/etc/sudoers.d/filename
$home_user_name ALL=(root) /bin/virsh
EOT
com

#---------------------------------

echo "setting up .vimrc file"
#Set up .vimrc. 

cat <<EOT >> /home/$home_user_name/.vimrc
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'
" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
"Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
set number
filetype plugin on
filetype indent on
set autoindent
EOT

#---------------------------------

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
