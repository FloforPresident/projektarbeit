#!/usr/bin/env python

import multiprocessing

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
		print("INIT")
		self.bridge = CvBridge()
		self.image_sub = rospy.Subscriber("/raspicam_node/image", Image, self.callback_raspi_image)

	def callback_raspi_image(self, data):

		
		print("Callback!")

		try:
			cv_image = self.bridge.imgmsg_to_cv2(data, "bgr8") 
		except Exception as e:
			print(e)
			print("Fehler in CV2 Bridge: 'self.bridge.imgmsg_to_cv2(data, 'bgr8')'")


		face_recognition_(cv_image)

	def unsubscribe(self):
    		# use the saved subscriber object to unregister the subscriber
		self.image_sub.unregister()
		

######     /Image Converter Class ###########################################################################################################


######     Get name, message and face encoding from db    ###################################################################################


person_name = ""
person_embedding = ""
person_embedding_array = np.empty([1, 128])
message = ""

def callback_name(data):
	global person_name
	person_name = data.data
	print("Name received!" + person_name)
	#print(person_name)

def callback_embedding(data):
	#person_embedding = data
	global person_embedding
	global person_embedding_array
	person_embedding = data.data
	person_embedding_array = np.fromstring(data.data, sep='#')
	
	print("Embedding received!")
	print(person_embedding_array)

	# print(person_embedding_array)

def callback_message(data):
	global message
	message = data.data
	print("Message received!" + message)	
	# print(message)

######     /Get Data    #####################################################################################################################

######     Publish Message   ################################################################################################################

def talker(tts):
	### Publisher Found Person ###
	pub_action = rospy.Publisher('chatter', String, queue_size=10)
	datastring = '{"action": "found_person"}'
	pub_action.publish(datastring)

	### Publisher Message For Speaker ###
	pub = rospy.Publisher('Message_for_Speaker', String, queue_size = 2)
	pub.publish(tts)

######     /Publish Message   ################################################################################################################

######     Face Recognition    ###############################################################################################################

#Load a sample picture and learn how to recognize it

publish_this_frame = True

def face_recognition_(cv_image):
	global person_name
	global person_embedding_array
	global message
	global publish_this_frame

	known_face_encodings = [person_embedding_array]
	known_face_names = [person_name]

	
	

	face_locations = []
	face_encodings = []
	face_names = []

	

	#frame_counter = 0

	# Resize frame of video to 1/4 size for faster face recognition processing
	small_frame = cv2.resize(cv_image, (0, 0), fx=0.25, fy=0.25)

	#Convert the image from BGR color (which OpenCV uses) to RGB color (which face_recognition uses)
	rgb_small_frame = small_frame[:, :, ::-1]

	# Find all the faces and face encodings in the current frame of video
	face_locations = face_recognition.face_locations(rgb_small_frame)
	face_encodings = face_recognition.face_encodings(rgb_small_frame, face_locations)

	if person_name == "" or message == "":
		print("Not all variables set!")
		face_names.append("unknown")
	else:
		print("All variables set!")
		

		# print("")
		# print("Name")
		# print(person_name)
		
		# print("")
		# print("Embedding Array")
		# print(person_embedding_array)
		# print(person_embedding_array.shape)
		
		# print("")
		# print("Message")
		# print(message)

		for face_encoding in face_encodings:

			print ("Face detected")
			print ("Starting Comparison")
			print ("For Schleife face_encoding")
			


			# See if the face is a match for the known face(s)
			matches = face_recognition.compare_faces(known_face_encodings, face_encoding, 0.9)
			recognised_name = "unkonown"
			print("Matches:")
			print(matches)
			print("Known face encodings: ")
			print(known_face_encodings[0])
			print(known_face_encodings[0].shape)
			print("Face encoding: ")
			print (face_encoding)
			print (face_encoding.shape)




			# If a match was found in known_face_encodings, just use the first one		
			if True in matches:	
				first_match_index = matches.index(True)
				recognised_name = known_face_names[first_match_index]
			
				face_names.append(recognised_name)
			
				print("Person erkannt: " + recognised_name)

				#Create String, which is going to be published to talker Topic for speaker
				tts = "Hallo " + recognised_name + "! Hier ist eine Nachricht fuer dich:        " + message

				try:
					talker(tts)
				except:
					print("Fehler im Talker")

				#unregister from topic, doesnt work yet
				#unsubscribe()
			else:
				face_names.append("unknown")
		
		


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

	
	#if publish_this_frame:
	# Publish processed image to Node on Topic "Face_Recognition_Stream"
	print("Publish this frame")
	pub.publish(bridge.cv2_to_imgmsg(cv2.resize(cv_image, (0, 0), fx=0.5, fy=0.5), "bgr8"))

	#publish every other frame
#	publish_this_frame = not publish_this_frame
	



######     /Face Recognition    #############################################################################################################

def name_subscriber():
	print("name subscriber")
	rospy.Subscriber('data_name', String, callback_name)
def embedding_subscriber():
	print("embedding subscriber")
	rospy.Subscriber('data_embedding', String, callback_embedding)
def message_subscriber():
	print("message subscriber")
	rospy.Subscriber('data_message', String, callback_message)

def letsGo():
	
	rospy.init_node('face_recognition', anonymous=False)

	
	# p_name_sub = multiprocessing.Process(target=name_subscriber)
	# p_name_sub.start()

	# p_embedding_sub = multiprocessing.Process(target=embedding_subscriber)
	# p_embedding_sub.start()

	# p_message_sub = multiprocessing.Process(target=message_subscriber)
	# p_message_sub.start()
	
	name_subscriber()
	embedding_subscriber()
	message_subscriber()
	#rospy.Subscriber("chatter", String, callback_message)


	

	ic = image_converter()	
	#rospy.spin()

###########################





######     Main         #####################################################################################################################

if __name__=='__main__':

	pub = rospy.Publisher('Face_Recognition_Stream', Image, queue_size=10)

	try:
		letsGo()

	except rospy.ROSInterruptException:
		pass
		
	rospy.spin()

######   Video Stream with Webcam works

#		rate=rospy.Rate(10)
#		video_capture = cv2.VideoCapture(0)
		
#		while True:
#			ret, frame = video_capture.read()
#			face_recognition_(frame)

	
		



######     /Main         #####################################################################################################################
