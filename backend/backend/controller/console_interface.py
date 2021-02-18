#! /usr/bin/env python

"""
Console interface for starting required scripts and nodes

"""

import os

def main():

    str_exit = "Exit"
    str_roscore = "Roscore"
    str_dbContainer = "Database Container"
    str_controller = "Controller"
    str_faceRecognition = "Face Recognition"
    str_webVideoServer = "Web Video Server"
    str_findPerson = "Find Person"

    try:
        print("# ---------------COMMANDS---------------")
        print(f"# 0: {str_exit}")
        print(f"# 1: {str_roscore}")
        print(f"# 2: {str_dbContainer}")
        print(f"# 3: {str_controller}")
        print(f"# 4: {str_faceRecognition}")
        print(f"# 5: {str_webVideoServer}")
        print(f"# 6: {str_findPerson}")
        print(f"# --------------------------------------")

        user_input = -1

        while(user_input != 0):
            print("\nInput number for the node you want to start: ")
            user_input = input()
            user_input = int(user_input)
            if(user_input == 1):
                os.system('sh startup_scripts/roscore.sh')
                print(f"\nStarted {str_roscore}")
            elif(user_input == 2):
                os.system('sh startup_scripts/database.sh')
                print(f"\nStarted {str_dbContainer}")
            elif(user_input == 3):
                os.system('sh startup_scripts/controller.sh')
                print(f"\nStarted {str_controller}")
            elif(user_input == 4):
                os.system('sh startup_scripts/face_recognition.sh')
                print(f"\nStarted {str_faceRecognition}")
            elif(user_input == 5):
                os.system('sh startup_scripts/web_video_server.sh')
                print(f"\nStarted {str_webVideoServer}")
            elif(user_input == 6):
                os.system('sh startup_scripts/find_person.sh')
                print(f"\nStarted {str_findPerson}")

            


    except Exception as e:
        print("Error!")
        print(e)


if __name__ == '__main__':
    print("Starting console interface...")
    main()