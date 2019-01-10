--1
CREATE VIEW AktualneProjekty(nazwa, kierownik, licz_pracownikow)
AS
(
    SELECT A.nazwa, B.nazwisko, COUNT(DISTINCT C.idPrac)
    FROM   Projekty A JOIN Pracownicy B ON A.kierownik=B.id LEFT JOIN Realizacje C ON A.id=C.idProj
    WHERE  dataZakonczFakt IS NULL
    GROUP BY A.nazwa, B.nazwisko
) 

SELECT nazwa, licz_pracownikow
FROM   AktualneProjekty
WHERE  licz_pracownikow = (
                            SELECT MAX(licz_pracownikow) FROM AktualneProjekty
                          )

--3
SELECT id_nauczyciela
INTO #Nauczyciele_do_usuniecia
FROM Nauczyciele
WHERE Nazwisko = 'Nowak';

DELETE FROM Nauczyciele
WHERE id_nauczyciela IN (
                          SELECT id_nauczyciela FROM #Nauczyciele_do_usuniecia
                        ); 

--4
DECLARE @NauczycielePoZwolnieniach TABLE
(
    id_nauczyciela INTEGER,
    imie VARCHAR(30),
    nazwisko VARCHAR(30),
    zarobek FLOAT
);

INSERT INTO @NauczycielePoZwolnieniach
SELECT id_nauczyciela, imie, nazwisko, zarobek
FROM Nauczyciele;

UPDATE @NauczycielePoZwolnieniach
SET zarobek*=1.1;

SELECT *
FROM @NauczycielePoZwolnieniach;

--5
WITH CTE_Podwladni(nazwisko, id, poziom)
AS
(
    SELECT nazwisko,             
           id,                    
           1
    FROM   Pracownicy 
    WHERE  szef = (SELECT id FROM Pracownicy WHERE nazwisko='Mielcarz')

    UNION ALL                     

    SELECT P.nazwisko,           
           P.id, 
           T.poziom + 1
    FROM   Pracownicy P 
           JOIN CTE_Podwladni T 
             ON P.szef = T.id
)
SELECT  nazwisko,
        id, 
        poziom
FROM    CTE_Podwladni;

--6
WITH CTE_Prze³o¿eni(nazwisko, szef, poziom)
AS
(
    SELECT nazwisko,             
           szef,                  
           0
    FROM   Pracownicy 
    WHERE  nazwisko='Andrzejewicz'

    UNION ALL                    

    SELECT P.nazwisko,           
           P.szef, 
           T.poziom + 1
    FROM   Pracownicy P 
           JOIN CTE_Prze³o¿eni T 
             ON P.id = T.szef
)
SELECT  nazwisko,
        szef, 
        poziom
FROM    CTE_Prze³o¿eni
WHERE   nazwisko <> 'Anrzejewicz';