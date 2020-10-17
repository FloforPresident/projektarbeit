#!/usr/bin/env python
import mysql.connector

import rospy
from std_msgs.msg import String

def database():
	pub = rospy.Publisher('chatter', String, queue_size=10)
	rospy.init_node('print_person', anonymous=False)

	mydb = mysql.connector.connect(
	  host="localhost",
	  user="root",
	  password="",
	  database="test"
	)

	answer = mydb
	rospy.loginfo(answer)
	#pub.publish(answer)


if __name__ == '__main__':
    try:
        database()
    except rospy.ROSInterruptException:
        pass
