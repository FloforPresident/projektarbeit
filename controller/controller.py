#! /usr/bin/env python

"""
Controller, operates as bridge between app, database, and ROS

Features:
- Accesses database script
- Receives actions from app over websocket protocol
- Sends actions to ROS (topics, nodes...) -> actions should be outsourced to own scripts

"""

# import database_access as db
import json
import subprocess
import multiprocessing
import paramiko
import sys
import signal

import rospy
import roslaunch
from std_msgs.msg import String

# websocket imports

import asyncio
import websockets

import time

# robot action imports
# import go_to_goal
import init_position
import move_forward
import teleop_keyboard as teleop
# import move_to_goal

ACTION_KEY = "action"


# get action that should be done from JSON Object
def json_get_action(jsonObj):
	action = json_get_value_by_key(jsonObj, ACTION_KEY)
	return action

# get value by key from a JSON Oject
def json_get_value_by_key(jsonObj, key):
	data = json.loads(jsonObj)
	return data[key]

def robo_ssh():
	host = "192.168.1.124"
	port = "22"
	username = "pi"
	password = "turtlebot"

	#command = "cd BringupScripts && ./start_camera.sh"
	#command = '/opt/ros/kinetic/bin/roslaunch raspicam_node camerav1_1280x720.launch enable_raw:=true'
	#command = 'bash --login -c "roslaunch raspicam_node camerav1_1280x720.launch enable_raw:=true"'
	#command = 'PATH="$PATH;/opt/ros/kinetic/bin/roslaunch" && roslaunch raspicam_node camerav1_1280x720.launch enable_raw:=true'
	#command = "/sbin/ifconfig"
	command = "echo $PATH"

	ssh = paramiko.SSHClient()
	ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
	ssh.connect(host, port, username, password)
	stdin, stdout, stderr = ssh.exec_command(command,timeout=None)
	lines = stdout.readlines()
	err = stderr.readlines()
	print(lines)
	print(err)


	#chan=ssh.invoke_shell()
	#chan.send('roslaunch raspicam_node camerav1_1280x720.launch enable_raw:=true')

def action_find_person(name, x, y, message):
		#user = db.getUser(name)
		#locationID = user[1]
		#location = db.getLocation(locationID)
		#x = location[3]
		#y = location[4]
		print(x)
		print(y)
		datastring = '{"action": "find_person", "name": "'+name+'", "x": "'+x+'", "y": "'+y+'"}'
		dataArray = json.loads(datastring)

		pub = rospy.Publisher('chatter', String, queue_size=10)
		rospy.init_node('print_person', anonymous=False)
		rospy.loginfo("Auf der Suche nach: " + dataArray["name"])

		rate = rospy.Rate(1) # 10hz
		i = 0
		while i < 4:
			pub.publish(datastring)
			i += 1
			rate.sleep()

teleopInstance = teleop.Teleop()

def action_teleop_start():
	teleopInstance.startTeleop()
	print("Starting teleop....")

def teleop_talker(key):
	pub = rospy.Publisher('teleop_chatter', String, queue_size=10)
	rospy.init_node('teleop_talker', anonymous=True)
	rate = rospy.Rate(10) # 10hz
	pub.publish(key)
	
def launch_node():
	print("launching node...")
	subprocess.run(["rosrun", "find_person", "go_to_person.py"])

######################### WEBSOCKET ####################################################

connected = set()

def start_websocket():
	print("Starting websocket")
	async def ws_recieve(websocket, path):
		connected.add(websocket)
		print(websocket)
		msg = await websocket.recv()
		data = json.loads(msg)
		print(msg)
		response = ''

		action = data['action']

		if(action == 'FIND PERSON'):
			action_find_person(data['name'],data['x'], data['y'], data['message'])
			#await websocket.send("sucess")
		elif(action == 'TELEOP'):
			key = data['key']
			if(key == 'start'):
				action_teleop_start()
			else:
				teleop_talker(key)
		else:
			print("unknown action")
		
		#await websocket.send(response)

	start_server = websockets.serve(ws_recieve, "192.168.1.225", 8765, close_timeout=1000) # IP has to be IP of ROS-Computer

	asyncio.get_event_loop().run_until_complete(start_server)
	asyncio.get_event_loop().run_forever()

######################### CLEANUP ####################################################
def cleanup_on_exit(signal, frame):
	print("cleanup...")

	# terminate websocket connections
	for ws in connected:
		ws.close()
		print("closed websocket connection: " + str(ws))

	for proc in activeProcesses:
		proc.terminate()
		print("terminated process: " + str(proc))
	exit(0)

######################### TEST ####################################################
activeProcesses = set()

def main():

	try:
		# register KeyboardInterrupt handler
		signal.signal(signal.SIGINT, cleanup_on_exit)

		# -- launch node process --
		p_launchNode = multiprocessing.Process(target=launch_node)
		p_launchNode.start()
		activeProcesses.add(p_launchNode)

		# -- websocket process --
		p_websocket = multiprocessing.Process(target=start_websocket)
		p_websocket.start()
		activeProcesses.add(p_websocket)

		# -- teleop process --
		p_teleop = multiprocessing.Process(target=action_teleop_start)
		p_teleop.start()

		# -- robot ssh process --
		process3 = multiprocessing.Process(target=robo_ssh)
		#process3.start()
	finally:
		print("...")
		
if __name__ == '__main__':
	main()
	
