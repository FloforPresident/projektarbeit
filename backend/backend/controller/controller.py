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

#:::::::::::::::::::::::::: STAND 10.01.2021 ::::::::::::::::::::::::::

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


# def robo_ssh():
#     host = "192.168.1.124"
#     port = "22"
#     username = "pi"
#     password = "turtlebot"
#
#     # command = "cd BringupScripts && ./start_camera.sh"
#     # command = '/opt/ros/kinetic/bin/roslaunch raspicam_node camerav1_1280x720.launch enable_raw:=true'
#     # command = 'bash --login -c "roslaunch raspicam_node camerav1_1280x720.launch enable_raw:=true"'
#     # command = 'PATH="$PATH;/opt/ros/kinetic/bin/roslaunch" && roslaunch raspicam_node camerav1_1280x720.launch enable_raw:=true'
#     # command = "/sbin/ifconfig"
#     command = "echo $PATH"
#
#     ssh = paramiko.SSHClient()
#     ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
#     ssh.connect(host, port, username, password)
#     stdin, stdout, stderr = ssh.exec_command(command, timeout=None)
#     lines = stdout.readlines()
#     err = stderr.readlines()
#     print(lines)
#     print(err)


# chan=ssh.invoke_shell()
# chan.send('roslaunch raspicam_node camerav1_1280x720.launch enable_raw:=true')

def action_face_recognition(user, message):
    print("face recognition started")
    name = user[0]
    embedding = user[1]
    pubMessage = message
    
    print("Name: " + name)
    print("Embedding: " + embedding)
    print("Message" + message)

    rospy.init_node('face_recognition', anonymous=True)

    pub_name = rospy.Publisher('data_name', String, queue_size=1)
    pub_embedding = rospy.Publisher('data_embedding', String, queue_size=1)
    pub_message = rospy.Publisher('data_message', String, queue_size=1)

    while pub_name.get_num_connections() == 0:
        rospy.loginfo("Waiting for  name publisher to connect")
        rospy.sleep(1)
    pub_name.publish(name)

    time.sleep(2)

    while pub_embedding.get_num_connections() == 0:
        rospy.loginfo("Waiting for embedding publisher to connect")
        rospy.sleep(1)
    pub_embedding.publish(embedding)

    time.sleep(2)

    while pub_message.get_num_connections() == 0:
        rospy.loginfo("Waiting for message publisher to connect")
        rospy.sleep(1)
    pub_message.publish(pubMessage)

    time.sleep(2)

def action_find_person(name, x, y):
    datastring = '{"action": "find_person", "name": "' + name + '", "x": "' + str(x) + '", "y": "' + str(y) + '"}'
    print(datastring)
    dataArray = json.loads(datastring)

    pub = rospy.Publisher('chatter', String, queue_size=10)
    rospy.init_node('print_person', anonymous=False)
    rospy.loginfo("Auf der Suche nach: " + dataArray["name"])

    rate = rospy.Rate(1)  # 10hz
    i = 0
    while i < 4:
        pub.publish(datastring)
        i += 1
        rate.sleep()

teleopInstance = teleop.Teleop()


def action_teleop_start():
    teleopInstance.startTeleop()
    print("Starting teleop....")

def action_roscore_start():
    subprocess.run(["roscore"])


def teleop_talker(key):
    print("Teleop Talker!")
    pub = rospy.Publisher('teleop_chatter', String, queue_size=10)
    rospy.init_node('teleop_talker', anonymous=True)

    #tell find person node to stop
    pubStop = rospy.Publisher('chatter', String, queue_size=10)
    datastring = '{"action": "stop", "name": "nobody"}'
    dataArray = json.loads(datastring)
    pubStop.publish(datastring)

    #rate = rospy.Rate(10)  # 10hz
    pub.publish(key)


def launch_node():
    print("launching node...")
    subprocess.run(["rosrun", "find_person", "go_to_person.py"])



######################### WEBSOCKET ####################################################

connected = set()

def start_websocket():

    
    print("Starting websocket")
    async def ws_recieve(websocket, path):
        connected.add(websocket)
        print(websocket)

        msg = await websocket.recv()
        data = json.loads(msg)
        
        response = ''

        action = data['action']

        # USER
        if action == 'ADD USER':
            image = data['image']
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
            #action_find_person(response['user'][0], response['x'], response['y'])
            mp_action_find_person = multiprocessing.Process(target=action_find_person, args=[response['user'][0], response['x'], response['y']])
            mp_action_find_person.start()
            #action_face_recognition(response['user'], data['message'])
            mp_action_face_recognition = multiprocessing.Process(target=action_face_recognition, args=[response['user'], data['message']])
            mp_action_face_recognition.start()

        # CONTROL
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
            teleop_talker('s')
            response = action

        response = json.dumps(response)
        #print(response)

        # if(action == 'FIND PERSON'):
        #     action_find_person(data['name'],data['x'], data['y'], data['message'])
        # #await websocket.send("sucess")
        # elif(action == 'TELEOP'):
        #     key = data['key']
        #     if(key == 'start'):
        #         action_teleop_start()
        #     else:
        #         teleop_talker(key)
        # else:
        #     print("unknown action")

        await websocket.send(response)

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

def rospy_init_node():
    rospy.init_node('controller_node', anonymous=False)

def main():

    try:
        
        # initalize Database
        db.create_all()

        # register KeyboardInterrupt handler
        signal.signal(signal.SIGINT, cleanup_on_exit)

        #rospy_init_node()

        #p_roscore = multiprocessing.Process(target=action_roscore_start)
        #p_roscore.start()
        #activeProcesses.add(p_roscore)

        # -- launch node process --
        # p_launchNode = multiprocessing.Process(target=launch_node)
        # p_launchNode.start()
        # activeProcesses.add(p_launchNode)

        # -- websocket process --
        p_websocket = multiprocessing.Process(target=start_websocket)
        p_websocket.start()
        activeProcesses.add(p_websocket)

        # -- teleop process --
        p_teleop = multiprocessing.Process(target=action_teleop_start)
        p_teleop.start()

        
        # -- robot ssh process --
        # process3 = multiprocessing.Process(target=robo_ssh)
    #process3.start()
    finally:
        print("...")


if __name__ == '__main__':
    print("start controller")
    main()
    print('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<')
    print('<<<<<<<<<<<WELCOME<<<<<<<<<<<<<')
    print('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<')