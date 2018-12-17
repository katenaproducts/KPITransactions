SELECT DISTINCT CAST(ISNULL(i.ITEM,'Unknown') AS VARCHAR)	AS ItemCode,
			    CAST(ISNULL(i.DESCRIPTION,'Unknown') AS VARCHAR)	AS ItemName,
				CAST(ISNULL(i.PRODUCT_CODE,'Unknown') AS VARCHAR)	AS ProductCode,
				CAST(ISNULL(i.FAMILY_CODE,'Unknown') AS VARCHAR)	AS FamilyCode,
				CAST(ISNULL(f.description,'Unknown') AS VARCHAR)	AS FamilyName,
				CAST(i.avg_u_cost AS DECIMAL(18,4))					AS AverageUnitCost,
				CAST(ISNULL(i.UF_GTIN,'Unknown') AS VARCHAR)		AS GTIN,
				i.UF_itm_DatetoMarket								AS DateToMarket,
				i.UF_Itm_TravelerID									AS TravelerID,
				CASE(i.UF_Itm_CEMArked)
				WHEN 0 THEN 'No'
				ELSE 'Yes'
				END													AS CEMarked
FROM			ITEM_MST i
LEFT JOIN		famcode_mst f		ON i.family_code = f.family_code