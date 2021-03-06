#!/usr/bin/env python

# Copyright (c) 2011, Willow Garage, Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#    * Redistributions of source code must retain the above copyright
#      notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above copyright
#      notice, this list of conditions and the following disclaimer in the
#      documentation and/or other materials provided with the distribution.
#    * Neither the name of the Willow Garage, Inc. nor the names of its
#      contributors may be used to endorse or promote products derived from
#       this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

import rospy
import subprocess
from std_msgs.msg import String
from geometry_msgs.msg import Twist
import sys, select, os
if os.name == 'nt':
  import msvcrt
else:
  import tty, termios

class Teleop:

    BURGER_MAX_LIN_VEL = 0.22
    BURGER_MAX_ANG_VEL = 2.84

    WAFFLE_MAX_LIN_VEL = 0.26
    WAFFLE_MAX_ANG_VEL = 1.82

    LIN_VEL_STEP_SIZE = 0.01
    ANG_VEL_STEP_SIZE = 0.1

    status = 0
    target_linear_vel = 0.0
    target_angular_vel = 0.0
    control_linear_vel = 0.0
    control_angular_vel = 0.0

    turtlebot3_model = rospy.get_param("model", "burger")

    msg = """
    Control Your TurtleBot3!
    ---------------------------
    Moving around:
            w
      a    s    d
            x

    w/x : increase/decrease linear velocity (Burger : ~ 0.22, Waffle and Waffle Pi : ~ 0.26)
    a/d : increase/decrease angular velocity (Burger : ~ 2.84, Waffle and Waffle Pi : ~ 1.82)

    space key, s : force stop

    CTRL-C to quit
    """

    e = """
    Communications Failed
    """

    currentKey = 'empty'

    def callback(self, data):
        rospy.loginfo(rospy.get_caller_id() + "I heard %s", data.data)
        self.publishKey(data.data)
    
    def listener(self):
        rospy.Subscriber("teleop_chatter", String, self.callback)
        # spin() simply keeps python from exiting until this node is stopped
        #rospy.spin()

    def vels(self, target_linear_vel, target_angular_vel):
        return "currently:\tlinear vel %s\t angular vel %s " % (self.target_linear_vel,self.target_angular_vel)

    def makeSimpleProfile(self, output, input, slop):
        if input > output:
            output = min( input, output + slop )
        elif input < output:
            output = max( input, output - slop )
        else:
            output = input

        return output

    def constrain(self, input, low, high):
        if input < low:
          input = low
        elif input > high:
          input = high
        else:
          input = input

        return input

    def checkLinearLimitVelocity(self, vel):
        if self.turtlebot3_model == "burger":
          vel = self.constrain(vel, -self.BURGER_MAX_LIN_VEL, self.BURGER_MAX_LIN_VEL)
        elif self.turtlebot3_model == "waffle" or self.turtlebot3_model == "waffle_pi":
          vel = self.constrain(vel, -self.WAFFLE_MAX_LIN_VEL, self.WAFFLE_MAX_LIN_VEL)
        else:
          vel = self.constrain(vel, -self.BURGER_MAX_LIN_VEL, self.BURGER_MAX_LIN_VEL)

        return vel

    def checkAngularLimitVelocity(self, vel):
        if self.turtlebot3_model == "burger":
          vel = self.constrain(vel, -self.BURGER_MAX_ANG_VEL, self.BURGER_MAX_ANG_VEL)
        elif self.turtlebot3_model == "waffle" or self.turtlebot3_model == "waffle_pi":
          vel = self.constrain(vel, -self.WAFFLE_MAX_ANG_VEL, self.WAFFLE_MAX_ANG_VEL)
        else:
          vel = self.constrain(vel, -self.BURGER_MAX_ANG_VEL, self.BURGER_MAX_ANG_VEL)

        return vel

    def publishKey(self, key):
        
        pub = rospy.Publisher('cmd_vel', Twist, queue_size=10)
        #test: pub = rospy.Publisher('/turtle1/cmd_vel', Twist, queue_size=10)
        try:
            if key != 'empty':
                print("Got key:")
                print(key)
            if key == 'w' :
                self.target_linear_vel = self.checkLinearLimitVelocity(self.target_linear_vel + self.LIN_VEL_STEP_SIZE)
                self.status = self.status + 1
                print(self.vels(self.target_linear_vel,self.target_angular_vel))
            elif key == 'x' :
                self.target_linear_vel = self.checkLinearLimitVelocity(self.target_linear_vel - self.LIN_VEL_STEP_SIZE)
                self.status = self.status + 1
                print(self.vels(self.target_linear_vel,self.target_angular_vel))
            elif key == 'a' :
                self.target_angular_vel = self.checkAngularLimitVelocity(self.target_angular_vel + self.ANG_VEL_STEP_SIZE)
                self.status = self.status + 1
                print(self.vels(self.target_linear_vel,self.target_angular_vel))
            elif key == 'd' :
                self.target_angular_vel = self.checkAngularLimitVelocity(self.target_angular_vel - self.ANG_VEL_STEP_SIZE)
                self.status = self.status + 1
                print(self.vels(self.target_linear_vel,self.target_angular_vel))
            elif key == ' ' or key == 's' :
                self.target_linear_vel   = 0.0
                self.control_linear_vel  = 0.0
                self.target_angular_vel  = 0.0
                self.control_angular_vel = 0.0
                print(self.vels(self.target_linear_vel, self.target_angular_vel))
            else:
                if (key == '\x03'):
                    print("else")

            if self.status == 20 :
                self.status = 0
            twist = Twist()

            self.control_linear_vel = self.makeSimpleProfile(self.control_linear_vel, self.target_linear_vel, (self.LIN_VEL_STEP_SIZE/2.0))
            twist.linear.x = self.control_linear_vel
            twist.linear.y = 0.0
            twist.linear.z = 0.0

            self.control_angular_vel = self.makeSimpleProfile(self.control_angular_vel, self.target_angular_vel, (self.ANG_VEL_STEP_SIZE/2.0))
            twist.angular.x = 0.0
            twist.angular.y = 0.0
            twist.angular.z = self.control_angular_vel
            print(twist)
            
            while pub.get_num_connections() < 1:
                pass
            pub.publish(twist)

        except Exception as e:
            print("EXCEPTION:")
            print(e)
        '''
        finally:
            twist = Twist()
            twist.linear.x = 0.0; twist.linear.y = 0.0; twist.linear.z = 0.0
            twist.angular.x = 0.0; twist.angular.y = 0.0; twist.angular.z = 0.0
            while pub.get_num_connections() < 1:
                pass
            
            pub.publish(twist)

            #string = '{ linear: {x: ' + str(self.control_linear_vel) + ', y: 0, z: 0}, angular: { x: 0, y: 0, z: ' + str(self.control_angular_vel) + '}}'
            #subprocess.run(["rostopic","pub", "/cmd_vel", "geometry_msgs/Twist", string])
        '''




    def startTeleop(self):
        
        print("start teleop_keyboard.py script")
        #rospy.init_node('turtlebot3_teleop', anonymous=True)
        self.listener()



        

