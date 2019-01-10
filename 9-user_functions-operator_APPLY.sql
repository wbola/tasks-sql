--1
CREATE FUNCTION ufn_licz_lata
(
	@data DATE
)
	RETURNS INTEGER
AS
BEGIN
	RETURN DATEDIFF(YEAR, @data, GETDATE())
END;
GO

SELECT dbo.ufn_licz_lata('2015-05-06')

SELECT nazwisko, dbo.ufn_licz_lata(zatrudniony) AS czas_zatrudnienia
FROM Pracownicy

--2
CREATE FUNCTION ufn_staz_pracy
(
	@s INT
)
	RETURNS TABLE
AS
	RETURN SELECT nazwisko
		   FROM Pracownicy
		   WHERE dbo.ufn_licz_lata(zatrudniony) > @s;
GO

SELECT *
FROM dbo.ufn_staz_pracy(20); 

--3
CREATE FUNCTION ufn_dziel_zdanie
(
	@zdanie VARCHAR(200),
	@separator CHAR(1)
)
	RETURNS @tabelaWyrazow TABLE(kurs VARCHAR(50))
AS
BEGIN
	DECLARE @pozycja INT;
	WHILE @zdanie <> ''
	BEGIN
		SET @pozycja = (SELECT CHARINDEX(@separator, @zdanie));
		IF @pozycja = 0
		BEGIN
			INSERT INTO @tabelaWyrazow
			SELECT @zdanie;
			BREAK;
		END;
		IF @pozycja > 1
		BEGIN
			INSERT INTO @tabelaWyrazow
			SELECT LEFT(@zdanie, @pozycja-1);
		END;
		SET @zdanie = (SELECT RIGHT(@zdanie, LEN(@zdanie)-@pozycja));
	END
	RETURN;
END
GO

CREATE TABLE Szkolenia_Nieznormalizowane
(
    PESEL_uczestnika  CHAR(11),
    kursy             VARCHAR(1000)
);

INSERT INTO Szkolenia_Nieznormalizowane (PESEL_uczestnika, kursy) VALUES
(78020806063, 'Programowanie VBA w Accessie,MySQL dla programistów'),
(88021816060, 'Analiza danych,Programowanie VBA w Accessie,MS Access (zaawansowany)'),
(81120811163, 'MySQL dla programistów'),
(80120811199, 'Administracja MySQL,Analiza danych');

CREATE TABLE Szkolenia_Znormalizowane
(
    PESEL_uczestnika  CHAR(11),
    kurs              VARCHAR(100)
);

INSERT INTO Szkolenia_Znormalizowane
SELECT a.PESEL_uczestnika, b.kurs
FROM Szkolenia_Nieznormalizowane a
CROSS APPLY (SELECT *
			 FROM ufn_dziel_zdanie(a.kursy, ',')) b