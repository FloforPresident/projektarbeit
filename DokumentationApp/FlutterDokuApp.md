# Flutter App Dokumentation


# Flutter Files

![App Struktur](https://github.com/FloforPresident/projektarbeit/blob/master/DokumentationApp/TurlebotAppStruktur.png)

Format: ![Alt Text](url)

# 1. Flutter_Apk

Hier befindet sich die App zum installieren und eine Kurzanleitung zum Installieren.


# 2. turlebot

Hier befindet sich der Programmcode der App

## 2.1 Ordner .dart_tool - ios (außer images) 
    
Diese Ordner enthalten alle Files entweder von der IDE erstellte oder von Flutter und wurden nicht bearbeitet
    
## 2.2 Order Images

hier befindet sich nur ein Testbild

## 2.3 Ordner lib
    
Im Ordner lib befindet sich der selbstgschriebene Code
    
## 2.3.1 Ordner Frameworks
        
Dieser enthält Widgets die keine vollständige Seite repräsentiert und als Hilfswidgets gestaltet wurden

## 2.3.1.1 CustomDropDownMenu

Mit diesem Widget lassen sich DropdownMenus erstellen. Hierbei kann der aktuelle Index(controller.getCurrentIndex),
und der Wert (controller.getValue) ausgegeben werden. Der aktuelle Zustand des Dropdown,
also aktueller Wert und Index wird im ControllerCustomDropdown festgehalten.

## 2.3.1.2 IncorrectIP

Widget das in den Pages eingebaut und zu sehen ist, wenn der WebSocket keine Verbindung aufbauen konnte.

## 2.3.1.3 Logout

Diese Klasse kann überall eingebaut werden um einen Logout bei Funktionaufruf zu erzeugen

## 2.3.1.4 PageFrame

Beinhaltet den Rahmen für alle Seiten, es ermöglicht eine farbliche Anpassung der Taskbar,
den Farbverlauf unter die eigentliche Seite zu legen und den Rand zu bestimmen.
        
## 2.3.2 Ordner Objects
        
Dieser enthält Datentypen die den jeweiligen Tabellen in der Datenbank repräsentieren
        
## 2.3.3 Ordner pages
        
Dieser enthält die einzelnen Seiten mit Controller, Widget und dem Layout.

In main.dart wird die App gestartet. Hier befindet sich die Navigation durch die Seiten und der Verbindungsaufbau mit dem Websocket des ROS-Laptops

Im Klassennamen befinden sich die statischen Werte, wie Layoutwerte. Im State<Klassennamen> befindet 
sich das eigentliche Layout des Widgets. Im Controller befindet sich die Logik der Seite, mit Logik zur 
Nachrichten Versendung mit dem Websocket. Außerdem befinden sich hier auch seitenspezifische AlertDialogs.
        
![Aufbau Pages](https://github.com/FloforPresident/projektarbeit/blob/master/DokumentationApp/PageStructure.png)

Format: ![Alt Text](url)

## 2.3.3.1 Home Ordner

active_location.dart, home.dart und messages.dart bilden die erste Seite nachdem Login.
Vorsicht, Home.dart enthält die Klasse HomeScreen, home befindet sich in main.dart.

## 2.3.3.2 Maps Ordner

Hier bilden locations.dart, maps.dart und rooms.dart eine Seite



## 2.3.4 Ordner Services
        
Hier befinden sich unterstützende Funktionen und die AlertDialogs (PopUpDialogs)
Das Routing, die Daten zur Festlegung der IP-Adresse des ROS-Laptops
        
## 2.4 File pupspec.yaml
    
Hier befinden sich die zusätzlich verwendeten Packages unter "dependencies"
        
    
    
    
