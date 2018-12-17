/**
select *
from inv_item_mst
where disc <>0

**/
SELECT CAST(ISNULL(NULLIF(LTRIM(RTRIM(INV_ITEM.INV_NUM)),''),'')	AS VARCHAR)				AS InvoiceNumber,
	   CAST(ISNULL(NULLIF(LTRIM(RTRIM(INV_ITEM.CO_Line)),''),'')	AS VARCHAR)				AS InvoiceLineNumber,
	   CAST(dmDate.DateKey AS INT)															AS DateKey,
	   CAST(dmTime.TimeKey AS INT)															AS TimeKey,	   
	   CAST(dmProduct.ItemKey AS INT)														AS ItemKey,
	   CAST(dmSales.SalesPersonKey	AS INT)													AS SalesPersonKey,
	   CAST(dmCustomer.CustomerKey  AS INT)													AS CustomerKey,
       CAST(INV_ITEM.COST	   AS DECIMAL(18,4))											AS COST,
	   CAST(INV_ITEM.PRICE	   AS DECIMAL(18,4))											AS PRICE,
	   CAST(INV_ITEM.PRICE-INV_ITEM.COST	   AS DECIMAL(18,4))
																							AS MARGIN,
	   CAST(INV_ITEM.DISC      AS DECIMAL(18,4))											AS DISCOUNT,
	   CAST(INV_ITEM.QTY_INVOICED	   AS DECIMAL(18,4))									AS QUANTITY,
	   CASE CAST(INV_ITEM.PRICE	   AS DECIMAL(18,4)) 
	   WHEN 0.0000 THEN
			CAST(INV_ITEM.QTY_INVOICED	   AS DECIMAL(18,4)) *
		(CAST(INV_ITEM.COST	   AS DECIMAL(18,4)) - CAST(INV_ITEM.DISC	   AS DECIMAL(18,4)))
	   ELSE
		 CAST(INV_ITEM.QTY_INVOICED	   AS DECIMAL(18,4)) *
		(CAST(INV_ITEM.PRICE	   AS DECIMAL(18,4)) - CAST(INV_ITEM.DISC	   AS DECIMAL(18,4)))
	   END
	   																						 AS AMOUNT,
	   CASE 
	   WHEN CAST((INV_ITEM.PRICE-INV_ITEM.COST) AS DECIMAL(18,4)) < 0 THEN
			CASE 
			WHEN INV_ITEM.QTY_INVOICED < 0 THEN
			CAST((INV_ITEM.PRICE-INV_ITEM.COST)*-1*INV_ITEM.QTY_INVOICED AS DECIMAL(18,4)) 
			ELSE
			CAST((INV_ITEM.PRICE-INV_ITEM.COST)*INV_ITEM.QTY_INVOICED AS DECIMAL(18,4)) 
			END
		ELSE
		CAST((INV_ITEM.PRICE-INV_ITEM.COST)*INV_ITEM.QTY_INVOICED AS DECIMAL(18,4)) 
		END																							AS MARGINAMOUNT
																	  
FROM				dbo.INV_ITEM_MST INV_ITEM
INNER JOIN			dbo.INV_HDR_MST  INV					ON			INV.INV_NUM  = INV_ITEM.INV_NUM
INNER JOIN			dbo.CustAddr_Mst  ca					ON			INV.CUST_NUM = ca.CUST_NUM
															AND			INV.cust_seq = ca.CUST_SEQ
INNER JOIN		    KPIDW.dbo.DimDate dmDate			ON			dmDate.DateKey = YEAR(inv.inv_date)  * 10000 +
																				 MONTH(inv.inv_date) * 100 +
																				 DAY(inv.inv_date)
INNER JOIN		    KPIDW.dbo.DimTime dmTime			ON			dmTime.[Time] = CONVERT(VARCHAR,inv.CreateDate,108)
INNER JOIN		    KPIDW.dbo.DimSalesPerson  dmSales       ON		dmSales.SalesPersonCode =  ISNULL(NULLIF(INV.slsman,''),'000000')
INNER JOIN		    KPIDW.dbo.DimCustomer     dmCustomer    ON		dmCustomer.CustomerNumber = LTRIM(RTRIM(INV.CUST_NUM))
INNER JOIN			dbo.ITEM_MST     ITM					ON			INV_ITEM.ITEM= ITM.ITEM
INNER JOIN		    KPIDW.dbo.DimItem	      dmProduct     ON		dmProduct.ItemCode   = INV_ITEM.item
INNER JOIN			dbo.coitem_mst					 dmCustOrd		ON	dmCustOrd.co_num = INV_ITEM.co_num
																	AND dmCustOrd.co_line = INV_ITEM.co_line
																	AND dmCustOrd.cust_seq = dmCustomer.CustomerSequence
