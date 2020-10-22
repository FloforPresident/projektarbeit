"""
Controller, operates as bridge between app, database, and ROS

Features:
- Accesses database script
- Receives actions from app over websocket protocol
- Sends actions to ROS (topics, nodes...) -> actions should be outsourced to own scripts

"""

import database_access as db
import json

import rospy

# websocket imports
import asyncio
import websockets

import time

# robot action imports
import go_to_goal
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

def add_user_db(name, password, image, location):
	db.add_user(name, password, image, location)

def delete_user_db(name, password):
	db.delete_user(name, password)

def login_user_db(name, password):
	db.login_user(name, password)

def logout_user_db(name):
	db.logout_user(name)

'''
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

######################### WEBSOCKET ####################################################


connected = set()

async def ws_recieve(websocket, path):
	connected.add(websocket)
	print(websocket)
	msg = await websocket.recv()
	decoded = json.loads(msg)
	#param1 = decoded["param1"]
	
	if(decoded["action"] == "move"):
		# move_forward(3,1)
		await websocket.send("sucess")
	print(msg)

start_server = websockets.serve(ws_recieve, "192.168.1.225", 8765, close_timeout=1000) # IP has to be IP of ROS-Computer

asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()

######################### TEST ####################################################

# move_forward(3)

dummyJson = '{ "action": "find_goal", "name":"bocklet", "room":1 }'

testRoom = json_get_value_by_key(dummyJson, "room")
testName = json_get_value_by_key(dummyJson, "name")
testAction = json_get_action(dummyJson)
# print(testRoom)
# print(testName)
# print(testAction)


if __name__ == '__main__':
	add_user_db("Patrick", "123", "TestImage", "Room1")
