gnome-terminal --tab -- /bin/sh -c 'echo Turtlebot Speaker Node started;turtlebotip=`cat turtlebotip.txt`;sshpass -p 'turtlebot' ssh pi@$turtlebotip "rosrun speaker_node speaker_node.py"'
