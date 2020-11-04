"""
Script for accessing the database

"""


#!/usr/bin/env python
import mysql.connector

import rospy
from std_msgs.msg import String
def connect():
	sqlConnection = mysql.connector.connect(
		host="localhost",
		user="root",
		password="",
		database="test"
	)

	answer = sqlConnection

############################ DB ACTION METHODS #####################################

#------------- USER --------------

def add_user(name, password, image, location):
	#TODO
	print(name)

def delete_user(name, password):

	#TODO
	print("delete user")

def login_user(name, password):
	#TODO
	print("lobin user")

def logout_user(name):
	#TODO
	print("logout user")

'''
#------------- ROBOS --------------

def add_robo_db(name, ip, username):
	db.add_robo(name, ip, username)

def delete_robo_db(name, username):
	db.delete_robo(name, username)

def get_robos():
	db.get_robos()

#------------- ROOM --------------

def add_room_db(name, roboname, username):
	db.add_room(name, roboname, username)

def delete_room_db(name, username):
	db.delete_room(name, username)

def get_rooms_db():
	db.get_rooms

#------------- LOCATION --------------	

def add_location_db(name, x, y, username, room):
	db.add_location(name, x, y, username, room)

def delete_location_db(name, username):
	db.delete_location(name, username)

def change_active_location_db(locationname, username):
	db.change_active_location(locationname, username)

def get_locations_db(username):
	db.get_locations(username)

#------------- LOCATION --------------	

def send_message_db(usernameSender, usernameReceiver, text):
	db.send_message(usernameSender, usernameReceiver, text)

def get_messages_db():
	db.get_messages()

'''

if __name__ == '__main__':
    try:
        connect()
    except rospy.ROSInterruptException:
        pass
