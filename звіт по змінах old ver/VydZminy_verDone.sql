SELECT
	vydZminy._IDRRef,
	CASE vydZminy._EnumOrder 
		WHEN 1 THEN 'Денна'
		WHEN 0 THEN 'Нічна'
	END AS VydZminy
FROM _Enum23693 vydZminy