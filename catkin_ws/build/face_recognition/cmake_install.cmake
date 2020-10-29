<<<<<<< HEAD
# Install script for directory: /home/basti/projektarbeit/catkin_ws/src/face_recognition

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/home/basti/projektarbeit/catkin_ws/install")
=======
# Install script for directory: /home/stefan/projektarbeit/catkin_ws/src/face_recognition

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
<<<<<<< HEAD
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE FILES "/home/basti/projektarbeit/catkin_ws/build/face_recognition/catkin_generated/installspace/face_recognition.pc")
=======
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE FILES "/home/stefan/projektarbeit/catkin_ws/build/face_recognition/catkin_generated/installspace/face_recognition.pc")
>>>>>>> 92f239d285461c11170bff33d44c46af98a92357
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/face_recognition/cmake" TYPE FILE FILES
<<<<<<< HEAD
    "/home/basti/projektarbeit/catkin_ws/build/face_recognition/catkin_generated/installspace/face_recognitionConfig.cmake"
    "/home/basti/projektarbeit/catkin_ws/build/face_recognition/catkin_generated/installspace/face_recognitionConfig-version.cmake"
=======
    "/home/stefan/projektarbeit/catkin_ws/build/face_recognition/catkin_generated/installspace/face_recognitionConfig.cmake"
    "/home/stefan/projektarbeit/catkin_ws/build/face_recognition/catkin_generated/installspace/face_recognitionConfig-version.cmake"
>>>>>>> 92f239d285461c11170bff33d44c46af98a92357
    )
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
<<<<<<< HEAD
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/face_recognition" TYPE FILE FILES "/home/basti/projektarbeit/catkin_ws/src/face_recognition/package.xml")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/face_recognition" TYPE PROGRAM FILES "/home/basti/projektarbeit/catkin_ws/build/face_recognition/catkin_generated/installspace/face_recognize.py")
=======
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/face_recognition" TYPE FILE FILES "/home/stefan/projektarbeit/catkin_ws/src/face_recognition/package.xml")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/face_recognition" TYPE PROGRAM FILES "/home/stefan/projektarbeit/catkin_ws/build/face_recognition/catkin_generated/installspace/face_recognize.py")
>>>>>>> 92f239d285461c11170bff33d44c46af98a92357
endif()

