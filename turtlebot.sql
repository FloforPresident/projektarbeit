-- phpMyAdmin SQL Dump
-- version 4.9.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Nov 27, 2020 at 05:02 PM
-- Server version: 10.4.10-MariaDB
-- PHP Version: 7.3.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `turtlebot`
--

-- --------------------------------------------------------

--
-- Table structure for table `Location`
--

CREATE TABLE `Location` (
  `location_id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `x` double NOT NULL,
  `y` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `Location`
--

INSERT INTO `Location` (`location_id`, `room_id`, `title`, `x`, `y`) VALUES
(3, 10, 'Flos Desk', 1.2, 1.5),
(6, 14, 'Table', 1, 2),
(8, 13, 'Washing Machine', 1.2, 2.4),
(11, 10, 'Printer', 2.2, 1.9),
(14, 18, 'Car', 1, 1),
(15, 18, 'Door', 3, 3),
(20, 16, 'Folterecke', 1.1, 1.4),
(21, 16, 'Porno Regal', 0.87, 1.2),
(22, 10, 'Patrick\'s Chair', 0.1, 0.2),
(23, 16, 'Bett', 0.69, 0.69),
(25, 16, 'Sockenschrank', 1.2, 3.1);

-- --------------------------------------------------------

--
-- Table structure for table `Message`
--

CREATE TABLE `Message` (
  `message_id` int(11) NOT NULL,
  `from_user` int(11) NOT NULL,
  `to_user` int(11) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `message` varchar(255) NOT NULL,
  `datetime` datetime NOT NULL DEFAULT current_timestamp(),
  `received` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `Message`
--

INSERT INTO `Message` (`message_id`, `from_user`, `to_user`, `subject`, `message`, `datetime`, `received`) VALUES
(22, 28, 37, 'WTF', 'Warum hast du n Folter Regal?', '2020-11-26 19:42:04', NULL),
(23, 28, 36, 'Hi', 'Was geht ab?', '2020-11-27 11:52:58', NULL),
(24, 28, 38, 'Hi', 'Ich brauch Hilfe', '2020-11-27 16:38:34', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `Robo`
--

CREATE TABLE `Robo` (
  `robo_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `ip` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `Robo`
--

INSERT INTO `Robo` (`robo_id`, `name`, `ip`) VALUES
(4, 'Turtletäubchen', '192.168.188.145'),
(5, 'Robob Ross', '192.168.122.159'),
(6, 'Turtlebot', '192.168.154.111');

-- --------------------------------------------------------

--
-- Table structure for table `Room`
--

CREATE TABLE `Room` (
  `room_id` int(11) NOT NULL,
  `robo_id` int(11) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `pgm` blob DEFAULT NULL,
  `yaml` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `Room`
--

INSERT INTO `Room` (`room_id`, `robo_id`, `title`, `pgm`, `yaml`) VALUES
(10, 4, 'Office', NULL, NULL),
(13, 6, 'Bathroom', NULL, NULL),
(14, 5, 'Kitchen', NULL, NULL),
(16, 5, 'Stefan\'s Zimmer', NULL, NULL),
(18, 5, 'Garage', NULL, NULL),
(19, 4, 'Basement', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `User`
--

CREATE TABLE `User` (
  `user_id` int(11) NOT NULL,
  `location_id` int(11) DEFAULT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `image` blob DEFAULT NULL,
  `embedding` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `User`
--

INSERT INTO `User` (`user_id`, `location_id`, `username`, `password`, `image`, `embedding`) VALUES
(28, 3, 'Flo', '123', NULL, NULL),
(35, 11, 'Basti', '123', NULL, NULL),
(36, 11, 'Patrick', '123', NULL, NULL),
(37, 11, 'Stefan', '123', NULL, NULL),
(38, 11, 'Coach', '123', NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Location`
--
ALTER TABLE `Location`
  ADD PRIMARY KEY (`location_id`),
  ADD KEY `room_id` (`room_id`);

--
-- Indexes for table `Message`
--
ALTER TABLE `Message`
  ADD PRIMARY KEY (`message_id`),
  ADD KEY `from_user` (`from_user`),
  ADD KEY `to_user` (`to_user`);

--
-- Indexes for table `Robo`
--
ALTER TABLE `Robo`
  ADD PRIMARY KEY (`robo_id`);

--
-- Indexes for table `Room`
--
ALTER TABLE `Room`
  ADD PRIMARY KEY (`room_id`),
  ADD KEY `Room_ibfk_1` (`robo_id`);

--
-- Indexes for table `User`
--
ALTER TABLE `User`
  ADD PRIMARY KEY (`user_id`),
  ADD KEY `User_ibfk_1` (`location_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `Location`
--
ALTER TABLE `Location`
  MODIFY `location_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `Message`
--
ALTER TABLE `Message`
  MODIFY `message_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `Robo`
--
ALTER TABLE `Robo`
  MODIFY `robo_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `Room`
--
ALTER TABLE `Room`
  MODIFY `room_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `User`
--
ALTER TABLE `User`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `Location`
--
ALTER TABLE `Location`
  ADD CONSTRAINT `Location_ibfk_2` FOREIGN KEY (`room_id`) REFERENCES `Room` (`room_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Message`
--
ALTER TABLE `Message`
  ADD CONSTRAINT `Message_ibfk_1` FOREIGN KEY (`from_user`) REFERENCES `User` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `Message_ibfk_2` FOREIGN KEY (`to_user`) REFERENCES `User` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `Room`
--
ALTER TABLE `Room`
  ADD CONSTRAINT `Room_ibfk_1` FOREIGN KEY (`robo_id`) REFERENCES `Robo` (`robo_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `User`
--
ALTER TABLE `User`
  ADD CONSTRAINT `User_ibfk_1` FOREIGN KEY (`location_id`) REFERENCES `Location` (`location_id`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
