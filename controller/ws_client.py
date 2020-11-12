import asyncio
import websockets
import json

async def ws_send():
	uri = "ws://192.168.1.116:8762"
	async with websockets.connect(uri) as websocket:
	
		msg = json.dumps({"action":"FIND PERSON","name":"Patrick", "message":"Hallo", "x":"0","y":"0"})
		#msg="hello"
		await websocket.send(msg)
		print(msg)

        # greeting = await websocket.recv()

asyncio.get_event_loop().run_until_complete(ws_send())
