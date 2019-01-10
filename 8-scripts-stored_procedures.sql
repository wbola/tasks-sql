--1
DECLARE @zdanie    VARCHAR(1000) = 'Ala ma kota   i psa';
DECLARE @separator CHAR(1)       = ' ';

DECLARE @tabelaWyrazow TABLE(wyrazy VARCHAR(100));

DECLARE @index INT = CHARINDEX(@separator, @zdanie)
WHILE @index > 0
BEGIN
    IF LEN(LEFT(@zdanie, @index - 1)) > 0
    BEGIN
		INSERT INTO @tabelaWyrazow VALUES (LEFT(@zdanie, @index - 1));
    END;
    SET @zdanie = RIGHT(@zdanie, LEN(@zdanie) - @index);
    SET @index = CHARINDEX(@separator, @zdanie);
END
INSERT INTO @tabelaWyrazow VALUES (@zdanie);

SELECT *
FROM   @tabelaWyrazow;

--2
CREATE OR ALTER PROCEDURE usp_podwyzka
	@proc TINYINT = 10,
	@kwota MONEY OUTPUT
AS
	BEGIN
		SET @kwota = (SELECT SUM(placa) FROM Pracownicy);
		UPDATE Pracownicy
		SET placa = (1+@proc/100)*placa
		WHERE id IN (SELECT id FROM Pracownicy WHERE placa<2000);
		SET @kwota = (SELECT SUM(placa) FROM Pracownicy) - @kwota;
	END;
GO

SELECT   *
FROM     Pracownicy
ORDER BY placa;

DECLARE @wynik AS MONEY;

EXEC usp_podwyzka
	 10,
	 @wynik OUTPUT;

SELECT @wynik;

SELECT   *
FROM     Pracownicy
ORDER BY placa;

--3
CREATE OR ALTER PROCEDURE usp_wstaw_pracownika
    @nazwisko VARCHAR(20),
    @stanowisko VARCHAR(20) DEFAULT 'doktorant',
    @szef CHAR(1),
    @placa MONEY,
    @zatrudniony DATETIME = NULL DEFAULT GETDATE()
AS
    --1. Zadeklaruj nowe zmienne @szef_id i @pracownik_id typu INT
    DECLARE @szef_id INT;
    DECLARE @pracownik_id INT;

	--2. Jeśli nazwisko szefa nie jest prawidłowe wywołaj bląd i zakończ procedurę
    IF NOT EXISTS (SELECT nazwisko FROM Pracownicy)
    BEGIN
        RAISERROR(N'Bledne nazwisko szefa: %s', 16, 1);
        RETURN;
    END

	--3. Jeżeli nazwa stanowiska nie jest prawidłowa wywołaj bląd i zakończ procedurę
    IF NOT EXISTS (SELECT stanowisko FROM Pracownicy)
    BEGIN
        RAISERROR(N'Bledna nazwa stanowiska: %s', 16, 1);
        RETURN;
    END;

	--4. Ustal id szefa na podstawie nazwiska
    SET @szef_id = (SELECT id 
                    FROM Pracownicy
                    WHERE  nazwisko = @nazwisko);
    
    --5. Ustal nowe id pracownika. Nowe id jest równe MAX istniejących id + 10
    SET @pracownik_id = (id ISNULL(MAX(id), 0) + 10 
                         FROM Pracownicy);
    
	--6. Jeśli data zatrudnienia nie została podana (jest NULL), pobierz datę dzisiejszą
    IF @Zatrudniony IS NULL 
        SET @Zatrudniony = GETDATE();

    --7. Wstaw nowego pracownika:
    INSERT INTO Pracownicy (id, nazwisko, szef, placa, stanowisko, zatrudniony)
    VALUES (@pracownik_id);
GO

BEGIN TRY
    --EXEC usp_wstaw_pracownika 'Nowak', 'adiunktTT', 'Jankowiak', 2200;
    --EXEC usp_wstaw_pracownika 'Nowak', 'asystent',  'Jankowski', 2200;
    --EXEC usp_wstaw_pracownika 'Nowak', 'adiunkt',   'Jankowski', 2200;
    --EXEC usp_wstaw_pracownika 'Nowak', DEFAULT,     'Jankowski', 2200;
    --EXEC usp_wstaw_pracownika @nazwisko = 'Nowak', @szef = 'Jankowski', @placa = 2200, @zatrudniony = '2018-01-01';

    SELECT * 
    FROM   Pracownicy;

    DELETE FROM Pracownicy 
    WHERE  nazwisko = 'Nowak';
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER()  AS ErrorNumber, 
           ERROR_MESSAGE() AS ErrorMessage;
END CATCH;