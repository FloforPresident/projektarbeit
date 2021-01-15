#!/usr/bin/env python
# license removed for brevity
import rospy
import json
import actionlib
from std_msgs.msg import String
from geometry_msgs.msg import PoseStamped, Twist
from move_base_msgs.msg import MoveBaseActionGoal, MoveBaseActionFeedback, MoveBaseAction, MoveBaseGoal
from actionlib_msgs.msg import GoalID

import time


#global variables - coordinates
goalX = None
goalY = None
currentX = None
currentY = None

foundPerson = False
cancel_script = False

#standard callback if chatter data received
def callback_action(data):
	global goalX, goalY, currentX, currentY, foundPerson, cancel_script
	
	print("---------- i got a new command ----------")
	cancel_move_base()

	try:

		jsonString = data.data
		dataArray = json.loads(jsonString)

		#current time
		now = rospy.get_rostime()

		#::::: stops movement :::::
		if dataArray["action"] == "stop":
			if cancel_script == True:
				print("dont execute script")
				return

			#stops moving right here
			cancel_script = True

			if currentX == None or currentY == None:
				print("robot hasnt moved yet")
				currentX = 0
				currentY = 0

			print("Stop movement at:")
			print("X: " + str(currentX))
			print("Y: " + str(currentY))

			# cancel everything
			cancel_move_base()

			goalX = currentX
			goalY = currentY

		else:
			cancel_script = False 
			#::::: goes to person, publishing to simple goal :::::
			if dataArray["action"] == "find_person":
				foundPerson = False
				person = dataArray["name"]
				x = float(dataArray["x"])
				y = float(dataArray["y"])


				print("Gehe ins Buero von: "+person)
				goToPosition(x, y)

				#set goal coordinates
				goalX = x
				goalY = y

			#::::: found person :::::
			elif dataArray["action"] == "found_person":
				print("+++++ FOUND PERSON +++++")

				if checkFoundPerson() == False:
					foundPerson = True

					goToPosition(currentX, currentY)
					
					goalX = None
					goalY = None

					reached_goal()
				else: 
					print("already found person")
					go_home()
					return

	except:
		rospy.loginfo("none of my business")

def reached_goal():
	global cancel_script
	print("+++++ GOAL +++++")
	cancel_move_base()

	sleeptime = 15
	print("waiting")
	time.sleep(sleeptime)

	if cancel_script == False:

		if checkFoundPerson() == True:
			print("Person found :)")
			go_home()
		else:
			print("Person not found :(")
			#alternativ 1: just go home
			#go_home()

			#alternative 2: rotating to search for person
			rotate(sleeptime)
			go_home()
	else:
		print("cancel script")

def checkFoundPerson():
	global foundPerson
	#foundperson output for debugging
	#print("Person found? " + str(foundPerson))

	if foundPerson == True:
		return True
	else:
		return False


#-----rotate-----
PI = 3.1415926535897
def rotate(sleeptime):

	velocity_publisher = rospy.Publisher('/cmd_vel', Twist, queue_size=10)
	vel_msg = Twist()
	
	print("Rotating. I am looking for the person.")
	speed = 40	#degrees/second
	angle = 360	#degrees
	
	#Converting from angles to radians
	angular_speed = speed*2*PI/360
	relative_angle = angle*2*PI/360
	#We wont use linear components
	vel_msg.linear.x=0
	vel_msg.linear.y=0
	vel_msg.linear.z=0
	vel_msg.angular.x = 0
	vel_msg.angular.y = 0

	vel_msg.angular.z = abs(angular_speed)

	# Setting the current time for distance calculus
	t0 = rospy.Time.now().to_sec()
	current_angle = 0

	while(current_angle < relative_angle):
		velocity_publisher.publish(vel_msg)
		t1 = rospy.Time.now().to_sec()
		current_angle = angular_speed*(t1-t0)

		if checkFoundPerson() == True:
			print("found person while rotating.")

			#Forcing our robot to stop
			cancel_move_base()

			print("waiting and rotating!")
			time.sleep(sleeptime)
			break

	#Forcing our robot to stop
	vel_msg.angular.z = 0
	velocity_publisher.publish(vel_msg)

	#go home after rotating
	print("Finished rotating")
		 
def go_home():

	#hat nun kein Ziel mehr
	global goalX, goalY, foundPerson
	goalX = None
	goalY = None
	print("I am going home.")

	goToPosition(0,0)
	

def cancel_move_base():
	print("canceled move base")

	#cancel action 
	pubCancelAction = rospy.Publisher('/move_base/cancel', GoalID, queue_size=0)
	answerCancel = GoalID()
	answerCancel.stamp = rospy.get_rostime()
	answerCancel.id = "map"

	pubCancelAction.publish(answerCancel)
	

	#cancel movement
	pubCancelMove = rospy.Publisher('cmd_vel', Twist, queue_size=10)
	twist = Twist()
	twist.linear.x = 0.0
	twist.linear.y = 0.0
	twist.linear.z = 0.0

	twist.angular.x = 0.0
	twist.angular.y = 0.0
	twist.angular.z = 0.0
            
	pubCancelMove.publish(twist)


#-----get current location constantaniously-----
def getLocation(locationData):
	global goalX, goalY, currentX, currentY, cancel_script
	currentX = locationData.feedback.base_position.pose.position.x
	currentY = locationData.feedback.base_position.pose.position.y

	#print(format(currentX, '.1f'))
	#print(format(goalX, '.1f'))
	#print(format(currentY, '.1f'))
	#print(format(goalY, '.1f'))

	tolerance = float(0.05)

	#check if goal-coordinates match current-coordinates
	if goalX != None and goalY != None and cancel_script == False:
		if float(format(currentX, '.1f')) <= float(format(goalX, '.1f'))+tolerance and float(format(currentY, '.1f')) <= float(format(goalY, '.1f'))+tolerance and float(format(currentX, '.1f')) >= float(format(goalX, '.1f'))-tolerance and float(format(currentY, '.1f')) >= float(format(goalY, '.1f'))-tolerance:
			reached_goal()


#############
#############
#############
def goToPosition(x, y):
	print("Goal X: " + str(x))
	print("Goal Y: " + str(y))

	#goal action
	client = actionlib.SimpleActionClient('move_base',MoveBaseAction)
	client.wait_for_server()

	goal = MoveBaseGoal()
	goal.target_pose.header.frame_id = "map"
	goal.target_pose.header.stamp = rospy.Time.now()
	goal.target_pose.pose.position.x = x
	goal.target_pose.pose.position.y = y
	goal.target_pose.pose.orientation.w = 1.0

	client.send_goal(goal)
	# wait = client.wait_for_result()
	# if not wait:
	# 	rospy.logerr("Action server not available!")
	# 	rospy.signal_shutdown("Action server not available!")
	# else:
	# 	return client.get_result()

#############
#############
#############
#-------------------------------------------------------------------------------------------------------------
	
def letsGo():
	#get current location
	rospy.Subscriber("move_base/feedback", MoveBaseActionFeedback, getLocation)

	#wait what chatter has to say (json)
	rospy.init_node('find_person', anonymous=True)
	rospy.Subscriber("chatter", String, callback_action)

	rospy.spin()



if __name__ == '__main__':
    try:
		print("::::::::::::::::::::::::::")
		print("::::::::  READY  :::::::::")
		print("::::::::::::::::::::::::::")
		letsGo()

    except rospy.ROSInterruptException:
        pass
