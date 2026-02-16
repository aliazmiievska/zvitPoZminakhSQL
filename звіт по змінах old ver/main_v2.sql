SELECT 
DATEADD(YEAR, -2000, reg._Period) AS [Дата],

CASE smen._EnumOrder 
    WHEN 1 THEN 'Нічна'
    WHEN 0 THEN 'Денна'
END AS [Тип зміни],

podr._Description AS [Лінія],
nom._Description AS [Найменування],

planchas._Fld24502 ПланЧас,

CAST(
    ROUND(
        reg._Fld20674 * 1.0 
        / NULLIF(DATEDIFF(MINUTE, doc._Fld23192, doc._Fld23193), 0),
    0)
AS INT) AS [Факт шт/хв],

rizy._Fld25445 AS [Кількість різів],

-- ДАНІ З ДРУГОГО ЗАПИТУ
CAST(zat.ПроцентТехнологічних AS VARCHAR(20)) + N'%' 
AS БракСировиниВідсоток,

zat.ОбщаяСумма AS СировинаКількість,

CAST(DATEDIFF(MINUTE, doc._Fld23192, doc._Fld23193)/60 AS VARCHAR(10)) + 'год ' 
+ RIGHT(CAST(DATEDIFF(MINUTE, doc._Fld23192, doc._Fld23193)%60 AS VARCHAR(2)),2) + 'хв'
AS [Робочий час],

CAST(DATEDIFF(MINUTE, rem._Fld24655, rem._Fld24656)/60 AS VARCHAR(10)) + 'год ' 
+ RIGHT(CAST(DATEDIFF(MINUTE, rem._Fld24655, rem._Fld24656)%60 AS VARCHAR(2)),2) + 'хв'
AS [Час Ремонту],

CAST(DATEDIFF(MINUTE, prost._Fld25199, prost._Fld25200)/60 AS VARCHAR(10)) + 'год ' 
+ RIGHT(CAST(DATEDIFF(MINUTE, prost._Fld25199, prost._Fld25200)%60 AS VARCHAR(2)),2) + 'хв'
AS [Час Простою],

ISNULL(sotr_count.КількістьПрацівників, 0) AS [Кількість виконавців]

FROM _Document426 doc

LEFT JOIN _AccumRg20664 reg
    ON reg._RecorderRRef = doc._IDRRef

LEFT JOIN _InfoRg25440 rizy
    ON reg._RecorderRRef = rizy._RecorderRRef 

LEFT JOIN _InfoRg24651 rem
    ON reg._RecorderRRef = rem._Fld24657RRef

LEFT JOIN _InfoRg25196 prost
    ON reg._RecorderRRef = prost._Fld25202RRef

LEFT JOIN _Reference151 nom
    ON reg._Fld20666RRef = nom._IDRRef

LEFT JOIN _Reference170 podr
    ON reg._Fld20665RRef = podr._IDRRef

LEFT JOIN _Enum23693 smen
    ON doc._Fld23714RRef = smen._IDRRef

-- АГРЕГОВАНИЙ ЗАПИТ
LEFT JOIN (
    SELECT
        zatnavyp._RecorderRRef,
        SUM(zatnavyp._Fld21062) AS ОбщаяСумма,

        SUM(CASE 
                WHEN statizat._Description LIKE N'Технологічні%' 
                THEN zatnavyp._Fld21062 
                ELSE 0 
            END) AS ТехнологічніСума,

	CAST(
    ROUND(
        CASE 
            WHEN SUM(zatnavyp._Fld21062) = 0 THEN 0
            ELSE 
                SUM(CASE 
                        WHEN statizat._Description LIKE N'Технологічні%' 
                        THEN zatnavyp._Fld21062 
                        ELSE 0 
                    END) * 100.0
                / SUM(zatnavyp._Fld21062)
        END
    , 2)
AS DECIMAL(10,2)) AS ПроцентТехнологічних

    FROM _AccumRg21045 zatnavyp

    LEFT JOIN _Reference216 statizat
        ON zatnavyp._Fld21054RRef = statizat._IDRRef

    GROUP BY zatnavyp._RecorderRRef
) zat
    ON reg._RecorderRRef = zat._RecorderRRef

LEFT JOIN (
    SELECT 
        s._Document426_IDRRef,
        COUNT(*) AS КількістьПрацівників
    FROM _Document426_VT9992 s
    GROUP BY s._Document426_IDRRef
) sotr_count
    ON doc._IDRRef = sotr_count._Document426_IDRRef

LEFT JOIN _InfoRg24499 AS planchas
	ON reg._Fld20665RRef = planchas._Fld24500RRef
	AND reg._Fld20667RRef = planchas._Fld25310RRef

WHERE podr._Description LIKE N'Цех%'
AND smen._EnumOrder IS NOT NULL

ORDER BY DATEADD(YEAR, -2000, reg._Period) DESC