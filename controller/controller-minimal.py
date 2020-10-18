import json

# websocket imports
import asyncio
import websockets

# websocket server --------------------------------------------------------------

connected = set()

async def ws_recieve(websocket, path):
	connected.add(websocket)
	print(websocket)
	msg = await websocket.recv()
	data = json.loads(msg)
	
	
	if(data['action'] == 'ADD USER'):
		with open('test-user.txt', 'w') as file:
			json.dump(data, file)
	
	if(decoded["action"] == "move"):
		
		with open('test-user.txt', 'w') as file:
			json.dump(decoded, file)
		
		await websocket.send("sucess")
	print(msg)

start_server = websockets.serve(ws_recieve, "192.168.0.175", 8765, close_timeout=1000)

asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()
