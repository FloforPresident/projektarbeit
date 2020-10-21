import rospy
import time
from geometry_msgs.msg import Twist

def move_forward(seconds, direction):
	vel_msg = Twist()
	vel_msg.linear.x = direction
	vel_msg.linear.y = 0
	vel_msg.linear.z = 0
	vel_msg.angular.x = 0
	vel_msg.angular.y = 0
	vel_msg.angular.z = 0

	t_end = time.time() + seconds
	while time.time() < t_end:
		rospy.init_node('move', anonymous=True)
		pub = rospy.Publisher('/turtle1/cmd_vel', Twist, queue_size=10)
		pub.publish(vel_msg)
