-- phpMyAdmin SQL Dump
-- version 5.0.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Erstellungszeit: 05. Nov 2020 um 14:11
-- Server-Version: 10.4.14-MariaDB
-- PHP-Version: 7.4.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `turtlebot`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `Location`
--

CREATE TABLE `Location` (
  `location_id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `x` int(11) NOT NULL,
  `y` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `Location`
--

INSERT INTO `Location` (`location_id`, `room_id`, `title`, `x`, `y`) VALUES
(1, 9, 'Printer', 2, 3);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `Message`
--

CREATE TABLE `Message` (
  `message_id` int(11) NOT NULL,
  `from_user` int(11) NOT NULL,
  `to_user` int(11) NOT NULL,
  `text` varchar(255) NOT NULL,
  `datetime` datetime NOT NULL,
  `sent` tinyint(1) NOT NULL,
  `received` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `Robo`
--

CREATE TABLE `Robo` (
  `robo_id` int(11) NOT NULL,
  `room_id` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `ip` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `Robo`
--

INSERT INTO `Robo` (`robo_id`, `room_id`, `name`, `ip`) VALUES
(1, 9, 'bot_ross', '007');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `robo_room`
--

CREATE TABLE `robo_room` (
  `robo_id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `Room`
--

CREATE TABLE `Room` (
  `room_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `pgm` blob DEFAULT NULL,
  `yaml` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `Room`
--

INSERT INTO `Room` (`room_id`, `title`, `pgm`, `yaml`) VALUES
(9, 'Office', NULL, NULL);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `User`
--

CREATE TABLE `User` (
  `user_id` int(11) NOT NULL,
  `location_id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `image` blob DEFAULT NULL,
  `embedding` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `Location`
--
ALTER TABLE `Location`
  ADD PRIMARY KEY (`location_id`),
  ADD KEY `room_id` (`room_id`);

--
-- Indizes für die Tabelle `Message`
--
ALTER TABLE `Message`
  ADD PRIMARY KEY (`message_id`),
  ADD KEY `from_user` (`from_user`),
  ADD KEY `to_user` (`to_user`);

--
-- Indizes für die Tabelle `Robo`
--
ALTER TABLE `Robo`
  ADD PRIMARY KEY (`robo_id`),
  ADD KEY `room_id` (`room_id`);

--
-- Indizes für die Tabelle `robo_room`
--
ALTER TABLE `robo_room`
  ADD KEY `robo_id` (`robo_id`),
  ADD KEY `room_id` (`room_id`);

--
-- Indizes für die Tabelle `Room`
--
ALTER TABLE `Room`
  ADD PRIMARY KEY (`room_id`);

--
-- Indizes für die Tabelle `User`
--
ALTER TABLE `User`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `User_ibfk_1` (`location_id`);

--
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `Location`
--
ALTER TABLE `Location`
  MODIFY `location_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT für Tabelle `Message`
--
ALTER TABLE `Message`
  MODIFY `message_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `Robo`
--
ALTER TABLE `Robo`
  MODIFY `robo_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT für Tabelle `Room`
--
ALTER TABLE `Room`
  MODIFY `room_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT für Tabelle `User`
--
ALTER TABLE `User`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints der exportierten Tabellen
--

--
-- Constraints der Tabelle `Location`
--
ALTER TABLE `Location`
  ADD CONSTRAINT `Location_ibfk_2` FOREIGN KEY (`room_id`) REFERENCES `Room` (`room_id`);

--
-- Constraints der Tabelle `Message`
--
ALTER TABLE `Message`
  ADD CONSTRAINT `Message_ibfk_1` FOREIGN KEY (`from_user`) REFERENCES `User` (`user_id`),
  ADD CONSTRAINT `Message_ibfk_2` FOREIGN KEY (`to_user`) REFERENCES `User` (`user_id`);

--
-- Constraints der Tabelle `Robo`
--
ALTER TABLE `Robo`
  ADD CONSTRAINT `Robo_ibfk_1` FOREIGN KEY (`room_id`) REFERENCES `Room` (`room_id`);

--
-- Constraints der Tabelle `robo_room`
--
ALTER TABLE `robo_room`
  ADD CONSTRAINT `robo_room_ibfk_1` FOREIGN KEY (`robo_id`) REFERENCES `Robo` (`robo_id`),
  ADD CONSTRAINT `robo_room_ibfk_2` FOREIGN KEY (`room_id`) REFERENCES `Room` (`room_id`);

--
-- Constraints der Tabelle `User`
--
ALTER TABLE `User`
  ADD CONSTRAINT `User_ibfk_1` FOREIGN KEY (`location_id`) REFERENCES `Location` (`location_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
