#! /usr/bin/env python

"""
Controller, operates as bridge between app, database, and ROS

Features:
- Accesses database script
- Receives actions from app over websocket protocol
- Sends actions to ROS (topics, nodes...) -> actions should be outsourced to own scripts

"""

# python imports
import json
import subprocess
import multiprocessing
# import paramiko
import sys
import signal
import base64
import time
import asyncio
import websockets

from flask import Flask

# ros imports
import rospy
import roslaunch
from std_msgs.msg import String

# user imports
from models import *
from face_encoding.face_encoding import createFaceEncoding
import teleop_keyboard as teleop

app = Flask(__name__)

teleop_active = False

#:::::::::::::::::::::::::: STAND 15.01.2021 ::::::::::::::::::::::::::

# get env file
import os
from dotenv import load_dotenv
load_dotenv()

# set ip
public_ip = os.getenv("HOST_IP")
ip = str(public_ip)
print("your ip is: " + ip)

app.config['SQLALCHEMY_DATABASE_URI'] = 'postgres://admin:admin@'+ip+':5432/turtlebot_db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False


#initialize teleop class
teleopInstance = teleop.Teleop()


# start roscore - not needed yet
def action_roscore_start():
    subprocess.run(["roscore"])
# launch node - not needed yet
def launch_node():
    print("launching node...")
    subprocess.run(["rosrun", "find_person", "go_to_person.py"])




#send data to face_recognition node
def action_face_recognition(user, message):
    print("face recognition started")
    name = user[0]
    embedding = user[1]
    pubMessage = message
    
    print("Name: " + name)
    print("Embedding: " + embedding)
    print("Message" + message)


    pub_name = rospy.Publisher('data_name', String, queue_size=1)
    pub_embedding = rospy.Publisher('data_embedding', String, queue_size=1)
    pub_message = rospy.Publisher('data_message', String, queue_size=1)

    pub_name.publish(name)
    time.sleep(2)

    pub_embedding.publish(embedding)
    time.sleep(2)

    pub_message.publish(pubMessage)
    time.sleep(2)


# send data to find_person node
def action_find_person(name, x, y):
    global teleop_active
    teleop_active = False

    datastring = '{"action": "find_person", "name": "' + name + '", "x": "' + str(x) + '", "y": "' + str(y) + '"}'
    print(datastring)
    dataArray = json.loads(datastring)

    pub = rospy.Publisher('chatter', String, queue_size=10)
    rospy.loginfo("Auf der Suche nach: " + dataArray["name"])

    pub.publish(datastring)


# initialize teleop class
def action_teleop_start():
    teleopInstance.startTeleop()
    print("Starting teleop....")

# send key to teleop_keyboard script
def teleop_talker(key):
    print("Teleop Talker!")
    find_person_node_pause()

    pub = rospy.Publisher('teleop_chatter', String, queue_size=10)
    pub.publish(key)

# tell find_person node that teleop is active
def find_person_node_pause():
    global teleop_active

    if teleop_active == False:
        print("set teleop active")
        #tell find person node to stop
        pubStop = rospy.Publisher('chatter', String, queue_size=10)
        datastring = '{"action": "stop", "name": "nobody"}'
        dataArray = json.loads(datastring)
        pubStop.publish(datastring)

        teleop_active = True



######################### WEBSOCKET ####################################################

connected = set()

def start_websocket():

    print("Starting websocket")
    print('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<')
    print('<<<<<<<<<<<WELCOME<<<<<<<<<<<<<')
    print('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<')
    
    #------------------------------------------------------------
    #--- calls this function whenever websocket receives data ---
    #------------------------------------------------------------
    async def ws_recieve(websocket, path):

        connected.add(websocket)
        print(websocket)

        msg = await websocket.recv()
        data = json.loads(msg)
        
        response = ''

        try:
            # action tells controller what to do
            action = data['action']

            # USER
            if action == 'ADD USER':
                image = data['image']
                print("this could take a while. please wait or try again.")
                embedding = createFaceEncoding(image)
                add_user(data['location_id'], data['name'], image, embedding)
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
                
                #send to find_person package
                action_find_person(response['user'][0], response['x'], response['y'])

                #send to face_recognition package
                action_face_recognition(response['user'], data['message'])

            # CONTROLS
            elif action == "UP":
                teleop_talker('w')
                response = action
            elif action == "DOWN":
                teleop_talker('x')
                response = action
            elif action == "RIGHT":
                teleop_talker('d')
                response = action
            elif action == "LEFT":
                teleop_talker('a')
                response = action
            elif action == "STOP":
                #make sure STOP always stops
                print("----- STOP -----")
                forceStop = rospy.Publisher('chatter', String, queue_size=10)
                datastring = '{"action": "stop", "name": "nobody"}'
                dataArray = json.loads(datastring)
                forceStop.publish(datastring)

                teleop_talker('s')
                response = action

            response = json.dumps(response)

            await websocket.send(response)
        
        except:
            print("an error occured. try sending command again")



    start_server = websockets.serve(ws_recieve, ip, 8765, max_size=1000000000000000, close_timeout=1000) # IP has to be IP of ROS-Computer

    asyncio.get_event_loop().run_until_complete(start_server)
    asyncio.get_event_loop().run_forever()


######################### CLEANUP ####################################################
def cleanup_on_exit(signal, frame):
    print("cleanup...")

    # terminate websocket connections
    for ws in connected:
        ws.close()
        print("closed websocket connection: " + str(ws))

    for proc in activeProcesses:
        proc.terminate()
        print("terminated process: " + str(proc))
    exit(0)

activeProcesses = set()


# --- main ---
def main():

    try:
        
        # initalize Database
        db.create_all()

        # register KeyboardInterrupt handler
        signal.signal(signal.SIGINT, cleanup_on_exit)

        #init_node nur einmal aufrufen hier
        rospy.init_node('controller_node', anonymous=False)

        #initialize teleop
        action_teleop_start()

        #initialize websocket
        start_websocket()
        #activeProcesses.add(p_websocket)

    except:
        print("something went wrong in main")


if __name__ == '__main__':
    print("start controller")
    main()