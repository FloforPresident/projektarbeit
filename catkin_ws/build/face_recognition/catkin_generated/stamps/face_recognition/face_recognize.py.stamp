#!/usr/bin/env python
import face_recognition
import cv2
import numpy as np
from gtts import gTTS
language = 'de'
#from io import BytesIO
#from mpyg321.mpyg321 import MPyg321Player

# Get a reference to webcam #0 (the default one)
video_capture = cv2.VideoCapture(0)

#audio player
#player = MPyg321Player()


####################################
########     ROS    ################
####################################
#for writing a ROS Node
import rospy
from std_msgs.msg import String
#from nav_msgs.msg import Image
#import face_text_data
from cv_bridge import CvBridge


######     Get Image    #####################################################################################################################
# Get image from /raspicam_node/image

def __init__(self):
    self.bridge = CvBridge()
    self.image_sub = rospy.Subscriber("/raspicam_node/image",Image,self.callback)

def callback(self,data):
    try:
        cv_image = self.bridge.imgmsg_to_cv2(data, "bgr8")
    except CvBridgeError as e:
        print(e)

######     /Get Image    #####################################################################################################################


######     Get Name, Face, Message    #####################################################################################################################

def callback_textdata():
    person_name = msg.name
    message = msg.message
    person_face_encoding = msg.face_encoding[0]

def listener():
    rospy.init_node('Face_recognition')
    rospy.Subscriber("/face_text_data", face_text_data, callback_textdata)
    # spin() keeps python from exiting until this node is stopped
    rospy.spin()

######     /Get Name, Face, Message    #####################################################################################################################



def talker():
    pub = rospy.Publisher('message_delivery', String)
    pub.publish(message)


if __name__=='__main__':
    #listener()

known_face_encoding = [
    person_face_encoding
    ]
known_face_name = [
    person_name
    ]

face_locations = []
face_encodings = []
face_names = []
process_this_frame = True

######     Face Recognition    #####################################################################################################################

while True:
    # Grab a single frame of video
    ret, frame = cv_image.read()

    # Resize frame of video to 1/4 size for faster face recognition processing
    small_frame = cv2.resize(frame, (0, 0), fx=0.25, fy=0.25)

    #Convert the image from BGR color (which OpenCV uses) to RGB color (which face_recognition uses)
    rgb_small_frame = small_frame[:, :, ::-1]

    recognised_name = "unkonown"

    # Only process every other frame of video to save time
    if process_this_frame:
        # Find all the faces and face encodings in the current frame of video
        face_locations = face_recognition.face_locations(small_frame)
        face_encodings = face_recognition.face_encodings(small_frame, face_locations)

    for face_encoding in face_encodings:
        # See if the face is a match for the known face(s)
        matches = face_recognition.compare_faces(known_face_encoding, face_encoding)

        # If a match was found in known_face_encodings, just use the first one
        if True in matches:
            first_match_index = matches.index(True)
            recognised_name = known_face_name[first_match_index]
            #talker()
            break

    tts = gTTS('Hallo' + recognised_name)
    tts.save('hallo.mp3')
    player.play_song('hallo.mp3')

    process_this_frame = not process_this_frame

######     /Face Recognition    #####################################################################################################################






####################################
########     /ROS    ################
####################################






    # Display the results
    for (top, right, bottom, left), name in zip(face_locations, face_names):
        # Scale back up face locations since the frame we detected in was scaled to 1/4 size
        top *= 4
        right *= 4
        bottom *= 4
        left *= 4

        # Draw a box around the faceq
        cv2.rectangle(frame, (left, top), (right, bottom), (0, 0, 255), 2)

        # Draw a label with a name below the face
        cv2.rectangle(frame, (left, bottom - 35), (right, bottom), (0, 0, 255), cv2.FILLED)
        font = cv2.FONT_HERSHEY_DUPLEX
        cv2.putText(frame, name, (left + 6, bottom - 6), font, 1.0, (255, 255, 255), 1)

    # Display the resulting image
    cv2.imshow('Video', frame)

    # Hit 'q' on the keyboard to quit!
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# Release handle to the webcam
video_capture.release()
cv2.destroyAllWindows()
