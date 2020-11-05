#!/usr/bin/env python

import rospy
import json
from std_msgs.msg import String

def print_person():
	pub = rospy.Publisher('chatter', String, queue_size=10)
	rospy.init_node('print_person', anonymous=False)

	datastring = '{"action": "find_person", "name": "Patrick", "x": "-3.5", "y": "-3.0"}'
	dataArray = json.loads(datastring)

	rospy.loginfo("Auf der Suche nach: " + dataArray["name"])
	
	rate = rospy.Rate(1) # 10hz
	i = 0
	while i < 4:
		pub.publish(datastring)
		i += 1
		rate.sleep()


if __name__ == '__main__':
    try:
        print_person()
    except rospy.ROSInterruptException:
        pass
