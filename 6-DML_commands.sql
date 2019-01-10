--1
SELECT *
INTO   KursyKopia
FROM   Kursy

SELECT *
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME IN ('KursyKopia');

--2
--a
INSERT INTO Uczestnicy
VALUES('95011300465','Bola',DEFAULT, 'werbol@st.amu.edu.pl');
--c
INSERT INTO Udzial
SELECT 12341234123,
       Kod,
      '2017-10-20',
      '2017-10-22',
      'ukonczony'
FROM Kursy
WHERE nazwa = 'Analiza danych';

--3
--a
UPDATE Kursy
SET    liczba_dni = liczba_dni + 1
WHERE  nazwa LIKE '%SQL%';
--b
ALTER TABLE Uczestnicy
ADD Rok_urodzenia INTEGER;
UPDATE Uczestnicy
SET Rok_urodzenia = CAST(1900 + LEFT(PESEL, 2) AS INTEGER);

--4
UPDATE Tab_A
SET    Tab_A.miasto = Tab_B.forma_poprawna
FROM   Uczestnicy AS Tab_A
       INNER JOIN MapujMiasta AS Tab_B
	           ON Tab_A.miasto = Tab_B.forma_niepoprawna
WHERE  Tab_A.miasto <> Tab_B.forma_poprawna;	
		   
--5
--a
DELETE FROM Uczestnicy
WHERE nazwisko='Jakubowicz'


ALTER TABLE Uczestnicy
ADD CONSTRAINT niepusty nazwisko;

--b
SELECT *
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS			
WHERE TABLE_NAME = 'Udzial'

ALTER TABLE Udzial									
DROP CONSTRAINT fk__udzial__uczestnik		        

ALTER TABLE Udzial									
ADD CONSTRAINT fk_udzial_uczestnik FOREIGN KEY (Uczestnik) REFERENCES Uczestnicy(PESEL) ON DELETE SET NULL			

DELETE FROM Uczestnicy
WHERE nazwisko = 'Jakubowicz'

SELECT * FROM Uczestnicy
SELECT * FROM Udzial	

--c	
SELECT *
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS			
where TABLE_NAME = 'Udzial'

ALTER TABLE Udzial									
DROP CONSTRAINT fk__udzial__uczestnik		        

ALTER TABLE Udzial									
ADD CONSTRAINT fk_udzial_uczestnik FOREIGN KEY (Uczestnik) REFERENCES Uczestnicy(PESEL) ON DELETE CASCADE			

DELETE FROM Uczestnicy
WHERE nazwisko = 'Jakubowicz'

SELECT * FROM Uczestnicy
SELECT * FROM Udzial		

--6
SELECT * FROM UczestnicyAktualnie
SELECT * FROM Uczestnicy


MERGE Uczestnicy
USING UczestnicyAktualnie
ON    (Uczestnicy.PESEL = UczestnicyAktualnie.PESEL)
WHEN MATCHED THEN
      UPDATE 
	  SET   Uczestnicy.nazwisko = UczestnicyAktualnie.nazwisko,
			Uczestnicy.miasto = UczestnicyAktualnie.miasto,
			Uczestnicy.email =   UczestnicyAktualnie.email
WHEN NOT MATCHED THEN
      INSERT (PESEL, nazwisko, miasto, email) -- ew., rok_urodzenia)
      VALUES (UczestnicyAktualnie.PESEL, 
			  UczestnicyAktualnie.nazwisko,
			  UczestnicyAktualnie.miasto,
			  UczestnicyAktualnie.email)
			  --,LEFT(UczestnicyAktualnie.pesel,2)+1900) -- ew
OUTPUT deleted.*, inserted.*;