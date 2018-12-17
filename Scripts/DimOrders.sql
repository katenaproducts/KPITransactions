/*
select *
from co_mst

select * FROM shipcode_mst

select *
from inv_hdr_mst

use[KPIDW]
	CREATE TABLE [dbo].[DimOrder](
				[OrderKey] [int] IDENTITY(1,1) NOT NULL,
				[OrderNumber] [varchar](30) NOT NULL,
				[CustomerNumber]	[varchar](30) NOT NULL,
				[CustomerSequence] [varchar](10) NOT NULL,
				[Contact] [varchar](50) NULL,
				[Phone] [varchar](30) NULL,
				[CustomerPO] [varchar](50) NULL,
				[ShipCode] [varchar](50) NULL,
				[ShipMethod]	[varchar](30) NULL,	
				[Freight]		DECIMAL(18,4) NULL,
				[InvoiceNumber]	[varchar](30) NULL,
				[Reason]				[varchar](50) NULL,
				[ProblemCode]			[varchar](10) NULL,
				[ProblemDescription]	[varchar](50) NULL

	CONSTRAINT PK_DimOrder_OrderKey PRIMARY KEY CLUSTERED 
	(
		[OrderKey] ASC
	)	WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	)	ON [PRIMARY]

*/
use [KPI_App] 
SELECT CAST(LTRIM(RTRIM(co.co_num)) as VARCHAR) as OrderNum, 
	CAST(ISNULL(NULLIF(LTRIM(RTRIM(REPLACE(co.cust_num, 'NULL', ''))), ''), '') as VARCHAR) as CustomerNum, 
	CAST(ISNULL(NULLIF(LTRIM(RTRIM(REPLACE(co.cust_seq, 'NULL', ''))), ''), '') as VARCHAR) as CustSeq, 
	CAST(ISNULL(NULLIF(LTRIM(RTRIM(REPLACE(co.contact, 'NULL', ''))), ''), '') as VARCHAR) as Contact, 
	CAST(ISNULL(NULLIF(LTRIM(RTRIM(REPLACE(co.phone, 'NULL', ''))), ''), '') as VARCHAR)as Phone, 
	CAST(ISNULL(NULLIF(LTRIM(RTRIM(REPLACE(co.cust_po, 'NULL', ''))), ''), '') as VARCHAR) as CustomerPO, 
	CAST(ISNULL(NULLIF(LTRIM(RTRIM(REPLACE(co.ship_code, 'NULL', ''))), ''), '') as VARCHAR) as ShipCode, 
	CAST(ISNULL(NULLIF(LTRIM(RTRIM(REPLACE(sh.[description], 'NULL', ''))), ''), '') as VARCHAR) as ShipMethod,
	 CAST(ISNULL(NULLIF(LTRIM(RTRIM(REPLACE(inv.freight, 'NULL', '0'))), '0'), '0') AS DECIMAL(18,4)) as FREIGHT,
	 CAST(ISNULL(NULLIF(LTRIM(RTRIM(REPLACE(inv.inv_num, 'NULL', ''))), ''), '') as VARCHAR) as InvoiceNumber
FROM co_mst co 
INNER JOIN shipcode_mst sh 	ON co.ship_code = sh.ship_code
LEFT OUTER JOIN inv_hdr_mst inv on co.co_num = inv.co_num
Order by co.co_num


select *
FROM co_mst co 
INNER JOIN shipcode_mst sh 	ON co.ship_code = sh.ship_code
LEFT OUTER JOIN inv_hdr_mst inv on co.co_num = inv.co_num
where inv.co_num = 'NJ00029533'
