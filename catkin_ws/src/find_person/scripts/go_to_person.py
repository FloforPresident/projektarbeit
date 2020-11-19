#!/usr/bin/env python
# license removed for brevity
import rospy
import json
from std_msgs.msg import String
from geometry_msgs.msg import PoseStamped
from move_base_msgs.msg import MoveBaseActionGoal, MoveBaseActionFeedback
from actionlib_msgs.msg import GoalID


def callback_simple_goal(data):
	pubBase = rospy.Publisher('/move_base/goal', MoveBaseActionGoal, queue_size=10)
	now = rospy.get_rostime()

	answer = MoveBaseActionGoal()
	answer.header.stamp = now
	answer.header.frame_id = "map"

	answer.goal_id.stamp = now
	answer.goal_id.id = "map"

	answer.goal.target_pose = data

	print( "move_base callback")
	#print answer
	pubBase.publish(answer)



def callback_action(data):
	jsonString = data.data

	pubBase = rospy.Publisher('/move_base_simple/goal', PoseStamped, queue_size=10)
	
	now = rospy.get_rostime()

	dataArray = json.loads(jsonString)

	if dataArray["action"] == "find_person":
		person = dataArray["name"]
		x = float(dataArray["x"])
		y = float(dataArray["y"])

		answer = PoseStamped()
		answer.header.stamp = now
		answer.header.frame_id = "map"
		
		answer.pose.position.x = x
		answer.pose.position.y = y
		answer.pose.position.z = 0

		answer.pose.orientation.w = 1.0

		rospy.loginfo("Gehe ins Buero von: "+person)
		pubBase.publish(answer)

	elif dataArray["action"] == "stop":
		print(currentX)
		print(currentY)
		rospy.loginfo("Stop movement")
		pubCancel = rospy.Publisher('/move_base/cancel', GoalID, queue_size=10)
		answerCancel = GoalID()
		answerCancel.stamp = now
		answerCancel.id = "map"
		pubCancel.publish(answerCancel)

		answerBase = PoseStamped()
		answerBase.header.stamp = now
		answerBase.header.frame_id = "map"

		answerBase.pose.position.x = currentX
		answerBase.pose.position.y = currentY
		answerBase.pose.position.z = 0

		answerBase.pose.orientation.w = 1.0

		pubBase.publish(answerBase)

	else:
		rospy.loginfo("no action selected")


#get current location
def getLocation(locationData):
	global currentX
	global currentY
	currentX = locationData.feedback.base_position.pose.position.x
	currentY = locationData.feedback.base_position.pose.position.y

	#print("X: "+str(currentX))
	#print("Y: "+str(currentY))

	
def letsGo():
	#current coordinates
	global currentX
	global currentY
	currentX = 0
	currentY = 0
	#get current location
	rospy.Subscriber("move_base/feedback", MoveBaseActionFeedback, getLocation)

	rospy.init_node('find_person', anonymous=True)
	rospy.Subscriber("chatter", String, callback_action)

	#subscribed to simple goal and writes location in move_base/goal
	rospy.Subscriber("move_base_simple/goal", PoseStamped, callback_simple_goal)
	rospy.spin()


if __name__ == '__main__':
    try:
        letsGo()
    except rospy.ROSInterruptException:
        pass
