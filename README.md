# projektarbeit

Backend Controller in Docker starten:

- Navigiere in Backend Ordner im Terminal
- Trage deine aktuelle IP in der Datei docker-compose.yml an kommentierter Stelle ein
- Terminal-Befehl: <make start>, startet controller und Datenbank, nun kann sich App im selben Netzwerk verbinden 


#----bei Änderung des benutzers-----

cd ~/projektarbeit/catkin_ws/ && rm -r build devel && catkin_make

#----push data from command line ----

cd {REPOSITORY_PATH}

git add {FOLDER_FILE_ETC_NAME} oder alles hinzufügen: "git add ."

git commit -m "Push beschreibung" {FOLDER_FILE_ETC_NAME}


git status #aktuelle Änderungen, commits etc


git push -u origin master
