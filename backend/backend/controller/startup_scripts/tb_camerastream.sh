gnome-terminal --tab -- /bin/sh -c 'echo Camera Node started;turtlebotip=`cat turtlebotip.txt`;sshpass -p 'turtlebot' ssh pi@$turtlebotip "roslaunch raspicam_node camerav2_1280x960_10fps.launch enable_raw:=true"'
