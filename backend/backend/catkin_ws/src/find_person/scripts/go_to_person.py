#!/usr/bin/env python
# license removed for brevity
import rospy
import json
from std_msgs.msg import String
from geometry_msgs.msg import PoseStamped, Twist
from move_base_msgs.msg import MoveBaseActionGoal, MoveBaseActionFeedback
from actionlib_msgs.msg import GoalID

import time


#global variables - coordinates
goalX = None
goalY = None
currentX = None
currentY = None

foundPerson = False

#standard callback if chatter data received
def callback_action(data):
	global goalX, goalY, currentX, currentY, foundPerson
	try:
		jsonString = data.data
		dataArray = json.loads(jsonString)
		pubBase = rospy.Publisher('/move_base_simple/goal', PoseStamped, queue_size=10)

		#current time
		now = rospy.get_rostime()

		#::::: goes to person, publishing to simple goal :::::
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

			print("Gehe ins Buero von: "+person)
			pubBase.publish(answer)

			#set goal coordinates
			goalX = x
			goalY = y

		#::::: stops movement :::::
		elif dataArray["action"] == "stop":

			if currentX == None or currentY == None:
				print("robot hasnt moved yet")
				currentX = 0
				currentY = 0

			print("Stop movement at:")
			print("X: " + str(currentX))
			print("Y: " + str(currentY))

			#set new goal to current position
			answerBase = PoseStamped()
			answerBase.header.stamp = now
			answerBase.header.frame_id = "map"
			answerBase.pose.position.x = currentX
			answerBase.pose.position.y = currentY
			answerBase.pose.position.z = 0
			answerBase.pose.orientation.w = 1.0

			pubBase.publish(answerBase)

			goalX = currentX
			goalY = currentY

		#::::: found person :::::
		elif dataArray["action"] == "found_person":
			print("FOUND PERSON!!!")
			foundPerson = True

			answer = PoseStamped()
			answer.header.stamp = now
			answer.header.frame_id = "map"
			answer.pose.position.x = currentX
			answer.pose.position.y = currentY
			answer.pose.position.z = 0
			answer.pose.orientation.w = 1.0

			print("Stoppe hier fuer Person.")
			pubBase.publish(answer)
			
			goalX = None
			goalY = None
			# Warten auf Person welche Nachricht erhalten hat
			rate = rospy.Rate(0.1) # 10hz
			i = 0
			while i < 2:
				print("Waiting for person.")
				i += 1
				rate.sleep()
			go_home()
		else:
			rospy.loginfo("no action selected")
	except:
		rospy.loginfo("none of my business")

def reached_goal():
	#rotate and go home
	print("GOOOOOOOAL!!!!")
	cancel_move_base()
	#rotate()
	time.sleep(10) #wait 10 seconds for person
	cancel_move_base()
	#statement is needed if bot finds person during rotating
	if foundPerson == False:
		go_home()
		print("Finished my business. Awaiting more commands.")
		 
def go_home():
	print("Finished looking for the person. I am driving home for christmas.")
	pubGoHome = rospy.Publisher('/move_base_simple/goal', PoseStamped, queue_size=10)
	gohome = PoseStamped()
	gohome.header.stamp = rospy.get_rostime()
	gohome.header.frame_id = "map"
	gohome.pose.position.x = 0
	gohome.pose.position.y = 0
	gohome.pose.position.z = 0
	gohome.pose.orientation.w = 1.0

	#hat nun kein Ziel mehr
	global goalX, goalY, foundPerson
	goalX = None
	goalY = None

	print("I am going home.")
	pubGoHome.publish(gohome)
	foundPerson = False

def cancel_move_base():
	#cancel move_base (just for safety reasons)
	print("canceled move base")
	pubCancel = rospy.Publisher('/move_base/cancel', GoalID, queue_size=0)
	answerCancel = GoalID()
	answerCancel.stamp = rospy.get_rostime()
	answerCancel.id = "map"

	pubCancel.publish(answerCancel)


#-----writes move_base_simple/goal to move_base/goal-----
def callback_simple_goal(data):
	pubBase = rospy.Publisher('/move_base/goal', MoveBaseActionGoal, queue_size=10)
	now = rospy.get_rostime()

	answer = MoveBaseActionGoal()
	answer.header.stamp = now
	answer.header.frame_id = "map"
	answer.goal_id.stamp = now
	answer.goal_id.id = "map"
	answer.goal.target_pose = data

	pubBase.publish(answer)

#-----rotate-----
PI = 3.1415926535897
def rotate():
    velocity_publisher = rospy.Publisher('/cmd_vel', Twist, queue_size=10)
    vel_msg = Twist()
    # Receiveing the user's input
    print("I am looking for the person.")
    speed = 20	#degrees/second
    angle = 360	#degrees
    clockwise = True #True or false
    #Converting from angles to radians
    angular_speed = speed*2*PI/360
    relative_angle = angle*2*PI/360
    #We wont use linear components
    vel_msg.linear.x=0
    vel_msg.linear.y=0
    vel_msg.linear.z=0
    vel_msg.angular.x = 0
    vel_msg.angular.y = 0

    # Checking if our movement is CW or CCW
    if clockwise:
        vel_msg.angular.z = -abs(angular_speed)
    else:
        vel_msg.angular.z = abs(angular_speed)
    # Setting the current time for distance calculus
    t0 = rospy.Time.now().to_sec()
    current_angle = 0

    while(current_angle < relative_angle):
		velocity_publisher.publish(vel_msg)
		t1 = rospy.Time.now().to_sec()
		current_angle = angular_speed*(t1-t0)

    #Forcing our robot to stop
    vel_msg.angular.z = 0
    velocity_publisher.publish(vel_msg)


#-----get current location constantaniously-----
def getLocation(locationData):
	global goalX, goalY, currentX, currentY
	currentX = locationData.feedback.base_position.pose.position.x
	currentY = locationData.feedback.base_position.pose.position.y

	#print(format(currentX, '.1f'))
	#print(format(goalX, '.1f'))
	#print(format(currentY, '.1f'))
	#print(format(goalY, '.1f'))

	tolerance = float(0.05)

	#check if goal-coordinates match current-coordinates
	if goalX != None and goalY != None:
		if float(format(currentX, '.1f')) <= float(format(goalX, '.1f'))+tolerance and float(format(currentY, '.1f')) <= float(format(goalY, '.1f'))+tolerance and float(format(currentX, '.1f')) >= float(format(goalX, '.1f'))-tolerance and float(format(currentY, '.1f')) >= float(format(goalY, '.1f'))-tolerance:
			reached_goal()


#-------------------------------------------------------------------------------------------------------------
	
def letsGo():
	#get current location
	rospy.Subscriber("move_base/feedback", MoveBaseActionFeedback, getLocation)

	#subscribed to move_base_simple/goal and writes location in move_base/goal
	#not needed at the moment, but could be usefull later
	rospy.Subscriber("move_base_simple/goal", PoseStamped, callback_simple_goal)

	#wait what chatter has to say (json)
	rospy.init_node('find_person', anonymous=True)
	rospy.Subscriber("chatter", String, callback_action)

	rospy.spin()


if __name__ == '__main__':
    try:
		letsGo()

    except rospy.ROSInterruptException:
        pass
