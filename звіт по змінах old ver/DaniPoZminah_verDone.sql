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