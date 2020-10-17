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
	decoded = json.loads(msg)
	
	if(decoded["action"] == "move"):
		await websocket.send("sucess")
	print(msg)

start_server = websockets.serve(ws_recieve, "192.168.1.4", 8765, close_timeout=1000)

asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()
