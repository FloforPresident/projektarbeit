# Projektarbeit

## Backend

Backend starten:
  1. Persönliche IP Adresse im .env file anpassen (`ifconfig`)
  2. Befehl im Terminal ausführen

    $ make start

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
    $ docker exec -it {container-name} /bin/bash    // Alle laufenden Container schließen

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


# GIT

    $ git status                    // Show local file changes
    $ git commit -a                 // Only commit tracked files
    $ git add .                     // Stage tracked and untracked files
    $ git commit -m '(message)'     // Commit message -> If applied, this commit will...
    $ git push                      // Push local commits
    $ git pull                      // Pull remote commits
    $ git checkout -b branch        // Create and Switch to branch
    $ git checkout branch           // Switch to branch
    $ git reset --soft HEAD~1       // Rollback not already pushed commit if you havent pulled before committing