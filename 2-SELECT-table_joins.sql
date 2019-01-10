--1
SELECT nazwisko,
       placa,
       stanowisko,
       placa_min,
       placa_max
FROM   Pracownicy A
       INNER JOIN Stanowiska B 
	           ON A.stanowisko = B.nazwa;
			   
--2
SELECT nazwisko,
       placa,
       stanowisko,
       placa_min,
       placa_max
FROM   Pracownicy A
       INNER JOIN Stanowiska B ON A.stanowisko = B.nazwa
                               WHERE A.stanowisko='doktorant'
                                     AND (a.placa < b.placa_min 
                                          OR a.placa > b.placa_max);

--3
SELECT P1.nazwisko,
       P3.nazwa
FROM   Pracownicy P1
       INNER JOIN Realizacje P2 ON P1.id = P2.idPrac
       INNER JOIN Projekty P3 ON P2.idProj = P3.id
ORDER BY P1.nazwisko;

--4
SELECT A.nazwisko AS pracownik,
       B.nazwisko AS szef
FROM   Pracownicy A
       JOIN Pracownicy B 
	     ON A.szef = B.id;

--5
SELECT T1.nazwisko, 
       T2.nazwisko
FROM   Pracownicy T1 
       JOIN Pracownicy T2
         ON T1.nazwisko=T2.nazwisko AND T1.id<>T2.id; 
				
--6
SELECT T1.nazwisko, 
       T2.nazwisko
FROM   Pracownicy T1
       LEFT OUTER JOIN Pracownicy T2
                    ON T1.szef=T2.id;

--7
SELECT T1.nazwisko
FROM   Pracownicy T1
       LEFT OUTER JOIN Projekty T2
                    ON T2.kierownik=T1.id
WHERE T2.nazwa IS NULL;

--8
SELECT P.nazwisko
FROM   Pracownicy P
       LEFT OUTER JOIN Realizacje R
                    ON P.id = R.idPrac
                       AND R.idProj = '10'
WHERE  R.idProj IS NULL;

SELECT nazwisko
FROM Pracownicy
WHERE id NOT IN (SELECT idPrac
				 FROM Realizacje
				 WHERE idProj = 10
				);

--10
SELECT DISTINCT P1.nazwisko, 
                P1.placa
FROM   Pracownicy P1
       LEFT OUTER JOIN Pracownicy P2
	                ON P2.placa > P1.placa 
					   AND P2.placa IS NOT NULL
WHERE  P2.placa IS NULL
--lub
SELECT DISTINCT nazwisko, placa 
FROM Pracownicy 
WHERE placa NOT IN (SELECT P1.placa 
					FROM Pracownicy AS P1 
						 JOIN Pracownicy AS P2 
						   ON P1.placa < P2.placa
					)
--lub
SELECT nazwisko, placa 
FROM Pracownicy 
WHERE placa NOT IN (SELECT P1.placa 
					FROM Pracownicy AS P1, Pracownicy AS P2
					WHERE P1.placa < P2.placa
					)