--WHERE dmProduct.ProductCode IS NULL 
ORDER BY YEAR(inv.inv_date)  * 10000 + MONTH(inv.inv_date) * 100 + DAY(inv.inv_date)

/****************
	
	CREATE TABLE [dbo].[FactSales](
				[SalesKey]			[int] IDENTITY(1,1) NOT NULL,
				[InvoiceNumber]		[varchar](12)		NOT NULL,
				[InvoiceLine]       [varchar](2)		NOT NULL,
				[DateKey]			INT					NOT NULL,
				[TimeKey]			INT					NOT NULL,
				[ProductKey]		INT					NOT NULL,
				[SalesPersonKey]	INT					NOT NULL,
				[CustomerKey]		INT					NOT NULL,
				[Cost]				DECIMAL(18,4)		NOT NULL,
				[Price]				DECIMAL(18,4)		NOT NULL,
				[Margin]			DECIMAL(18,4)		NOT NULL,
				[Discount]			DECIMAL(18,4)		NOT NULL,
				[Quantity]			DECIMAL(18,4)		NOT NULL,
				[Amount]			DECIMAL(18,4)		NOT NULL,
				[MarginAmount]		DECIMAL(18,4)		NOT NULL,
	CONSTRAINT PK_FactSales_SalesKey PRIMARY KEY CLUSTERED 
	(
		[SalesKey] ASC
	)	WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	)	ON [PRIMARY]

	
	ALTER TABLE dbo.FactSales  WITH NOCHECK ADD CONSTRAINT FK_FactSales_DateKey_DimDate_DateKey
							   FOREIGN KEY(DATEKEY)
							   REFERENCES DimDate(DateKey)

	ALTER TABLE dbo.FactSales  WITH NOCHECK ADD CONSTRAINT FK_FactSales_TimeKey_DimTime_TimeKey 
							   FOREIGN KEY(TimeKEY)
							   REFERENCES DimTime(TimeKey)

	ALTER TABLE dbo.FactSales  WITH NOCHECK ADD CONSTRAINT FK_FactSales_ProductKey_DimProduct_ProductKey
							   FOREIGN KEY(ProductKEY)
							   REFERENCES DimProduct(ProductKey)
	ALTER TABLE dbo.FactSales  WITH NOCHECK ADD CONSTRAINT FK_FactSales_SalesPersonKey_DimSalesPerson_SalesPersonKey 
							   FOREIGN KEY(SalesPersonKey)
							   REFERENCES DimSalesPerson(SalesPersonKey)

	ALTER TABLE dbo.FactSales  WITH NOCHECK ADD CONSTRAINT FK_FactSales_CustomerKey_DimCustomer_CustomerKey
							   FOREIGN KEY(CustomerKey)
							   REFERENCES DimCustomer(CustomerKey)

							   
	*****/

	--- store the following data in temp SalesTemp table
	use [kpi_app]
	SELECT CAST(ISNULL(NULLIF(LTRIM(RTRIM(INV_ITEM.INV_NUM)),''),'')	AS VARCHAR)				AS InvoiceNumber,
	   CAST(ISNULL(NULLIF(LTRIM(RTRIM(INV_ITEM.CO_Line)),''),'')	AS VARCHAR)				AS InvoiceLineNumber,
       CAST(INV_ITEM.COST	   AS DECIMAL(18,4))											AS COST,
	   CAST(INV_ITEM.PRICE	   AS DECIMAL(18,4))											AS PRICE,
	   CAST(INV_ITEM.PRICE-INV_ITEM.COST	   AS DECIMAL(18,4))
																							AS MARGIN,
	   CAST(INV_ITEM.DISC      AS DECIMAL(18,4))											AS DISCOUNT,
	   CAST(INV_ITEM.QTY_INVOICED	   AS DECIMAL(18,4))									AS QUANTITY,
	   CASE CAST(INV_ITEM.PRICE	   AS DECIMAL(18,4)) 
	   WHEN 0.0000 THEN
			CAST(INV_ITEM.QTY_INVOICED	   AS DECIMAL(18,4)) *
		(CAST(INV_ITEM.COST	   AS DECIMAL(18,4)) - CAST(INV_ITEM.DISC	   AS DECIMAL(18,4)))
	   ELSE
		 CAST(INV_ITEM.QTY_INVOICED	   AS DECIMAL(18,4)) *
		(CAST(INV_ITEM.PRICE	   AS DECIMAL(18,4)) - CAST(INV_ITEM.DISC	   AS DECIMAL(18,4)))
	   END
	   																						 AS AMOUNT,
	   CASE 
	   WHEN CAST((INV_ITEM.PRICE-INV_ITEM.COST) AS DECIMAL(18,4)) < 0 THEN
			CASE 
			WHEN INV_ITEM.QTY_INVOICED < 0 THEN
			CAST((INV_ITEM.PRICE-INV_ITEM.COST)*-1*INV_ITEM.QTY_INVOICED AS DECIMAL(18,4)) 
			ELSE
			CAST((INV_ITEM.PRICE-INV_ITEM.COST)*INV_ITEM.QTY_INVOICED AS DECIMAL(18,4)) 
			END
		ELSE
		CAST((INV_ITEM.PRICE-INV_ITEM.COST)*INV_ITEM.QTY_INVOICED AS DECIMAL(18,4)) 
		END																							AS MARGINAMOUNT,
		INV.inv_date,
		INV.createdate,
		INV.slsman,
		INV.CUST_NUM,
		INV.CUST_SEQ,
		ITM.ITEM
																	  
