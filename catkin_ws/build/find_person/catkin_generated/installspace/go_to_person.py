#!/usr/bin/env python2
# license removed for brevity
import rospy
from std_msgs.msg import String
from geometry_msgs.msg import PoseStamped

def callback(data):
	person = data.data
	pub = rospy.Publisher('/move_base_simple/goal', PoseStamped, queue_size=10)
	#rate = rospy.Rate(10) # 10hz

    	#while not rospy.is_shutdown():
	now = rospy.get_rostime()

	answer = PoseStamped()
	answer.header.stamp = now

	if person == "Patrick":
		x = -3.5
		y = -3.0
	elif person == "Johannes":
		x = 2.0
		y = 3.0
	else:
		x = 0
		y = 0
		person = "no person selected"

	answer.header.frame_id = "map"
	answer.pose.position.x = x
	answer.pose.position.y = y
	answer.pose.position.z = 0

	answer.pose.orientation.w = 1.0

	rospy.loginfo("Gehe ins Buero von: "+person)
	pub.publish(answer)
	#rate.sleep()

	
def letsGo():
    rospy.init_node('find_person', anonymous=True)
    rospy.Subscriber("chatter", String, callback)
    rospy.spin()


if __name__ == '__main__':
    try:
        letsGo()
    except rospy.ROSInterruptException:
        pass
