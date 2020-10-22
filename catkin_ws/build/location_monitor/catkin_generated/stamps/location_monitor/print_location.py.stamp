#!/usr/bin/env python
# license removed for brevity
import rospy
from std_msgs.msg import String
from geometry_msgs.msg import PoseStamped
from move_base_msgs.msg import MoveBaseActionFeedback


def printLocation(data):
	rate = rospy.Rate(10) # 10hz

    	while not rospy.is_shutdown():
		#print("wird aufgerufen")
	
		print("x:")
		print(data.feedback.base_position.pose.position.x)
		print("y:")
		print(data.feedback.base_position.pose.position.y)

		rate.sleep()
	
def letsGo():
	rospy.init_node('location_monitor', anonymous=True)
	rospy.Subscriber("move_base/feedback", MoveBaseActionFeedback, printLocation)
	#rospy.Subscriber("move_base_simple/goal", PoseStamped, printLocation)
	rospy.spin()


if __name__ == '__main__':
    try:
	print("hallo")
        letsGo()
    except rospy.ROSInterruptException:
        pass
