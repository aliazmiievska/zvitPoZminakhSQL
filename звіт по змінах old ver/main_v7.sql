SELECT 

DATEADD(YEAR, -2000, rnVypuskProd_base.Perio)	AS ƒата_BASE1,

CASE enumVidySmen._EnumOrder 
    WHEN 1 THEN 'Ќ≥чна'
    WHEN 0 THEN 'ƒенна'
END												AS “ип«м≥ни_BASE2,

sprVidyPodrazdel._Description					AS Ћ≥н≥€_BASE3,
sprNomenklatura._Description					AS Ќайменуванн€_BASE4,

rsVremiaIzhotovlenia._Fld24502					AS ѕланЎт’в_BASE5,

CAST(
    ROUND(
        rnVypuskProd_base.Qty * 1.0 
        / NULLIF(DATEDIFF(MINUTE, docOtchetyPoProd._Fld23192, docOtchetyPoProd._Fld23193), 0),
    0)
AS INT)											AS ‘актЎт’в_BASE6,

ISNULL(rsColichRezov.RezCount, 0)				AS  ≥льк≥сть–≥з≥в_BASE7,

CAST(zat.defectProzent AS VARCHAR(20)) + N'%'	AS Ѕрак—ировини¬≥дсоток_BASE8,		

zat.allSum										AS —ировина ≥льк≥сть_BASE,

CAST(DATEDIFF(MINUTE, docOtchetyPoProd._Fld23192, docOtchetyPoProd._Fld23193)/60 AS VARCHAR(10)) + 'год ' 
+ RIGHT(CAST(DATEDIFF(MINUTE, docOtchetyPoProd._Fld23192, docOtchetyPoProd._Fld23193)%60 AS VARCHAR(2)),2) + 'хв'
												AS –обочий„ас_BASE9,

CAST(ISNULL(rsRemonty.RepairMinutes, 0) / 60 AS VARCHAR(10)) + 'год ' 
+ RIGHT(
    '0' + CAST(ISNULL(rsRemonty.RepairMinutes, 0) % 60 AS VARCHAR(2)),
    2
) + 'хв'										AS „ас–емонту_BASE10,

CAST(ISNULL(rsProstoi.DowntimeMinutes, 0) / 60 AS VARCHAR(10)) + 'год ' 
+ RIGHT(
    '0' + CAST(ISNULL(rsProstoi.DowntimeMinutes, 0) % 60 AS VARCHAR(2)),
    2
) + 'хв'
AS „асѕростою_BASE11,

ISNULL(sotr_count.executantsCount, 0)			AS  ≥льк≥сть¬иконавц≥в_BASE12

FROM _Document426 docOtchetyPoProd

--

LEFT JOIN (
    SELECT 
        _RecorderRRef,
        _Fld20665RRef,
        _Fld20666RRef,
        _Fld20667RRef,
		MAX(_Period) AS Perio,
        SUM(_Fld20674) AS Qty
    FROM _AccumRg20664
    GROUP BY 
        _RecorderRRef,
        _Fld20665RRef,
        _Fld20666RRef,
        _Fld20667RRef
) rnVypuskProd_base
    ON rnVypuskProd_base._RecorderRRef = docOtchetyPoProd._IDRRef


LEFT JOIN (
    SELECT 
        _RecorderRRef,
        SUM(_Fld25445) AS RezCount
    FROM _InfoRg25440
    GROUP BY _RecorderRRef
) rsColichRezov
    ON rnVypuskProd_base._RecorderRRef = rsColichRezov._RecorderRRef


-- LEFT JOIN _InfoRg24651 rsRemonty
--    ON rnVypuskProd_base._RecorderRRef = rsRemonty._Fld24657RRef

LEFT JOIN (
    SELECT 
        _Fld24657RRef,
        SUM(DATEDIFF(MINUTE, _Fld24655, _Fld24656)) AS RepairMinutes
    FROM _InfoRg24651
    GROUP BY _Fld24657RRef
) rsRemonty
    ON rnVypuskProd_base._RecorderRRef = rsRemonty._Fld24657RRef

LEFT JOIN (
    SELECT 
        _Fld25202RRef,
        SUM(DATEDIFF(MINUTE, _Fld25199, _Fld25200)) AS DowntimeMinutes
    FROM _InfoRg25196
    GROUP BY _Fld25202RRef
) rsProstoi
    ON rnVypuskProd_base._RecorderRRef = rsProstoi._Fld25202RRef

LEFT JOIN _Reference151 sprNomenklatura
    ON rnVypuskProd_base._Fld20666RRef = sprNomenklatura._IDRRef

LEFT JOIN _Reference170 sprVidyPodrazdel
    ON rnVypuskProd_base._Fld20665RRef = sprVidyPodrazdel._IDRRef

LEFT JOIN _Enum23693 enumVidySmen
    ON docOtchetyPoProd._Fld23714RRef = enumVidySmen._IDRRef

--

LEFT JOIN (
    SELECT
        zatratyNaVyplatu._RecorderRRef,
        SUM(zatratyNaVyplatu._Fld21062) allSum,

        SUM(CASE 
                WHEN stattiZatrat._Description LIKE N'“ехнолог≥чн≥%' 
                THEN zatratyNaVyplatu._Fld21062 
                ELSE 0 
            END) defectSum,

	CAST(
    ROUND(
        CASE 
            WHEN SUM(zatratyNaVyplatu._Fld21062) = 0 THEN 0
            ELSE 
                SUM(CASE 
                        WHEN stattiZatrat._Description LIKE N'“ехнолог≥чн≥%' 
                        THEN zatratyNaVyplatu._Fld21062 
                        ELSE 0 
                    END) * 100.0
                / SUM(zatratyNaVyplatu._Fld21062)
        END
    , 2)
AS DECIMAL(10,2)) defectProzent

    FROM _AccumRg21045 zatratyNaVyplatu

    LEFT JOIN _Reference216 stattiZatrat
        ON zatratyNaVyplatu._Fld21054RRef = stattiZatrat._IDRRef

    GROUP BY zatratyNaVyplatu._RecorderRRef
) zat
    ON rnVypuskProd_base._RecorderRRef = zat._RecorderRRef

LEFT JOIN (
    SELECT 
        s._Document426_IDRRef,
        COUNT(*) executantsCount
    FROM _Document426_VT9992 s
    GROUP BY s._Document426_IDRRef
) sotr_count
    ON docOtchetyPoProd._IDRRef = sotr_count._Document426_IDRRef

LEFT JOIN (
    SELECT *
    FROM (
        SELECT 
            *,
            ROW_NUMBER() OVER (
                PARTITION BY _Fld24500RRef, _Fld25310RRef
                ORDER BY _Period DESC
            ) AS rn
        FROM _InfoRg24499
    ) t
    WHERE rn = 1
) rsVremiaIzhotovlenia
    ON rnVypuskProd_base._Fld20665RRef = rsVremiaIzhotovlenia._Fld24500RRef
   AND rnVypuskProd_base._Fld20667RRef = rsVremiaIzhotovlenia._Fld25310RRef

--

WHERE sprVidyPodrazdel._Description LIKE N'÷ех%'
AND enumVidySmen._EnumOrder IS NOT NULL

ORDER BY DATEADD(YEAR, -2000, rnVypuskProd_base.Perio) DESC