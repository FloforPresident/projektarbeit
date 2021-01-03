import asyncio
import websockets
import json
import time

async def ws_send():
	uri = "ws://192.168.1.225:8765"
	async with websockets.connect(uri) as websocket:
		'''
		msg = json.dumps({"action":"TELEOP","key":"UP"})
		#msg="hello"
		await websocket.send(msg)
		print(msg)
		'''

		msg = json.dumps({"action":"TELEOP","key":"s"})

		#msg = json.dumps({"action":"FIND PERSON","name":"Patrick", "message":"Hallo", "x":"0.723","y":"0.087"})

		await websocket.send(msg)


        # greeting = await websocket.recv()

asyncio.get_event_loop().run_until_complete(ws_send())
