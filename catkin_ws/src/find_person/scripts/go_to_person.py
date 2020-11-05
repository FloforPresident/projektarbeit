#!/usr/bin/env python
# license removed for brevity
import rospy
import json
from std_msgs.msg import String
from geometry_msgs.msg import PoseStamped

def callback(data):
	jsonString = data.data
	pub = rospy.Publisher('/move_base_simple/goal', PoseStamped, queue_size=10)
	#rate = rospy.Rate(10) # 10hz

	#while not rospy.is_shutdown():
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
		pub.publish(answer)
	elif dataArray["action"] == "stop":
		pub.publish()
		rospy.loginfo("stop moving")
	else:
		rospy.loginfo("no action selected")

	
def letsGo():
	rospy.init_node('find_person', anonymous=True)
	rospy.Subscriber("chatter", String, callback)
	rospy.spin()


if __name__ == '__main__':
    try:
        letsGo()
    except rospy.ROSInterruptException:
        pass
