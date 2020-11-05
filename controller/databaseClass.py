#!/usr/bin/env python

import rospy
import os
import subprocess

import mysql.connector
import rospy

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
		

	def addUser(self, name, password):
		mycursor = self.mydb.cursor(prepared = True)
		sql = "INSERT INTO User (username, password) VALUES (%s, %s)"
		val = (name, password)
		mycursor.execute(sql, val)
		self.mydb.commit()
		print(mycursor.rowcount, "record inserted.")
	
	def deleteUser(self, user_id):
		mycursor = self.mydb.cursor()
		sql = "DELETE FROM User WHERE user_id = "+str(user_id)
		mycursor.execute(sql)
		self.mydb.commit()
		print(mycursor.rowcount, "record(s) deleted")

	def loginUser(self, name, password):
		getName = self.mydb.cursor(prepared = True)
		getName.execute("SELECT username FROM User WHERE username = '"+name+"'")
		username = getName.fetchone()
	
		getPw = self.mydb.cursor(prepared = True)
		getPw.execute("SELECT password FROM User WHERE username = '"+name+"'")
		pw = getPw.fetchone()

		if(password == pw[0]):
			print("login succesfull")
			print("welcome "+username[0])
			return 1
		else:
			print("wrong password")
			return 0


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
	def addRoom(self, roomName, mapInformation):
		mycursor = self.mydb.cursor(prepared = True)
		sql = "INSERT INTO Room (title, map) VALUES (%s, %s)"
		val = (roomName, mapInformation)
		mycursor.execute(sql, val)
		self.mydb.commit()
		print(mycursor.rowcount, "record inserted.")


	def deleteRoom(self, roomName):
		mycursor = self.mydb.cursor()
		sql = "DELETE FROM Room WHERE robo_id = '"+roomName+"'"
		mycursor.execute(sql)
		self.mydb.commit()
		print(mycursor.rowcount, "record(s) deleted")

	def getRoom(self, roomName):
		mycursor = self.mydb.cursor(prepared = True)
		mycursor.execute("SELECT * FROM Room  WHERE title = '"+roomName+"'")
		myresult = mycursor.fetchall()
		for x in myresult:
			print(x)
		return myresult


	#::::LOCATION::::
	def addLocation(self, user_id, room_id, locationName, x, y):
		mycursor = self.mydb.cursor(prepared = True)
		sql = "INSERT INTO Location (user_id, room_id, title, x, y) VALUES (%s, %s, %s, %s, %s)"
		val = (user_id, room_id, locationName, x, y)
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
	
	def getLocation(self, title):
		mycursor = self.mydb.cursor(prepared = True)
		mycursor.execute("SELECT * FROM Location  WHERE title = '"+title+"'")
		myresult = mycursor.fetchall()
		for x in myresult:
			print(x)
		return myresult


	#::::MESSAGE::::
	#def sendMessage(senderName,receiverName, text):
	#TODO
	#def getMessages(username):
	


if __name__ == '__main__':
    	#new database
	db = database("localhost","root","","test")
	
	db.addUser('test', '1234')

	print("----- user information: -----")
	user = db.getUser('test')
	print("User id: "+ str(user[0])) #get users id
	print()
	
	
	print("----- user login: -----")
	db.loginUser('test','1234')
	print()

	print("----- all users: -----")
	db.getAllUsers()
	db.deleteUser(user[0])
	db.getAllUsers()
	
	
