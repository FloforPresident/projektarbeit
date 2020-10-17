import rospy
from std_msgs.msg import String

#datenbank
import mysql.connector

mydb = mysql.connector.connect(
  host="localhost:8080/phpmyadmin/",
  user="root",
  password="",
  database="test"
)

rospy.loginfo(print(mydb))
