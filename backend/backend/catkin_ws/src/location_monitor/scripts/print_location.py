#!/usr/bin/env python
# license removed for brevity
import rospy
import json
from std_msgs.msg import String
from geometry_msgs.msg import PoseStamped, Twist
from move_base_msgs.msg import MoveBaseActionFeedback, MoveBaseActionGoal, MoveBaseActionFeedback


	
#-----get current location constantaniously-----
def getLocation(locationData):
	currentX = locationData.feedback.base_position.pose.position.x
	currentY = locationData.feedback.base_position.pose.position.y

	print("x: " + str(currentX))
	print("y: " + str(currentY))


#-------------------------------------------------------------------------------------------------------------
if __name__ == '__main__':
    try:
		rospy.init_node('location_monitor', anonymous=True)
		
		#stop movement and twist
		pub = rospy.Publisher('chatter', String, queue_size=10)

		datastring = '{"action": "stop", "name": "nobody"}'
		dataArray = json.loads(datastring)

		rospy.loginfo("Auf der Suche nach: " + dataArray["name"])
		
		rate1 = rospy.Rate(1) # 10hz
		i = 0
		while i < 4:
			pub.publish(datastring)
			i += 1
			rate1.sleep()
		
		
		#get current location
		rate2 = rospy.Rate(10) # 10hz
		while not rospy.is_shutdown():

			rospy.Subscriber("move_base/feedback", MoveBaseActionFeedback, getLocation)
			rate2.sleep()
			rospy.spin()

    except rospy.ROSInterruptException:
        pass

