#!/usr/bin/env python

import face_recognition
import numpy as np
import base64

import time


def createFaceEncoding(data):

    #with open("/home/projektarbeit/backend/backend/face_encoding/stefan.jpg", "rb") as file:
    #    data = base64.b64encode(file.read())

    image = base64.b64decode(data)

    with open("/home/basti/projektarbeit/backend/backend/controller/face_encoding/image.jpg", "wb") as file:
        file.write(image)
        file.close()



    time.sleep(5)

    #erkennt auf image.jpg kein Gesicht, deshalb wird stefan.jpg verwendet
    image_new = face_recognition.load_image_file("/home/basti/projektarbeit/backend/backend/controller/face_encoding/image.jpg")

    
   
    face_encoding = face_recognition.face_encodings(image_new)[0]

    print(face_encoding)
    

    encoding_string = np.array2string(face_encoding, prefix="", suffix="", separator="#")
    encoding_string = encoding_string.strip('[')
    encoding_string = encoding_string.strip(']')

    return encoding_string
