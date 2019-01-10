--1
SELECT nazwisko
FROM   Pracownicy
WHERE  placa > (SELECT placa
                FROM   Pracownicy 
                WHERE  nazwisko = 'Ró¿ycka')

--2
SELECT nazwisko
FROM   Pracownicy
WHERE  id NOT IN (SELECT kierownik
                  FROM   Projekty)

--3
SELECT nazwisko
FROM   Pracownicy
WHERE  id NOT IN (SELECT idPrac
                  FROM   Realizacje
                  WHERE  idProj = 10)

--4
SELECT nazwisko
FROM   Pracownicy
WHERE  id IN 
(
  SELECT idPrac
  FROM   Realizacje
  WHERE  idProj IN
  ( 
     SELECT id
     FROM   Projekty
     WHERE  nazwa = 'e-learning'
  )
);

--5
SELECT nazwisko
FROM   Pracownicy P
WHERE  P.id IN
(
  SELECT idPrac
  FROM   Realizacje R1
  WHERE  R1.idProj IN
  (
   SELECT idProj
   FROM   Realizacje R2
   WHERE  R2.idPrac = P.szef
  )
);  

--6
SELECT nazwisko,
       placa
FROM   Pracownicy
WHERE  placa >= ALL (SELECT placa
                     FROM   Pracownicy)
           
--7
SELECT P.nazwisko
FROM   Pracownicy P
WHERE  NOT EXISTS (SELECT *
                   FROM   Projekty S
                   WHERE  S.kierownik = P.id)

--8
SELECT nazwisko
FROM   Pracownicy T1
WHERE  NOT EXISTS
(
   SELECT *
   FROM   Projekty T2
   WHERE  NOT EXISTS
   (
    SELECT *
    FROM   Realizacje T3
    WHERE  T3.idPrac = T1.id
           AND T3.idProj = T2.id
   )
);