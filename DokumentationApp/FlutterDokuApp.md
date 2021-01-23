### Flutter App Dokumentation


## Flutter Files

![App Struktur] (https://github.com/FloforPresident/projektarbeit/blob/master/DokumentationApp/TurlebotAppStruktur.png)

1. Flutter_Apk

Hier befindet sich die App zum installieren und eine Kurzanleitung zum Installieren.


2. turlebot

Hier befindet sich der Programmcode der App

2.1 Ordner .dart_tool - ios (außer images) 
    
Diese Ordner enthalten alle Files entweder von der IDE erstellte oder von Flutter und wurden nicht bearbeitet
    
2.2 Order Images

hier befindet sich nur ein Testbild

2.3 Ordner lib
    
Im Ordner lib befindet sich der selbstgschriebene Code
    
2.3.1 Ordner Frameworks
        
Dieser enthält Widgets die keine vollständige Seite repräsentiert und als Hilfswidgets gestaltet wurden
        
2.3.2 Ordner Objects
        
Dieser enthält Datentypen die den jeweiligen Tabellen in der Datenbank repräsentieren
        
2.3.3 Ordner pages
        
Dieser enthält die einzelnen Seiten mit Controller, Widget und dem Layout
        
Hier befindet sich die Logik und das Layout der Seiten
        
![Aufbau Pages] (https://github.com/FloforPresident/projektarbeit/blob/master/DokumentationApp/PageStructure.png)

2.3.4 Ordner Services
        
Hier befinden sich unterstützende Funktionen und die AlertDialogs (PopUpDialogs)
Das Routing, die Daten zur Festlegung der IP-Adresse des ROS-Laptops
        
2.4 File pupspec.yaml
    
Hier befinden sich die zusätzlich verwendeten Packages 
        
    
    
    
