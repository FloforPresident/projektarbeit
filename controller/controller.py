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
