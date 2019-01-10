--1
SELECT AVG(c.placa),
       COUNT(*)
FROM   Projekty a
       JOIN Realizacje b ON a.id = b.idProj
       JOIN Pracownicy c ON b.idPrac = c.id
WHERE a.nazwa = 'e-learning';

--2
SELECT nazwisko,
       placa
FROM   Pracownicy
WHERE  placa =
(
  SELECT MAX(placa)
  FROM   Pracownicy
);

--3
SELECT stanowisko,
       nazwisko,
       placa
FROM   Pracownicy a
WHERE  placa =
(
  SELECT MAX(placa)
  FROM   Pracownicy
  WHERE  stanowisko = a.stanowisko
); 

--4
SELECT szef,
       MIN(placa) AS minimum,
       MAX(placa) AS maximum
FROM   Pracownicy
WHERE  szef IS NOT NULL
GROUP BY szef;

--5
SELECT nazwisko,
       COUNT(DISTINCT idProj) AS licz_proj
FROM   Pracownicy a
       JOIN Realizacje b ON a.id = b.idPrac
WHERE  a.stanowisko <> 'profesor'
GROUP BY nazwisko
HAVING COUNT(DISTINCT idProj) > 1; 

--6
SELECT nazwisko,
       COUNT(*) AS liczba
FROM   Pracownicy
GROUP BY nazwisko
HAVING  COUNT(*) > 1;

--7
SELECT nazwa,
       dataZakonczPlan AS DataZakonczenia,
       'projekt trwa' AS Status
FROM   Projekty
WHERE  dataZakonczFakt IS NULL
UNION ALL
SELECT nazwa,
       dataZakonczFakt AS DataZakonczenia,
       'projekt zakonczony' AS Status
FROM   Projekty
WHERE  dataZakonczFakt IS NOT NULL;

--8
SELECT nazwisko
FROM   Pracownicy
EXCEPT
SELECT p1.nazwisko
FROM   Pracownicy p1
       JOIN Projekty p2 ON p1.id=p2.kierownik;

--9
SELECT nazwisko,
       CAST(100 * CAST(placa AS REAL) /
(
  SELECT AVG(placa)
  FROM   Pracownicy
) AS NUMERIC(10, 2)) AS 'procent sredniej'
FROM   Pracownicy;

--10
SELECT nazwisko,
       placa
FROM   Pracownicy A
WHERE 
( 
   SELECT COUNT(*)
   FROM   Pracownicy
   WHERE  placa > a.placa
) <3; 

--11
SELECT a.nazwisko,
       SUM(b.godzin*stawka*DATEDIFF(week, dataRozp, ISNULL(dataZakonczFakt, '2018-03-15'))) AS zarobki
FROM   Pracownicy a
       JOIN Realizacje b ON a.id = b.idPrac
       JOIN Projekty c ON b.idProj = c.id
GROUP BY a.nazwisko
ORDER BY zarobki DESC;

--12
--z TOP
SELECT TOP 1 p1.nazwisko,
             COUNT(DISTINCT p2.idProj) AS 'licz projektow'
FROM   Pracownicy p1
       JOIN Realizacje p2 ON p1.id = p2.idPrac
GROUP BY p1.nazwisko
ORDER BY 'licz projektow';
--bez TOP
SELECT *
FROM
(
  SELECT nazwisko,
         COUNT(DISTINCT idProj) AS [licz projektow]
  FROM   Pracownicy a
         JOIN Realizacje b ON a.id = b.idPrac
  GROUP BY nazwisko
) t
WHERE [licz projektow] >= ALL
(
  SELECT COUNT(DISTINCT idProj) AS [licz projektow]
  FROM Pracownicy a
       JOIN Realizacje b ON a.id = b.idPrac
  GROUP BY nazwisko
);