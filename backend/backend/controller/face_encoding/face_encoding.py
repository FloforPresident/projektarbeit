#!/usr/bin/env python

import face_recognition
import numpy as np
import base64

import time


def createFaceEncoding(data):

    # Gets picture as base64 data
    image = base64.b64decode(data)

    # overwrites image.jpg with taken picture
    with open("./face_encoding/image.jpg", "wb") as file:
        file.write(image)
        file.close()

    time.sleep(3)
    
    
    image_new = face_recognition.load_image_file("./face_encoding/image.jpg")

    # Recognise face in image.jpg and create encoding
    face_encoding = face_recognition.face_encodings(image_new)[0]

    # Creates String of face_encoding for storage in db
    encoding_string = np.array2string(face_encoding, prefix="", suffix="", separator="#")
    encoding_string = encoding_string.strip('[')
    encoding_string = encoding_string.strip(']')

    return encoding_string
