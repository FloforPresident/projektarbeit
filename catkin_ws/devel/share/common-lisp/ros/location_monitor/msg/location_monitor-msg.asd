
(cl:in-package :asdf)

(defsystem "location_monitor-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "location_monitor_generate_messages_cpp" :depends-on ("_package_location_monitor_generate_messages_cpp"))
    (:file "_package_location_monitor_generate_messages_cpp" :depends-on ("_package"))
  ))