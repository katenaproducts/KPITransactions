/*
	Name		 :- Katena DW
	Author		 :-	Nauman Chughtai
	Created Date :- 06/22/2018
	Purpose		 :- Scripts to create data model for DW
*/
DECLARE
		@ErrorNumber				INT,
		@ErrorMessage				VARCHAR(2048),
		@ErrorSeverity				INT,
		@ErrorLine					INT,
		@ErrorSource				SYSNAME,		
		@ErrorState					INT;		
		
		
BEGIN

	BEGIN TRY		
		
	BEGIN TRANSACTION		
		
	IF EXISTS(SELECT 1
			  FROM   SYSOBJECTS
			  WHERE  NAME ='inv_hdr_mst'
			  )
	BEGIN
		DROP TABLE dbo.inv_hdr_mst
	END


	IF EXISTS(SELECT 1
			  FROM   SYSOBJECTS
			  WHERE  NAME ='inv_item_mst'
			  )
	BEGIN
		DROP TABLE dbo.inv_item_mst
	END


	IF EXISTS(SELECT 1
			  FROM   SYSOBJECTS
			  WHERE  NAME ='FactSales'
			  )
	BEGIN
		DROP TABLE dbo.FactSales
	END


	IF EXISTS(SELECT 1
			  FROM   SYSOBJECTS
			  WHERE  NAME ='DimCustomer'
			  )
	BEGIN
		DROP TABLE dbo.DimCustomer
	END

	IF EXISTS(SELECT 1
			  FROM   SYSOBJECTS
			  WHERE  NAME ='DimItem'
			  )
	BEGIN
		DROP TABLE dbo.DimItem
	END	
		
	IF EXISTS(SELECT 1
			  FROM   SYSOBJECTS
			  WHERE  NAME ='DimSalesPerson'
			  )
	BEGIN
		DROP TABLE dbo.DimSalesPerson
	END
			
	
	IF EXISTS(SELECT 1
			  FROM   SYSOBJECTS
			  WHERE  NAME ='DimDate'
			  )
	BEGIN
		DROP TABLE dbo.DimDate
	END


	IF EXISTS(SELECT 1
			  FROM   SYSOBJECTS
			  WHERE  NAME ='DimTime'
			  )
	BEGIN
		DROP TABLE dbo.DimTime
	END

	IF EXISTS(SELECT 1
			  FROM   SYSOBJECTS
			  WHERE  NAME ='FactSalesTemp'
			  )
	BEGIN
		DROP TABLE dbo.FactSalesTemp
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


	CREATE TABLE [dbo].[DimItem](
				[ItemKey]	  [int] IDENTITY(1,1) NOT NULL,				
				[ItemCode] [varchar](80) NOT NULL,
				[ItemName] [varchar](80) NOT NULL,
				[ProductCode] [varchar](80) NOT NULL,
				[FamilyCode] [varchar](80) NOT NULL,
				[FamilyName] [varchar](80) NOT NULL,
				[AverageUnitCost]  DECIMAL(18,4),
				[GTIN]	[varchar](40) NULL,
				[DateToMarket]	[datetime],
				[TravelerID]	[varchar] (10),
				[CEMarked]		[varchar] (10)
				
	CONSTRAINT PK_DimItem_ProductKey PRIMARY KEY CLUSTERED 
	(
		[ItemKey] ASC
	)	WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	)	ON [PRIMARY]
	
	
	CREATE TABLE [dbo].[DimSalesPerson](
				[SalesPersonKey] [int] IDENTITY(1,1) NOT NULL,
				[SalesPersonCode] [varchar](10) NOT NULL,
				[SalesPersonName] [varchar](80) NOT NULL,
				[SalesManagerCode][varchar](10) NOT NULL,
				[SalesManagerName] [varchar](80) NOT NULL,
				[SalesRegionCode]  [varchar](10) NOT NULL,
				[SalesRegionName]  [varchar](80) NOT NULL,
				
	CONSTRAINT PK_DimSalesPerson_SalesPersonKey PRIMARY KEY CLUSTERED 
	(
		[SalesPersonKey] ASC
	)	WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	)	ON [PRIMARY]



	CREATE TABLE [dbo].[DimDate](
	   --[ID] [int] IDENTITY(1,1) NOT NULL--Use this line if you just want an autoincrementing counter AND COMMENT BELOW LINE	 
       [DateKey] [int] NOT NULL--TO MAKE THE ID THE YYYYMMDD FORMAT USE THIS LINE AND COMMENT ABOVE LINE. 
	 , [Date] [datetime] NOT NULL
	 , [Day] [char](2) NOT NULL
	 , [DaySuffix] [varchar](4) NOT NULL
	 , [DayOfWeek] [varchar](9) NOT NULL
	 , [DOWInMonth] [TINYINT] NOT NULL
	 , [DayOfYear] [int] NOT NULL
	 , [WeekOfYear] [tinyint] NOT NULL
	 , [WeekOfMonth] [tinyint] NOT NULL
	 , [Month] [char](2) NOT NULL
	 , [MonthName] [varchar](9) NOT NULL
	 , [Quarter] [tinyint] NOT NULL
	 , [QuarterName] [varchar](6) NOT NULL
	 , [Year] [char](4) NOT NULL
	 , [StandardDate] [varchar](10) NULL
	 , [HolidayText] [varchar](50) NULL
	 CONSTRAINT [PK_DimDate] PRIMARY KEY CLUSTERED 
	 (
	 [DateKey] ASC
	 )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
	 ) ON [PRIMARY]


	CREATE TABLE [dbo].[DimTime](
	 [TimeKey] [int] IDENTITY(1,1) NOT NULL,
	 [Time] [char](8) NOT NULL,
	 [Hour] [char](2) NOT NULL,
	 [MilitaryHour] [char](2) NOT NULL,
	 [Minute] [char](2) NOT NULL,
	 [Second] [char](2) NOT NULL,
	 [AmPm] [char](2) NOT NULL,
	 [StandardTime] [char](11) NULL,
	 CONSTRAINT [PK_DimTime] PRIMARY KEY CLUSTERED 
	 (
	 TimeKey ASC
	 )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	 ) ON [PRIMARY]									

	-- INDEXES For DimDate and DimTime

	--DimDate indexes---------------------------------------------------------------------------------------------
	CREATE UNIQUE NONCLUSTERED INDEX [IDX_DimDate_Date] ON [dbo].[DimDate] 
	(
	[Date] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [IDX_DimDate_Day] ON [dbo].[DimDate] 
	(
	[Day] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [IDX_DimDate_DayOfWeek] ON [dbo].[DimDate] 
	(
	[DayOfWeek] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [IDX_DimDate_DOWInMonth] ON [dbo].[DimDate] 
	(
	[DOWInMonth] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [IDX_DimDate_DayOfYear] ON [dbo].[DimDate] 
	(
	[DayOfYear] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [IDX_DimDate_WeekOfYear] ON [dbo].[DimDate] 
	(
	[WeekOfYear] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [IDX_DimDate_WeekOfMonth] ON [dbo].[DimDate] 
	(
	[WeekOfMonth] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [IDX_DimDate_Month] ON [dbo].[DimDate] 
	(
	[Month] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [IDX_DimDate_MonthName] ON [dbo].[DimDate] 
	(
	[MonthName] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [IDX_DimDate_Quarter] ON [dbo].[DimDate] 
	(
	[Quarter] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [IDX_DimDate_QuarterName] ON [dbo].[DimDate] 
	(
	[QuarterName] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [IDX_DimDate_Year] ON [dbo].[DimDate] 
	(
	[Year] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [IDX_DimTime_HolidayText] ON [dbo].[DimDate] 
	(
	[HolidayText] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

	--DimTime indexes
	CREATE UNIQUE NONCLUSTERED INDEX [IDX_DimTime_Time] ON [dbo].[DimTime] 
	(
	[Time] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [IDX_DimTime_Hour] ON [dbo].[DimTime] 
	(
	[Hour] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [IDX_DimTime_MilitaryHour] ON [dbo].[DimTime] 
	(
	[MilitaryHour] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [IDX_DimTime_Minute] ON [dbo].[DimTime] 
	(
	[Minute] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [IDX_DimTime_Second] ON [dbo].[DimTime] 
	(
	[Second] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [IDX_DimTime_AmPm] ON [dbo].[DimTime] 
	(
	[AmPm] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [IDX_DimTime_StandardTime] ON [dbo].[DimTime] 
	(
	[StandardTime] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

	CREATE TABLE [dbo].[FactSales](
			[SalesKey]			[int] IDENTITY(1,1) NOT NULL,
			[InvoiceNumber]		[varchar](12)		NOT NULL,
			[InvoiceLine]       [varchar](2)		NOT NULL,
			[DateKey]			INT					NOT NULL,
			[TimeKey]			INT					NOT NULL,
			[ItemKey]		INT					NOT NULL,
			[SalesPersonKey]	INT					NOT NULL,
			[CustomerKey]		INT					NOT NULL,
			[Cost]				DECIMAL(18,4)		NOT NULL,
			[Price]				DECIMAL(18,4)		NOT NULL,
			[Margin]			DECIMAL(18,4)		NOT NULL,
			[Discount]			DECIMAL(18,4)		NOT NULL,
			[Quantity]			DECIMAL(18,4)		NOT NULL,
			[ExtendedPrice]			DECIMAL(18,4)		NOT NULL,
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

	ALTER TABLE dbo.FactSales  WITH NOCHECK ADD CONSTRAINT FK_FactSales_ItemKey_DimItem_ItemKey
							   FOREIGN KEY(ItemKEY)
							   REFERENCES DimItem(ItemKey)
	ALTER TABLE dbo.FactSales  WITH NOCHECK ADD CONSTRAINT FK_FactSales_SalesPersonKey_DimSalesPerson_SalesPersonKey 
							   FOREIGN KEY(SalesPersonKey)
							   REFERENCES DimSalesPerson(SalesPersonKey)

	ALTER TABLE dbo.FactSales  WITH NOCHECK ADD CONSTRAINT FK_FactSales_CustomerKey_DimCustomer_CustomerKey
							   FOREIGN KEY(CustomerKey)
							   REFERENCES DimCustomer(CustomerKey)
							   
	
		CREATE TABLE [dbo].[FactSalesTemp](
			[InvoiceNumber]		[varchar](12)		NOT NULL,
			[InvoiceLine]       [varchar](2)		NOT NULL,
			[Cost]				DECIMAL(18,4)		NOT NULL,
			[Price]				DECIMAL(18,4)		NOT NULL,
			[Margin]			DECIMAL(18,4)		NOT NULL,
			[Discount]			DECIMAL(18,4)		NOT NULL,
			[Quantity]			DECIMAL(18,4)		NOT NULL,
			[ExtendedPrice]		DECIMAL(18,4)		NOT NULL,
			[MarginAmount]		DECIMAL(18,4)		NOT NULL,
			[inv_date]			DATETIME			NOT NULL,
			[CreateDate]		DATETIME			NOT NULL,
			[Slsman]			[VARCHAR](20)		NULL,
			[CUST_NUM]			[VARCHAR](30)		NULL,
			[CUST_SEQ]			[VARCHAR](30)		NULL,
			[ITEM]				[VARCHAR](30)		NULL
	)	ON [PRIMARY]


	COMMIT TRANSACTION
	
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SET @ErrorMessage = ERROR_MESSAGE();
		SET @ErrorSource  = ISNULL(ERROR_PROCEDURE(), 'Unknown');
		SET @ErrorLine	  = ERROR_LINE();
		SET @ErrorSeverity= ERROR_SEVERITY();
		SET @ErrorState   = ERROR_STATE();
		GOTO ErrorHandler;
	END CATCH
	RETURN;
	
	ErrorHandler:
		RAISERROR('The following error has occured in the object [%s]: Error Number %d on line %d with message [%s]',
					@ErrorSeverity, @ErrorState, @ErrorSource, @ErrorNumber, @ErrorLine, @ErrorMessage)			
END
GO
