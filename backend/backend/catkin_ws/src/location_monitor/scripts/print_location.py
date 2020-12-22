#!/usr/bin/env python
# license removed for brevity
import rospy
import json
from std_msgs.msg import String
from geometry_msgs.msg import PoseStamped, Twist
from move_base_msgs.msg import MoveBaseActionFeedback, MoveBaseActionGoal, MoveBaseActionFeedback


	
#----------
def getLocation(locationData):
	#current time
	now = rospy.get_rostime()
	currentX = locationData.feedback.base_position.pose.position.x
	currentY = locationData.feedback.base_position.pose.position.y

	print("x: " + str(currentX))
	print("y: " + str(currentY))

	#publish again to stay at current position
	pubReset = rospy.Publisher('/move_base_simple/goal', PoseStamped, queue_size=10)
	answerReset = PoseStamped()
	answerReset.header.stamp = now
	answerReset.header.frame_id = "map"
	answerReset.pose.position.x = currentX
	answerReset.pose.position.y = currentY
	answerReset.pose.position.z = 0
	answerReset.pose.orientation.w = 1.0

	pubReset.publish(answerReset)



#-------------------------------------------------------------------------------------------------------------
if __name__ == '__main__':
    try:
		#initialize node
		rospy.init_node('location_monitor', anonymous=True)
		#current time
		now = rospy.get_rostime()
		
		#publish once to move_base_simple/goal
		pub = rospy.Publisher('/move_base_simple/goal', PoseStamped, queue_size=10)
		answer = PoseStamped()
		answer.header.stamp = now
		answer.header.frame_id = "map"
		answer.pose.position.x = 0
		answer.pose.position.y = 0
		answer.pose.position.z = 0
		answer.pose.orientation.w = 1.0
		#------------

		#get current location
		rate2 = rospy.Rate(0.2) #0.5hz
		rospy.Subscriber("move_base/feedback", MoveBaseActionFeedback, getLocation)
		#wait until answer got published
		rate2.sleep()

		#alternativ
		#stop movement and twist
		#pub = rospy.Publisher('chatter', String, queue_size=10)
		#datastring = '{"action": "stop", "name": "nobody"}'
		#dataArray = json.loads(datastring)

		#publish to move_base_simple to activate subscriber
		pub.publish(answer)
		
		

    except rospy.ROSInterruptException:
        pass

