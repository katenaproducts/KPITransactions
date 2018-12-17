/*
	Name		 :- Katena DW
	Author		 :-	Nauman Chughtai
	Created Date :- 06/19/2018
	Purpose		 :- Scripts to create to populate data model for lookup/configuration - DimDate and DimTime
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
		
	DELETE FROM  dbo.DimDate
	DELETE FROM  dbo.DimTime

	
	--IF YOU ARE USING THE YYYYMMDD format for the primary key then you need to comment out this line.
	--DBCC CHECKIDENT (DimDate, RESEED, 60000) --In case you need to add earlier dates later.

	DECLARE @tmpDOW TABLE (DOW INT, Cntr INT)--Table for counting DOW occurance in a month
	INSERT INTO @tmpDOW(DOW, Cntr) VALUES(1,0)--Used in the loop below
	INSERT INTO @tmpDOW(DOW, Cntr) VALUES(2,0)
	INSERT INTO @tmpDOW(DOW, Cntr) VALUES(3,0)
	INSERT INTO @tmpDOW(DOW, Cntr) VALUES(4,0)
	INSERT INTO @tmpDOW(DOW, Cntr) VALUES(5,0)
	INSERT INTO @tmpDOW(DOW, Cntr) VALUES(6,0)
	INSERT INTO @tmpDOW(DOW, Cntr) VALUES(7,0)

	DECLARE @StartDate datetime
	 , @EndDate datetime
	 , @Date datetime
	 , @WDofMonth INT
	 , @CurrentMonth INT
 
	SELECT @StartDate = '1/1/1900'
	 , @EndDate = '1/1/2050'--Non inclusive. Stops on the day before this.
	 , @CurrentMonth = 1 --Counter used in loop below.

	SELECT @Date = @StartDate

	WHILE @Date < @EndDate
	 BEGIN
 
	 IF DATEPART(MONTH,@Date) <> @CurrentMonth 
	 BEGIN
	 SELECT @CurrentMonth = DATEPART(MONTH,@Date)
	 UPDATE @tmpDOW SET Cntr = 0
	 END

	 UPDATE @tmpDOW
	 SET Cntr = Cntr + 1
	 WHERE DOW = DATEPART(DW,@DATE)

	 SELECT @WDofMonth = Cntr
	 FROM @tmpDOW
	 WHERE DOW = DATEPART(DW,@DATE) 

	 INSERT INTO DimDate
	 (
	   [DateKey],--TO MAKE THE ID THE YYYYMMDD FORMAT UNCOMMENT THIS LINE... Comment for autoincrementing.
	   [Date]
	 , [Day]
	 , [DaySuffix]
	 , [DayOfWeek]
	 , [DOWInMonth]
	 , [DayOfYear]
	 , [WeekOfYear]
	 , [WeekOfMonth] 
	 , [Month]
	 , [MonthName]
	 , [Quarter]
	 , [QuarterName]
	 , [Year]
	 )
	 SELECT CONVERT(VARCHAR,@Date,112), --TO MAKE THE ID THE YYYYMMDD FORMAT UNCOMMENT THIS LINE COMMENT FOR AUTOINCREMENT
	 @Date [Date]
	 , DATEPART(DAY,@DATE) [Day]
	 , CASE 
	 WHEN DATEPART(DAY,@DATE) IN (11,12,13) THEN CAST(DATEPART(DAY,@DATE) AS VARCHAR) + 'th'
	 WHEN RIGHT(DATEPART(DAY,@DATE),1) = 1 THEN CAST(DATEPART(DAY,@DATE) AS VARCHAR) + 'st'
	 WHEN RIGHT(DATEPART(DAY,@DATE),1) = 2 THEN CAST(DATEPART(DAY,@DATE) AS VARCHAR) + 'nd'
	 WHEN RIGHT(DATEPART(DAY,@DATE),1) = 3 THEN CAST(DATEPART(DAY,@DATE) AS VARCHAR) + 'rd'
	 ELSE CAST(DATEPART(DAY,@DATE) AS VARCHAR) + 'th' 
	 END AS [DaySuffix]
	 , CASE DATEPART(DW, @DATE)
	 WHEN 1 THEN 'Sunday'
	 WHEN 2 THEN 'Monday'
	 WHEN 3 THEN 'Tuesday'
	 WHEN 4 THEN 'Wednesday'
	 WHEN 5 THEN 'Thursday'
	 WHEN 6 THEN 'Friday'
	 WHEN 7 THEN 'Saturday'
	 END AS [DayOfWeek]
	 , @WDofMonth [DOWInMonth]--Occurance of this day in this month. If Third Monday then 3 and DOW would be Monday.
	 , DATEPART(dy,@Date) [DayOfYear]--Day of the year. 0 - 365/366
	 , DATEPART(ww,@Date) [WeekOfYear]--0-52/53
	 , DATEPART(ww,@Date) + 1 -
	 DATEPART(ww,CAST(DATEPART(mm,@Date) AS VARCHAR) + '/1/' + CAST(DATEPART(yy,@Date) AS VARCHAR)) [WeekOfMonth]
	 , DATEPART(MONTH,@DATE) [Month]--To be converted with leading zero later. 
	 , DATENAME(MONTH,@DATE) [MonthName]
	 , DATEPART(qq,@DATE) [Quarter]--Calendar quarter
	 , CASE DATEPART(qq,@DATE) 
	 WHEN 1 THEN 'First'
	 WHEN 2 THEN 'Second'
	 WHEN 3 THEN 'Third'
	 WHEN 4 THEN 'Fourth'
	 END AS [QuarterName]
	 , DATEPART(YEAR,@Date) [Year]

	 SELECT @Date = DATEADD(dd,1,@Date)
	 END

	--You can replace this code by editing the insert using my functions dbo.DBA_fnAddLeadingZeros
	UPDATE dbo.DimDate
	 SET [DAY] = '0' + [DAY]
	 WHERE LEN([DAY]) = 1

	UPDATE dbo.DimDate
	 SET [MONTH] = '0' + [MONTH]
	 WHERE LEN([MONTH]) = 1

	UPDATE dbo.DimDate
	 SET STANDARDDATE = [MONTH] + '/' + [DAY] + '/' + [YEAR]

	--Add HOLIDAYS --------------------------------------------------------------------------------------------------------------
	--THANKSGIVING --------------------------------------------------------------------------------------------------------------
	--Fourth THURSDAY in November.
	UPDATE DimDate
	SET HolidayText = 'Thanksgiving Day'
	WHERE [MONTH] = 11 
	 AND [DAYOFWEEK] = 'Thursday' 
	 AND [DOWInMonth] = 4
	

	--CHRISTMAS -------------------------------------------------------------------------------------------
	UPDATE dbo.DimDate
	SET HolidayText = 'Christmas Day'
	WHERE [MONTH] = 12 AND [DAY] = 25

	--4th of July ---------------------------------------------------------------------------------------------
	UPDATE dbo.DimDate
	SET HolidayText = 'Independance Day'
	WHERE [MONTH] = 7 AND [DAY] = 4

	-- New Years Day ---------------------------------------------------------------------------------------------
	UPDATE dbo.DimDate
	SET HolidayText = 'New Year''s Day'
	WHERE [MONTH] = 1 AND [DAY] = 1

	--Memorial Day ----------------------------------------------------------------------------------------
	--Last Monday in May
	UPDATE dbo.DimDate
	SET HolidayText = 'Memorial Day'
	FROM DimDate
	WHERE DateKey IN 
	 (
	 SELECT MAX([DateKey])
	 FROM dbo.DimDate
	 WHERE [MonthName] = 'May'
	 AND [DayOfWeek] = 'Monday'
	 GROUP BY [YEAR], [MONTH]
	 )
	--Labor Day -------------------------------------------------------------------------------------------
	--First Monday in September
	UPDATE dbo.DimDate
	SET HolidayText = 'Labor Day'
	FROM DimDate
	WHERE DateKey IN 
	 (
	 SELECT MIN([DateKey])
	 FROM dbo.DimDate
	 WHERE [MonthName] = 'September'
	 AND [DayOfWeek] = 'Monday'
	 GROUP BY [YEAR], [MONTH]
	 )

	-- Valentine's Day ---------------------------------------------------------------------------------------------
	UPDATE dbo.DimDate
	SET HolidayText = 'Valentine''s Day'
	WHERE [MONTH] = 2 AND [DAY] = 14

	-- Saint Patrick's Day -----------------------------------------------------------------------------------------
	UPDATE dbo.DimDate
	SET HolidayText = 'Saint Patrick''s Day'
	WHERE [MONTH] = 3 AND [DAY] = 17
	
	--Martin Luthor King Day ---------------------------------------------------------------------------------------
	--Third Monday in January starting in 1983
	UPDATE DimDate
	SET HolidayText = 'Martin Luthor King Jr Day'
	WHERE [MONTH] = 1--January
	 AND [Dayofweek] = 'Monday'
	 AND [YEAR] >= 1983--When holiday was official
	 AND [DOWInMonth] = 3--Third X day of current month.
	
	--President's Day ---------------------------------------------------------------------------------------
	--Third Monday in February.
	UPDATE DimDate
	SET HolidayText = 'President''s Day'--select * from DimDate
	WHERE [MONTH] = 2--February
	 AND [Dayofweek] = 'Monday'
	 AND [DOWInMonth] = 3--Third occurance of a monday in this month.
	
	--Mother's Day ---------------------------------------------------------------------------------------
	--Second Sunday of May
	UPDATE DimDate
	SET HolidayText = 'Mother''s Day'--select * from DimDate
	WHERE [MONTH] = 5--May
	 AND [Dayofweek] = 'Sunday'
	 AND [DOWInMonth] = 2--Second occurance of a monday in this month.
	
	--Father's Day ---------------------------------------------------------------------------------------
	--Third Sunday of June
	UPDATE DimDate
	SET HolidayText = 'Father''s Day'--select * from DimDate
	WHERE [MONTH] = 6--June
	 AND [Dayofweek] = 'Sunday'
	 AND [DOWInMonth] = 3--Third occurance of a monday in this month.
	
	--Halloween 10/31 ----------------------------------------------------------------------------------
	UPDATE dbo.DimDate
	SET HolidayText = 'Halloween'
	WHERE [MONTH] = 10 AND [DAY] = 31
	--Election Day--------------------------------------------------------------------------------------
	--The first Tuesday after the first Monday in November.
	BEGIN TRY
	 drop table #tmpHoliday
	END TRY 
	BEGIN CATCH
	 --do nothing
	END CATCH

	CREATE TABLE #tmpHoliday(ID INT IDENTITY(1,1), DateID int, Week TINYINT, YEAR CHAR(4), DAY CHAR(2))

	INSERT INTO #tmpHoliday(DateID, [YEAR],[DAY])
	 SELECT [DateKey], [YEAR], [DAY]
	 FROM dbo.DimDate
	 WHERE [MONTH] = 11
	 AND [Dayofweek] = 'Monday'
	 ORDER BY YEAR, DAY

	DECLARE @CNTR INT, @POS INT, @STARTYEAR INT, @ENDYEAR INT, @CURRENTYEAR INT, @MINDAY INT

	SELECT @CURRENTYEAR = MIN([YEAR])
	 , @STARTYEAR = MIN([YEAR])
	 , @ENDYEAR = MAX([YEAR])
	FROM #tmpHoliday

	WHILE @CURRENTYEAR <= @ENDYEAR
	 BEGIN
	 SELECT @CNTR = COUNT([YEAR])
	 FROM #tmpHoliday
	 WHERE [YEAR] = @CURRENTYEAR

	 SET @POS = 1

	 WHILE @POS <= @CNTR
	 BEGIN
	 SELECT @MINDAY = MIN(DAY)
	 FROM #tmpHoliday
	 WHERE [YEAR] = @CURRENTYEAR
	 AND [WEEK] IS NULL

	 UPDATE #tmpHoliday
	 SET [WEEK] = @POS
	 WHERE [YEAR] = @CURRENTYEAR
	 AND [DAY] = @MINDAY

	 SELECT @POS = @POS + 1
	 END

	 SELECT @CURRENTYEAR = @CURRENTYEAR + 1
	 END

	UPDATE DT
	SET HolidayText = 'Election Day'
	FROM dbo.DimDate DT
	JOIN #tmpHoliday HL
	 ON (HL.DateID + 1) = DT.DateKey
	WHERE [WEEK] = 1

	DROP TABLE #tmpHoliday


	PRINT CONVERT(VARCHAR,GETDATE(),113)--USED FOR CHECKING RUN TIME.

	--Load time data for every second of a day
	DECLARE @Time DATETIME

	SET @TIME = CONVERT(VARCHAR,'12:00:00 AM',108)

	DELETE FROM dbo.DimTime

	WHILE @TIME <= '11:59:59 PM'
	 BEGIN
	 INSERT INTO dbo.DimTime([Time], [Hour], [MilitaryHour], [Minute], [Second], [AmPm])
	 SELECT CONVERT(VARCHAR,@TIME,108) [Time]
	 , CASE 
	 WHEN DATEPART(HOUR,@Time) > 12 THEN DATEPART(HOUR,@Time) - 12
	 ELSE DATEPART(HOUR,@Time) 
	 END AS [Hour]
	 , CAST(SUBSTRING(CONVERT(VARCHAR,@TIME,108),1,2) AS INT) [MilitaryHour]
	 , DATEPART(MINUTE,@Time) [Minute]
	 , DATEPART(SECOND,@Time) [Second]
	 , CASE 
	 WHEN DATEPART(HOUR,@Time) >= 12 THEN 'PM'
	 ELSE 'AM'
	 END AS [AmPm]

	 SELECT @TIME = DATEADD(second,1,@Time)
	 END

	UPDATE DimTime
	SET [HOUR] = '0' + [HOUR]
	WHERE LEN([HOUR]) = 1

	UPDATE DimTime
	SET [MINUTE] = '0' + [MINUTE]
	WHERE LEN([MINUTE]) = 1

	UPDATE DimTime
	SET [SECOND] = '0' + [SECOND]
	WHERE LEN([SECOND]) = 1

	UPDATE DimTime
	SET [MilitaryHour] = '0' + [MilitaryHour]
	WHERE LEN([MilitaryHour]) = 1

	UPDATE DimTime
	SET StandardTime = [Hour] + ':' + [Minute] + ':' + [Second] + ' ' + AmPm
	WHERE StandardTime is null
	AND HOUR <> '00'

	UPDATE DimTime
	SET StandardTime = '12' + ':' + [Minute] + ':' + [Second] + ' ' + AmPm
	WHERE [HOUR] = '00'


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





	