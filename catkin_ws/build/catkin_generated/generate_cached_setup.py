# -*- coding: utf-8 -*-
from __future__ import print_function
import argparse
import os
import stat
import sys

# find the import for catkin's python package - either from source space or from an installed underlay
if os.path.exists(os.path.join('/opt/ros/kinetic/share/catkin/cmake', 'catkinConfig.cmake.in')):
    sys.path.insert(0, os.path.join('/opt/ros/kinetic/share/catkin/cmake', '..', 'python'))
try:
    from catkin.environment_cache import generate_environment_script
except ImportError:
    # search for catkin package in all workspaces and prepend to path
<<<<<<< HEAD
    for workspace in "/home/basti/projektarbeit/catkin_ws/devel;/opt/ros/kinetic".split(';'):
=======
    for workspace in "/home/stefan/projektarbeit/catkin_ws/devel;/opt/ros/kinetic".split(';'):
>>>>>>> 92f239d285461c11170bff33d44c46af98a92357
        python_path = os.path.join(workspace, 'lib/python2.7/dist-packages')
        if os.path.isdir(os.path.join(python_path, 'catkin')):
            sys.path.insert(0, python_path)
            break
    from catkin.environment_cache import generate_environment_script

<<<<<<< HEAD
code = generate_environment_script('/home/basti/projektarbeit/catkin_ws/devel/env.sh')

output_filename = '/home/basti/projektarbeit/catkin_ws/build/catkin_generated/setup_cached.sh'
=======
code = generate_environment_script('/home/stefan/projektarbeit/catkin_ws/devel/env.sh')

output_filename = '/home/stefan/projektarbeit/catkin_ws/build/catkin_generated/setup_cached.sh'
>>>>>>> 92f239d285461c11170bff33d44c46af98a92357
with open(output_filename, 'w') as f:
    #print('Generate script for cached setup "%s"' % output_filename)
    f.write('\n'.join(code))

mode = os.stat(output_filename).st_mode
os.chmod(output_filename, mode | stat.S_IXUSR)
