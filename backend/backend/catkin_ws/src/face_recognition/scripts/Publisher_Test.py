#!/usr/bin/env python
from std_msgs.msg import String
import rospy 


TestString = "TESTEST"

rospy.init_node('TESTNODE', anonymous=True)

pub = rospy.Publisher('TESTTOPIC', String, queue_size=10)


while pub.get_num_connections() < 1:
 	#wait for a connection to publisher
	task = "doNothing"   #need Block in while loop

pub.publish(TestString)



