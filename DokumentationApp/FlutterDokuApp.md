# Flutter App Dokumentation


# Flutter Files

![App Struktur](https://github.com/FloforPresident/projektarbeit/blob/master/DokumentationApp/TurlebotAppStruktur.png)

Format: ![Alt Text](url)

# 1.0 Flutter_Apk

Hier befindet sich die App zum installieren und eine Kurzanleitung zum Installieren.


# 2.0 turlebot

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

## 2.3.1.3 LoadingInfo

Dies wird angezeigt wenn die Anfrage an dem Websocket länger dauert als erwartet. 
Wenn das zusehen ist meist keine Verbindung zum Websocket Server möglich.
Vermutlich falsche Ip-Adresse oder Websocket noch nicht eingeschalten.

## 2.3.1.4 Logout

Diese Klasse kann überall eingebaut werden um einen Logout bei Funktionaufruf zu erzeugen

## 2.3.1.5 PageFrame

Beinhaltet den Rahmen für alle Seiten, es ermöglicht eine farbliche Anpassung der Taskbar,
den Farbverlauf unter die eigentliche Seite zu legen und den Rand zu bestimmen.
        
## 2.3.2 Ordner Objects
        
Dieser enthält Datentypen die die jeweiligen Tabellen in der Datenbank repräsentieren
        
## 2.3.3 Ordner pages
        
Dieser enthält die einzelnen Seiten mit Controller, Widget und dem Layout.

In main.dart wird die App gestartet. Hier befindet sich die Navigation durch die Seiten und der Verbindungsaufbau mit dem Websocket des ROS-Laptops

Im Klassennamen befinden sich die statischen Werte, wie Layoutwerte. Im State<Klassennamen> befindet 
sich das eigentliche Layout des Widgets. 
Im Controller befindet sich die Logik der Seite, mit Logik zur Nachrichten Versendung mit dem Websocket. 
Mehr zu Websockets in Listenpunkt 3.0.
Außerdem befinden sich hier auch seitenspezifische AlertDialogs.
        
![Aufbau Pages](https://github.com/FloforPresident/projektarbeit/blob/master/DokumentationApp/PageStructure.png)

Format: ![Alt Text](url)

## 2.3.3.1 Home Ordner

active_location.dart, home.dart und messages.dart bilden die erste Seite nachdem Login.
Vorsicht, Home.dart enthält die Klasse HomeScreen, home befindet sich in main.dart.

# 2.3.3.2 Main.dart

Das Dart-File beinhaltet zwei Klassen, MyApp und Home.

MyApp enhält die Initialiserung der App mit MyApp.build. Hier wird die Routenfunktionen festgelegt
und die StartRoute. Routenfunktion RouteGenerator.RouteHome.

Hier befindet sich die main-Funktion, mit con() wird eine Verbindung zum Websocket Server aufgebaut,
hier passiert auch der Login (genau Erklärung Listenpunkt 5.0) 

Home enthält die BottomNavigationBar die unser UI für das switchen zwischen unserer Seiten ist 
und den allgemeinen Rahmen für unsere Seiten.

## 2.3.4 Ordner Services
        
Hier befinden sich unterstützende Funktionen und die AlertDialogs (PopUpDialogs)
Das Routing, die Daten zur Festlegung der IP-Adresse des ROS-Laptops
        
## 2.4 File pupspec.yaml
    
Hier befinden sich die zusätzlich verwendeten Packages unter "dependencies"


## 3.0 Websocket

Die Verwendung des Websockets, funktioniert über eine Verbindung zum Websocket Server
zu finden in main.dart Klasse MyApp. Außerdem befindet sich in socke_info.dart die Informationen
zur WebsocketServer IP, dem Port und die Logik um Werte zu setzen und zu initialisieren.

In jedem Widget der die Verbindung benötigt wird dieser im State abgefragt.

Über getData im jeweiligen Controller werden die Daten aus dem Server abgefragt.

Über das Widget StreamBuilder in den Pages, wird überprüft ob Daten angekommen sind und bei Erfolg
nach der entsprechenden Logik angezeigt.

https://api.flutter.dev/flutter/widgets/StreamBuilder-class.html

Außerdem wird bei nicht Erfolg eine Meldung angezeigt das keine Daten übertragen wurden.

Mit addData und channel.sink.add(data) werden Daten an den Websocket Server übertragen.

Hier die offizielle Flutter Doku zu Websockets:
https://flutter.dev/docs/cookbook/networking/web-sockets 

Der Websocket im serverseitigen ROS-Laptop funktioniert über Python.

## 4.0 AnimatedLists

Animierte dynamische Listen:

Bitte die allgemeine Handhabung der offiziellen Flutter Doku entnehmen.

Wichtige Hinweise:

Damit die Seiten richtig scrollen muss physiscs: NeverScrollableScrollPhysics() gesetzt sein.
Ansonsten wird wenn auch ein SingleChildScrollView Widget verwendet diese nicht miteinander 
funktioniert und die Listen nicht mitscrollen.

Bei Änderung der Listdaten müssen immer der State der AnimatedList und die zu Beginn übergebenen Daten geändert werden. (siehe Flutter Doku) 
Bei uns wird dies über key.currentState und dann .insertItem oder .removeItem erreicht.
Für die übergebene Daten in Form einer Liste wird list.items.add oder .remove(item) verwendet.

Hier die offizielle Flutter Doku zu AnimatedList:
https://api.flutter.dev/flutter/widgets/AnimatedList-class.html

## 5.0 Login

Allgemeiner Hinweis:

Wenn man sich versucht auf der Login-Seite anzumeleden und es kommt keine Benachrichtigung,
entweder User nicht vorhanden oder eine sonstige Benachrichtigung, dann ist vermutlich die IP-Adresse falsch.
Nach 1-2 Minuten kommt eine Meldung kein WebSocket-Server vorhanden, aber das wie gesagt dauert.

Der Login erstreckt sich über login.dart und über main.dart in der Klasse Home. (sieh Grafik unten)

Initiale Seite ist hier Home aus main.dart. In dieser wird abgeprüft ob der User bereits 
eingeloggt ist in _HomeState::initState(). 

Falls der User zuvor von der Login.dart Seite gekommen ist und einen Nutzer erstellt hat
ist sessionUser befüllt und Home::login() wird ausgeführt ansonsten Home::autoLogin().

### Home::login():
In  wird die beiden SharedPrefrences(Doku am Ende des Listenpunkts) abgefragt "id" und "name". 
Sind diese gegeben und die IP-Adresse zum WebsocketServer gesetzt, dann werden die Attribute 
MyApp.id und MyApp.name gesetzt. Anschließend wird die build Methode von Home aufgerufen, die prüft ob 
MyApp.id gesetzt ist und falls ja baut den HomeScreen zusammen.

### Home::autoLogin():
Falls autoLogin ausgewählt wird weil kein sessionUser vorhanden ist,
dann werden die SharedPrefrences "id" und "name" abgefragt.
Falls id null ist und zuvor keine WebsocketServer IP(SocketInfo.hostAdress) angegeben wurde, wird auf die Login.dart Seite 
weitergeleitet.
Wenn "id" und die WebSocketServer Adresse vorhanden ist wird auch wie in login() die HomeScreen Seite gebaut.

Weiterleitung zu login.dart:

### Raised Button "Anmelden":
Überprüft ob Ip-Adresse und Name gesetzt wurde. Falls Nein, Fehlermeldung "nicht alle Felder ausgefüllt".
Ansonsten wird die WebsocketServer IP gesetzt, und über Login::loginUser der neue User am WebsocketServer angmeldet. Falls die Daten falsch sind,
wird nicht weitergegangen und eine Fehlermeldung geworfen. Falls der Name stimmt wird an Login::loginHelper weitergeleitet.
Login::loginHelper setzt den SessionUser und leitet weiter an main.dart und die Klass Home. Anschließend weiter mit Home::login(). 

### Raised Button "Registrierung":
Bei Registrierung wird geprüft ob die WebSocketServer IP gesetzt wurde, falls nein kommt eine Fehlermeldung.
Fall Ja wird Login::signupDialog geöffnet. Dieser fragt einen UserNamen ab. Anschließend wird auf den Login::pictureDialog 
weitergeleitet. Dieser speichert ein Bild des Nutzers ab. Daraufhin wird an Login::editItemDialog 
weitergeleitet. Dieser gibt die Möglichkeit den Raum und die Location des neuen Users bei Bedarf 
zu setzen. Anschließend wird Login::addUser aufgerufen. Dieser speichert den neuen User in die Datenbank 
und leitet wieder zu Login::loginHelper weiter. Login::loginHelper speichert den User als sessionUser und
leitet weiter an main.dart Home. Anschließend weiter mit Home::login().

SharedPrefrences offizielle Doku:
https://flutter.dev/docs/cookbook/persistence/key-value


![LoginAblauf](https://github.com/FloforPresident/projektarbeit/blob/master/DokumentationApp/Basic_Activity_ Diagram.png)


## 6.0 BottomNavigationBar

Die Logik hierfür befindet sich in der Datei main.dart und in der Klasse Home.
In Home::build wird zuerst abgefragt ob ein User gesetzt ist falls nein wird Home::autoLogin() ausgeführt.
Falls ein User angemeldet ist wird der _selectedIndex in HomeState ausgelesen und die Funktion
_HomeState::choosePageAndColour aufgerufen und dementsprechend die richtige Seite aufgerufen.
Falls ein anderer Reiter in der BottomNavigationBar ausgewählt wird, läd sich die Seite neu
und _selectedIndex wird auf den Index des geklickten Icons geändert.

Somit muss wenn die Reihenfolge der Icons in der BottomNavigationBar geändert wird,
die Reihenfholge in ChoosePageAndColor auch geändert werden!!


## 7.0 Funktionalität geblockt

Da wir erst nicht mehr geschafft haben eine freie Roboterwahl und eine freie Raumwahl im Controller und über die Datenbank 
zu implementieren sind einige Funktionalitäten in der App auskommentiert. Diese werden mit dem Stichwort "Funktionalität geblockt" betitelt im Quellcode.
Falls diese Funktionalitäten noch umgesetzt wird kann die hierfür eingesetzte Statusmeldung wieder entfernt werden,
und die Logik auskommentiert werden. Also einfach in Flutter dieses Stichwort "Funktionalität geblockt" suchen dann findet ihr die Beiträge.

Hier die Änderungen nochmal aufgelistet:

FlutterApp/turtlebot/lib/pages/maps/rooms.dart/_RoomState/build()/RaisedButton

FlutterApp/turtlebot/lib/pages/robos.dart/_RoboState/build()/RaisedButton

Bei oberen Beiden einfach die auskommentierte Funktion wieder einfügen

Bei dem Darunter checkIfDefaultRoboAndMapSet() und auch die Verwendung in models.py
Sowie defaultRoboMissing() und defaultMapMissing()

backend/backend/controller/models.py 


## 8.0 Aktuelle Funktionalität


Die aktuelle Funktionalität funktioniert so, es wird eine standard Karte und ein standard Roboter ausgewählt.
Wenn eine Nachricht versendet wird, wird immer die standard Karte und der standard Roboter ausgewählt.
Locations können erstellt werden und auch neue User über Login angelegt werden. Ebenfalls kann die aktuelle Position ausgewählt werden.
Die Karte kann geändert werden wenn am Lagerort der Karte diese mit einer anderen ausgetauscht wird.
Dann müssen aber alle Locations gelöscht werden da die Werte vermutlich nur in dieser Map Sinn ergeben.




 
    
    
    
