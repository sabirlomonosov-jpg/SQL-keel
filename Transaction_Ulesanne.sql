CREATE DATABASE Transaktsion_Ulesanne
use Transaktsion_Ulesanne

-- Osa 1 / Ülesanne 1
CREATE TABLE tblMailingAddress (
    AddressId int NOT NULL PRIMARY KEY,
    EmployeeNumber int,
    HouseNumber nvarchar(50),
    StreetAddress nvarchar(50),
    City nvarchar(10),
    PostalCode nvarchar(50)
);

INSERT INTO tblMailingAddress
VALUES (1, 101, '#10', 'King Street', 'Londoon', 'CR27DW');

SELECT * FROM tblMailingAddress;

CREATE TABLE tblPhysicalAddress (
    AddressId int NOT NULL PRIMARY KEY,
    EmployeeNumber int,
    HouseNumber nvarchar(50),
    StreetAddress nvarchar(50),
    City nvarchar(10),
    PostalCode nvarchar(50)
);

INSERT INTO tblPhysicalAddress
VALUES (1, 101, '#10', 'King Street', 'Londoon', 'CR27DW');

SELECT * FROM tblPhysicalAddress;

-- Osa 1 / Ülesanne 2
SELECT * FROM tblMailingAddress;
SELECT * FROM tblPhysicalAddress;

-- Osa 3 / Ülesanne 3
CREATE PROCEDURE spUpdateAddress
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE tblMailingAddress
        SET City = 'LONDON'
        WHERE AddressId = 1 AND EmployeeNumber = 101;

        UPDATE tblPhysicalAddress
        SET City = 'LONDON'
        WHERE AddressId = 1 AND EmployeeNumber = 101;

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
    END CATCH
END;

-- Käivita ja kontrolli
EXEC spUpdateAddress;

SELECT * FROM tblMailingAddress;
SELECT * FROM tblPhysicalAddress;

-- Osa 1 / Ülesanne 4
ALTER PROCEDURE spUpdateAddress
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE tblMailingAddress
        SET City = 'LONDON12'
        WHERE AddressId = 1 AND EmployeeNumber = 101;

        UPDATE tblPhysicalAddress
        SET City = 'LONDON LONDON'
        WHERE AddressId = 1 AND EmployeeNumber = 101;

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
    END CATCH
END;

-- Käivita ja kontrolli
EXEC spUpdateAddress;

SELECT * FROM tblMailingAddress;
SELECT * FROM tblPhysicalAddress;

-- Osa 1 / Ülesanne 5
UPDATE tblMailingAddress
SET City = 'LONDON12'
WHERE AddressId = 1 AND EmployeeNumber = 101;

UPDATE tblPhysicalAddress
SET City = 'LONDON LON'
WHERE AddressId = 1 AND EmployeeNumber = 101;

-- Kontrolli pärast veateadet
SELECT * FROM tblMailingAddress;
SELECT * FROM tblPhysicalAddress;



-- Osa 2 / ülesanne 1
CREATE TABLE tblArveldusarve (
    KontoId int NOT NULL PRIMARY KEY,
    KliendiNr int,
    Omanik nvarchar(30),
    Saldo decimal(10,2) CHECK (Saldo >= 0)
);

INSERT INTO tblArveldusarve
VALUES (1, 201, 'Mari Maasikas', 500.00);

SELECT * FROM tblArveldusarve;

CREATE TABLE tblHoiusarve (
    KontoId int NOT NULL PRIMARY KEY,
    KliendiNr int,
    Omanik nvarchar(30),
    Saldo decimal(10,2) CHECK (Saldo >= 0)
);

INSERT INTO tblHoiusarve
VALUES (1, 201, 'Mari Maasikas', 1000.00);

SELECT * FROM tblHoiusarve;

-- Osa 2 / Ülesanne 2
SELECT * FROM tblArveldusarve;
SELECT * FROM tblHoiusarve;

