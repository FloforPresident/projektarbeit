# Projektarbeit

## Backend

Pre Setup:
  - Docker & Docker Compose auf Rechner installiert

Backend starten:
  1. Persönliche IP Adresse im projektarbeit/backend/.env file anpassen (`ifconfig`) (wird im File-Explorer nicht angezeigt)
  
  	$ cd ~/projektarbeit/backend
	$ gedit .env
  	
  2. Roscore starten
  3. Turtlebot bringup
  4. Befehl im Terminal ausführen im projektarbeit/backend Ordner

	$ cd ~/projektarbeit/backend
	$ make start
	
  5. Docker-Datenbank starten
  
	$ cd ~/projektarbeit/backend/backend/controller
	$ python3 controller.py
	
  6. App starten
  

### Docker Container

- Controller
    - _python3.8 image_
    - Schnittstelle zwischen App, Datenbank und ROS
- Datenbank
    - _postgress image_
    - Postgress Datenbank, zugriff mit O/M Mapper SQlAlchemy aus controller
- Ros  
    - _ubuntu 16.04 image_ 
    - Vollständige Ubuntu installation mit allen Ros Konfigurationen


Die wichtigsten Docker Commands:

    $ docker ps                                     // Laufende Container anzeigen lassen
    $ docker inspect {container-name}               // Infos zu bestimmtem Container
    $ docker container kill $(docker ps -q)         // Alle laufenden Container schließen
    $ docker exec -it {container-name} bash    // ins Docker Terminal

## App

### Setup:

- Installiertes Flutter SDK
- Android / IOS Emulator
- Android Studio / IntelliJ
- Laufender Controller im selben Netzwerk


## ROS

### Setup

    $ roscore                       // Ros starten
    $ catkin_make                   // Im catkin_ws Ordner ausführen um packages zu regisrieren
    $ rosrun package python-file    // Topic starten
    $ cd ~/projektarbeit/catkin_ws/ && rm -r build devel && catkin_make


### Camera, Face Recognition, Stream

    Turtlebot:
    $	roslaunch raspicam_node camerav2_1280x960.launch	// Streamt Bild von Raspicam an Topic /raspicam_node/image

    Host Laptop:
    $	rosrun face_recognition face_recognition	// Startet Face Recognition Node, streamt verarbeitetes Bild an Topic /Face_Recognition_Stream 
    $	rosrun web_video_server web_video_server  	// Streamt sämtliche Image Topics an http://localhost:8080/ - Link für /Face_Recognition_Stream ist in App eingebaut

	


## GIT

    $ git status                    // Show local file changes
    $ git commit -a                 // Only commit tracked files
    $ git add .                     // Stage tracked and untracked files
    $ git commit -m '(message)'     // Commit message -> If applied, this commit will...
    $ git push                      // Push local commits
    $ git pull                      // Pull remote commits
    $ git checkout -b branch        // Create and Switch to branch
    $ git checkout branch           // Switch to branch
    $ git reset --soft HEAD~1       // Rollback not already pushed commit if you havent pulled before committing
