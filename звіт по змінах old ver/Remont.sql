SELECT
	remont._Fld24657RRef,
	CAST(DATEDIFF(MINUTE, remont._Fld24655, remont._Fld24656)/60 AS VARCHAR(10)) + ':' 
	+ RIGHT('0' + CAST(DATEDIFF(MINUTE, remont._Fld24655, remont._Fld24656)%60 AS VARCHAR(2)),2) 
	AS „ас–емонту
FROM _InfoRg24651 remont