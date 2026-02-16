-- DaniPoZminah_verDone

SELECT 
	DATEADD(YEAR, -2000, reg._Period) AS Дата,

	reg._Fld20665RRef AS Лінія_SPRpodrazdelenie,
	reg._Fld20666RRef AS Найменування_SPRnomenklatura,

	reg._Fld20674 * 1.0 
	/ NULLIF(DATEDIFF(MINUTE, doc._Fld23192, doc._Fld23193), 0) 
	AS ФактШтХв,

	rizy._Fld25445 AS КількістьРізів,

	CAST(DATEDIFF(MINUTE, doc._Fld23192, doc._Fld23193)/60 AS VARCHAR(10)) + ':' 
	+ RIGHT('0' + CAST(DATEDIFF(MINUTE, doc._Fld23192, doc._Fld23193)%60 AS VARCHAR(2)),2) 
	AS РобочийЧас,

	CAST(DATEDIFF(MINUTE, remont._Fld24655, remont._Fld24656)/60 AS VARCHAR(10)) + ':' 
	+ RIGHT('0' + CAST(DATEDIFF(MINUTE, remont._Fld24655, remont._Fld24656)%60 AS VARCHAR(2)),2) 
	AS ЧасРемонту,
	
	CAST(DATEDIFF(MINUTE, prostoi._Fld25199, prostoi._Fld25200)/60 AS VARCHAR(10)) + ':' 
	+ RIGHT('0' + CAST(DATEDIFF(MINUTE, prostoi._Fld25199, prostoi._Fld25200)%60 AS VARCHAR(2)),2) 
	AS ЧасПростою

FROM _Document426 doc

LEFT JOIN _AccumRg20664 reg
    ON reg._RecorderRRef = doc._IDRRef


LEFT JOIN _InfoRg25440 rizy
    ON reg._RecorderRRef = rizy._RecorderRRef 

LEFT JOIN _InfoRg24651 remont
    ON reg._RecorderRRef = remont._Fld24657RRef

LEFT JOIN _InfoRg25196 prostoi
    ON reg._RecorderRRef = prostoi._Fld25202RRef


ORDER BY DATEADD(YEAR, -2000, reg._Period) DESC


-- VydZminy_verDone

SELECT
	vydZminy._IDRRef,
	CASE vydZminy._EnumOrder 
		WHEN 1 THEN 'Денна'
		WHEN 0 THEN 'Нічна'
	END AS VydZminy
FROM _Enum23693 vydZminy


-- SPRpodrazdelenie_verDone

SELECT 
	podrazdelenie._IDRRef,
	podrazdelenie._Description AS Podrazdelenie
FROM _Reference170 AS podrazdelenie	


-- SPRnomenklatura_verDone

SELECT
	nomenklatura._IDRRef,
	nomenklatura._Description AS Nomenklatura
FROM _Reference151 AS nomenklatura


-- PlanShtukaUHvylynu_verDone

SELECT 
	planShtukaUHvylynu._Fld25310RRef AS SPRnomenklatura,
	planShtukaUHvylynu._Fld24500RRef AS SPRpodrazdelenie,
	planShtukaUHvylynu._Fld24502 AS PlanShtukaUHvylynu
FROM _InfoRg24499 AS planShtukaUHvylynu


-- VidsotokBraku_verDone

SELECT
	RNzatratyNaVypuskProduktsii._RecorderRRef,
	SUM(RNzatratyNaVypuskProduktsii._Fld21062) AS ЗагальнаСума,

	SUM(CASE 
	WHEN SPRstattiZatrat._Description LIKE N'Технологічні%' 
	THEN RNzatratyNaVypuskProduktsii._Fld21062 
	ELSE 0 
	END) AS БракСума,

	CASE 
	WHEN SUM(RNzatratyNaVypuskProduktsii._Fld21062) = 0 THEN 0
	ELSE 
		SUM(CASE 
		WHEN SPRstattiZatrat._Description LIKE N'Технологічні%' 
		THEN RNzatratyNaVypuskProduktsii._Fld21062 
		ELSE 0 
	END) 
	/ SUM(RNzatratyNaVypuskProduktsii._Fld21062) * 100.0
	END	AS ВідсотокБраку
FROM _AccumRg21045 RNzatratyNaVypuskProduktsii

LEFT JOIN _Reference216 SPRstattiZatrat
ON RNzatratyNaVypuskProduktsii._Fld21054RRef = SPRstattiZatrat._IDRRef

GROUP BY RNzatratyNaVypuskProduktsii._RecorderRRef


-- Ispolniteli_verDone

SELECT 
    ispolniteli._Document426_IDRRef,
	COUNT(*) Ispolniteli
FROM _Document426_VT9992 ispolniteli

GROUP BY ispolniteli._Document426_IDRRef