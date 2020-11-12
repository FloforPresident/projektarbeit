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
	def getUser(self, name):
		mycursor = self.mydb.cursor(prepared = True)
		mycursor.execute("SELECT * FROM User WHERE username = '"+name+"'")
		myresult = mycursor.fetchone()
		print(myresult)

		return myresult

	def getAllUsers(self):
		mycursor = self.mydb.cursor(prepared = True)
		mycursor.execute("SELECT * FROM User")
		myresult = mycursor.fetchall()
		for x in myresult:
			print(x)
		
		#beispiel abfrage: print(myresult[0][3])
		return myresult
		

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
		# getName = self.mydb.cursor(prepared = True)
		# getName.execute("SELECT username FROM User WHERE username = '"+name+"'")
		# username = getName.fetchone()
	
		# getPw = self.mydb.cursor(prepared = True)
		# getPw.execute("SELECT password FROM User WHERE username = '"+name+"'")
		# pw = getPw.fetchone()

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
	def addRobo(self, room_id, roboName, ip):
		mycursor = self.mydb.cursor(prepared = True)
		sql = "INSERT INTO Robo (room_id, name, ip) VALUES (%s, %s, %s)"
		val = (room_id, roboName, ip)
		mycursor.execute(sql, val)
		self.mydb.commit()
		print(mycursor.rowcount, "record inserted.")

	def deleteRobo(self, robo_id):
		mycursor = self.mydb.cursor()
		sql = "DELETE FROM Robo WHERE robo_id = '"+robo_id+"'"
		mycursor.execute(sql)
		self.mydb.commit()
		print(mycursor.rowcount, "record(s) deleted")


	def getRobo(self, name):
		mycursor = self.mydb.cursor(prepared = True)
		mycursor.execute("SELECT * FROM Robo WHERE name = '"+name+"'")
		myresult = mycursor.fetchall()
		for x in myresult:
			print(x)
		return myresult


	#::::ROOM::::

	# TODO yaml und pgm

	def addRoom(self, roomName, pgm, yaml):
		mycursor = self.mydb.cursor(prepared = True)
		# sql = "INSERT INTO Room (title, pgm, yaml) VALUES (%s, %s, %s)"
		# val = (roomName, pgm, yaml)
		# mycursor.execute(sql, val)

		mycursor.execute("INSERT INTO Room (title) VALUES ('"+roomName+"')")

		self.mydb.commit()
		print(mycursor.rowcount, "record inserted.")


	def deleteRoom(self, room_id):
		mycursor = self.mydb.cursor()
		sql = "DELETE FROM Room WHERE room_id = '"+room_id+"'"
		mycursor.execute(sql)
		self.mydb.commit()
		print(mycursor.rowcount, "record(s) deleted")

	def getRoom(self, roomName):
		mycursor = self.mydb.cursor(prepared = True)
		mycursor.execute("SELECT * FROM Room  WHERE title = '"+roomName+"'")
		myresult = mycursor.fetchone()
		for x in myresult:
			print(x)
		return myresult


	#::::LOCATION::::
	def addLocation(self, room_id, locationName, x, y):
		mycursor = self.mydb.cursor(prepared = True)
		sql = "INSERT INTO Location (room_id, title, x, y) VALUES (%s, %s, %s, %s)"
		val = (room_id, locationName, x, y)
		mycursor.execute(sql, val)
		self.mydb.commit()
		print(mycursor.rowcount, "record inserted.")

	def deleteLocation(self, locationId):
		mycursor = self.mydb.cursor()
		sql = "DELETE FROM Location WHERE location_id = '"+locationId+"'"
		mycursor.execute(sql)
		self.mydb.commit()
		print(mycursor.rowcount, "record(s) deleted")

	#def changeActiveLocation(locationNameNew, username):
	
	def getLocation(self, id):
		mycursor = self.mydb.cursor(prepared = True)
		mycursor.execute("SELECT * FROM Location  WHERE location_id = '"+id+"'")
		myresult = mycursor.fetchone()
		for x in myresult:
			print(x)
		return myresult


	#::::MESSAGE::::
	#def sendMessage(senderName,receiverName, text):
	#TODO
	#def getMessages(username):
	

#::::::		code fuer controller skript:	db = database("localhost","root","","turtlebot")		:::::::::
