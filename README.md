# Projektarbeit Turtlebot Setup

## Prerequisites
- VirtualBox VM (min 3GB Ram + 15GB Speicher)
- Ubuntu 16.04 Xenial (https://releases.ubuntu.com/16.04.7/ubuntu-16.04.7-desktop-amd64.iso)
- VM Netzwerk Einstellungen auf Netzwerkbrücke statt NAT

## Installation
### 1. Git installieren


    $ sudo apt-get install git

### 2. Git Repository Klonen


    $ git clone https://github.com/FloforPresident/projektarbeit.git

### 3. Dependencies Installieren (nur als Root ausführbar)
    - Während Installation muss einmal mit Enter bestätigt werden


    $ cd projektarbeit
    $ sudo -s
    $ ./install-dependencies.sh
 
### 4. Nach fertiger Installation (ca. 60 Minuten) Terminal schließen und neues öffnen
### 5. Turtlebot starten
   5.1 Turtlebot mit Bildschirm verbinden, starten (pw = _turtlebot_) \
   5.2 Mit Netzwerk verbinden und IP-Adresse auslesen (`ifconfig`) \
   5.3 ROS Variablen anpassen: \
        `sudo nano ~/.bashrc`: \
            ROS_MASTER_URI = http://$RosLaptopIP:11311 \
            ROS_HOSTNAME = $turtlebotIP \
   5.4  Einmalig `ssh pi@$turtlebotip` auf ROS Laptop um SSH Verbindung zu erlauben. Terminal kann danach wieder geschlossen werden
### 6. Packages und Nodes ausführen:

6.1. **Create Map** um Raum zu kartieren (Punkte nacheinander ausführen)
   
       $ cd backend/backend/controller
       $ sudo -s
       $ python3 console_interface.py

- Nummern eingeben um zu starten (+ alternativ Befehl ohne console-interface)

1. Set Turtlebot ID
2. Roscore starten 
   
    `roscore`
3. Turtlebot Bringup (Mit SSH Verbindung zum turtlebot)
   
    `ssh pi@{IP_ADDRESSS_TURTLEBOT}` \
    `roslaunch turtlebot3_bringup turtlebot3_robot.launch` 
   
4. Start Gmapping
   
   `roslaunch turtlebot3_slam turtlebot3_slam.launch`

5. Start Teleop ( auf Host PC oder in App nachdem Controller gestartet wurde )

   `roslaunch turtlebot3_teleop turtlebot3_teleop_key.launch`

6. Save Map (muss zwingend _map.pgm_ heißen)

   `rosrun map_server map_saver -f $HOME/projektarbeit/backend/backend/catkin_ws/maps/map`

=> X und Y Koordinaten aus RViz herauslesen für spätere Zuweisung zu Personen

    
6.2. **General Bringup** Um gesamtes Projekt zu starten (Punkte ausführen und anweisungen folgen)

    $ cd backend/backend/controller
    $ sudo -s
    $ python3 console_interface.py

1. Set Turtlebot ID
2. Roscore starten 
   
    `roscore`
3. Database Container (in _/projektarbeit/backend_)
    
    `make start`
    
4. Controller Starten (in _/projektarbeit/backend/backend/controller_)

    `python3 controller.py`

5. Face Recognition

   `rosrun face_recognition face_recognize_plus_Web_Video_Stream.py`

6. Web Video Server

    `rosrun web_video_server web_video_server`

7. Find Person

    `rosrun find_person go_to_person.py`

8. TurtleBot Bringup

   `ssh pi@{IP_ADDRESSS_TURTLEBOT}` \
   `roslaunch turtlebot3_bringup turtlebot3_robot.launch`

9. Turtlebot Kamera Stream
   
   `ssh pi@{IP_ADDRESSS_TURTLEBOT}` \
   `roslaunch raspicam_node camerav2_1280x960_10fps.launch enable_raw:=true`

10. Turtlebot Speaker
    
    `ssh pi@{IP_ADDRESSS_TURTLEBOT}` \
    `rosrun speaker_node speaker_node.py`

11. Map laden
   
    `roslaunch turtlebot3_navigation turtlebot3_navigation.launch map_file:=$HOME/projektarbeit/backend/backend/catkin_ws/maps/map.yaml` 


### 7. App Installieren (Andoid)

Flutter App - APK Datei downloaden und installieren (_/projektarbeit/FlutterApp/Flutter_Apk/app-release.apk_) \


## Dateistruktur & Management

- Projektmanagement wurde auf **Trello** erledigt
  

- **Dokumentation**: Selbsterklärend
- **Backend**: Enthält Grundsätzlichen Projektcode 
    - ROS spezifisches in _projektarbeit/backend/backend/catkin_ws_
    - Controller spezifisches in _projektarbeit/backend/backend/controller_ 
- **FlutterApp**: App spezifisches, Apk und Flutter App code



