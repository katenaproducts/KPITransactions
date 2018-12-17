use [KPI]
SELECT CAST(LTRIM(RTRIM(c.CUST_NUM)) AS VARCHAR)						AS CustomerNumberKey,
		CAST(LTRIM(RTRIM(ca.cust_seq)) AS VARCHAR) AS CustomerSequence,		
	   CAST(ISNULL(NULLIF(LTRIM(RTRIM(ca.NAME)),''),'') AS VARCHAR)			AS CustomerName,
	   CAST(ISNULL(NULLIF(LTRIM(RTRIM(REPLACE(ca.addr##1,'NULL', ''))),''),'') AS VARCHAR)	 as Address1,
	   CAST(ISNULL(NULLIF(LTRIM(RTRIM(REPLACE(ca.addr##2, 'NULL', ''))),''),'') AS VARCHAR)	 as Address2,
	   CAST(ISNULL(NULLIF(LTRIM(RTRIM(REPLACE(ca.addr##3,'NULL', ''))),''),'') AS VARCHAR)	 as Address3,
	   CAST(ISNULL(NULLIF(LTRIM(RTRIM(REPLACE(ca.addr##4,'NULL', ''))),''),'') AS VARCHAR)	 as Address4,
	   CAST(ISNULL(NULLIF(LTRIM(RTRIM(REPLACE(c.contact##1,'NULL', ''))),''),'') AS VARCHAR)	 as Contact1,
	   CAST(ISNULL(NULLIF(LTRIM(RTRIM(REPLACE(c.contact##2,'NULL', ''))),''),'') AS VARCHAR)	 as Contact2,
	   CAST(ISNULL(NULLIF(LTRIM(RTRIM(REPLACE(c.contact##3,'NULL', ''))),''),'') AS VARCHAR)	 as Contact3,
	   CAST(ISNULL(NULLIF(LTRIM(RTRIM(REPLACE(c.phone##1,'NULL', ''))),''),'') AS VARCHAR)	 as Phone1,
	   CAST(ISNULL(NULLIF(LTRIM(RTRIM(REPLACE(c.phone##2,'NULL', ''))),''),'') AS VARCHAR)	 as Phone2,
	   CAST(ISNULL(NULLIF(LTRIM(RTRIM(REPLACE(c.phone##3,'NULL', ''))),''),'') AS VARCHAR)	 as Phone3,
	   CAST(ISNULL(NULLIF(LTRIM(RTRIM(REPLACE(ca.[city],'NULL', ''))),''),'') AS VARCHAR)	 as City,
	   CAST(ISNULL(NULLIF(LTRIM(RTRIM(REPLACE(ca.[state],'NULL', ''))),''),'') AS VARCHAR)	 as [State],
	   CAST(ISNULL(NULLIF(LTRIM(RTRIM(REPLACE(ca.zip,'NULL', ''))),''),'') AS VARCHAR)	 as Zip,
	   CAST(ISNULL(NULLIF(LTRIM(RTRIM(REPLACE(ca.country,'NULL', ''))),''),'') AS VARCHAR)	 as Country,
	   CAST(ISNULL(NULLIF(LTRIM(RTRIM(REPLACE(ca.fax_num,'NULL', ''))),''),'') AS VARCHAR)	 as Fax,
	   CAST(ISNULL(NULLIF(LTRIM(RTRIM(REPLACE(ca.internal_email_addr,'NULL', ''))),''),'') AS VARCHAR)	 as InternalEmail,
	   CAST(ISNULL(NULLIF(LTRIM(RTRIM(REPLACE(ca.external_email_addr,'NULL', ''))),''),'') AS VARCHAR)	 as ExternalEmail,
		CAST(ISNULL(NULLIF(LTRIM(RTRIM(REPLACE(ca.carrier_bill_to_transportation,'NULL', ''))),''),'') AS VARCHAR)	 as Carrier,
		CAST(ISNULL(NULLIF(LTRIM(RTRIM(REPLACE(ca.carrier_account,'NULL', ''))),''),'') AS VARCHAR)	 as Account,
	   CAST(ISNULL(NULLIF(LTRIM(RTRIM(REPLACE(ca.Uf_FacilityID,'NULL', ''))),''),'') AS VARCHAR) AS FacilityID,
	   CAST(ISNULL(NULLIF(LTRIM(RTRIM(REPLACE(c.cust_type,'NULL', ''))),''),'') AS VARCHAR)	 as CustomerTypeCode,
	   CAST(ISNULL(NULLIF(LTRIM(RTRIM(REPLACE(ct.[description],'NULL', ''))),''),'') AS VARCHAR)	 as CustomerType,
	   CAST(ISNULL(NULLIF(LTRIM(RTRIM(REPLACE(c.tax_code1,'NULL', ''))),''),'') AS VARCHAR)	 as TaxCode,
	   CAST(ISNULL(NULLIF(LTRIM(RTRIM(REPLACE(c.end_user_type,'NULL', ''))),''),'') AS VARCHAR)	 as EndUserTypeCode,
	   CAST(ISNULL(NULLIF(LTRIM(RTRIM(REPLACE(et.[description],'NULL', ''))),''),'') AS VARCHAR)	 as EndUserType,
	   c.Uf_CustomerCreatedDate as CustomerCreatedDate
FROM		dbo.CUSTOMER_MST  c
INNER JOIN	dbo.CUSTADDR_MST  ca ON		c.CUST_NUM = ca.CUST_NUM
								 AND	c.CUST_SEQ = ca.CUST_SEQ
LEFT OUTER JOIN dbo.custtype_mst ct ON c.cust_type = ct.cust_type 
LEFT OUTER JOIN dbo.endtype_mst et ON c.end_user_type = et.end_user_type 

/**
select *
from custtype_mst

select *
from endtype_mst

select *
from customer_mst
where cust_seq = 0

select *
from custaddr_mst
where 
cust_seq = 0

select *
from dimcustomer

delete from  dimCustomer

**/


/**
use [KPI_Sales_DW]
IF EXISTS(SELECT 1
			FROM   SYSOBJECTS
			WHERE  NAME ='DimCustomer'
			)
BEGIN
	DROP TABLE dbo.DimCustomer
END



	CREATE TABLE [dbo].[DimCustomer](
				[CustomerKey] [int] IDENTITY(1,1) NOT NULL,
				[CustomerNumber] [varchar](30) NOT NULL,
				[CustomerSequence]	[varchar](10) NOT NULL,
				[CustomerName] [varchar](80) NOT NULL,
				[Address1] [varchar](50) NULL,
				[Address2] [varchar](50) NULL,
				[Address3] [varchar](50) NULL,
				[Address4] [varchar](50) NULL,
				[City]	[varchar](30) NULL,
				[State]	[varchar](30) NULL,
				[Zip]	[varchar](30) NULL,
				[Country]	[varchar](30) NULL,
				[Contact1] [varchar](30) NULL,
				[Contact2] [varchar](30) NULL,
				[Contact3] [varchar](30) NULL,
				[Phone1] [varchar](25) NULL,
				[Phone2] [varchar](25) NULL,
				[Phone3] [varchar](25) NULL,
				[Fax] [varchar](25) NULL,
				[InternalEmail]	[varchar](30) NULL,
				[ExternalEmail]	[varchar](30) NULL,
				[Carrier]	[varchar](30) NULL,
				[CarrierAccount]	[varchar](30) NULL,
				[FacilityID]	[varchar](30) NULL,
				[CustomerTypeCode] [varchar](25) NULL,
				[CustomerType] [varchar](50) NULL,
				[TaxCode] [varchar](6) NULL,
				[EndUserTypeCode] [varchar](6) NULL,
				[EndUserType] [varchar](50) NULL,
				[CustomerCreatedDate] [datetime] NULL	
	CONSTRAINT PK_DimCustomer_CustomerKey PRIMARY KEY CLUSTERED 
	(
		[CustomerKey] ASC
	)	WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	)	ON [PRIMARY]

**/