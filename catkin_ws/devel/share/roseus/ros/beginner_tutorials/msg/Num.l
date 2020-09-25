;; Auto-generated. Do not edit!


(when (boundp 'beginner_tutorials::Num)
  (if (not (find-package "BEGINNER_TUTORIALS"))
    (make-package "BEGINNER_TUTORIALS"))
  (shadow 'Num (find-package "BEGINNER_TUTORIALS")))
(unless (find-package "BEGINNER_TUTORIALS::NUM")
  (make-package "BEGINNER_TUTORIALS::NUM"))

(in-package "ROS")
;;//! \htmlinclude Num.msg.html


(defclass beginner_tutorials::Num
  :super ros::object
  :slots (_num _vorname _nachname _alter ))

(defmethod beginner_tutorials::Num
  (:init
   (&key
    ((:num __num) 0)
    ((:vorname __vorname) "")
    ((:nachname __nachname) "")
    ((:alter __alter) 0)
    )
   (send-super :init)
   (setq _num (round __num))
   (setq _vorname (string __vorname))
   (setq _nachname (string __nachname))
   (setq _alter (round __alter))
   self)
  (:num
   (&optional __num)
   (if __num (setq _num __num)) _num)
  (:vorname
   (&optional __vorname)
   (if __vorname (setq _vorname __vorname)) _vorname)
  (:nachname
   (&optional __nachname)
   (if __nachname (setq _nachname __nachname)) _nachname)
  (:alter
   (&optional __alter)
   (if __alter (setq _alter __alter)) _alter)
  (:serialization-length
   ()
   (+
    ;; int64 _num
    8
    ;; string _vorname
    4 (length _vorname)
    ;; string _nachname
    4 (length _nachname)
    ;; uint8 _alter
    1
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; int64 _num
#+(or :alpha :irix6 :x86_64)
       (progn (sys::poke _num (send s :buffer) (send s :count) :long) (incf (stream-count s) 8))
#-(or :alpha :irix6 :x86_64)
       (cond ((and (class _num) (= (length (_num . bv)) 2)) ;; bignum
              (write-long (ash (elt (_num . bv) 0) 0) s)
              (write-long (ash (elt (_num . bv) 1) -1) s))
             ((and (class _num) (= (length (_num . bv)) 1)) ;; big1
              (write-long (elt (_num . bv) 0) s)
              (write-long (if (>= _num 0) 0 #xffffffff) s))
             (t                                         ;; integer
              (write-long _num s)(write-long (if (>= _num 0) 0 #xffffffff) s)))
     ;; string _vorname
       (write-long (length _vorname) s) (princ _vorname s)
     ;; string _nachname
       (write-long (length _nachname) s) (princ _nachname s)
     ;; uint8 _alter
       (write-byte _alter s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; int64 _num
#+(or :alpha :irix6 :x86_64)
      (setf _num (prog1 (sys::peek buf ptr- :long) (incf ptr- 8)))
#-(or :alpha :irix6 :x86_64)
      (setf _num (let ((b0 (prog1 (sys::peek buf ptr- :integer) (incf ptr- 4)))
                  (b1 (prog1 (sys::peek buf ptr- :integer) (incf ptr- 4))))
              (cond ((= b1 -1) b0)
                     ((and (= b1  0)
                           (<= lisp::most-negative-fixnum b0 lisp::most-positive-fixnum))
                      b0)
                    ((= b1  0) (make-instance bignum :size 1 :bv (integer-vector b0)))
                    (t (make-instance bignum :size 2 :bv (integer-vector b0 (ash b1 1)))))))
   ;; string _vorname
     (let (n) (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4) (setq _vorname (subseq buf ptr- (+ ptr- n))) (incf ptr- n))
   ;; string _nachname
     (let (n) (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4) (setq _nachname (subseq buf ptr- (+ ptr- n))) (incf ptr- n))
   ;; uint8 _alter
     (setq _alter (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;;
   self)
  )

(setf (get beginner_tutorials::Num :md5sum-) "d59150134dddd4be2143129962b51a21")
(setf (get beginner_tutorials::Num :datatype-) "beginner_tutorials/Num")
(setf (get beginner_tutorials::Num :definition-)
      "int64 num
string vorname
string nachname
uint8 alter

")



(provide :beginner_tutorials/Num "d59150134dddd4be2143129962b51a21")


