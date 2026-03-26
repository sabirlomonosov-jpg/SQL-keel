-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Loomise aeg: Märts 26, 2026 kell 01:53 PL
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
-- Andmebaas: `lomonosovpraktibaas`
--

DELIMITER $$
--
-- Toimingud
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `EditTable` (IN `valik` VARCHAR(10), IN `tabeli_nimi` VARCHAR(20), IN `veerunimi` VARCHAR(20), IN `type` VARCHAR(20))   BEGIN
SET @sql = CASE
WHEN valik LIKE 'add' THEN
CONCAT('ALTER TABLE ', tabeli_nimi, ' ADD ', veerunimi, ' ', type)
WHEN valik LIKE 'drop' THEN
CONCAT('ALTER TABLE ', tabeli_nimi, ' DROP COLUMN ', veerunimi)
END;
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `KeskminePalk` ()   BEGIN
    SELECT AVG(palk) AS keskmine_palk
    FROM praktikajuhendaja;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `LisaFirma` (IN `firmanimi` VARCHAR(20), IN `aadress` VARCHAR(20), IN `telefon` VARCHAR(20))   BEGIN
    INSERT INTO firma (firmanimi, aadress, telefon)
    VALUES (firmanimi, aadress, telefon);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `LisaVeerg` ()   BEGIN
    ALTER TABLE praktikajuhendaja
    ADD email VARCHAR(50);
END$$

--
-- Funktsioonid
--
CREATE DEFINER=`root`@`localhost` FUNCTION `CalculateAge` (`DOB` DATE) RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE Age INT;

    SET Age = TIMESTAMPDIFF(YEAR, DOB, CURDATE());

    -- Adjust if birthday hasn't occurred yet this year
    IF (MONTH(DOB) > MONTH(CURDATE())) 
       OR (MONTH(DOB) = MONTH(CURDATE()) AND DAY(DOB) > DAY(CURDATE())) THEN
        SET Age = Age - 1;
    END IF;

    RETURN Age;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnComputeAge` (`DOB` DATE) RETURNS VARCHAR(50) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN
    DECLARE years INT;
    DECLARE months INT;
    DECLARE days INT;
    DECLARE tempdate DATE;
    DECLARE Age VARCHAR(50);

    SET tempdate = DOB;

    -- Calculate years
    SET years = TIMESTAMPDIFF(YEAR, tempdate, CURDATE());
    IF DATE_ADD(tempdate, INTERVAL years YEAR) > CURDATE() THEN
        SET years = years - 1;
    END IF;
    SET tempdate = DATE_ADD(tempdate, INTERVAL years YEAR);

    -- Calculate months
    SET months = TIMESTAMPDIFF(MONTH, tempdate, CURDATE());
    IF DATE_ADD(tempdate, INTERVAL months MONTH) > CURDATE() THEN
        SET months = months - 1;
    END IF;
    SET tempdate = DATE_ADD(tempdate, INTERVAL months MONTH);

    -- Calculate days
    SET days = DATEDIFF(CURDATE(), tempdate);

    -- Build result string
    SET Age = CONCAT(years, ' Years ', months, ' Months ', days, ' Days old');

    RETURN Age;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Tabeli struktuur tabelile `firma`
--

CREATE TABLE `firma` (
  `firmaID` int(11) NOT NULL,
  `firmanimi` varchar(20) DEFAULT NULL,
  `aadress` varchar(20) DEFAULT NULL,
  `telefon` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Andmete tõmmistamine tabelile `firma`
--

INSERT INTO `firma` (`firmaID`, `firmanimi`, `aadress`, `telefon`) VALUES
(1, 'TechSoft', 'Tallinn', '5551111'),
(2, 'DataPro', 'Tartu', '5552222'),
(3, 'NetGroup', 'Narva', '5553333'),
(4, 'CodeLab', 'Parnu', '5554444'),
(5, 'ITWorks', 'Tallinn', '5555555');

-- --------------------------------------------------------

--
-- Tabeli struktuur tabelile `praktikabaas`
--

CREATE TABLE `praktikabaas` (
  `praktikabaasID` int(11) NOT NULL,
  `firmaID` int(11) DEFAULT NULL,
  `praktikatingimused` varchar(20) DEFAULT NULL,
  `arvutiprogramm` varchar(20) DEFAULT NULL,
  `juhendajaID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Andmete tõmmistamine tabelile `praktikabaas`
