#!/usr/bin/env sh
# generated from catkin/cmake/template/local_setup.sh.in

# since this file is sourced either use the provided _CATKIN_SETUP_DIR
# or fall back to the destination set at configure time
<<<<<<< HEAD
: ${_CATKIN_SETUP_DIR:=/home/basti/projektarbeit/catkin_ws/install}
=======
: ${_CATKIN_SETUP_DIR:=/home/stefan/projektarbeit/catkin_ws/install}
>>>>>>> 92f239d285461c11170bff33d44c46af98a92357
CATKIN_SETUP_UTIL_ARGS="--extend --local"
. "$_CATKIN_SETUP_DIR/setup.sh"
unset CATKIN_SETUP_UTIL_ARGS
