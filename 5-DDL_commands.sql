--1
--A) 
CREATE TABLE Uczestnicy
(
    PESEL VARCHAR(11) NOT NULL CONSTRAINT pk_uczest_PESEL PRIMARY KEY, --pk -> primary key
    nazwisko VARCHAR(30) NOT NULL CONSTRAINT ck_uczest_nazw CHECK (nazwisko LIKE '[A-Z]%'),
    miasto VARCHAR(30) CONSTRAINT ck_uczest_miast CHECK (miasto LIKE '[A-Z]%') DEFAULT 'Poznañ',
);

--lub
CREATE TABLE Uczestnicy
(
    PESEL INT NOT NULL CONSTRAINT pk_uczest_PESEL PRIMARY KEY, --pk -> primary key
    nazwisko VARCHAR(30) NOT NULL CONSTRAINT ck_uczest_nazw CHECK (nazwisko LIKE '[A-Z]%'),
    miasto VARCHAR(30) CONSTRAINT ck_uczest_miast CHECK (miasto LIKE '[A-Z]%') DEFAULT 'Poznañ',
);

--lub
CREATE TABLE Uczestnicy
(
	PESEL CHAR(11) PRIMARY KEY,
	nazwisko VARCHAR(200) NOT NULL,
	miasto VARCHAR(100) DEFAULT 'Poznañ'
)

--B)
CREATE TABLE Kursy
(
    Kod INT IDENTITY(1,1) PRIMARY KEY,
    nazwa VARCHAR(30) UNIQUE,
    liczba_dni INT CHECK (liczba_dni BETWEEN 1 AND 5),
    cena AS (liczba_dni * 1000)
); 

--lub
CREATE TABLE Kursy
(
	Kod INT PRIMARY KEY IDENTITY(1,1),
	nazwa VARCHAR(100) UNIQUE NOT NULL,
	liczba_dni TINYINT CHECK (liczba_dni BETWEEN 1 AND 5),
	cena AS liczba_dni * 1000
)

--C)
CREATE TABLE Udzial
(
    uczestnik INT FOREIGN KEY REFERENCES Uczestnicy(Pesel),
    kurs INT FOREIGN KEY REFERENCES Kursy(Kod),
    data_od DATE,
    data_do DATE,
    status VARCHAR(15) CHECK (status IN ('w trakcie', 'ukonczony', 'nieukonczony')),
    CONSTRAINT kolejnosc_dat CHECK (data_od<data_do)
);

--lub
CREATE TABLE Udzial
(
    uczestnik VARCHAR(11) FOREIGN KEY REFERENCES Uczestnicy(Pesel),
    kurs INT FOREIGN KEY REFERENCES Kursy(Kod),
    data_od DATE,
    data_do DATE,
    status VARCHAR(15) CHECK (status IN ('w trakcie', 'ukonczony', 'nieukonczony')),
    CONSTRAINT kolejnosc_dat CHECK (data_od<data_do)
);

--2
--A
ALTER TABLE Uczestnicy
ADD e-mail VARCHAR(50);
--B
ALTER TABLE Uczestnicy
ADD CONSTRAINT pesel_ok CHECK (PESEL NOT LIKE '&[^0-9]&' AND LEN(PESEL)=11);
--C
ALTER TABLE Udzial
ADD CONSTRAINT trojka PRIMARY KEY(uczestnik, kurs, data_od)
--D
ALTER TABLE Kursy
DROP CONSTRAINT ck_kursy_licz; 
--E
ALTER TABLE Kursy
ADD Kod_2

--3
DROP TABLE Udzial
DROP TABLE Kursy
DROP TABLE Uczestnicy