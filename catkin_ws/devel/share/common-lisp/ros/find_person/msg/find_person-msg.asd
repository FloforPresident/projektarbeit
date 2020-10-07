
(cl:in-package :asdf)

(defsystem "find_person-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "person_info" :depends-on ("_package_person_info"))
    (:file "_package_person_info" :depends-on ("_package"))
  ))