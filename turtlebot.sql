-- phpMyAdmin SQL Dump
-- version 4.9.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Oct 10, 2020 at 02:43 PM
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
  `user_id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `x` int(11) NOT NULL,
  `y` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `Message`
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
-- Table structure for table `Robo`
--

CREATE TABLE `Robo` (
  `robo_id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `ip` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `robo_room`
--

CREATE TABLE `robo_room` (
  `robo_id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `Room`
--

CREATE TABLE `Room` (
  `room_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `map` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `User`
--

CREATE TABLE `User` (
  `user_id` int(11) NOT NULL,
  `location_id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `image` blob NOT NULL,
  `embedding` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`embedding`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Location`
--
ALTER TABLE `Location`
  ADD PRIMARY KEY (`location_id`),
  ADD KEY `user_id` (`user_id`),
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
  ADD PRIMARY KEY (`robo_id`),
  ADD KEY `room_id` (`room_id`);

--
-- Indexes for table `robo_room`
--
ALTER TABLE `robo_room`
  ADD KEY `robo_id` (`robo_id`),
  ADD KEY `room_id` (`room_id`);

--
-- Indexes for table `Room`
--
ALTER TABLE `Room`
  ADD PRIMARY KEY (`room_id`);

--
-- Indexes for table `User`
--
ALTER TABLE `User`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `location_id` (`location_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `Location`
--
ALTER TABLE `Location`
  MODIFY `location_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Message`
--
ALTER TABLE `Message`
  MODIFY `message_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Robo`
--
ALTER TABLE `Robo`
  MODIFY `robo_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Room`
--
ALTER TABLE `Room`
  MODIFY `room_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `User`
--
ALTER TABLE `User`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `Location`
--
ALTER TABLE `Location`
  ADD CONSTRAINT `Location_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`),
  ADD CONSTRAINT `Location_ibfk_2` FOREIGN KEY (`room_id`) REFERENCES `Room` (`room_id`);

--
-- Constraints for table `Message`
--
ALTER TABLE `Message`
  ADD CONSTRAINT `Message_ibfk_1` FOREIGN KEY (`from_user`) REFERENCES `User` (`user_id`),
  ADD CONSTRAINT `Message_ibfk_2` FOREIGN KEY (`to_user`) REFERENCES `User` (`user_id`);

--
-- Constraints for table `Robo`
--
ALTER TABLE `Robo`
  ADD CONSTRAINT `Robo_ibfk_1` FOREIGN KEY (`room_id`) REFERENCES `Room` (`room_id`);

--
-- Constraints for table `robo_room`
--
ALTER TABLE `robo_room`
  ADD CONSTRAINT `robo_room_ibfk_1` FOREIGN KEY (`robo_id`) REFERENCES `Robo` (`robo_id`),
  ADD CONSTRAINT `robo_room_ibfk_2` FOREIGN KEY (`room_id`) REFERENCES `Room` (`room_id`);

--
-- Constraints for table `User`
--
ALTER TABLE `User`
  ADD CONSTRAINT `User_ibfk_1` FOREIGN KEY (`location_id`) REFERENCES `Location` (`location_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
