;; Auto-generated. Do not edit!


(when (boundp 'location_monitor::location_monitor_generate_messages_cpp)
  (if (not (find-package "LOCATION_MONITOR"))
    (make-package "LOCATION_MONITOR"))
  (shadow 'location_monitor_generate_messages_cpp (find-package "LOCATION_MONITOR")))
(unless (find-package "LOCATION_MONITOR::LOCATION_MONITOR_GENERATE_MESSAGES_CPP")
  (make-package "LOCATION_MONITOR::LOCATION_MONITOR_GENERATE_MESSAGES_CPP"))

(in-package "ROS")
;;//! \htmlinclude location_monitor_generate_messages_cpp.msg.html


(defclass location_monitor::location_monitor_generate_messages_cpp
  :super ros::object
  :slots ())

(defmethod location_monitor::location_monitor_generate_messages_cpp
  (:init
   (&key
    )
   (send-super :init)
   self)
  (:serialization-length
   ()
   (+
    0
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;;
   self)
  )

(setf (get location_monitor::location_monitor_generate_messages_cpp :md5sum-) "d41d8cd98f00b204e9800998ecf8427e")
(setf (get location_monitor::location_monitor_generate_messages_cpp :datatype-) "location_monitor/location_monitor_generate_messages_cpp")
(setf (get location_monitor::location_monitor_generate_messages_cpp :definition-)
      "
")



(provide :location_monitor/location_monitor_generate_messages_cpp "d41d8cd98f00b204e9800998ecf8427e")


