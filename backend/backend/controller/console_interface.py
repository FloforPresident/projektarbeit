#! /usr/bin/env python

"""
Console interface for starting required scripts and nodes

"""

import os

str_profileGeneral = "General Bringup"
str_profileMap = "Create Map"
str_changeProfile = "Change Profile"

str_exit = "Exit"
str_roscore = "Roscore"
str_dbContainer = "Database Container"
str_controller = "Controller"
str_faceRecognition = "Face Recognition"
str_webVideoServer = "Web Video Server"
str_findPerson = "Find Person"
str_addRsaKey = "Add RSA private Key / Set Turtlebot IP"
str_tbBringup = "Turtlebot Bringup"
str_tbCamerastream = "Turtlebot Camerastream"
str_tbSpeakernode = "Turtlebot Speakernode"
str_loadMap = "Load Map"
str_gmap = "Start Gmapping"
str_saveMap = "Save Map"
str_teleop = "Start Teleop"

def profileGeneral():
    try:
        print("# ---------------COMMANDS---------------")
        print(f"# 0: {str_exit}")
        print(f"# 1: {str_addRsaKey}")
        print(f"# 2: {str_roscore}")
        print(f"# 3: {str_dbContainer}")
        print(f"# 4: {str_controller}")
        print(f"# 5: {str_faceRecognition}")
        print(f"# 6: {str_webVideoServer}")
        print(f"# 7: {str_findPerson}")
        print(f"# 8: {str_tbBringup}")
        print(f"# 9: {str_tbCamerastream}")
        print(f"# 10: {str_tbSpeakernode}")
        print(f"# 11: {str_loadMap}")

        print(f"# --------------------------------------")

        user_input = -1

        while(True):
            print("\nInput number for the node you want to start: ")
            user_input = input()
            user_input = int(user_input)
            if(user_input == 0):
                return
            if(user_input == 1):
                os.system('sh startup_scripts/add_rsa.sh')
            elif(user_input == 2):
                os.system('sh startup_scripts/roscore.sh')
                print(f"\nStarted {str_roscore}")
            elif(user_input == 3):
                os.system('sh startup_scripts/database.sh')
                print(f"\nStarted {str_dbContainer}")
            elif(user_input == 4):
                os.system('sh startup_scripts/controller.sh')
                print(f"\nStarted {str_controller}")
            elif(user_input == 5):
                os.system('sh startup_scripts/face_recognition.sh')
                print(f"\nStarted {str_faceRecognition}")
            elif(user_input == 6):
                os.system('sh startup_scripts/web_video_server.sh')
                print(f"\nStarted {str_webVideoServer}")
            elif(user_input == 7):
                os.system('sh startup_scripts/find_person.sh')
                print(f"\nStarted {str_findPerson}")
            elif(user_input == 8):
                os.system('sh startup_scripts/tb_bringup.sh')
                print(f"\nStarted {str_tbBringup}")
            elif(user_input == 9):
                os.system('sh startup_scripts/tb_camerastream.sh')
                print(f"\nStarted {str_tbCamerastream}")
            elif(user_input == 10):
                os.system('sh startup_scripts/tb_speakernode.sh')
                print(f"\nStarted {str_tbSpeakernode}")
            elif(user_input == 11):
                os.system('sh startup_scripts/load_map.sh')
                print(f"\nStarted {str_loadMap}")
            else:
                print("Unknown command, please enter a number from the COMMANDS list")
            
    except Exception as e:
        print("Error:")
        print(e)

def profileMap():

    try:
        print("# ---------------COMMANDS---------------")
        print(f"# 0: {str_exit}")
        print(f"# 1: {str_addRsaKey}")
        print(f"# 2: {str_roscore}")
        print(f"# 3: {str_tbBringup}")
        print(f"# 4: {str_gmap}")
        print(f"# 5: {str_teleop}")
        print(f"# 6: {str_saveMap}")


        print(f"# --------------------------------------")

        user_input = -1

        while(True):
            print("\nInput number for the node you want to start: ")
            user_input = input()
            user_input = int(user_input)
            if(user_input == 0):
                return
            elif(user_input == 1):
                os.system('sh startup_scripts/add_rsa.sh')
            elif(user_input == 2):
                os.system('sh startup_scripts/roscore.sh')
                print(f"\nStarted {str_roscore}")
            elif(user_input == 3):
                os.system('sh startup_scripts/tb_bringup.sh')
                print(f"\nStarted {str_tbBringup}")
            elif(user_input == 4):
                os.system('sh startup_scripts/gmap.sh')
                print(f"\nStarted {str_gmap}")
            elif(user_input == 5):
                os.system('sh startup_scripts/teleop.sh')
                print(f"\nStarted {str_teleop}")
            elif(user_input == 6):
                os.system('sh startup_scripts/save_map.sh')
                print(f"\nStarted {str_saveMap}")
            else:
                print("Unknown command, please enter a number from the COMMANDS list")
            
    except Exception as e:
        print("Error:")
        print(e)


#def profileMap():


def main():
    try:
        print("# ---------------CHOOSE PROFILE---------------")
        print(f"# 0: {str_exit}")
        print(f"# 1: {str_profileGeneral}")
        print(f"# 2: {str_profileMap}")

        print(f"# --------------------------------------")

        user_input_profile = -1

        while(user_input_profile != 0):
            print("\nInput number for the profile you want to start: ")
            user_input_profile = input()
            user_input_profile = int(user_input_profile)

            if(user_input_profile == 1):
                profileGeneral()
                break
            elif(user_input_profile ==2):
                profileMap()
                break

    except Exception as e:
        print("Error:")
        print(e)


if __name__ == '__main__':
    print("Starting console interface...")
    main()
