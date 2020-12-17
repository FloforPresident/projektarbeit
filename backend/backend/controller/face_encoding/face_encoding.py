#!/usr/bin/env python

import face_recognition
import numpy as np


def createFaceEncoding(data):
    with open("image.jpg", "wb") as file:
        file.write(data.decode("base64"))
        file.close()

    image = face_recognition.load_image_file("faceTest.jpg")
    face_encoding = face_recognition.face_encodings(image)[0]

    # Numpy Array in String umwandeln
    encoding_string = np.array2string(face_encoding, prefix="", suffix="", separator="#")
    # Klammern am Anfang und Ende entfernen
    encoding_string = encoding_string.strip('[')
    encoding_string = encoding_string.strip(']')

    return encoding_string
