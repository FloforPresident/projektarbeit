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

	if(action == 'ADD USER'):
		response = db.addUser(data['location'], data['name'], data['password'])
	elif(action == 'LOGIN USER'):
		response = db.loginUser(data['name'], data['password'])
	elif(action == 'GET ROOMS'):
		response = db.getAllRooms()
	elif(action == 'ADD ROOM'):
		db.addRoom(data['name'], data['robo_id'], None, None)
	elif(action == 'DELETE ROOM'):
		db.deleteRoom(data['id'])
	elif(action == 'GET ROBOS'):
		response = db.getAllRobos()
	elif(action == 'ADD ROBO'):
		db.addRobo(data['name'], data['ip'])
	elif(action == 'DELETE ROBO'):
		db.deleteRobo(data['id'])

	print(response)

	await websocket.send(response)

	

start_server = websockets.serve(ws_recieve, "192.168.188.145", 8765, close_timeout=1000)

asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()
