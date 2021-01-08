#!/usr/bin/env python

import face_recognition
import numpy as np
import base64

import time


def createFaceEncoding(data):

    image = base64.b64decode(data)

    with open("/home/controller/face_encoding/image.jpg", "wb") as file:
        file.write(image)
        file.close()

    # cv2.imshow("Fenster", "/home/patrick/projektarbeit/backend/backend/controller/face_encoding/image.jpg")
    # cv2.waitKey(0)
    # cv2.destroyAllWindows()


    time.sleep(5)

    image_new = face_recognition.load_image_file("/home/controller/face_encoding/image.jpg")

    face_encoding = face_recognition.face_encodings(image_new)[0]

    encoding_string = np.array2string(face_encoding, prefix="", suffix="", separator="#")
    encoding_string = encoding_string.strip('[')
    encoding_string = encoding_string.strip(']')

    return encoding_string
