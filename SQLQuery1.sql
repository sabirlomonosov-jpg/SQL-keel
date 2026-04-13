CREATE DATABASE TrigerLomonosov
use TrigerLomonosov

--tabel linnad
CREATE TABLE linnad(
linnID int primary key identity(1,1),
linnaNimi varchar(50) unique,
rahvaArv int NOT NULL
);

-- tabel logi
CREATE TABLE logi(
ID int primary key identity(1,1),
kuupaev date,
andmed TEXT
);

CREATE TRIGGER linnaLisamine
ON linnad
FOR INSERT
AS
INSERT INTO logi(kuupaev, andmed)
SELECT
getdate(), inserted.linnaNimi
FROM inserted

--kontrollimiseks tuleb lisada uus linn tabelisse linnad
INSERT INTO linnad(linnaNimi, rahvaArv)
VALUES('Tallinn', 600000);
SELECT * FROM linnad
SELECT * FROM logi

drop TRIGGER linnaLisamine

CREATE TRIGGER linnaLisamine
ON linnad
FOR INSERT
AS
INSERT INTO logi(kuupaev, andmed)
SELECT
getdate(),
CONCAT('Linn: ', inserted.linnaNimi,
' rahvaarv: ', inserted.rahvaArv,
' ID: ', inserted.linnID)
FROM inserted

INSERT INTO linnad(linnaNimi, rahvaArv)
VALUES('Narva', 60000);
SELECT * FROM linnad
SELECT * FROM logi

--DELETE triger
CREATE TRIGGER linnaKutsutamine
ON linnad
FOR DELETE
AS
INSERT INTO logi(kuupaev, andmed)
SELECT
getdate(),
CONCAT('Linn: ', deleted.linnaNimi,
' rahvaarv: ', deleted.rahvaArv,
' ID: ', deleted.linnID)
FROM deleted

DELETE FROM linnad WHERE linnID = 1
SELECT * FROM linnad
SELECT * FROM logi

-- UPDATE triger
CREATE TRIGGER linnaUuendamine
ON linnad
FOR UPDATE
AS
INSERT INTO logi(kuupaev, andmed)
SELECT
getdate(),
CONCAT('Vana linna andmed: ', d.linnaNimi,
' rahvaarv: ', d.rahvaArv,
' ID: ', d.linnID,
'Uued linna andmed: ', i.linnaNimi,
' rahvaarv: ', d.rahvaArv,
' ID: ', d.linnID)
FROM deleted d INNER JOIN inserted i
ON d.linnID=i.linnaNimi

SELECT * FROM linnad;
UPDATE linnad SET linnaNimi= 'Paldiski', rahvaArv=1000
WHERE linnID = 2;
SELECT * FROM linnad
SELECT * FROM logi

ALTER TABLE logi ADD kasutaja varchar(40);

-- tabel Auto 
CREATE TABLE Auto (
    AutoID INT PRIMARY KEY identity(1,1),
    autoNR CHAR(6),
    Omanik VARCHAR(100),
    Mark VARCHAR(50),
    Aasta INT
);

INSERT INTO Auto (autoNR, Omanik, Mark, Aasta) 
VALUES ('123ABC', 'Jaan Tamm', 'Toyota', 2015),
('456DEF', 'Mari Saar', 'Volkswagen', 2018),
('789GHI', 'Peeter Kask', 'BMW', 2020),
('321JKL', 'Kati Põld', 'Audi', 2017),
('654MNO', 'Tõnis Lepp', 'Mercedes-Benz', 2019);

SELECT * FROM Auto
-- auto log
CREATE TABLE autoLogi (
    id INT PRIMARY KEY identity(1,1),
    tegevus VARCHAR(30),
    autoID INT,
    aeg DATE
);

-- INSERT triger
CREATE TRIGGER insert_log
ON Auto
FOR INSERT
AS
BEGIN
INSERT INTO autoLogi(tegevus, autoID)
SELECT 'lisas', AutoID 
FROM inserted;
END;

INSERT INTO Auto(autoNR, Omanik

--DELETE triger
CREATE TRIGGER delete_log
ON Auto
FOR DELETE
AS
BEGIN
INSERT INTO autoLogi(tegevus, autoID)
SELECT 'kustutas', AutoID 
FROM deleted;
END;

-- UPDATE triger
CREATE TRIGGER update_log
ON Auto
FOR UPDATE
AS
BEGIN
    INSERT INTO autoLogi (tegevus, autoID)
    SELECT 'muutis', AutoID FROM inserted;
END;

