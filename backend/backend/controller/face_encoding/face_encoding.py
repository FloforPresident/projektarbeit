#!/usr/bin/env python

import face_recognition
import numpy as np
import base64


def createFaceEncoding(data):
    image = base64.b64decode(data)

    with open("/home/controller/face_encoding/image.jpg", "wb") as file:
        file.write(image)
        file.close()

    image = face_recognition.load_image_file("/home/controller/face_encoding/image.jpg")
    #TODO image out of range?
    face_encoding = face_recognition.face_encodings(image)[0]

    # Numpy Array in String umwandeln
    encoding_string = np.array2string(face_encoding, prefix="", suffix="", separator="#")
    # Klammern am Anfang und Ende entfernen
    encoding_string = encoding_string.strip('[')
    encoding_string = encoding_string.strip(']')

    return encoding_string
