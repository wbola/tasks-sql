--1
SELECT DISTINCT a.nazwa_asortymentu
FROM   Transakcje T 
       JOIN Klienci K
         ON T.klient = K.id_klienta
       JOIN Asortyment A
         ON A.id_asortymentu = T.asortyment
WHERE  K.imie = 'Abdiasz' 
       AND K.nazwisko = 'Eleryk';

SELECT DISTINCT A.nazwa_asortymentu
FROM   Transakcje T
       JOIN Asortyment A
         ON A.id_asortymentu = T.asortyment
WHERE  T.klient IN (SELECT id_klienta 
                    FROM   Klienci K
                    WHERE  K.imie = 'Abdiasz'
                           AND K.nazwisko = 'Eleryk');
						   
--2
SELECT K.nazwisko, 
       T.data_transakcji
FROM   Transakcje T
       JOIN Klienci K 
         ON T.klient = K.id_klienta
WHERE  T.asortyment = 'EGE';

SELECT A.nazwa_asortymentu, 
       T.data_transakcji
FROM   Transakcje T
       JOIN Asortyment A
         ON T.asortyment = A.id_asortymentu
WHERE  T.klient = 'KoKa16220';

SELECT A.nazwa_asortymentu,
       T.ilosc
FROM   Transakcje T
       JOIN Asortyment A
         ON T.asortyment = A.id_asortymentu
WHERE  T.asortyment = 'EGE';

--3
sp_helpindex Transakcje;
sp_helpindex Asortyment;
sp_helpindex Klienci; -- za³o¿ony indeks

--4
ALTER TABLE Transakcje_IDX
ALTER COLUMN id_transakcji VARCHAR(13) NOT NULL
GO
ALTER TABLE Transakcje_IDX
ADD CONSTRAINT pk_trans PRIMARY KEY nonclustered (id_transakcji);
sp_helpindex Transakcje_IDX;

--5
CREATE CLUSTERED INDEX c_idx_col
ON     Transakcje_IDX (data_transakcji);

SELECT top 100 * FROM Transakcje
SELECT top 100 * FROM Transakcje_IDX

--execution plan
SELECT *
FROM   Transakcje
WHERE  data_transakcji = '2014-03-16';

SELECT *
FROM   Transakcje_IDX
WHERE  data_transakcji = '2014-03-16';

--6
CREATE INDEX idx_pokrywajacy
ON     Klienci_IDX (wojewodztwo)
	   INCLUDE (imie, nazwisko);

SELECT imie,
       nazwisko
FROM   Klienci
WHERE  wojewodztwo = 'zachodniopomorskie';

SELECT imie,
       nazwisko 
FROM   Klienci_IDX
WHERE  wojewodztwo = 'zachodniopomorskie';