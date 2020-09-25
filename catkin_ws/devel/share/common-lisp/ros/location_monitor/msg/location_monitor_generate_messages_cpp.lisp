; Auto-generated. Do not edit!


(cl:in-package location_monitor-msg)


;//! \htmlinclude location_monitor_generate_messages_cpp.msg.html

(cl:defclass <location_monitor_generate_messages_cpp> (roslisp-msg-protocol:ros-message)
  ()
)

(cl:defclass location_monitor_generate_messages_cpp (<location_monitor_generate_messages_cpp>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <location_monitor_generate_messages_cpp>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'location_monitor_generate_messages_cpp)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name location_monitor-msg:<location_monitor_generate_messages_cpp> is deprecated: use location_monitor-msg:location_monitor_generate_messages_cpp instead.")))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <location_monitor_generate_messages_cpp>) ostream)
  "Serializes a message object of type '<location_monitor_generate_messages_cpp>"
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <location_monitor_generate_messages_cpp>) istream)
  "Deserializes a message object of type '<location_monitor_generate_messages_cpp>"
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<location_monitor_generate_messages_cpp>)))
  "Returns string type for a message object of type '<location_monitor_generate_messages_cpp>"
  "location_monitor/location_monitor_generate_messages_cpp")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'location_monitor_generate_messages_cpp)))
  "Returns string type for a message object of type 'location_monitor_generate_messages_cpp"
  "location_monitor/location_monitor_generate_messages_cpp")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<location_monitor_generate_messages_cpp>)))
  "Returns md5sum for a message object of type '<location_monitor_generate_messages_cpp>"
  "d41d8cd98f00b204e9800998ecf8427e")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'location_monitor_generate_messages_cpp)))
  "Returns md5sum for a message object of type 'location_monitor_generate_messages_cpp"
  "d41d8cd98f00b204e9800998ecf8427e")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<location_monitor_generate_messages_cpp>)))
  "Returns full string definition for message of type '<location_monitor_generate_messages_cpp>"
  (cl:format cl:nil "~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'location_monitor_generate_messages_cpp)))
  "Returns full string definition for message of type 'location_monitor_generate_messages_cpp"
  (cl:format cl:nil "~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <location_monitor_generate_messages_cpp>))
  (cl:+ 0
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <location_monitor_generate_messages_cpp>))
  "Converts a ROS message object to a list"
  (cl:list 'location_monitor_generate_messages_cpp
))
