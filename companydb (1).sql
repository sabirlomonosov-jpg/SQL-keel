-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Loomise aeg: Mai 04, 2026 kell 11:37 EL
-- Serveri versioon: 10.4.32-MariaDB
-- PHP versioon: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Andmebaas: `companydb`
--

-- --------------------------------------------------------

--
-- Tabeli struktuur tabelile `auditlog`
--

CREATE TABLE `auditlog` (
  `id` int(11) NOT NULL,
  `event_time` datetime DEFAULT NULL,
  `description_` varchar(255) DEFAULT NULL,
  `user_` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Andmete tõmmistamine tabelile `auditlog`
--

INSERT INTO `auditlog` (`id`, `event_time`, `description_`, `user_`) VALUES
(1, '2026-04-20 11:13:16', 'Võeti tööle uus töötaja: Ivan Ivanov', 'root@localhost'),
(2, '2026-04-20 11:13:16', 'Võeti tööle uus töötaja: Anna Petrova', 'root@localhost'),
(3, '2026-04-20 11:13:16', 'Võeti tööle uus töötaja: John Smith', 'root@localhost'),
(4, '2026-05-04 11:27:21', 'Lisati töötaja: test', 'root@localhost'),
(5, '2026-05-04 12:32:58', 'Lisati töötaja: test2, 100.00, 3', 'root@localhost'),
(6, '2026-05-04 12:36:12', 'Lisati töötaja: test3, 345.99, 2', 'root@localhost');

-- --------------------------------------------------------

--
-- Tabeli struktuur tabelile `departments`
--

CREATE TABLE `departments` (
  `id` int(11) NOT NULL,
  `department_name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Andmete tõmmistamine tabelile `departments`
--

INSERT INTO `departments` (`id`, `department_name`) VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Finance');

--
-- Päästikud `departments`
--
DELIMITER $$
CREATE TRIGGER `department_after_delete` AFTER DELETE ON `departments` FOR EACH ROW BEGIN
INSERT INTO AuditLog (event_time, description_, user_)
VALUES (NOW(),CONCAT('Kustutati osakond: ',OLD.department_name,', id=',OLD.id),CURRENT_USER());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `department_after_insert` AFTER INSERT ON `departments` FOR EACH ROW BEGIN
INSERT INTO AuditLog (event_time, description_, user_)
VALUES (NOW(),CONCAT('Lisati osakond: ',NEW.department_name,', id=',NEW.id),CURRENT_USER());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `department_after_update` AFTER UPDATE ON `departments` FOR EACH ROW BEGIN
INSERT INTO AuditLog (event_time, description_, user_)
VALUES (NOW(),CONCAT('Muudeti osakonda: ',OLD.department_name,' -> ',NEW.department_name,', id=',OLD.id),CURRENT_USER());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Tabeli struktuur tabelile `employees`
--

CREATE TABLE `employees` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `salary` decimal(10,2) DEFAULT NULL,
  `department_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Andmete tõmmistamine tabelile `employees`
--

INSERT INTO `employees` (`id`, `name`, `salary`, `department_id`) VALUES
(1, 'Ivan Ivanov', 1500.00, 1),
(2, 'Anna Petrova', 1800.00, 2),
(6, 'test', 567.00, 1),
(7, 'test2', 100.00, 3),
(8, 'test3', 345.99, 2);

--
-- Päästikud `employees`
--
DELIMITER $$
CREATE TRIGGER `trg_Employees_Delete` AFTER DELETE ON `employees` FOR EACH ROW BEGIN
INSERT INTO AuditLog (event_time, description_, user_)
VALUES (NOW(),CONCAT('Kustutati töötaja: ',OLD.name, ', ',OLD.salary, ', ',OLD.department_id),CURRENT_USER());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_Employees_Insert` AFTER INSERT ON `employees` FOR EACH ROW BEGIN
INSERT INTO AuditLog (event_time, description_, user_)VALUES (NOW(),CONCAT('Lisati töötaja: ',NEW.name, ', ',NEW.salary, ', ',NEW.department_id),CURRENT_USER());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_Employees_Update` AFTER UPDATE ON `employees` FOR EACH ROW BEGIN
INSERT INTO AuditLog (event_time, description_, user_)
VALUES (NOW(),CONCAT('Muudeti töötajat: ',OLD.name, ', ',OLD.salary, ', ', OLD.department_id,' -> ',NEW.name, ', ', NEW.salary, ', ', NEW.department_id),CURRENT_USER());
END
$$
DELIMITER ;

--
-- Indeksid tõmmistatud tabelitele
--

--
-- Indeksid tabelile `auditlog`
--
ALTER TABLE `auditlog`
  ADD PRIMARY KEY (`id`);

--
-- Indeksid tabelile `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`id`);

--
-- Indeksid tabelile `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_department` (`department_id`);

--
-- AUTO_INCREMENT tõmmistatud tabelitele
--

--
-- AUTO_INCREMENT tabelile `auditlog`
--
ALTER TABLE `auditlog`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT tabelile `departments`
--
ALTER TABLE `departments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT tabelile `employees`
--
ALTER TABLE `employees`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Tõmmistatud tabelite piirangud
--

--
-- Piirangud tabelile `employees`
--
ALTER TABLE `employees`
  ADD CONSTRAINT `fk_department` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
