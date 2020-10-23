#!/usr/bin/env python

import rospy
import os
import subprocess

def letsGo():
	os.system('roslaunch find_person print_patrick.launch')

if __name__ == '__main__':
	letsGo()
