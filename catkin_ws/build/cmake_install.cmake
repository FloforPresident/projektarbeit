<<<<<<< HEAD
# Install script for directory: /home/basti/projektarbeit/catkin_ws/src

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/home/basti/projektarbeit/catkin_ws/install")
=======
# Install script for directory: /home/stefan/projektarbeit/catkin_ws/src

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/home/stefan/projektarbeit/catkin_ws/install")
>>>>>>> 92f239d285461c11170bff33d44c46af98a92357
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  
      if (NOT EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}")
        file(MAKE_DIRECTORY "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}")
      endif()
      if (NOT EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/.catkin")
        file(WRITE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/.catkin" "")
      endif()
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
<<<<<<< HEAD
   "/home/basti/projektarbeit/catkin_ws/install/_setup_util.py")
=======
   "/home/stefan/projektarbeit/catkin_ws/install/_setup_util.py")
>>>>>>> 92f239d285461c11170bff33d44c46af98a92357
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
<<<<<<< HEAD
file(INSTALL DESTINATION "/home/basti/projektarbeit/catkin_ws/install" TYPE PROGRAM FILES "/home/basti/projektarbeit/catkin_ws/build/catkin_generated/installspace/_setup_util.py")
=======
file(INSTALL DESTINATION "/home/stefan/projektarbeit/catkin_ws/install" TYPE PROGRAM FILES "/home/stefan/projektarbeit/catkin_ws/build/catkin_generated/installspace/_setup_util.py")
>>>>>>> 92f239d285461c11170bff33d44c46af98a92357
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
<<<<<<< HEAD
   "/home/basti/projektarbeit/catkin_ws/install/env.sh")
=======
   "/home/stefan/projektarbeit/catkin_ws/install/env.sh")
>>>>>>> 92f239d285461c11170bff33d44c46af98a92357
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
<<<<<<< HEAD
file(INSTALL DESTINATION "/home/basti/projektarbeit/catkin_ws/install" TYPE PROGRAM FILES "/home/basti/projektarbeit/catkin_ws/build/catkin_generated/installspace/env.sh")
=======
file(INSTALL DESTINATION "/home/stefan/projektarbeit/catkin_ws/install" TYPE PROGRAM FILES "/home/stefan/projektarbeit/catkin_ws/build/catkin_generated/installspace/env.sh")
>>>>>>> 92f239d285461c11170bff33d44c46af98a92357
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
<<<<<<< HEAD
   "/home/basti/projektarbeit/catkin_ws/install/setup.bash;/home/basti/projektarbeit/catkin_ws/install/local_setup.bash")
=======
   "/home/stefan/projektarbeit/catkin_ws/install/setup.bash;/home/stefan/projektarbeit/catkin_ws/install/local_setup.bash")
>>>>>>> 92f239d285461c11170bff33d44c46af98a92357
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
<<<<<<< HEAD
file(INSTALL DESTINATION "/home/basti/projektarbeit/catkin_ws/install" TYPE FILE FILES
    "/home/basti/projektarbeit/catkin_ws/build/catkin_generated/installspace/setup.bash"
    "/home/basti/projektarbeit/catkin_ws/build/catkin_generated/installspace/local_setup.bash"
=======
file(INSTALL DESTINATION "/home/stefan/projektarbeit/catkin_ws/install" TYPE FILE FILES
    "/home/stefan/projektarbeit/catkin_ws/build/catkin_generated/installspace/setup.bash"
    "/home/stefan/projektarbeit/catkin_ws/build/catkin_generated/installspace/local_setup.bash"
>>>>>>> 92f239d285461c11170bff33d44c46af98a92357
    )
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
<<<<<<< HEAD
   "/home/basti/projektarbeit/catkin_ws/install/setup.sh;/home/basti/projektarbeit/catkin_ws/install/local_setup.sh")
=======
   "/home/stefan/projektarbeit/catkin_ws/install/setup.sh;/home/stefan/projektarbeit/catkin_ws/install/local_setup.sh")
>>>>>>> 92f239d285461c11170bff33d44c46af98a92357
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
<<<<<<< HEAD
file(INSTALL DESTINATION "/home/basti/projektarbeit/catkin_ws/install" TYPE FILE FILES
    "/home/basti/projektarbeit/catkin_ws/build/catkin_generated/installspace/setup.sh"
    "/home/basti/projektarbeit/catkin_ws/build/catkin_generated/installspace/local_setup.sh"
=======
file(INSTALL DESTINATION "/home/stefan/projektarbeit/catkin_ws/install" TYPE FILE FILES
    "/home/stefan/projektarbeit/catkin_ws/build/catkin_generated/installspace/setup.sh"
    "/home/stefan/projektarbeit/catkin_ws/build/catkin_generated/installspace/local_setup.sh"
>>>>>>> 92f239d285461c11170bff33d44c46af98a92357
    )
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
<<<<<<< HEAD
   "/home/basti/projektarbeit/catkin_ws/install/setup.zsh;/home/basti/projektarbeit/catkin_ws/install/local_setup.zsh")
