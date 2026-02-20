;WITH planVidhar_SvoistwaOb AS (

    SELECT

        planVidhar_SvoistwaOb._IDRRef AS ID,
        planVidhar_SvoistwaOb._Code AS Code,
        planVidhar_SvoistwaOb._Description AS NameN,
        planVidhar_SvoistwaOb._Marked AS ПоміткаВидалення,
        
        planVidhar_SvoistwaOb._Fld22859RRef AS Призначення

    FROM _Chrc1016 AS planVidhar_SvoistwaOb

)

SELECT * FROM planVidhar_SvoistwaOb