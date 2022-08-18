#!/bin/sh

#Script for Fedora fresh install. Execute as root
#Tested functional august 11 2022

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
cmake mono-devel qemu bat \
java-latest-openjdk npm -y

#kdenlive   


echo "dnf upgrading"
dnf upgrade -y

#Enable flatpaks
echo "Enabling flatpaks"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
echo "Success"

echo "Installing Go (golang)"
#Installing Go
dnf install golang -y
mkdir -p $HOME/go
echo 'export GOPATH=$HOME/go' >> $HOME/.bashrc
source $HOME/.bashrc

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

# Home username variable
home_user_name=$(ls /home/ | grep -wv admin)

gpasswd -d $(home_user_name) wheel

# Configure User for VM acces
echo "Configuring user for SSH access"
touch /etc/sudoers.d/filename
cat <<EOT >>/etc/sudoers.d/filename
$home_user_name ALL=(root) /bin/virsh
EOT

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

echo "Success. Script completed."
