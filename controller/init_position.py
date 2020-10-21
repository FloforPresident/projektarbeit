"""
Sets initial position for robot
Necessary for map based navigation

"""

import rospy
import geometry_msgs.msg

def init_position():
	pub = rospy.Publisher('/initialpose', geometry_msgs.msg.PoseWithCovarianceStamped, queue_size=10)
	rospy.init_node('init_position', anonymous=True)
	rate = rospy.Rate(1) # 10hz

	pose = geometry_msgs.msg.PoseWithCovarianceStamped()
	pose.header.frame_id = "map"
	#TODO replace with variable (value from RVIZ)
	pose.pose.pose.position.x= -2.02499961853
	#TODO replace with variable (value from RVIZ)
	pose.pose.pose.position.y= -0.519999742508
	pose.pose.pose.position.z=0
	pose.pose.covariance=[0.25, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
	0.06853891945200942]
	#TODO replace with variable (value from RVIZ)
	pose.pose.pose.orientation.z=0.0
	pose.pose.pose.orientation.w=1.0
	rospy.loginfo(pose)
	pub.publish(pose)
	rate.sleep()
	pub.publish(pose)
	rate.sleep()    
	pub.publish(pose)
	rate.sleep()
	rospy.spin()


if __name__ == '__main__': 
	try: 
		init_position() 
	except rospy.ROSInterruptException: 
		pass
