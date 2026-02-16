SELECT

    -- BAZA (nonduplicatable)
    DATEADD(YEAR, -2000, docOtchetyPoProd._Date_Time) AS BASE1_DATE,
    docOtchetyPoProd._IDRRef BAZA,
    docOtchetyPoProd._Number DocNUMBER,
	docOtchetyPoProd._Posted Posted
    

    
FROM _Document426 docOtchetyPoProd



ORDER BY docOtchetyPoProd._Date_Time