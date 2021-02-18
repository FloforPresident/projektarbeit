#! /usr/bin/env python

"""
Console interface for starting required scripts and nodes

"""

import os


def main():
    try:
        print("# ---------------COMMANDS---------------")
        print("# 0: Exit")
        print("# 1: Roscore")
        print("# 2: Database-Container")
        print("# 3: Controller")
        print("# 4: ROS-Nodes")
        print("# --------------------------------------")

        user_input = -1

        while(user_input != 0):
            print("Please input a number:\n")
            user_input = input()
            print("User input: " + user_input)
            user_input = int(user_input)
            if(user_input == 1):
                os.system('sh startup_scripts/roscore.sh')
            elif(user_input == 2):
                os.system('sh startup_scripts/database.sh')
            elif(user_input == 3):
                os.system('sh startup_scripts/controller.sh')
            elif(user_input == 4):
                os.system('sh face_recognition.sh')
            elif(user_input == 5):
                os.system('sh web_video_server.sh')
            elif(user_input == 6):
                os.system('sh find_person.sh')

    except Exception as e:
        print("Error!")
        print(e)


if __name__ == '__main__':
    print("Starting console interface...")
    main()