FROM				dbo.INV_ITEM_MST INV_ITEM
INNER JOIN			dbo.INV_HDR_MST  INV					ON			INV.INV_NUM  = INV_ITEM.INV_NUM
INNER JOIN			dbo.CustAddr_Mst  ca					ON			INV.CUST_NUM = ca.CUST_NUM
															AND			INV.cust_seq = ca.CUST_SEQ
INNER JOIN			dbo.ITEM_MST     ITM					ON			INV_ITEM.ITEM= ITM.ITEM
INNER JOIN			dbo.coitem_mst					 dmCustOrd		ON	dmCustOrd.co_num = INV_ITEM.co_num
																	AND dmCustOrd.co_line = INV_ITEM.co_line
																	AND dmCustOrd.cust_seq = ca.CUST_SEQ

--read data from the above temp table
use [KPIDW]
SELECT INV.InvoiceNumber,
		INV.InvoiceLineNumber,
		   CAST(dmDate.DateKey AS INT)															AS DateKey,
		   CAST(dmTime.TimeKey AS INT)															AS TimeKey,	   
		   CAST(dmProduct.ItemKey AS INT)														AS ItemKey,
		   CAST(dmSales.SalesPersonKey	AS INT)													AS SalesPersonKey,
		   dmCustomer.CustomerKey,
		INV.COST,
		INV.PRICE,
		INV.MARGIN,
		INV.DISCOUNT,
		INV.QUANTITY,
		INV.AMOUNT,
		INV.MARGINAMOUNT
																	  
FROM				dbo.GetSalesTemp inv
INNER JOIN		    dbo.DimDate dmDate			ON			dmDate.DateKey = YEAR(inv.inv_date)  * 10000 +
																				 MONTH(inv.inv_date) * 100 +
																				 DAY(inv.inv_date)
INNER JOIN		    KPIDW.dbo.DimTime dmTime			ON			dmTime.[Time] = CONVERT(VARCHAR,inv.CreateDate,108)
INNER JOIN		    KPIDW.dbo.DimSalesPerson  dmSales       ON		dmSales.SalesPersonCode =  ISNULL(NULLIF(INV.slsman,''),'000000')
INNER JOIN		    KPIDW.dbo.DimCustomer     dmCustomer    ON		dmCustomer.CustomerNumber = LTRIM(RTRIM(INV.CUST_NUM))
															AND		dmCustomer.CustomerSequence = LTRIM(RTRIM(INV.CUST_SEQ))
INNER JOIN		    KPIDW.dbo.DimItem	      dmProduct     ON		dmProduct.ItemCode   = INV.item
ORDER BY YEAR(inv.inv_date)  * 10000 + MONTH(inv.inv_date) * 100 + DAY(inv.inv_date)