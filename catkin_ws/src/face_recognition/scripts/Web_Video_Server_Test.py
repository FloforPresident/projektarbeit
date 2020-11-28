#!/usr/bin/env python


import rospy 

import face_recognition
import cv2

from cv_bridge import CvBridge, CvBridgeError

from sensor_msgs.msg import Image
import sensor_msgs
import std_msgs

import numpy as np



def talker():

	video_capture = cv2.VideoCapture(0)
	bridge = CvBridge()
	
	while True:

	 	ret, frame = video_capture.read()

		pub = rospy.Publisher('chatter', Image, queue_size=10)
		rospy.init_node('talker', anonymous=True)
		rate = rospy.Rate(100) # 100hz

	#	image = face_recognition.load_image_file("Pic.jpg")

		rgb_image = frame[:, :, ::-1]


		
	#	image_message = bridge.cv2_to_imgmsg(rgb_image, "bgr8")

		pub.publish(bridge.cv2_to_imgmsg(rgb_image, "bgr8"))





if __name__ == '__main__':
	
	talker()

	try:
		rospy.spin()
	except KeybooardInterrupt:
		print("Shutting down")
	cv2.destroyAllWindows()
