#!/bin/bash

echo "*** add user to dialout for asctec hl ***"
username=`whoami`
sudo adduser $username dialout
echo


# system monitor
sudo add-apt-repository ppa:indicator-multiload/stable-daily -y
sudo apt-get update


# some usefull packages
sudo apt-get install vim htop meld gitk git-cola indicator-multiload -y

# install some codecs
sudo apt-get install libavformat-extra-53 libavcodec-extra-53 ubuntu-restricted-extras -y


# install oracle java 7 (REALLY recomended for eclipse)
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java7-installer -y


# eclipse (copied from pascal gohl)  (merci)
wget http://mirror.switch.ch/eclipse/technology/epp/downloads/release/kepler/SR1/eclipse-cpp-kepler-SR1-linux-gtk-x86_64.tar.gz
tar -zxvf eclipse-cpp-kepler-SR1-linux-gtk-x86_64.tar.gz
sudo mv eclipse /opt
sudo chown pascal -R /opt/eclipse/
sudo ln -s /opt/eclipse/eclipse /usr/sbin/eclipse
rm eclipse-cpp-kepler-SR1-linux-gtk-x86_64.tar.gz
# setup unity link
cat > eclipse.desktop << "EOF"
[Desktop Entry]
Name=Eclipse
Type=Application
Exec=eclipse
Terminal=false
Icon=eclipse
Comment=Integrated Development Environment
NoDisplay=false
Categories=Development;IDE;
Name[en]=Eclipse
EOF
sudo mv eclipse.desktop /opt/eclipse/
sudo desktop-file-install /opt/eclipse/eclipse.desktop
sudo cp /opt/eclipse/icon.xpm /usr/share/pixmaps/eclipse.xpm

# --- SET UP ROS ---

# add ros repository to package manager
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu raring main" > /etc/apt/sources.list.d/ros-latest.list'

# add key to ros repository
wget http://packages.ros.org/ros.key -O - | sudo apt-key add -

# update package manager
sudo apt-get update

# install ros hydro
sudo apt-get install ros-hydro-desktop-full -y

# initialize rosdep
sudo rosdep init
rosdep update

# ros python install helper
sudo apt-get install python-rosinstall -y

# install node manager
sudo apt-get install ros-hydro-node-manager-fkie -y

echo
echo "*** SETTING UP ROS ***"
echo

cd ~

source /opt/ros/hydro/setup.bash

# create catkin workspace
mkdir -p ~/catkin_ws/src
cd ~/catkin_ws/src
catkin_init_workspace

cd ~/catkin_ws/
catkin_make

cd ~

# create rosbuild workspace
mkdir -p ~/rosbuild_ws
rosws init ~/rosbuild_ws ~/catkin_ws/devel

# add ros to bash
sh -c 'echo "source ~/rosbuild_ws/setup.bash" >> ~/.bashrc'


# --- SET UP GIT ---

while true; do
    read -p "Do you wish to set up git? [y/n] " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

# fancy bash coloring for git :)
sh -c 'echo "export GIT_PS1_SHOWDIRTYSTATE=1" >> ~/.bashrc'
echo "export PS1='\[\033[03;32m\]\u@\h\[\033[01;34m\]:\w\[\033[02;33m\]\$(__git_ps1)\[\033[01;34m\]\\$\[\033[00m\] '" >> ~/.bashrc


echo ""
read -p "your git user name (Full name)? " git_name
echo "$ git config --global user.name \"$git_name\""
git config --global user.name "$git_name"

echo ""
read -p "your git email? " git_email
echo "$ git config --global user.email "$git_email
git config --global user.email $git_email
echo ""

git config --global credential.helper cache
git config --global push.default simple

git config --list

echo ""

echo "*** setting up ssh ***"
if [ ! -f ~/.ssh/id_rsa.pub ]; then
    echo "ssh key not found!"
    echo "generating one for you"
    echo "$ ssh-keygen"
    ssh-keygen
else
    echo "ssh public key found!"
fi
echo 


echo "$ cat ~/.ssh/id_rsa.pub"
cat ~/.ssh/id_rsa.pub
echo
read -p "Please copy your ssh public key to your github account" temp