--

INSERT INTO `praktikabaas` (`praktikabaasID`, `firmaID`, `praktikatingimused`, `arvutiprogramm`, `juhendajaID`) VALUES
(1, 1, 'Kontor', 'Excel', 1),
(2, 2, 'Kaugtoo', 'AutoCAD', 2),
(3, 3, 'Kontor', 'Photoshop', 3),
(4, 1, 'Hubriid', 'Word', 4),
(5, 4, 'Kontor', 'Python', 2),
(6, 5, 'Kaugtoo', 'Java', 5),
(7, 2, 'Hubriid', 'C++', 3),
(8, 3, 'Kontor', 'SQL', 1);

-- --------------------------------------------------------

--
-- Tabeli struktuur tabelile `praktikajuhendaja`
--

CREATE TABLE `praktikajuhendaja` (
  `praktikajuhendajaID` int(11) NOT NULL,
  `eesnimi` varchar(20) DEFAULT NULL,
  `perekonnanimi` varchar(20) DEFAULT NULL,
  `synniaeg` date DEFAULT NULL,
  `telefon` varchar(20) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Andmete tõmmistamine tabelile `praktikajuhendaja`
--

INSERT INTO `praktikajuhendaja` (`praktikajuhendajaID`, `eesnimi`, `perekonnanimi`, `synniaeg`, `telefon`, `email`) VALUES
(1, 'Jaan', 'Tamm', '1980-05-12', '5123456', NULL),
(2, 'Mari', 'Kask', '1990-07-23', '5234567', NULL),
(3, 'Toomas', 'Saar', '1985-03-15', '5345678', NULL),
(4, 'Liis', 'Magi', '1992-11-30', '5456789', NULL),
(5, 'Karl', 'Oun', '1988-01-20', '5567890', NULL);

--
-- Indeksid tõmmistatud tabelitele
--

--
-- Indeksid tabelile `firma`
--
ALTER TABLE `firma`
  ADD PRIMARY KEY (`firmaID`);

--
-- Indeksid tabelile `praktikabaas`
--
ALTER TABLE `praktikabaas`
  ADD PRIMARY KEY (`praktikabaasID`),
  ADD KEY `firmaID` (`firmaID`),
  ADD KEY `juhendajaID` (`juhendajaID`);

--
-- Indeksid tabelile `praktikajuhendaja`
--
ALTER TABLE `praktikajuhendaja`
  ADD PRIMARY KEY (`praktikajuhendajaID`);

--
-- AUTO_INCREMENT tõmmistatud tabelitele
--

--
-- AUTO_INCREMENT tabelile `firma`
--
ALTER TABLE `firma`
  MODIFY `firmaID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT tabelile `praktikabaas`
--
ALTER TABLE `praktikabaas`
  MODIFY `praktikabaasID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT tabelile `praktikajuhendaja`
--
ALTER TABLE `praktikajuhendaja`
  MODIFY `praktikajuhendajaID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Tõmmistatud tabelite piirangud
--

--
-- Piirangud tabelile `praktikabaas`
--
ALTER TABLE `praktikabaas`
  ADD CONSTRAINT `praktikabaas_ibfk_1` FOREIGN KEY (`firmaID`) REFERENCES `firma` (`firmaID`),
  ADD CONSTRAINT `praktikabaas_ibfk_2` FOREIGN KEY (`juhendajaID`) REFERENCES `praktikajuhendaja` (`praktikajuhendajaID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
