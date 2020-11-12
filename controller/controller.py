#! /usr/bin/env python

"""
Controller, operates as bridge between app, database, and ROS

Features:
- Accesses database script
- Receives actions from app over websocket protocol
- Sends actions to ROS (topics, nodes...) -> actions should be outsourced to own scripts

"""

#import database_access as db
import json
import subprocess
import multiprocessing
import paramiko

import rospy
import roslaunch
from std_msgs.msg import String

# websocket imports

import asyncio
import websockets

import time

# robot action imports
#import go_to_goal
import init_position
import move_forward
#import move_to_goal

ACTION_KEY = "action"


# get action that should be done from JSON Object
def json_get_action(jsonObj):
	action = json_get_value_by_key(jsonObj, ACTION_KEY)
	return action

# get value by key from a JSON Oject
def json_get_value_by_key(jsonObj, key):
	data = json.loads(jsonObj)
	return data[key]

######################### DATABASE ACTIONS ##############################################

# implementation in DB script

#------------- USER --------------

'''

def getUser_db(name, password, image, location):
	db.getUser(name)

def getAllUsers_db():
	db.getAllUsers(name, password)

def addUser_db(name, password):
	db.addUser(name, password)

def deleteUser_db(user_id):
	db.deleteUser(user_id)


#------------- ROBOS --------------

def add_robo_db(name, ip, username):
	db.add_robo(name, ip, username)

def delete_robo_db(name, username):
	db.delete_robo(name, username)

def get_robos():
	db.get_robos()

#------------- ROOM --------------

def add_room_db(name, roboname, username):
	db.add_room(name, roboname, username)

def delete_room_db(name, username):
	db.delete_room(name, username)

def get_rooms_db():
	db.get_rooms()

#------------- LOCATION --------------	

def add_location_db(name, x, y, username, room):
	db.add_location(name, x, y, username, room)

def delete_location_db(name, username):
	db.delete_location(name, username)

def change_active_location_db(locationname, username):
	db.change_active_location(locationname, username)

def get_locations_db(username):
	db.get_locations(username)

#------------- LOCATION --------------	

def send_message_db(usernameSender, usernameReceiver, text):
	db.send_message(usernameSender, usernameReceiver, text)

def get_messages_db():
	db.get_messages()

'''

'''
######################### ROBOT ACTIONS ##############################################



def init_position_action(x,y):
	
	#init_position.init_position(x,y)
	
# dummy Twist action for moving forward
def move_forward_action(seconds, direction):

	#move_forward.move_forward(seconds, direction)

# go to goal example with import -----------------------------------------------------------
def go_to_goal_action(pos_X, pos_Y, tolerance):
	
	#TODO implement
	#go_to_goal.move_to_goal(pos_X, pos_Y, tolerance)

'''

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





def launch_node():
	print("launching node...")
	subprocess.run(["rosrun", "find_person", "print_patrick.py"])

######################### WEBSOCKET ####################################################

def start_websocket():
	connected = set()
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
		
		#await websocket.send(response)

	start_server = websockets.serve(ws_recieve, "192.168.1.116", 8762, close_timeout=1000) # IP has to be IP of ROS-Computer

	asyncio.get_event_loop().run_until_complete(start_server)
	asyncio.get_event_loop().run_forever()

######################### TEST ####################################################

if __name__ == '__main__':
	process = multiprocessing.Process(target=launch_node)
	#process.start()
	processWebsocket = multiprocessing.Process(target=start_websocket)
	processWebsocket.start()
	process3 = multiprocessing.Process(target=robo_ssh)
	#process3.start()
