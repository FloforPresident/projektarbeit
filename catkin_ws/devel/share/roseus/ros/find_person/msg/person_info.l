;; Auto-generated. Do not edit!


(when (boundp 'find_person::person_info)
  (if (not (find-package "FIND_PERSON"))
    (make-package "FIND_PERSON"))
  (shadow 'person_info (find-package "FIND_PERSON")))
(unless (find-package "FIND_PERSON::PERSON_INFO")
  (make-package "FIND_PERSON::PERSON_INFO"))

(in-package "ROS")
;;//! \htmlinclude person_info.msg.html


(defclass find_person::person_info
  :super ros::object
  :slots (_name _x _y ))

(defmethod find_person::person_info
  (:init
   (&key
    ((:name __name) "")
    ((:x __x) 0)
    ((:y __y) 0)
    )
   (send-super :init)
   (setq _name (string __name))
   (setq _x (round __x))
   (setq _y (round __y))
   self)
  (:name
   (&optional __name)
   (if __name (setq _name __name)) _name)
  (:x
   (&optional __x)
   (if __x (setq _x __x)) _x)
  (:y
   (&optional __y)
   (if __y (setq _y __y)) _y)
  (:serialization-length
   ()
   (+
    ;; string _name
    4 (length _name)
    ;; uint8 _x
    1
    ;; uint8 _y
    1
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; string _name
       (write-long (length _name) s) (princ _name s)
     ;; uint8 _x
       (write-byte _x s)
     ;; uint8 _y
       (write-byte _y s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; string _name
     (let (n) (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4) (setq _name (subseq buf ptr- (+ ptr- n))) (incf ptr- n))
   ;; uint8 _x
     (setq _x (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;; uint8 _y
     (setq _y (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;;
   self)
  )

(setf (get find_person::person_info :md5sum-) "6a961519893f7b5c9a396afc5b003835")
(setf (get find_person::person_info :datatype-) "find_person/person_info")
(setf (get find_person::person_info :definition-)
      "string name
uint8 x
uint8 y

")



(provide :find_person/person_info "6a961519893f7b5c9a396afc5b003835")


