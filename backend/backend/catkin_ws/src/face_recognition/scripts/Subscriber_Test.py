#!/usr/bin/env python

from std_msgs.msg import String
import rospy 


def callback(data):

	SRINGRECIEVED = data.data
	print (SRINGRECIEVED)


rospy.init_node('TESTRECEIVERNODE', anonymous=True)

rospy.Subscriber('TESTTOPIC', String, callback)

rospy.spin()