-- Osa 2 / Ülesanne 3
CREATE PROCEDURE spUlekanne
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE tblHoiusarve
        SET Saldo = Saldo + 200
        WHERE KontoId = 1 AND KliendiNr = 201;

        UPDATE tblArveldusarve
        SET Saldo = Saldo - 200
        WHERE KontoId = 1 AND KliendiNr = 201;

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
    END CATCH
END;

-- Käivita ja kontrolli
EXEC spUlekanne;

SELECT * FROM tblArveldusarve;
SELECT * FROM tblHoiusarve;

-- Osa 2 / Ülesanne 4
ALTER PROCEDURE spUlekanne
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE tblHoiusarve
        SET Saldo = Saldo + 1000
        WHERE KontoId = 1 AND KliendiNr = 201;

        UPDATE tblArveldusarve
        SET Saldo = Saldo - 1000
        WHERE KontoId = 1 AND KliendiNr = 201;

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
    END CATCH
END;

-- Käivita ja kontrolli
EXEC spUlekanne;

SELECT * FROM tblArveldusarve;
SELECT * FROM tblHoiusarve;

-- Osa 2 / Ülesanne 5
UPDATE tblHoiusarve
SET Saldo = Saldo + 1000
WHERE KontoId = 1 AND KliendiNr = 201;

UPDATE tblArveldusarve
SET Saldo = Saldo - 100
WHERE KontoId = 1 AND KliendiNr = 201;

-- Kontrolli pärast veateadet
SELECT * FROM tblArveldusarve;
SELECT * FROM tblHoiusarve;

-- Osa 2 / ülesanne +
ALTER PROCEDURE spUlekanne
    @Summa decimal(10,2)
AS
BEGIN
    IF @Summa IS NULL OR @Summa <= 0
    BEGIN
        PRINT 'Summa peab olema suurem kui 0.';
        RETURN;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE tblHoiusarve
        SET Saldo = Saldo + @Summa
        WHERE KontoId = 1 AND KliendiNr = 201;

        UPDATE tblArveldusarve
        SET Saldo = Saldo - @Summa
        WHERE KontoId = 1 AND KliendiNr = 201;

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
    END CATCH
END;

-- Käivita ja kontrolli
EXEC spUlekanne @Summa = 50;

SELECT * FROM tblArveldusarve;
SELECT * FROM tblHoiusarve;



-- Osa 3 / Ülesanne 1
CREATE TABLE tblLadu (
    ToodeId int NOT NULL PRIMARY KEY,
    Nimetus nvarchar(30),
    Hind decimal(10,2),
    Kogus int CHECK (Kogus >= 0)
);

INSERT INTO tblLadu
VALUES
    (1, 'Hiir', 15.00, 10),
    (2, 'Klaviatuur', 25.00, 8),
    (3, 'Monitor', 120.00, 5);

SELECT * FROM tblLadu;

CREATE TABLE tblTellimus (
    TellimusId int NOT NULL PRIMARY KEY,
    ToodeId int REFERENCES tblLadu(ToodeId),
    Klient nvarchar(30),
    Kogus int
);

INSERT INTO tblTellimus
VALUES
    (1, 1, 'Mari Maasikas', 1),
    (2, 2, 'Jaan Tamm', 2),
    (3, 3, 'Anna Kask', 1);

SELECT * FROM tblTellimus;

-- Osa 3 / Ülesanne 2
SELECT * FROM tblLadu;
SELECT * FROM tblTellimus;

-- Osa 3 / Ülesanne 3
CREATE PROCEDURE spLisaToodeTellimusse
    @Kogus int
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE tblTellimus
        SET Kogus = Kogus + @Kogus
        WHERE TellimusId = 1 AND ToodeId = 1;

        UPDATE tblLadu
        SET Kogus = Kogus - @Kogus
        WHERE ToodeId = 1;

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        PRINT ERROR_MESSAGE();
    END CATCH
END;

-- Osa 3 / Ülesanne 4
EXEC spLisaToodeTellimusse @Kogus = 2;

SELECT * FROM tblLadu;
SELECT * FROM tblTellimus;

-- Osa 3 / Ülesanne 5
EXEC spLisaToodeTellimusse @Kogus = 20;

SELECT * FROM tblLadu;
SELECT * FROM tblTellimus;