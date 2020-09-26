; Auto-generated. Do not edit!


(cl:in-package find_person-msg)


;//! \htmlinclude person_info.msg.html

(cl:defclass <person_info> (roslisp-msg-protocol:ros-message)
  ((name
    :reader name
    :initarg :name
    :type cl:string
    :initform "")
   (x
    :reader x
    :initarg :x
    :type cl:fixnum
    :initform 0)
   (y
    :reader y
    :initarg :y
    :type cl:fixnum
    :initform 0))
)

(cl:defclass person_info (<person_info>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <person_info>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'person_info)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name find_person-msg:<person_info> is deprecated: use find_person-msg:person_info instead.")))

(cl:ensure-generic-function 'name-val :lambda-list '(m))
(cl:defmethod name-val ((m <person_info>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader find_person-msg:name-val is deprecated.  Use find_person-msg:name instead.")
  (name m))

(cl:ensure-generic-function 'x-val :lambda-list '(m))
(cl:defmethod x-val ((m <person_info>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader find_person-msg:x-val is deprecated.  Use find_person-msg:x instead.")
  (x m))

(cl:ensure-generic-function 'y-val :lambda-list '(m))
(cl:defmethod y-val ((m <person_info>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader find_person-msg:y-val is deprecated.  Use find_person-msg:y instead.")
  (y m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <person_info>) ostream)
  "Serializes a message object of type '<person_info>"
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'name))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'name))
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'x)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'y)) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <person_info>) istream)
  "Deserializes a message object of type '<person_info>"
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'name) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'name) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'x)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'y)) (cl:read-byte istream))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<person_info>)))
  "Returns string type for a message object of type '<person_info>"
  "find_person/person_info")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'person_info)))
  "Returns string type for a message object of type 'person_info"
  "find_person/person_info")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<person_info>)))
  "Returns md5sum for a message object of type '<person_info>"
  "6a961519893f7b5c9a396afc5b003835")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'person_info)))
  "Returns md5sum for a message object of type 'person_info"
  "6a961519893f7b5c9a396afc5b003835")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<person_info>)))
  "Returns full string definition for message of type '<person_info>"
  (cl:format cl:nil "string name~%uint8 x~%uint8 y~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'person_info)))
  "Returns full string definition for message of type 'person_info"
  (cl:format cl:nil "string name~%uint8 x~%uint8 y~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <person_info>))
  (cl:+ 0
     4 (cl:length (cl:slot-value msg 'name))
     1
     1
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <person_info>))
  "Converts a ROS message object to a list"
  (cl:list 'person_info
    (cl:cons ':name (name msg))
    (cl:cons ':x (x msg))
    (cl:cons ':y (y msg))
))
