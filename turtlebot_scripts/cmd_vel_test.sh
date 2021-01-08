#!/bin/bash
#go to destination
rostopic pub /cmd_vel geometry_msgs/Twist '{ linear: {x: 0.05, y: 0, z: 0}, angular: { x: -3.5, y: -3.0, z: 0}}'