=======
   "/home/stefan/projektarbeit/catkin_ws/install/setup.zsh;/home/stefan/projektarbeit/catkin_ws/install/local_setup.zsh")
>>>>>>> 92f239d285461c11170bff33d44c46af98a92357
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
<<<<<<< HEAD
file(INSTALL DESTINATION "/home/basti/projektarbeit/catkin_ws/install" TYPE FILE FILES
    "/home/basti/projektarbeit/catkin_ws/build/catkin_generated/installspace/setup.zsh"
    "/home/basti/projektarbeit/catkin_ws/build/catkin_generated/installspace/local_setup.zsh"
=======
file(INSTALL DESTINATION "/home/stefan/projektarbeit/catkin_ws/install" TYPE FILE FILES
    "/home/stefan/projektarbeit/catkin_ws/build/catkin_generated/installspace/setup.zsh"
    "/home/stefan/projektarbeit/catkin_ws/build/catkin_generated/installspace/local_setup.zsh"
>>>>>>> 92f239d285461c11170bff33d44c46af98a92357
    )
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
<<<<<<< HEAD
   "/home/basti/projektarbeit/catkin_ws/install/.rosinstall")
=======
   "/home/stefan/projektarbeit/catkin_ws/install/.rosinstall")
>>>>>>> 92f239d285461c11170bff33d44c46af98a92357
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
<<<<<<< HEAD
file(INSTALL DESTINATION "/home/basti/projektarbeit/catkin_ws/install" TYPE FILE FILES "/home/basti/projektarbeit/catkin_ws/build/catkin_generated/installspace/.rosinstall")
=======
file(INSTALL DESTINATION "/home/stefan/projektarbeit/catkin_ws/install" TYPE FILE FILES "/home/stefan/projektarbeit/catkin_ws/build/catkin_generated/installspace/.rosinstall")
>>>>>>> 92f239d285461c11170bff33d44c46af98a92357
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
<<<<<<< HEAD
  include("/home/basti/projektarbeit/catkin_ws/build/gtest/cmake_install.cmake")
  include("/home/basti/projektarbeit/catkin_ws/build/turtlebot3/turtlebot3/cmake_install.cmake")
  include("/home/basti/projektarbeit/catkin_ws/build/turtlebot3_msgs/cmake_install.cmake")
  include("/home/basti/projektarbeit/catkin_ws/build/turtlebot3/turtlebot3_navigation/cmake_install.cmake")
  include("/home/basti/projektarbeit/catkin_ws/build/turtlebot3_simulations/turtlebot3_simulations/cmake_install.cmake")
  include("/home/basti/projektarbeit/catkin_ws/build/beginner_tutorials/cmake_install.cmake")
  include("/home/basti/projektarbeit/catkin_ws/build/face_recognition/cmake_install.cmake")
  include("/home/basti/projektarbeit/catkin_ws/build/find_person/cmake_install.cmake")
  include("/home/basti/projektarbeit/catkin_ws/build/location_monitor/cmake_install.cmake")
  include("/home/basti/projektarbeit/catkin_ws/build/turtlebot3/turtlebot3_bringup/cmake_install.cmake")
  include("/home/basti/projektarbeit/catkin_ws/build/turtlebot3/turtlebot3_example/cmake_install.cmake")
  include("/home/basti/projektarbeit/catkin_ws/build/turtlebot3_simulations/turtlebot3_fake/cmake_install.cmake")
  include("/home/basti/projektarbeit/catkin_ws/build/turtlebot3_simulations/turtlebot3_gazebo/cmake_install.cmake")
  include("/home/basti/projektarbeit/catkin_ws/build/turtlebot3/turtlebot3_slam/cmake_install.cmake")
  include("/home/basti/projektarbeit/catkin_ws/build/turtlebot3/turtlebot3_teleop/cmake_install.cmake")
  include("/home/basti/projektarbeit/catkin_ws/build/turtlebot3/turtlebot3_description/cmake_install.cmake")
=======
  include("/home/stefan/projektarbeit/catkin_ws/build/gtest/cmake_install.cmake")
  include("/home/stefan/projektarbeit/catkin_ws/build/beginner_tutorials/cmake_install.cmake")
  include("/home/stefan/projektarbeit/catkin_ws/build/face_recognition/cmake_install.cmake")
  include("/home/stefan/projektarbeit/catkin_ws/build/find_person/cmake_install.cmake")
  include("/home/stefan/projektarbeit/catkin_ws/build/location_monitor/cmake_install.cmake")
>>>>>>> 92f239d285461c11170bff33d44c46af98a92357

endif()

if(CMAKE_INSTALL_COMPONENT)
  set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
<<<<<<< HEAD
file(WRITE "/home/basti/projektarbeit/catkin_ws/build/${CMAKE_INSTALL_MANIFEST}"
=======
file(WRITE "/home/stefan/projektarbeit/catkin_ws/build/${CMAKE_INSTALL_MANIFEST}"
>>>>>>> 92f239d285461c11170bff33d44c46af98a92357
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
