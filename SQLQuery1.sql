create database lomonosovTAR1
use lomonosovTAR1

--tabeli loomine
create table tootaja(
tootajaID int Primary key identity(1,1),
eesnimi varchar(30),
perenimi varchar(30),
synniaeg date,
koormus decimal(5,2),
elukoht text,
abielus bit
)
--tabeli kutsutamine
drop table tootaja

--tabeli kuvamine
select * from tootaja

--tabeli andmete lisamine
insert into tootaja(eesnimi, perenimi, synniaeg)
values('Kiril','Gringo','2005-7-25'),
('Martin','Gringo','1989-3-24'),
('Artjom','Gringo','2024-07-30')