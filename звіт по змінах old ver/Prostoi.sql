SELECT
	prostoi._Fld25202RRef,
	CAST(DATEDIFF(MINUTE, prostoi._Fld25199, prostoi._Fld25200)/60 AS VARCHAR(10)) + ':' 
	+ RIGHT('0' + CAST(DATEDIFF(MINUTE, prostoi._Fld25199, prostoi._Fld25200)%60 AS VARCHAR(2)),2) 
	AS ЧасПростою
FROM _InfoRg25196 prostoi