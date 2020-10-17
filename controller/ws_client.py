import asyncio
import websockets
import json

async def ws_send():
	uri = "ws://192.168.1.225:8765"
	async with websockets.connect(uri) as websocket:
	
		#msg = json.dumps({'action':'goToGoal','param1':'1.0', 'param2':'1.0', #'param3':'0.5'})
		msg="hello"
		await websocket.send(msg)
		print(msg)

        # greeting = await websocket.recv()

asyncio.get_event_loop().run_until_complete(ws_send())
