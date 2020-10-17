import database_access as db
import json

import rospy

# websocket imports
import asyncio
import websockets

import time

# topics & msg
from geometry_msgs.msg import Twist

import goToGoal

ACTION_KEY = "action"


# get action that should be done from JSON Object
def json_get_action(jsonObj):
	action = json_get_value_by_key(jsonObj, ACTION_KEY)
	return action

# get value by key from a JSON Oject
def json_get_value_by_key(jsonObj, key):
	data = json.loads(jsonObj)
	return data[key]



# move forward example -----------------------------------------------------------

def move_sim(seconds, direction):
	# dummy Twist msg for moving forward
	vel_msg = Twist()
	vel_msg.linear.x = direction
	vel_msg.linear.y = 0
	vel_msg.linear.z = 0
	vel_msg.angular.x = 0
	vel_msg.angular.y = 0
	vel_msg.angular.z = 1.0

	t_end = time.time() + seconds
	while time.time() < t_end:
		rospy.init_node('move', anonymous=True)
		pub = rospy.Publisher('/turtle1/cmd_vel', Twist, queue_size=10)
		pub.publish(vel_msg)

# go to goal example with import -----------------------------------------------------------
def go_to_goal(pos_X, pos_Y, tolerance):
	goToGoal.move_to_goal(pos_X, pos_Y, tolerance)

# websocket server --------------------------------------------------------------

connected = set()

async def ws_recieve(websocket, path):
	connected.add(websocket)
	print(websocket)
	msg = await websocket.recv()
	decoded = json.loads(msg)
	#param1 = decoded["param1"]
	#param2 = decoded["param2"]
	#param3 = decoded["param3"]
	
	if(decoded["action"] == "move"):
		move_sim(3,1)
		await websocket.send("sucess")
	#elif(decoded["action"] == "goToGoal"):
	#	go_to_goal(param1, param2, param3)
	# await websocket.send(greeting)
	print(msg)

start_server = websockets.serve(ws_recieve, "192.168.1.225", 8765, close_timeout=1000)

asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()

# test ----------------------------------------------------------------------------

# move_sim(3)

dummyJson = '{ "action": "find_goal", "name":"bocklet", "room":1 }'

testRoom = json_get_value_by_key(dummyJson, "room")
testName = json_get_value_by_key(dummyJson, "name")
testAction = json_get_action(dummyJson)
# print(testRoom)
# print(testName)
# print(testAction)
