gnome-terminal --tab -- /bin/sh -c 'echo Turtlebot Bringup started;turtlebotip=`cat turtlebotip.txt`;sshpass -p 'turtlebot' ssh pi@$turtlebotip "roslaunch turtlebot3_bringup turtlebot3_robot.launch"'



