import json
import base64
from flask import Flask
from models import *
import asyncio
import websockets

app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = 'postgres://admin:admin@db:5432/turtlebot_db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

connected = set()


async def ws_handler(websocket, path):
    connected.add(websocket)
    print(websocket)
    msg = await websocket.recv()
    data = json.loads(msg)
    response = ''

    action = data['action']

    # USER
    if action == 'ADD USER':
        add_user(data['location_id'], data['name'], data['image'])
        response = login_user(data['name'])
    elif action == 'LOGIN USER':
        response = login_user(data['name'])
    elif action == 'GET USERS':
        response = get_users()

    # ROOM
    elif action == 'ADD ROOM':
        add_room(data['roboID'], data['name'])
        response = get_room(data['name'])
    elif action == 'DELETE ROOM':
        delete_room(data['id'])
    elif action == 'UPDATE ROBO':
        update_robo(data['robo_id'], data['room_id'])
    elif action == 'GET ROOMS':
        response = {"rooms": get_rooms(), "robos": get_robos()}
    elif action == 'SCAN ROOM':
        # Todo Room Scan logic
        response = ''

    # ROBO
    elif action == 'ADD ROBO':
        response = add_robo(data['name'], data['ip'])
    elif action == 'DELETE ROBO':
        delete_robo(data['id'])
    elif action == 'GET ROBOS':
        response = get_robos()

    # Friend
    elif action == 'DELETE FRIEND':
        delete_user(data['id'])
    elif action == 'UPDATE FRIEND':
        update_location(data['user_id'], data['location_id'])
    elif action == 'GET FRIENDS':
        response = {"users": get_users(), "locations": get_locations(), "rooms": get_rooms()}

    # LOCATION
    elif action == 'ADD LOCATION':
        response = add_location(data['roomID'], data['title'], data['x'], data['y'])
    elif action == 'DELETE LOCATION':
        delete_location(data['id'])
    elif action == 'GET LOCATIONS':
        response = {"locations": get_locations(), "rooms": get_rooms(), "user": get_user(data['id'])}

    # MESSAGE
    elif action == 'SEND MESSAGE':
        response = send_message(data['from_user'], data['to_user'], data['subject'], data['message'])
    # Todo Funkionalität von Roboter aufrufen

    # CONTROL
    elif action == "UP":
        response = action
    elif action == "DOWN":
        response = action
    elif action == "RIGHT":
        response = action
    elif action == "LEFT":
        response = action
    elif action == "STOP":
        response = action

    response = json.dumps(response)
    print(response)

    await websocket.send(str(response))


async def create_db():
    # db.drop_all()
    db.create_all()


async def main():
    await create_db()
    ws_server = websockets.serve(ws_handler, '0.0.0.0', 8765)
    asyncio.ensure_future(ws_server)


if __name__ == '__main__':
    print('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<')
    print('<<<<<<<<<<<WELCOME<<<<<<<<<<<<<')
    print('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<')
    loop = asyncio.get_event_loop()
    server = asyncio.ensure_future(main())
    loop.run_until_complete(server)
    loop.run_forever()
