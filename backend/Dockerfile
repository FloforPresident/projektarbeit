FROM ubuntu:16.04

RUN apt-get update && \
      apt-get -y install sudo && \
      apt-get -y install nano

RUN apt-get update
RUN apt-get upgrade -y
ADD https://raw.githubusercontent.com/ROBOTIS-GIT/robotis_tools/master/install_ros_kinetic.sh .
RUN chmod 755 ./install_ros_kinetic.sh
RUN bash ./install_ros_kinetic.sh -y

RUN apt-get install ros-kinetic-joy ros-kinetic-teleop-twist-joy -y \
  ros-kinetic-teleop-twist-keyboard ros-kinetic-laser-proc -y \
  ros-kinetic-rgbd-launch ros-kinetic-depthimage-to-laserscan -y \
  ros-kinetic-rosserial-arduino ros-kinetic-rosserial-python -y \
  ros-kinetic-rosserial-server ros-kinetic-rosserial-client -y \
  ros-kinetic-rosserial-msgs ros-kinetic-amcl ros-kinetic-map-server -y \
  ros-kinetic-move-base ros-kinetic-urdf ros-kinetic-xacro -y \
  ros-kinetic-compressed-image-transport ros-kinetic-rqt-image-view -y \
  ros-kinetic-gmapping ros-kinetic-navigation ros-kinetic-interactive-markers -y

RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash"
RUN apt-get install ros-kinetic-turtlebot3-msgs -y && \
    apt-get install ros-kinetic-turtlebot3 -y

ADD backend /home

RUN echo "export TURTLEBOT3_MODEL=burger" >> ~/.bashrc
RUN echo "export ROS_MASTER_URI=HTTP://0.0.0.0:11311" >> ~/.bashrc
RUN echo "export ROS_HOSTNAME=0.0.0.0" >> ~/.bashrc

RUN apt install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y  python3.7 && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 0

RUN apt-get update && \
    apt-get install -y python-pip && \
    apt-get install -y python3-pip

RUN pip3 install -r /home/pip3_requirements.txt
#    pip install -r /home/pip2_requirements.txt

CMD ["python3", "/home/controller/websocket.py"]

#RUN echo "source /home/catkin_ws/devel/setup.bash" >> ~/.bashrc
#RUN /bin/bash -c "source ~/.bashrc"

