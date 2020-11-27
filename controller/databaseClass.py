#!/usr/bin/env python

# import rospy
import os
import subprocess
import json

import mysql.connector


class database:
	def __init__(self, host, user, password, databasename):
		self.mydb = mysql.connector.connect(
			host=host,
			user=user,
			password=password,
			database=databasename
		)

	#::::USER::::
	def getAllUsers(self):
		mycursor = self.mydb.cursor(prepared = True)
		mycursor.execute("SELECT * FROM User")
		users = mycursor.fetchall()

		data = []

		for i in range(len(users)):
			users[i] = list(users[i])
			for r in range(len(users[i])):
				if isinstance(users[i][r], bytearray):
					users[i][r] = users[i][r].decode("utf-8")

			dataEntity = {
				"user_id": users[i][0],
				"location_id": users[i][1],
				"username": users[i][2]
			}
			data.append(dataEntity)

		return json.dumps(data)
		

	def addUser(self, location_id, name, password):
		mycursor = self.mydb.cursor(prepared = True)
		sql = "INSERT INTO User (location_id, username, password) VALUES (%s, %s, %s)"
		val = (location_id, name, password)
		mycursor.execute(sql, val)
		self.mydb.commit()
		
		return 'success'
	
	def deleteUser(self, user_id):
		mycursor = self.mydb.cursor()
		sql = "DELETE FROM User WHERE user_id = "+str(user_id)
		mycursor.execute(sql)
		self.mydb.commit()
		print(mycursor.rowcount, "record(s) deleted")

	def loginUser(self, name, password):

		mycursor = self.mydb.cursor(prepared = True)
		mycursor.execute("SELECT user_id, location_id, username FROM User WHERE username = '"+name+"' AND password = '" + password + "'")
		myresult = mycursor.fetchall()

		if(myresult):
			myresult = myresult[0]
			
			data = {
				"user_id": myresult[0],
				"location_id": myresult[1],
				"username": myresult[2].decode("utf-8"),
			}

			return json.dumps(data)
		else:
			return ""


	#def logoutUser(name): TODO



	#::::ROBO::::
	def getAllRobos(self):
		mycursor = self.mydb.cursor(prepared = True)
		mycursor.execute("SELECT * FROM Robo")
		myresult = mycursor.fetchall()

		data = []

		for i in range(len(myresult)):
			myresult[i] = list(myresult[i])
			for r in range(len(myresult[i])):
				if isinstance(myresult[i][r], bytearray):
					myresult[i][r] = myresult[i][r].decode("utf-8")
				
			dataEntity = {
				"robo_id": myresult[i][0],
				"name": myresult[i][1],
				"ip": myresult[i][2]
			}
			data.append(dataEntity)

		return json.dumps(data)
	
	def addRobo(self, roboName, ip):
		mycursor = self.mydb.cursor(prepared = True)
		sql = "INSERT INTO Robo (name, ip) VALUES (%s, %s)"
		val = (roboName, ip)
		mycursor.execute(sql, val)
		self.mydb.commit()
		

	def deleteRobo(self, robo_id):
		mycursor = self.mydb.cursor()
		sql = "DELETE FROM Robo WHERE robo_id = '"+robo_id+"'"
		mycursor.execute(sql)
		self.mydb.commit()

	def updateRobo(self, room_id, robo_id):
		mycursor = self.mydb.cursor(prepared = True)
		sql = "UPDATE Room SET robo_id = %s WHERE Room.room_id = %s"
		val = (robo_id, room_id)
		mycursor.execute(sql, val)
		self.mydb.commit()

	def getRobo(self, name):
		mycursor = self.mydb.cursor(prepared = True)
		mycursor.execute("SELECT * FROM Robo WHERE name = '"+name+"'")
		myresult = mycursor.fetchall()
		for x in myresult:
			print(x)
		return myresult


	#::::FRIEND::::
	def getAllFriends(self):
		mycursor = self.mydb.cursor(prepared = True)

		#Get Users
		mycursor.execute("SELECT * FROM User")
		users = mycursor.fetchall()

		data = {"users": [], "locations": [], "rooms": []}

		for i in range(len(users)):
			users[i] = list(users[i])
			for r in range(len(users[i])):
				if isinstance(users[i][r], bytearray):
					users[i][r] = users[i][r].decode("utf-8")

			dataEntity = {
				"user_id": users[i][0],
				"location_id": users[i][1],
				"username": users[i][2]
			}
			data["users"].append(dataEntity)

		#Get Locations
		mycursor.execute("SELECT * FROM Location")
		locations = mycursor.fetchall()

		for i in range(len(locations)):
			locations[i] = list(locations[i])
			for r in range(len(locations[i])):
				if isinstance(locations[i][r], bytearray):
					locations[i][r] = locations[i][r].decode("utf-8")

			dataEntity = {
				"location_id": locations[i][0],
				"room_id": locations[i][1],
				"title": locations[i][2],
				"x": locations[i][3],
				"y": locations[i][4],
			}

			data["locations"].append(dataEntity)

		#Get Rooms
		mycursor.execute("SELECT * FROM Room")
		rooms = mycursor.fetchall()

		for i in range(len(rooms)):
			rooms[i] = list(rooms[i])
			for r in range(len(rooms[i])):
				if isinstance(rooms[i][r], bytearray):
					rooms[i][r] = rooms[i][r].decode("utf-8")

			dataEntity = {
				"room_id": rooms[i][0],
				"robo_id": rooms[i][1],
				"title": rooms[i][2],
				"pgm": rooms[i][3],
				"yaml": rooms[i][4]
			}
			data["rooms"].append(dataEntity)

		return json.dumps(data)

	# def getAllFriends(self):
	# 	mycursor = self.mydb.cursor(prepared = True)
	#
	# 	#Get Users
	# 	mycursor.execute("SELECT * FROM User")
	# 	users = mycursor.fetchall()
	#
	# 	data = {"users": [], "locations": [], "rooms": []}
	#
	# 	for i in range(len(users)):
	# 		users[i] = list(users[i])
	# 		for r in range(len(users[i])):
	# 			if isinstance(users[i][r], bytearray):
	# 				users[i][r] = users[i][r].decode("utf-8")
	#
	# 		dataEntity = {
	# 			"user_id": users[i][0],
	# 			"location_id": users[i][1],
	# 			"username": users[i][2]
	# 		}
	# 		data["users"].append(dataEntity)
	#
	# 		#Get Locations
	# 		location_id = str(dataEntity["location_id"])
	#
	# 		mycursor.execute("SELECT * FROM Location WHERE location_id = '"+location_id+"'")
	# 		locations = mycursor.fetchall()
	#
	# 		for i in range(len(locations)):
	# 			locations[i] = list(locations[i])
	# 			for r in range(len(locations[i])):
	# 				if isinstance(locations[i][r], bytearray):
	# 					locations[i][r] = locations[i][r].decode("utf-8")
	#
	# 			dataEntity = {
	# 				"location_id": locations[i][0],
	# 				"room_id": locations[i][1],
	# 				"title": locations[i][2],
	# 				"x": locations[i][3],
	# 				"y": locations[i][4],
	# 			}
	#
	# 			data["locations"].append(dataEntity)
	#
	# 			#Get Rooms
	# 			room_id = str(dataEntity['room_id'])
	#
	# 			mycursor.execute("SELECT * FROM Room WHERE room_id = '"+room_id+"'")
	# 			rooms = mycursor.fetchall()
	#
	# 			for i in range(len(rooms)):
	# 				rooms[i] = list(rooms[i])
	# 				for r in range(len(rooms[i])):
	# 					if isinstance(rooms[i][r], bytearray):
	# 						rooms[i][r] = rooms[i][r].decode("utf-8")
	#
	# 				dataEntity = {
	# 					"room_id": rooms[i][0],
	# 					"robo_id": rooms[i][1],
	# 					"title": rooms[i][2],
	# 					"pgm": rooms[i][3],
	# 					"yaml": rooms[i][4]
	# 				}
	# 				data["rooms"].append(dataEntity)
	#
	# 	return json.dumps(data)


	def deleteFriend(self, user_id):
		mycursor = self.mydb.cursor()
		sql = "DELETE FROM User WHERE user_id = '"+user_id+"'"
		mycursor.execute(sql)
		self.mydb.commit()


	#::::ROOM::::

	# TODO yaml und pgm

	def getAllRooms(self):
		mycursor = self.mydb.cursor(prepared = True)
		
		#Get Rooms
		mycursor.execute("SELECT * FROM Room")
		rooms = mycursor.fetchall()

		data = {"rooms": [], "robos": []}

		for i in range(len(rooms)):
			rooms[i] = list(rooms[i])
			for r in range(len(rooms[i])):
				if isinstance(rooms[i][r], bytearray):
					rooms[i][r] = rooms[i][r].decode("utf-8")
				
			dataEntity = {
				"room_id": rooms[i][0],
				"robo_id": rooms[i][1],
				"title": rooms[i][2],
				"pgm": rooms[i][3],
				"yaml": rooms[i][4]
			}
			data["rooms"].append(dataEntity)

		#Get Robos
		mycursor.execute("SELECT * FROM Robo")
		robos = mycursor.fetchall()

		for i in range(len(robos)):
			robos[i] = list(robos[i])
			for r in range(len(robos[i])):
				if isinstance(robos[i][r], bytearray):
					robos[i][r] = robos[i][r].decode("utf-8")
				
			dataEntity = {
				"robo_id": robos[i][0],
				"name": robos[i][1],
				"ip": robos[i][2],
			}
			data["robos"].append(dataEntity)

		return json.dumps(data)

	def addRoom(self, robo_id, roomName, pgm, yaml):
		mycursor = self.mydb.cursor(prepared = True)
		sql = "INSERT INTO Room (robo_id, title, pgm, yaml) VALUES (%s, %s, %s, %s)"
		val = (robo_id, roomName, pgm, yaml)
		mycursor.execute(sql, val)
		self.mydb.commit()

	def deleteRoom(self, room_id):
		mycursor = self.mydb.cursor()
		sql = "DELETE FROM Room WHERE room_id = '"+room_id+"'"
		mycursor.execute(sql)
		self.mydb.commit()

	def getRoom(self, roomName):
		mycursor = self.mydb.cursor(prepared = True)
		mycursor.execute("SELECT * FROM Room  WHERE title = '"+roomName+"'")
		myresult = mycursor.fetchone()
		for x in myresult:
			print(x)
		return myresult


	#::::LOCATION::::
	def getAllLocations(self):
		mycursor = self.mydb.cursor(prepared = True)
		
		#Get Rooms
		mycursor.execute("SELECT * FROM Room")
		rooms = mycursor.fetchall()

		data = {"locations": [], "active": [], "rooms": []}

		for i in range(len(rooms)):
			rooms[i] = list(rooms[i])
			for r in range(len(rooms[i])):
				if isinstance(rooms[i][r], bytearray):
					rooms[i][r] = rooms[i][r].decode("utf-8")
				
			dataEntity = {
				"room_id": rooms[i][0],
				"robo_id": rooms[i][1],
				"title": rooms[i][2],
				"pgm": rooms[i][3],
				"yaml": rooms[i][4]
			}
			data["rooms"].append(dataEntity)

		#Get Locations
		mycursor.execute("SELECT * FROM Location")
		locations = mycursor.fetchall()

		for i in range(len(locations)):
			locations[i] = list(locations[i])
			for r in range(len(locations[i])):
				if isinstance(locations[i][r], bytearray):
					locations[i][r] = locations[i][r].decode("utf-8")
				
			dataEntity = {
				"location_id": locations[i][0],
				"room_id": locations[i][1],
				"title": locations[i][2],
				"x": locations[i][3],
				"y": locations[i][4],
			}
			# if dataEntity['location_id'] == active:
			# 	data["active"].append(dataEntity)

			data["locations"].append(dataEntity)

		return json.dumps(data)

	
	def addLocation(self, room_id, title, x, y):
		mycursor = self.mydb.cursor(prepared = True)
		sql = "INSERT INTO Location (room_id, title, x, y) VALUES (%s, %s, %s, %s)"
		val = (room_id, title, x, y)
		mycursor.execute(sql, val)
		self.mydb.commit()

	def deleteLocation(self, location_id):
		mycursor = self.mydb.cursor()
		sql = "DELETE FROM Location WHERE location_id = '"+location_id+"'"
		mycursor.execute(sql)
		self.mydb.commit()

	def updateLocation(self, user_id, location_id):
		mycursor = self.mydb.cursor(prepared = True)
		sql = "UPDATE User SET location_id = %s WHERE User.user_id = %s"
		val = (location_id, user_id)
		mycursor.execute(sql, val)
		self.mydb.commit()

	
	def getLocation(self, id):
		mycursor = self.mydb.cursor(prepared = True)
		mycursor.execute("SELECT * FROM Location WHERE location_id = '"+id+"'")
		myresult = mycursor.fetchone()
		for x in myresult:
			print(x)
		return myresult


	#::::MESSAGE::::
	def sendMessage(self, from_user, to_user, subject, message):
		mycursor = self.mydb.cursor(prepared = True)
		sql = "INSERT INTO Message (from_user, to_user, subject, message) VALUES (%s, %s, %s, %s)"
		val = (from_user, to_user, subject, message)
		mycursor.execute(sql, val)
		self.mydb.commit()

		data = {"user": [], "location": [], "room": [], "robo": []}

		user_id = str(to_user)

		#Get User
		mycursor.execute("SELECT * FROM User WHERE user_id = '"+user_id+"'")
		user = list(mycursor.fetchall()[0])

		for i in range(len(user)):
			if isinstance(user[i], bytearray):
				user[i] = user[i].decode("utf-8")

		dataEntity = {
			"user_id": user[0],
			"location_id": user[1],
			"username": user[2]
		}
		data["user"].append(dataEntity)

		#Get Location
		location_id = str(dataEntity['location_id'])

		mycursor.execute("SELECT * FROM Location WHERE location_id = '"+location_id+"'")
		location = list(mycursor.fetchall()[0])

		for i in range(len(location)):
			if isinstance(location[i], bytearray):
				location[i] = location[i].decode("utf-8")

		dataEntity = {
			"location_id": location[0],
			"room_id": location[1],
			"title": location[2],
			"x": location[3],
			"y": location[4],
		}
		data["location"].append(dataEntity)

		#Get Room
		room_id = str(dataEntity['room_id'])

		mycursor.execute("SELECT * FROM Room WHERE room_id = '"+room_id+"'")
		room = list(mycursor.fetchall()[0])

		for i in range(len(room)):
			if isinstance(room[i], bytearray):
				room[i] = room[i].decode("utf-8")

		dataEntity = {
			"room_id": room[0],
			"robo_id": room[1],
			"title": room[2],
			"pgm": room[3],
			"yaml": room[4]
		}
		data["room"].append(dataEntity)

		#Get Robo
		robo_id = str(dataEntity['robo_id'])

		mycursor.execute("SELECT * FROM Robo WHERE robo_id = '"+robo_id+"'")
		robo = list(mycursor.fetchall()[0])

		for i in range(len(robo)):
			if isinstance(robo[i], bytearray):
				robo[i] = robo[i].decode("utf-8")

		dataEntity = {
			"robo_id": robo[0],
			"name": robo[1],
			"ip": robo[2]
		}
		data["robo"].append(dataEntity)

		return json.dumps(data)














