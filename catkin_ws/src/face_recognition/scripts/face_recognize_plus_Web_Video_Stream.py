#!/usr/bin/env python


#For writing a ROS Node
import rospy 
#from nav_msgs.msg import face_text_data

#For Face Recognition
import dlib
import face_recognition
import cv2
import numpy as np


#For Google Text To Speach
from gtts import gTTS
language = 'de'

#For connecting OpenCv with ROS
from cv_bridge import CvBridge, CvBridgeError
#import image_transport

#Contains the messages we need
from sensor_msgs.msg import Image

import sensor_msgs
import std_msgs

from std_msgs.msg import String


finish = False
bridge = CvBridge()

######     Get Image from Raspicam and convert to CV2_Image #################################################################################

class image_converter:

	def __init__(self):
		self.bridge = CvBridge()
		self.image_sub = rospy.Subscriber("/raspicam_node/image", Image, self.callback_raspi_image)

	def callback_raspi_image(self, data):
		try:
			cv_image = self.bridge.imgmsg_to_cv2(data, "bgr8") 
		except Exception as e:
			print(e)
			print("Fehler in CV2 Bridge: 'self.bridge.imgmsg_to_cv2(data, 'bgr8')'")


		face_recognition_(cv_image)
		

######     /Image Converter Class ###########################################################################################################


######     Get name, message and face encoding from db    ###################################################################################

def callback_textdata():
	person_name = msg.name
	message = msg.message
	person_face_encoding = msg.face_encoding[0]

######     /Get Data    #####################################################################################################################

######     Publish Message   ################################################################################################################

def talker(tts):
	pub = rospy.Publisher('Message_for_Speaker', std_msgs.msg.String, queue_size = 2)
	pub.publish(tts)

######     /Publish Message   ################################################################################################################

######     Face Recognition    ###############################################################################################################

#Load a sample picture and learn how to recognize it

stefan_image = face_recognition.load_image_file("stefan.jpg")
stefan_face_encoding = face_recognition.face_encodings(stefan_image)[0]

def face_recognition_(cv_image):


	known_face_encoding = [stefan_face_encoding]
	known_face_name = ["Stefan"]

	face_locations = []
	face_encodings = []
	face_names = []

	publish_this_frame = True

	frame_counter = 0

	# Resize frame of video to 1/4 size for faster face recognition processing
	small_frame = cv2.resize(cv_image, (0, 0), fx=0.25, fy=0.25)

	#Convert the image from BGR color (which OpenCV uses) to RGB color (which face_recognition uses)
	rgb_small_frame = small_frame[:, :, ::-1]

	# Only process every 4th frame of video to save time
	if frame_counter == 0:
		# Find all the faces and face encodings in the current frame of video
		face_locations = face_recognition.face_locations(rgb_small_frame)
		face_encodings = face_recognition.face_encodings(rgb_small_frame, face_locations)

		for face_encoding in face_encodings:
			# See if the face is a match for the known face(s)
			matches = face_recognition.compare_faces(known_face_encoding, face_encoding)
			recognised_name = "unkonown"

			# If a match was found in known_face_encodings, just use the first one		
			if True in matches:	
				first_match_index = matches.index(True)
				recognised_name = known_face_name[first_match_index]
			
				face_names.append(recognised_name)
			
				print("Person erkannt: " + recognised_name)

				#Create String, which is going to be published to talker Topic for speaker
				tts = "Hallo" + recognised_name

				try:
					talker(tts)
				except:
					print("Fehler im Talker")

				#unregister from topic, doesnt work yet
				#image_sub.unregister()
		
		


	# Display results
	for (top, right, bottom, left), name in zip(face_locations, face_names):
		# Scale back up face locations since the frame we detected in was scaled to 1/4 size
		top *= 4
		right *= 4
		bottom *= 4
		left *= 4

		# Draw a box around the face
		cv2.rectangle(cv_image,(left, top),(right, bottom),(0, 0, 255),2)

		# Draw a label with a name below the face
		cv2.rectangle(cv_image, (left, bottom - 35), (right, bottom), (0, 0, 255), cv2.FILLED)
		font = cv2.FONT_HERSHEY_DUPLEX
		cv2.putText(cv_image, name, (left + 6, bottom - 6), font, 1.0, (255, 255, 255), 1)



	if publish_this_frame:
		# Publish processed image to Node on Topic "Face_Recognition_Stream"		
		pub.publish(bridge.cv2_to_imgmsg(cv2.resize(cv_image, (0, 0), fx=0.5, fy=0.5), "bgr8"))

	#publish every other frame
	publish_this_frame = not publish_this_frame
	
	#process every 4th frame
	frame_counter += 1
	if frame_counter == 4:
		frame_counter = 0


######     /Face Recognition    #############################################################################################################



######     Main         #####################################################################################################################

if __name__=='__main__':
#	try:
		rospy.init_node('face_recognition', anonymous=True)
		
		pub = rospy.Publisher('Face_Recognition_Stream', Image, queue_size=10)
		

		


######   Video Stream with Webcam works

#		rate=rospy.Rate(10)
#		video_capture = cv2.VideoCapture(0)
		
#		while True:
#			ret, frame = video_capture.read()
#			face_recognition_(frame)



######   Video Stream of Raspi Cam works hopefully		
#		while True:
		ic = image_converter()
		
	



		
		try:
			rospy.spin()
		except KeybooardInterrupt:
			print("Shutting down")
		cv2.destroyAllWindows()


######     /Main         #####################################################################################################################
