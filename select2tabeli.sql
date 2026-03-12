CREATE DATABASE Lomonosov
use Lomonosov

CREATE TABLE uudised(
uudisID int PRIMARY KEY identity(1,1),
uudisPealkiri varchar(50),
kuupaev date,
kirjeldus TEXT,
ajakirjanikID int
);

CREATE TABLE ajakirjanik(
ajakirjanikID int PRIMARY KEY identity(1,1),
nimi varchar(50),
telefon varchar(13)
);


ALTER TABLE uudised ADD CONSTRAINT fk_ajakirjanik2
FOREIGN KEY(ajakirjanikID) REFERENCES ajakirjanik(ajakirjanikID);

INSERT INTO ajakirjanik(nimi, telefon)
VALUES('Lev','54943169'),
('Anton','465468753'),
('Vitalij', '62465795');

INSERT INTO uudised(uudisPealkiri, kuupaev, ajakirjanikID)
VALUES('Hoome on ises töö kodus', '2025-03-12', 1),
('Täna on andmebaasi tund', '2025-03-12', 1),
('See on Lomonosov andmebaas', '2025-03-12', 2);

select * from uudised

--alias nimede kassutamine
Select u.uudisPealkiri, u.kirjeldus from uudised as u
-- u. - alias nimi uudised tabelile

--2 tabeli põhilised laused
SELECT * FROM uudised, ajakirjanik --ei ole õige päring
--uudiste tabeli kirjed korrutakse teise tabeli kirjaga

--õige päring
SELECT * FROM uudised, ajakirjanik
WHERE uudised.ajakirjanikID = ajakirjanik.ajakirjanikID;

--sama päring alias nimedega
SELECT * FROM uudised as u, ajakirjanik as a
WHERE u.ajakirjanikID = a.ajakirjanikID;

--lihtsusame päringu
SELECT u.uudisPealkiri as uudis, a.nimi as autor
FROM uudised as u, ajakirjanik as a
WHERE u.ajakirjanikID=a.ajakirjanikID;

--lõikepilt tulemusest

-- INNER JOIN - sisemine ühendamine
SELECT u.uudisPealkiri as uudis, a.nimi as autor
FROM uudised as u INNER JOIN ajakirjanik as a
ON u.ajakirjanikID=a.ajakirjanikID;

-- LEFT JOIN - vasak väline ühendus
SELECT a.nimi as a, u.uudisPealkiri as uudis
FROM ajakirjanik as a LEFT JOIN uudised as u
ON u.ajakirjanikID=a.ajakirjanikID;

-- RIGHT JOIN - parem väline ühendus
SELECT a.nimi as a, u.uudisPealkiri as uudis
FROM ajakirjanik as a RIGHT JOIN uudised as u
ON u.ajakirjanikID=a.ajakirjanikID;

-- CROSS JOIN - parem väline ühendus
SELECT a.nimi as a, u.uudisPealkiri as uudis
FROM ajakirjanik as a CROSS JOIN uudised as u

CREATE TABLE ajaleht(
ajalehtID int PRIMARY KEY identity(1,1),
ajalehtNimetus varchar(50),
 );

INSERT ajaleht(ajalehtNimetus)
VALUES('Postimees'),('DELFI')
;

ALTER TABLE uudised ADD ajalehtID int;

ALTER TABLE uudised ADD CONSTRAINT fk_ajaleht
FOREIGN KEY (ajalehtID) REFERENCES ajaleht(ajalehtID);

UPDATE uudised SET ajalehtID = 2;

SELECT * FROM ajaleht;
SELECT * FROM ajakirjanik;

SELECT u.uudisPealkiri as uudis, a.nimi as autor, aj.ajalehtNimetus
FROM uudised as u, ajakirjanik as a, ajaleht as aj
WHERE u.ajakirjanikID=a.ajakirjanikID
AND u.ajakirjanikID = aj.ajalehtID;

--sama INER JOINiga
SELECT u.uudisPealkiri as uudis, a.nimi as autor
FROM (uudised as u INNER JOIN ajakirjanik as a
ON u.ajakirjanikID=a.ajakirjanikID)
INNER JOIN ajaleht as aj
ON u.ajakirjanikID = aj.ajalehtID;

--enesetestid...
