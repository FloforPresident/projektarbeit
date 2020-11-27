import json

# websocket imports
import asyncio
import websockets


from databaseClass import database


# websocket server --------------------------------------------------------------

connected = set()
db = database("localhost","root","","turtlebot")

async def ws_recieve(websocket, path):
	connected.add(websocket)
	print(websocket)
	msg = await websocket.recv()
	data = json.loads(msg)
	response = ''

	action = data['action']

	#USER
	if(action == 'ADD USER'):
		response = db.addUser(data['location'], data['name'], data['password'])
	elif(action == 'LOGIN USER'):
		response = db.loginUser(data['name'], data['password'])
	elif(action == 'GET USERS'):
		response = db.getAllUsers()
	#ROOM
	elif(action == 'GET ROOMS'):
		response = db.getAllRooms()
	elif(action == 'ADD ROOM'):
		db.addRoom(data['roboID'], data['name'], None, None)
	elif(action == 'DELETE ROOM'):
		db.deleteRoom(data['id'])
	#ROBO
	elif(action == 'GET ROBOS'):
		response = db.getAllRobos()
	elif(action == 'ADD ROBO'):
		db.addRobo(data['name'], data['ip'])
	elif(action == 'DELETE ROBO'):
		db.deleteRobo(data['id'])
	elif(action == 'UPDATE ROBO'):
		db.updateRobo(data['room_id'], data['robo_id'])
	#Friend
	elif(action == 'GET FRIENDS'):
		response = db.getAllFriends()
	elif(action == 'DELETE FRIEND'):
		db.deleteFriend(data['id'])
	#LOCATION
	elif(action == 'GET LOCATIONS'):
		response = db.getAllLocations()
	elif(action == 'ADD LOCATION'):
		db.addLocation(data['roomID'], data['title'], data['x'], data['y'])
	elif(action == 'DELETE LOCATION'):
		db.deleteLocation(data['id'])
	elif(action == 'UPDATE FRIEND'):
		db.updateLocation(data['user_id'], data['location_id'])
	#MESSAGE
	elif(action == 'SEND MESSAGE'):
		response = db.sendMessage(data['from_user'], data['to_user'], data['subject'], data['message'])
		# Hier dann Funkionalität von Roboter aufrufen
	#CONTROL
	elif(action == "UP"):
		response = action
	elif(action == "DOWN"):
		response = action
	elif(action == "RIGHT"):
		response = action
	elif(action == "LEFT"):
		response = action

	print(response)

	await websocket.send(response)

	

start_server = websockets.serve(ws_recieve, "192.168.188.145", 8765, close_timeout=1000)

asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()
