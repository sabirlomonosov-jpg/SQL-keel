-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Loomise aeg: Aprill 20, 2026 kell 10:15 EL
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
(3, '2026-04-20 11:13:16', 'Võeti tööle uus töötaja: John Smith', 'root@localhost');

-- --------------------------------------------------------

--
-- Tabeli struktuur tabelile `employees`
--

CREATE TABLE `employees` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `salary` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Andmete tõmmistamine tabelile `employees`
--

INSERT INTO `employees` (`id`, `name`, `salary`) VALUES
(1, 'Ivan Ivanov', 1500.00),
(2, 'Anna Petrova', 1800.00),
(3, 'John Smith', 2000.00);

--
-- Päästikud `employees`
--
DELIMITER $$
CREATE TRIGGER `trg_AfterEmployeeAdd` AFTER INSERT ON `employees` FOR EACH ROW BEGIN
    INSERT INTO AuditLog (event_time, description_, user_)
    VALUES (
        NOW(),
        CONCAT('Võeti tööle uus töötaja: ', NEW.name),
        USER()
    );
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
-- Indeksid tabelile `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT tõmmistatud tabelitele
--

--
-- AUTO_INCREMENT tabelile `auditlog`
--
ALTER TABLE `auditlog`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT tabelile `employees`
--
ALTER TABLE `employees`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
