import json

# websocket imports
import asyncio
import websockets

# functions

def writeData(file, data):
	
	#remove action
	del data['action']
	
	#append data to file
	with open(file, 'a+') as doc:
		doc.seek(0)
		content = doc.read(100)
		if len(content) > 0:
			doc.write("\n")
		json.dump(data, doc, sort_keys=True)


# websocket server --------------------------------------------------------------

connected = set()

async def ws_recieve(websocket, path):
	connected.add(websocket)
	print(websocket)
	msg = await websocket.recv()
	data = json.loads(msg)
	response = ''

	
	if(data['action'] == 'ADD USER'):
		writeData('test-user.txt', data)
		
	elif(data['action'] == 'LOGIN USER'):
		with open('test-user.txt', 'r') as file:
			lines = file.readlines()

			for line in lines:
				user = json.loads(line)	

				if user['name'] == data['name']:
					if user['password'] == data['password']:
						response = 'success'
						break
					else: 
						response = 'Incorrect password'
				else: 
					response = 'User not known, try to sign up'

	print(data)
	
	await websocket.send(response)

	

start_server = websockets.serve(ws_recieve, "192.168.188.143", 8765, close_timeout=1000)

asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()
