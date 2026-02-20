;WITH regSv_ZnachSvoistvOb AS (

    SELECT

        regSv_ZnachSvoistvOb._SimpleKey AS ID,
        regSv_ZnachSvoistvOb._Fld17698_RRRef AS Обьект,
        regSv_ZnachSvoistvOb._Fld17699RRef AS Свойство,
        regSv_ZnachSvoistvOb._Fld17700_RRRef AS Значення

        -- тут будуть FK поля

    FROM _InfoRg17697 AS regSv_ZnachSvoistvOb

)

SELECT * FROM regSv_ZnachSvoistvOb