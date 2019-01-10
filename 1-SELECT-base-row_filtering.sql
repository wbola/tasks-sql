--1
SELECT nazwisko,
       (placa+ISNULL(dod_funkc, 0))*12 AS 'placa roczna'
FROM Pracownicy;

--2
SELECT nazwa, DATEDIFF(m,dataRozp,ISNULL(datazakonczfakt,GETDATE())) AS [czas trwania]
FROM Projekty 

--3
SELECT 2/4;
SELECT CAST(2.00/4.00 AS MONEY);

--4
SELECT TOP 1 nazwa,
       dataRozp,
       kierownik
FROM Projekty
ORDER BY dataRozp DESC;

--5
SELECT *
FROM Pracownicy
WHERE stanowisko IN ('adiunkt','doktorant')
      AND placa>1500;

--6
SELECT *
FROM projekty
WHERE nazwa LIKE '%web%';

--7
SELECT *
FROM pracownicy
WHERE szef IS NULL;