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
	def getUser(self, name, password):
		mycursor = self.mydb.cursor(prepared = True)
		mycursor.execute("SELECT * FROM User WHERE username = '"+name+"'")
		myresult = mycursor.fetchall()
		for x in myresult:
			print(x)

	def addUser(self, name, password):
		mycursor = self.mydb.cursor(prepared = True)
		sql = "INSERT INTO User (username, password) VALUES (%s, %s)"
		val = (name, password)
		mycursor.execute(sql, val)
		mydb.commit()
		print(mycursor.rowcount, "record inserted.")

	#::::ROBO::::


	


if __name__ == '__main__':
    	#addUser('test', '1234')
	db = database("localhost","root","","test")


	db.getUser('test','b')
	
	
