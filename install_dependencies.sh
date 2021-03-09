#!/bin/bash

echo '<<<<<<<<<<<<< Start Install >>>>>>>>>>>>>>>>>>'

# Clean Packages
echo "========================================================"
echo "==================Cleanup==============================="
echo "========================================================"

apt-get update
apt-get upgrade -y

# Clone Project
apt install git -y
git clone https://github.com/FloforPresident/projektarbeit.git

# Python
echo "======================================================="
echo "==================PYTHON==============================="
echo "======================================================="
apt-get update
apt install -y software-properties-common
add-apt-repository -y ppa:deadsnakes/ppa
apt update 
apt-get install -y  python3.8 python3.8-dev python3.8-distutils python3.8-gdbm
update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 0 

# Pip
echo "======================================================="
echo "=====================PIP==============================="
echo "======================================================="
apt-get update
cd projektarbeit/backend
apt-get install -y python-pip 
pip install -r pip-requirements.txt

apt-get install -y python3-pip
apt remove python3-pip
python3.8 -m easy_install pip
python3.8 -m pip install -r pip3_requirements.txt


# Docker
echo "======================================================="
echo "==================Docker==============================="
echo "======================================================="

apt-get remove docker docker-engine docker.io containerd runc
apt-get install -y \
    apt-transport-https -y \
    ca-certificates -y \
    curl -y \
    gnupg -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io -y

# Docker Compose
curl -L "https://github.com/docker/compose/releases/download/1.28.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# General Packages
echo "======================================================="
echo "==================General Packages====================="
echo "======================================================="
apt-get install -y python-opencv python-cv-bridge 
apt-get install -y libjpeg62 libjpeg62-dev

# ROS 1
echo "======================================================="
echo "==================ROS=================================="
echo "======================================================="
wget https://raw.githubusercontent.com/ROBOTIS-GIT/robotis_tools/master/install_ros_kinetic.sh
chmod 755 ./install_ros_kinetic.sh 
bash ./install_ros_kinetic.sh -y

# ROS 1 Packages
apt-get install ros-kinetic-joy ros-kinetic-teleop-twist-joy -y \
  ros-kinetic-teleop-twist-keyboard ros-kinetic-laser-proc -y \
  ros-kinetic-rgbd-launch ros-kinetic-depthimage-to-laserscan -y \
  ros-kinetic-rosserial-arduino ros-kinetic-rosserial-python -y \
  ros-kinetic-rosserial-server ros-kinetic-rosserial-client -y \
  ros-kinetic-rosserial-msgs ros-kinetic-amcl ros-kinetic-map-server -y \
  ros-kinetic-move-base ros-kinetic-urdf ros-kinetic-xacro -y \
  ros-kinetic-compressed-image-transport ros-kinetic-rqt* -y \
  ros-kinetic-gmapping ros-kinetic-navigation ros-kinetic-interactive-markers -y \
  ros-kinetic-web-video-server -y

# Turtlebot3 Packages
echo "======================================================="
echo "==================Turtlebot============================"
echo "======================================================="
apt-get remove ros-kinetic-dynamixel-sdk
apt-get remove ros-kinetic-turtlebot3-msgs
apt-get remove ros-kinetic-turtlebot3

cd backend/catkin_ws/src/
git clone -b kinetic-devel https://github.com/ROBOTIS-GIT/DynamixelSDK.git
git clone -b kinetic-devel https://github.com/ROBOTIS-GIT/turtlebot3_msgs.git
git clone -b kinetic-devel https://github.com/ROBOTIS-GIT/turtlebot3.git
cd ..

echo "======================================================="
echo "==================Catkin Make=========================="
echo "======================================================="
source /opt/ros/kinetic/setup.bash
catkin_make
echo "source $PWD/devel/setup.bash" >> ~/.bashrc
source ~/.bashrc

# bashrc setup
echo "export TURTLEBOT3_MODEL=burger" >> ~/.bashrc
echo "export ROS_MASTER_URI=http://0.0.0.0:11311" >> ~/.bashrc
echo "export ROS_HOSTNAME=0.0.0.0" >> ~/.bashrc
