#!/usr/bin/env python

import rospy
import json
from std_msgs.msg import String

def print_person():
	pub = rospy.Publisher('chatter', String, queue_size=10)
	rospy.init_node('print_person', anonymous=False)

	datastring = '{"action": "stop", "name": "nobody"}'
	dataArray = json.loads(datastring)

	rospy.loginfo("Auf der Suche nach: " + dataArray["name"])
	
	pub.publish(datastring)


if __name__ == '__main__':
    try:
        print_person()
    except rospy.ROSInterruptException:
        pass
