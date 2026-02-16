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