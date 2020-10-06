#!/usr/bin/env python
# license removed for brevity
import rospy
from std_msgs.msg import String
import geometry_msgs.msg import PoseStamped

def talker():
    pub = rospy.Publisher('/move_base_simple/goal', PoseStamped, queue_size=10)
    rospy.init_node('talker', anonymous=True)
    rate = rospy.Rate(10) # 10hz
    while not rospy.is_shutdown():
        answer = '{ header: {stamp: now, frame_id: "map"}, pose: { position: {x: -3.5, y: -3.0, z: 0.0}, orientation: {w: 1.0}}}'
        rospy.loginfo(answer)
        pub.publish(answer)
        rate.sleep()

if __name__ == '__main__':
    try:
        talker()
    except rospy.ROSInterruptException:
        pass