;WITH spr_TechnolHaraktNomen AS (

    SELECT

        spr_TechnolHaraktNomen._IDRRef AS ID,
        spr_TechnolHaraktNomen._Code AS Code,
        spr_TechnolHaraktNomen._Description AS Назва,
        spr_TechnolHaraktNomen._Marked AS ПоміткаВидалення,

        spr_TechnolHaraktNomen._Fld24300 AS Активна,

        ---

        spr_TechnolHaraktNomen_SpisokHarakt._Fld24304RRef AS СвойствоRref,

        spr_TechnolHaraktNomen_SpisokHarakt._Fld24305_TYPE AS ТипЗначення,
        spr_TechnolHaraktNomen_SpisokHarakt._Fld24305_S AS ЗначенняСимвольне,
        spr_TechnolHaraktNomen_SpisokHarakt._Fld24305_N AS ЗначенняЧислове,
        spr_TechnolHaraktNomen_SpisokHarakt._Fld24305_T AS ЗначенняДата,
        spr_TechnolHaraktNomen_SpisokHarakt._Fld24305_L AS ЗначенняЛогічне,
        spr_TechnolHaraktNomen_SpisokHarakt._Fld24305_RRRef AS ЗначенняRref

    FROM _Reference24296 AS spr_TechnolHaraktNomen

    LEFT JOIN _Reference24296_VT24302 AS spr_TechnolHaraktNomen_SpisokHarakt
        ON spr_TechnolHaraktNomen._IDRRef = spr_TechnolHaraktNomen_SpisokHarakt._Reference24296_IDRRef

)

SELECT * FROM spr_TechnolHaraktNomen