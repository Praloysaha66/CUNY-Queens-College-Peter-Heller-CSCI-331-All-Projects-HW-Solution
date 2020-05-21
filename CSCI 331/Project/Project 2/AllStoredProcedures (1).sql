---------------------------------------------------------------------
-- Project 2: RECREATE THE BICLASS DATABASE STAR SCHEMA				
-- CSCI 331: Database Systems​										 
-- 7:45 to 9:00 AM​
-- Group 7: Durga Maharjan​, Abida Chowdhury​, Jerry Gao​, Naiem Gafar​,
--			 Praloy Saha​, Seth Marcus​, Efthimios Georgiou
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Using the BIClass Database backup file provided on Blackboard
---------------------------------------------------------------------
Use BIClass
GO


-- ===========================================================
-- Author: NAIEM GAFAR
-- Procedure: [Process].[usp_TrackWorkFlow]
-- Create date: 04-01-20
-- Description:	A stored procedure that is called in every other stored
-- 				procedure that is used to load the star schema. It is used
--				as a benchmark and traces the elapsed time for each load and
--				the specifics about how many rows are affected by the load.
--				It takes in 5 values that are used to populate the [Process].[WorkflowSteps]
-- 				table.
-- ===========================================================
GO
ALTER PROCEDURE [Process].[usp_TrackWorkFlow]
	-- Takes in 4 parameters that are used to populate the WorkflowSteps Table with all the steps we take.
	@WorkFlowDescription NVARCHAR(100),
	-- Describes what this procedure does
	@WorkFlowStepTableRowCount int,
	-- Count of how many rows affected
	@UserAuthorization int,
	-- Which user created this procedure?
	@startTime DATETIME2,
	-- Start time of procedure's execution
	@endTime DATETIME2
-- End time of procedure's execution

AS
BEGIN

	INSERT INTO Process.WorkflowSteps
		(WorkFlowStepDescription, WorkFlowStepTableRowCount, UserAuthorizationKey, StartingDateTime, EndingDateTime)
	VALUES
		(@WorkFlowDescription, @WorkFlowStepTableRowCount, @UserAuthorization, @startTime, @endTime)
END;


-- ===========================================================
-- Author: NAIEM GAFAR
-- Procedure: [Process].[usp_ShowWorkflowSteps]
-- Create date: 04-01-20
-- Description:	Displays the [Process].[WorkflowSteps] after all stored 
-- 				procedures have been called & executed. This allows you
-- 				to confirm that the load was successful, i.e, that all
-- 				of the tables were loaded with their correct values. We also
-- 				can calculate the time elapsed to see which procedures take the longest
-- 				and what the overall execution time is.
-- ===========================================================
GO
ALTER PROCEDURE [Process].[usp_ShowWorkflowSteps]
AS
BEGIN
	select *
	from Process.WorkflowSteps
	select concat(sum(B.time_elapsed), ' MILLISECONDS') as total_time_elapsed
	from
		(select time_elapsed = datediff(MILLISECOND, A.StartingDateTime, A.EndingDateTime)
		from Process.WorkflowSteps as A) as B

END;


-- ===========================================================
-- Author: SETH MARCUS
-- Procedure: [Project2].[AddForeignKeysToStarSchemaData]
-- Create date: 03-29-20
-- Description: Alters each table and adds a contraint
--				which is a foreign key. Each of the 
-- 				foreign keys are named using a very specific 
-- 				formatting: Foreign_Schema_TableName
-- ===========================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [Project2].[AddForeignKeysToStarSchemaData]
	-- Add the parameters for the stored procedure here
	@GroupMemberUserAuthorizationKey int
AS
BEGIN
	ALTER TABLE [CH01-01-Fact].[Data] WITH CHECK ADD CONSTRAINT [Foreign_Data_DimGender]
FOREIGN KEY([Gender]) REFERENCES [CH01-01-Dimension].[DimGender] ([Gender])
	ALTER TABLE [CH01-01-Fact].[Data] CHECK CONSTRAINT [Foreign_Data_DimGender]
	ALTER TABLE [CH01-01-Fact].[Data] WITH CHECK ADD CONSTRAINT [Foreign_Data_DimCustomer]
FOREIGN KEY([CustomerKey]) REFERENCES [CH01-01-Dimension].[DimCustomer] ([CustomerKey])
	ALTER TABLE [CH01-01-Fact].[Data] CHECK CONSTRAINT [Foreign_Data_DimCustomer]
	ALTER TABLE [CH01-01-Fact].[Data] WITH CHECK ADD CONSTRAINT [Foreign_Data_DimMaritalStatus]
FOREIGN KEY([MaritalStatus]) REFERENCES [CH01-01-Dimension].[DimMaritalStatus] ([MaritalStatus])
	ALTER TABLE [CH01-01-Fact].[Data] CHECK CONSTRAINT [Foreign_Data_DimMaritalStatus]
	ALTER TABLE [CH01-01-Fact].[Data] WITH CHECK ADD CONSTRAINT [Foreign_Data_DimOccupation]
FOREIGN KEY([OccupationKey]) REFERENCES [CH01-01-Dimension].[DimOccupation] ([OccupationKey])
	ALTER TABLE [CH01-01-Fact].[Data] CHECK CONSTRAINT [Foreign_Data_DimOccupation]
	ALTER TABLE [CH01-01-Fact].[Data] WITH CHECK ADD CONSTRAINT [Foreign_Data_DimOrderDate]
FOREIGN KEY([OrderDate]) REFERENCES [CH01-01-Dimension].[DimOrderDate] ([OrderDate])
	ALTER TABLE [CH01-01-Fact].[Data] CHECK CONSTRAINT [Foreign_Data_DimOrderDate]
	ALTER TABLE [CH01-01-Fact].[Data] WITH CHECK ADD CONSTRAINT [Foreign_Data_DimTerritory]
FOREIGN KEY([TerritoryKey]) REFERENCES [CH01-01-Dimension].[DimTerritory] ([TerritoryKey])
	ALTER TABLE [CH01-01-Fact].[Data] CHECK CONSTRAINT [Foreign_Data_DimTerritory]
	ALTER TABLE [CH01-01-Fact].[Data] WITH CHECK ADD CONSTRAINT [Foreign_Data_SalesManagers]
FOREIGN KEY([SalesManagerKey]) REFERENCES [CH01-01-Dimension].[SalesManagers] ([SalesManagerKey])
	ALTER TABLE [CH01-01-Fact].[Data] CHECK CONSTRAINT [Foreign_Data_SalesManagers]
	ALTER TABLE [CH01-01-Dimension].[DimProductSubcategory] WITH CHECK ADD CONSTRAINT [Foreign_DimProductSubcategory_DimProductCategory]
FOREIGN KEY([ProductCategoryKey]) REFERENCES [CH01-01-Dimension].[DimProductCategory] ([ProductCategoryKey])
	ALTER TABLE [CH01-01-Dimension].[DimProductSubcategory] CHECK CONSTRAINT [Foreign_DimProductSubcategory_DimProductCategory]
	ALTER TABLE [CH01-01-Dimension].[DimProduct] WITH CHECK ADD CONSTRAINT [Foreign_DimProduct_DimProductSubcategory]
FOREIGN KEY([ProductSubcategoryKey]) REFERENCES [CH01-01-Dimension].[DimProductSubcategory] ([ProductSubcategoryKey])
	ALTER TABLE [CH01-01-Dimension].[DimProduct] CHECK CONSTRAINT [Foreign_DimProduct_DimProductSubcategory]
	ALTER TABLE [CH01-01-Fact].[Data] WITH CHECK ADD CONSTRAINT [Foreign_Data_DimProduct]
FOREIGN KEY([ProductKey]) REFERENCES [CH01-01-Dimension].[DimProduct] ([ProductKey])
	ALTER TABLE [CH01-01-Fact].[Data] CHECK CONSTRAINT [Foreign_Data_DimProduct]
END;


-- ===========================================================
-- Author: SETH MARCUS
-- Procedure: [Project2].[DropForeignKeysFromStarSchemaData]
-- Create date: 03-29-20
-- Description:	Dropping All foreign keys as part of the load
--				process to for referential integrity purposes.
--				This stored procedure undo what is done in the
--				previous stored procedure.
-- ===========================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [Project2].[DropForeignKeysFromStarSchemaData]
	@GroupMemberUserAuthorizationKey INT
AS
BEGIN
	-- Dropping All foreign keys as part of the load process to for referential integrity purposes.
	ALTER TABLE [CH01-01-Fact].[Data]
DROP CONSTRAINT IF EXISTS [Foreign_Data_DimOccupation]
	ALTER TABLE [CH01-01-Fact].[Data]
DROP CONSTRAINT IF EXISTS [Foreign_Data_DimOrderDate]
	ALTER TABLE [CH01-01-Fact].[Data]
DROP CONSTRAINT IF EXISTS [Foreign_Data_DimCustomer]
	ALTER TABLE [CH01-01-Fact].[Data]
DROP CONSTRAINT IF EXISTS [Foreign_Data_DimGender]
	ALTER TABLE [CH01-01-Fact].[Data]
DROP CONSTRAINT IF EXISTS [Foreign_Data_DimMaritalStatus]
	ALTER TABLE [CH01-01-Fact].[Data]
DROP CONSTRAINT IF EXISTS [Foreign_Data_DimProduct]
	ALTER TABLE [CH01-01-Fact].[Data]
DROP CONSTRAINT IF EXISTS [Foreign_Data_DimProductCategory]
	ALTER TABLE [CH01-01-Fact].[Data]
DROP CONSTRAINT IF EXISTS [Foreign_Data_DimTerritory]
	ALTER TABLE [CH01-01-Fact].[Data]
DROP CONSTRAINT IF EXISTS [Foreign_Data_DimProductSubcategory]
	ALTER TABLE [CH01-01-Fact].[Data]
DROP CONSTRAINT IF EXISTS [Foreign_Data_SalesManagers]
	ALTER TABLE [CH01-01-Dimension].DimProduct
DROP CONSTRAINT IF EXISTS [Foreign_DimProduct_DimProductSubcategory]
	ALTER TABLE [CH01-01-Dimension].DimProductSubcategory
DROP CONSTRAINT IF EXISTS [Foreign_DimProductSubcategory_DimProductCategory]
END;


-- ===========================================================
-- Author: Efthimios Georgiou
-- Procedure: [Project2].[Load_DimGender]
-- Create date: 03-30-20
-- Description:	The stored procedure that is used to load
--				data into the [CH01-01-Dimension].[DimGender] table.
--				It only accounts for distinct genders, and
-- 				disregards any duplicate values. There are two
-- 				genders, M (or male) and F (or female).
-- ===========================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [Project2].[Load_DimGender]
	@GroupMemberUserAuthorizationKey INT
AS
BEGIN
	declare @start as datetime2, @end as datetime2;
	set @start = SYSDATETIME()
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	INSERT INTO [CH01-01-Dimension].[DimGender]
		(Gender, GenderDescription)
	SELECT DISTINCT Original.Gender, genderWord = (CASE g.Gender
			WHEN 'M' THEN 'MALE'
			ELSE 'FEMALE' END)
	FROM FileUpload.OriginallyLoadedData AS Original left JOIN
		[CH01-01-Dimension].[DimGender] AS g ON
			g.Gender = Original.Gender

	declare @rowcount as int
	set @rowcount = (select count(*)
	from [CH01-01-Dimension].[DimGender]);
	set @end = SYSDATETIME()
	EXEC [Process].[usp_TrackWorkFlow]
		@WorkFlowDescription = N'Procedure: [Project2].[Load_DimGender] loads data into [CH01-01-Dimension].[DimGender]',
		@WorkFlowStepTableRowCount = @rowcount,
		@UserAuthorization = @GroupMemberUserAuthorizationKey,
		@startTime = @start,
		@endTime = @end
END;


-- ===========================================================
-- Author: Durga Maharjan
-- Procedure: [Project2].[Load_DimMaritalStatus]
-- Create date: 04-01-20
-- Description:	The stored procedure that is used to load
--				data into the [CH01-01-Dimension].[DimMaritalStatus] table.
--				As of now, it only accounts for two statuses, and
-- 				disregards any duplicate values. There are two statuses
-- 				genders, S (or single) and M (or married).
-- ===========================================================
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [Project2].[Load_DimMaritalStatus]
	@GroupMemberUserAuthorizationKey INT
AS
BEGIN
	declare @start as datetime2, @end as datetime2;
	set @start = SYSDATETIME()
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	INSERT INTO [CH01-01-Dimension].[DimMaritalStatus]
		(MaritalStatus, MaritalStatusDescription)
	SELECT DISTINCT Orig.MaritalStatus, statusWord  = (CASE ms.MaritalStatusDescription
			WHEN 'M' THEN 'Married'
			ELSE 'Single' END)
	FROM FileUpload.OriginallyLoadedData AS Orig LEFT JOIN
		[CH01-01-Dimension].[DimMaritalStatus] AS ms ON
			ms.MaritalStatus = Orig.MaritalStatus

	declare @rowcount as int
	set @rowcount = (select count(*)
	from [CH01-01-Dimension].[DimMaritalStatus]);
	set @end = SYSDATETIME()
	EXEC [Process].[usp_TrackWorkFlow]
		@WorkFlowDescription = N'Procedure: [Project2].[Load_DimMaritalStatus] loads data into [CH01-01-Dimension].[DimMaritalStatus]',
		@WorkFlowStepTableRowCount = @rowcount,
		@UserAuthorization = @GroupMemberUserAuthorizationKey,
		@startTime = @start,
		@endTime = @end
END;


-- ===========================================================
-- Author: NAIEM GAFAR
-- Procedure: [Project2].[Load_DimCustomer]
-- Create date: 04-02-20
-- Description:	The stored procedure that is used to load
--				data into the [CH01-01-Dimension].[DimCustomer] table.
--				It only accounts for distinct customer names, and
-- 				disregards any duplicate values.
-- ===========================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [Project2].[Load_DimCustomer]
	@GroupMemberUserAuthorizationKey int
AS
BEGIN
	declare @start as datetime2, @end as datetime2;
	set @start = SYSDATETIME()
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	INSERT INTO [CH01-01-Dimension].[DimCustomer]
		(CustomerName)
	SELECT distinct Original.CustomerName
	FROM FileUpload.OriginallyLoadedData AS Original left JOIN
		[Ch01-01-Dimension].DimCustomer AS New
		ON New.CustomerName = Original.CustomerName;

	declare @rowcount as int
	set @rowcount = (select count(*)
	from [CH01-01-Dimension].[DimCustomer]);
	set @end = SYSDATETIME()
	EXEC [Process].[usp_TrackWorkFlow]
		@WorkFlowDescription = N'Procedure: [Project2].[Load_DimCustomer] loads data into [CH01-01-Dimension].[DimCustomer]',
		@WorkFlowStepTableRowCount = @rowcount,
		@UserAuthorization = @GroupMemberUserAuthorizationKey,
		@startTime = @start,
		@endTime = @end
END;


-- ===========================================================
-- Author: Jerry Gao
-- Procedure: [Project2].[Load_DimOccupation]
-- Create date: 04-02-20
-- Description:	The stored procedure that is used to load
--				data into the [CH01-01-Dimension].[DimOccupation] table.
--				There are 5 types of occupations:
--				Management, Manual, Skilled Manual, Clerical, Professional
-- ===========================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [Project2].[Load_DimOccupation]
	@GroupMemberUserAuthorizationKey INT
AS
BEGIN
	declare @start as datetime2, @end as datetime2;
	set @start = SYSDATETIME()
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	INSERT INTO [CH01-01-Dimension].[DimOccupation]
		(Occupation)
	SELECT DISTINCT A.Occupation
	FROM FileUpload.OriginallyLoadedData AS A left JOIN
		[Ch01-01-Dimension].DimOccupation AS oc
		ON oc.Occupation = A.Occupation;

	declare @rowcount as int
	set @rowcount = (select count(*)
	from [CH01-01-Dimension].[DimOccupation]);
	set @end = SYSDATETIME()
	EXEC [Process].[usp_TrackWorkFlow]
		@WorkFlowDescription = N'Procedure: [Project2].[Load_DimOccupation] loads data into [CH01-01-Dimension].[DimOccupation]',
		@WorkFlowStepTableRowCount = @rowcount,
		@UserAuthorization = @GroupMemberUserAuthorizationKey,
		@startTime = @start,
		@endTime = @end
END;


-- ===========================================================
-- Author: Seth Marcus
-- Procedure: [Project2].[Load_DimOrderDate]
-- Create date: 04-02-20
-- Description:	The stored procedure that is used to load
--				data into the [CH01-01-Dimension].DimOrderDate table.
-- 				It does not account for repeat dates and only shows days
-- 				where atleast 1 sale occurred.
-- ===========================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [Project2].[Load_DimOrderDate]
	@GroupMemberUserAuthorizationKey INT
AS
BEGIN
	declare @start as datetime2, @end as datetime2;
	set @start = SYSDATETIME()
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	insert into [CH01-01-Dimension].DimOrderDate
		(OrderDate, [MonthName], MonthNumber, [Year])
	select DISTINCT A.OrderDate, A.[MonthName], A.MonthNumber, A.[Year]
	from FileUpload.OriginallyLoadedData as A
		left join [CH01-01-Dimension].DimOrderDate as od
		ON od.OrderDate = A.OrderDate
			AND od.MonthNumber = A.MonthNumber
			AND od.[MonthName] = A.[MonthName]
			AND od.[Year] = A.[Year];

	declare @rowcount as int
	set @rowcount = (select count(*)
	from [CH01-01-Dimension].DimOrderDate);
	set @end = SYSDATETIME()
	EXEC [Process].[usp_TrackWorkFlow]
		@WorkFlowDescription = N'Procedure: [Project2].[Load_DimOrderDate] loads data into [CH01-01-Dimension].[DimOrderDate]',
		@WorkFlowStepTableRowCount = @rowcount,
		@UserAuthorization = @GroupMemberUserAuthorizationKey,
		@startTime = @start,
		@endTime = @end
END;


-- ===========================================================
-- Author: Jerry Gao
-- Procedure: [Project2].[Load_DimProductCategory]
-- Create date: 04-04-20
-- Description:	The stored procedure that is used to load
--				data into the [cH01-01-Dimension].DimProductCategory table.
-- ===========================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [Project2].[Load_DimProductCategory]
	@GroupMemberUserAuthorizationKey INT
AS
BEGIN
	declare @start as datetime2, @end as datetime2;
	set @start = SYSDATETIME()
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	insert into [cH01-01-Dimension].DimProductCategory
		(ProductCategory, UserAuthorizationKey)
	select distinct OLD.ProductCategory, @GroupMemberUserAuthorizationKey
	FROM FileUpload.OriginallyLoadedData as OLD
		left join [cH01-01-Dimension].DimProductCategory as NEW
		ON OLD.ProductCategory = NEW.ProductCategory

	declare @rowcount as int
	set @rowcount = (select count(*)
	from [cH01-01-Dimension].DimProductCategory);
	set @end = SYSDATETIME()
	EXEC [Process].[usp_TrackWorkFlow]
		@WorkFlowDescription = N'Procedure: [Project2].[Load_DimProductCategory] loads data into [cH01-01-Dimension].DimProductCategory',
		@WorkFlowStepTableRowCount = @rowcount,
		@UserAuthorization = @GroupMemberUserAuthorizationKey,
		@startTime = @start,
		@endTime = @end

END;


-- ===========================================================
-- Author: Praloy Saha
-- Procedure: [Project2].[Load_DimProductSubcategory]
-- Create date: 04-04-20
-- Description:	The stored procedure that is used to load
--				data into the [CH01-01-Dimension].DimProductSubcategory table.
-- ===========================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [Project2].[Load_DimProductSubcategory]
	@GroupMemberUserAuthorizationKey INT
AS
BEGIN
	declare @start as datetime2, @end as datetime2;
	set @start = SYSDATETIME()
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO [CH01-01-Dimension].DimProductSubcategory
		(ProductSubcategory, ProductCategoryKey, UserAuthorizationKey)
	select distinct OLD.ProductSubcategory, NEW.ProductCategoryKey, @GroupMemberUserAuthorizationKey
	FROM FileUpload.OriginallyLoadedData as OLD
		left join [cH01-01-Dimension].DimProductSubcategory as NEW
		ON OLD.ProductSubcategory = NEW.ProductSubcategory
	declare @rowcount as int
	set @rowcount = (select count(*)
	from [CH01-01-Dimension].DimProductSubcategory);
	set @end = SYSDATETIME()
	EXEC [Process].[usp_TrackWorkFlow]
		@WorkFlowDescription = N'Procedure: [Project2].[Load_DimProductSubcategory] loads data into [CH01-01-Dimension].DimProductSubcategory',
		@WorkFlowStepTableRowCount = @rowcount,
		@UserAuthorization = @GroupMemberUserAuthorizationKey,
		@startTime = @start,
		@endTime = @end
END;


-- ===========================================================
-- Author: Abida Chowdhury
-- Procedure: [Project2].[Load_DimTerritory]
-- Create date: 04-03-20
-- Description:	The stored procedure that is used to load
--				data into the [CH01-01-Dimension].[DimTerritory] table.
-- ===========================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [Project2].[Load_DimTerritory]
	@GroupMemberUserAuthorizationKey INT
AS
BEGIN
	declare @start as datetime2, @end as datetime2;
	set @start = SYSDATETIME()
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	INSERT INTO [CH01-01-Dimension].[DimTerritory]
		(TerritoryGroup, TerritoryCountry, TerritoryRegion)
	SELECT distinct Orig.TerritoryGroup, Orig.TerritoryCountry, Orig.TerritoryRegion
	FROM FileUpload.OriginallyLoadedData AS Orig left JOIN
		[CH01-01-Dimension].[DimTerritory] AS ter
		ON ter.TerritoryCountry = Orig.TerritoryCountry
			AND ter.TerritoryRegion = Orig.TerritoryRegion
			AND ter.TerritoryGroup = Orig.TerritoryGroup;


	declare @rowcount as int
	set @rowcount = (select count(*)
	from [CH01-01-Dimension].[DimTerritory]);
	set @end = SYSDATETIME()
	EXEC [Process].[usp_TrackWorkFlow]
		@WorkFlowDescription = N'Procedure: [Project2].[Load_DimTerritory] loads data into [CH01-01-Dimension].[DimTerritory]',
		@WorkFlowStepTableRowCount = @rowcount,
		@UserAuthorization = @GroupMemberUserAuthorizationKey,
		@startTime = @start,
		@endTime = @end
END;


-- ===========================================================
-- Author: Praloy Saha
-- Procedure: [Project2].[Load_SalesManagers]
-- Create date: 03-31-20
-- Description:	The stored procedure that is used to load
--				data into the [CH01-01-Dimension].[SalesManagers] table.
-- ===========================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [Project2].[Load_SalesManagers]
	@GroupMemberUserAuthorizationKey int
AS
BEGIN
	declare @start as datetime2, @end as datetime2;
	set @start = SYSDATETIME()
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	INSERT INTO [CH01-01-Dimension].[SalesManagers]
		(SalesManager, Category, Office)
	SELECT distinct Original.SalesManager, Category, Office
	FROM FileUpload.OriginallyLoadedData AS Original left JOIN
		[CH01-01-Dimension].[SalesManagers] AS M
		ON M.SalesManager = Original.SalesManager;

	declare @rowcount as int
	set @rowcount = (select count(*)
	from [CH01-01-Dimension].[SalesManagers]);
	set @end = SYSDATETIME()
	EXEC [Process].[usp_TrackWorkFlow]
		@WorkFlowDescription = N'Procedure: [Project2].[Load_SalesManagers] loads data into [CH01-01-Dimension].[SalesManagers]',
		@WorkFlowStepTableRowCount = @rowcount,
		@UserAuthorization = @GroupMemberUserAuthorizationKey,
		@startTime = @start,
		@endTime = @end
END;


-- ===========================================================
-- Author: Efthimios Georgiou
-- Procedure: [Project2].[Load_DimProduct]
-- Create date: 04-01-20
-- Description:	The stored procedure that is used to load
--				data into the [CH01-01-Dimension].[DimProduct] table.
-- 				It loads all of the individual unique products.
-- ===========================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [Project2].[Load_DimProduct]
	@GroupMemberUserAuthorizationKey INT
AS
BEGIN
	declare @start as datetime2, @end as datetime2;
	set @start = SYSDATETIME()
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- 
	SET NOCOUNT ON;
	INSERT INTO [CH01-01-Dimension].[DimProduct]
		(ProductCategory, ProductName, ProductSubcategory, ProductSubCategoryKey, ModelName, ProductCode, Color)
	SELECT fact.ProductCategory, fact.ProductName, fact.ProductSubcategory, sub.ProductSubcategoryKey, fact.ModelName, fact.ProductCode, fact.Color
	FROM [CH01-01-Fact].Data AS fact left JOIN
		[CH01-01-Dimension].[DimProduct] AS prod
		ON prod.ProductCategory = fact.ProductCategory
			AND prod.ProductName = fact.ProductName
			AND prod.Color = fact.Color
			AND prod.ProductSubcategory = fact.ProductSubcategory
			AND prod.ProductCode = fact.ProductCode
			AND prod.ModelName = fact.ModelName left JOIN
		[CH01-01-Dimension].DimProductSubcategory AS sub
		ON prod.ProductSubcategoryKey = sub.ProductSubcategoryKey;

	declare @rowcount as int
	set @rowcount = (select count(*)
	from [CH01-01-Dimension].[DimProduct]);
	set @end = SYSDATETIME()
	EXEC [Process].[usp_TrackWorkFlow]
		@WorkFlowDescription = N'Procedure: [Project2].[Load_DimProduct] loads data into [CH01-01-Dimension].[DimProduct]',
		@WorkFlowStepTableRowCount = @rowcount,
		@UserAuthorization = @GroupMemberUserAuthorizationKey,
		@startTime = @start,
		@endTime = @end
END;


-- ===========================================================
-- Author: Durga Maharjan​
-- Procedure: [Project2].[Load_Data]
-- Create date: 04-05-20
-- Description:	The stored procedure that is used to load
--				data into the [CH01-01-Fact].[Data] table.
-- 				@GroupMemberUserAuthorizationKey is the 
-- 				UserAuthorizationKey of the Group Member who completed 
-- 				this stored procedure. It is a reference to information
--				found in another table called [DbSecurity].[UserAuthorization]
-- ===========================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [Project2].[Load_Data]
	@GroupMemberUserAuthorizationKey int
AS
BEGIN
	declare @start as datetime2, @end as datetime2;
	set @start = SYSDATETIME()
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	insert into [CH01-01-Fact].[Data]
	SELECT SalesKey, SalesManagerKey, occ.OccupationKey, TerritoryKey, ProductKey, CustomerKey,
		Original.ProductCategory, Original.SalesManager, Original.ProductSubcategory, Original.ProductCode,
		Original.ProductName, Original.Color, Original.ModelName, OrderQuantity, UnitPrice, ProductStandardCost,
		SalesAmount, OrderDate, [MonthName], MonthNumber, [YEAR], Original.CustomerName, MaritalStatus,
		Gender, Education, Original.Occupation, Original.TerritoryRegion, Original.TerritoryCountry, Original.TerritoryGroup

	from FileUpload.OriginallyLoadedData as Original left join
		[CH01-01-Dimension].SalesManagers AS SalesManagers
		on Original.SalesManager = SalesManagers.SalesManager
		left join [CH01-01-Dimension].DimTerritory as terr
		on Original.TerritoryCountry = terr.TerritoryCountry
			AND Original.TerritoryGroup = terr.TerritoryGroup
			AND Original.TerritoryRegion = terr.TerritoryRegion
		left join [CH01-01-Dimension].DimProduct AS prod
		ON prod.ProductName = Original.ProductName
		left join [CH01-01-Dimension].DimCustomer as cust
		on cust.CustomerName = Original.CustomerName
		left join [CH01-01-Dimension].DimOccupation as occ
		on occ.Occupation = Original.Occupation

	declare @rowcount as int
	set @rowcount = (select count(*)
	from [CH01-01-Fact].[Data]);
	set @end = SYSDATETIME()
	EXEC [Process].[usp_TrackWorkFlow]
		@WorkFlowDescription = N'Procedure: [Project2].[Load_Data] loads data into [CH01-01-Fact].[Data]',
		@WorkFlowStepTableRowCount = @rowcount,
		@UserAuthorization = @GroupMemberUserAuthorizationKey,
		@startTime = @start,
		@endTime = @end
END;


-- ===========================================================
-- Author: Team Effort
-- Procedure: [Project2].[LoadStarSchemaData]
-- Create date: The date
-- Note: Each stored procedure is paired with a @GroupMemberUserAuthorizationKey that corresponds
--		to the user that created that procedure.
-- Description:	The main stored procedure that is mostly entirely composed
-- 				of calls to other stored procedures. It first drops all of the
-- 				foreign keys for any of the tables using the [Project2].[DropForeignKeysFromStarSchemaData]
--				stored procedure. Then it gets the row count before truncation using the [Project2].[ShowTableStatusRowCount]
-- 				stored procedure. Then it truncates all of the tables, which basically removes
-- 				all rows using the [Project2].[TruncateStarSchemaData] stored procedure. Then it
-- 				calls a load stored procedure for each table to load in its values.  Then it gets an 
--				updated row count after the tbales have been added. Finally it adds the foreign keys.
-- ===========================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [Project2].[LoadStarSchemaData]
-- Add the parameters for the stored procedure here
AS
BEGIN
	SET NOCOUNT ON;

	--
	--	Drop All of the foreign keys prior to truncating tables in the star schema
	--
	EXEC  [Project2].[DropForeignKeysFromStarSchemaData]@GroupMemberUserAuthorizationKey = 6;
	--
	--	Check row count before truncation
	EXEC	[Project2].[ShowTableStatusRowCount]
		@GroupMemberUserAuthorizationKey = 2,  -- Change -1 to the appropriate UserAuthorizationKey
		@TableStatus = N'''Pre truncate of tables'''
	--
	--	Always truncate the Star Schema Data
	--
	EXEC  [Project2].[TruncateStarSchemaData] @GroupMemberUserAuthorizationKey = -1;
	--
	--	Load the star schema
	--
	EXEC  [Project2].[Load_DimProductCategory] @GroupMemberUserAuthorizationKey = 3;
	-- Change -1 to the appropriate UserAuthorizationKey
	EXEC  [Project2].[Load_DimProductSubcategory] @GroupMemberUserAuthorizationKey = 5;
	-- Change -1 to the appropriate UserAuthorizationKey
	EXEC  [Project2].[Load_SalesManagers] @GroupMemberUserAuthorizationKey = 5;
	-- Change -1 to the appropriate UserAuthorizationKey
	EXEC  [Project2].[Load_DimGender] @GroupMemberUserAuthorizationKey = 7;
	-- Change -1 to the appropriate UserAuthorizationKey
	EXEC  [Project2].[Load_DimMaritalStatus] @GroupMemberUserAuthorizationKey = 1;
	-- Change -1 to the appropriate UserAuthorizationKey
	EXEC  [Project2].[Load_DimOccupation] @GroupMemberUserAuthorizationKey = 3;
	-- Change -1 to the appropriate UserAuthorizationKey
	EXEC  [Project2].[Load_DimOrderDate] @GroupMemberUserAuthorizationKey = 6;
	-- Change -1 to the appropriate UserAuthorizationKey
	EXEC  [Project2].[Load_DimTerritory] @GroupMemberUserAuthorizationKey = 2;
	-- Change -1 to the appropriate UserAuthorizationKey
	EXEC  [Project2].[Load_DimCustomer] @GroupMemberUserAuthorizationKey = 4;
	-- Change -1 to the appropriate UserAuthorizationKey
	EXEC  [Project2].[Load_Data] @GroupMemberUserAuthorizationKey = 1;
	-- Change -1 to the appropriate UserAuthorizationKey
	EXEC  [Project2].[Load_DimProduct] @GroupMemberUserAuthorizationKey = 7;
	-- Change -1 to the appropriate UserAuthorizationKey
	--
	--	Recreate all of the foreign keys prior after loading the star schema
	--
	--
	--	Check row count before truncation
	EXEC	[Project2].[ShowTableStatusRowCount]
		@GroupMemberUserAuthorizationKey = 2,  -- Change -1 to the appropriate UserAuthorizationKey
		@TableStatus = N'''Row Count after loading the star schema'''
	--

	EXEC [Project2].[AddForeignKeysToStarSchemaData] @GroupMemberUserAuthorizationKey = 6;
-- Change -1 to the appropriate UserAuthorizationKey
--
END;


-- ===========================================================
-- Author: Abida Chowdhury​
-- Procedure: [Project2].[ShowTableStatusRowCount]
-- Create date: 04-01-20
-- Description:	A method that prints out live updates as the schema
-- 				is being reconstructed. After each table is loaded, it
-- 				returns a message with the table that was loaded and
-- 				the number of rows in that table, before it is truncated
-- 				at the end to remove all rows.
-- ===========================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [Project2].[ShowTableStatusRowCount]
	@GroupMemberUserAuthorizationKey int,
	@TableStatus NVARCHAR(30)

AS
BEGIN
	SET NOCOUNT ON;
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimCustomer', COUNT(*) as numRows
	FROM [CH01-01-Dimension].DimCustomer
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimGender', COUNT(*) as numRows
	FROM [CH01-01-Dimension].DimGender
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimMaritalStatus', COUNT(*) as numRows
	FROM [CH01-01-Dimension].DimMaritalStatus
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimOccupation', COUNT(*) as numRows
	FROM [CH01-01-Dimension].DimOccupation
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimOrderDate', COUNT(*) as numRows
	FROM [CH01-01-Dimension].DimOrderDate
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimProduct', COUNT(*) as numRows
	FROM [CH01-01-Dimension].DimProduct
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimProductCategory', COUNT(*) as numRows
	FROM [CH01-01-Dimension].DimProductCategory
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimProductSubcategory', COUNT(*) as numRows
	FROM [CH01-01-Dimension].DimProductSubcategory
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimTerritory', COUNT(*) as numRows
	FROM [CH01-01-Dimension].DimTerritory
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.SalesManagers', COUNT(*) as numRows
	FROM [CH01-01-Dimension].SalesManagers
	select TableStatus = @TableStatus, TableName ='CH01-01-Fact.Data', COUNT(*) as numRows
	FROM [CH01-01-Fact].Data

END;


-- ===========================================================
-- Author: Team Effort
-- Procedure: [Project2].[TruncateStarSchemaData]
-- Create date: The date
-- Description:	Removes all of the rows from all of the tables, using
--				SQL's truncate command. This will allow us to populate the table
-- 				from fresh using the stored procedures created above.
-- ===========================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [Project2].[TruncateStarSchemaData]
	@GroupMemberUserAuthorizationKey int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	truncate table [CH01-01-Fact].data;
	truncate table [CH01-01-Dimension].SalesManagers;
	truncate table [CH01-01-Dimension].DimProductSubcategory;
	truncate table [CH01-01-Dimension].DimProductCategory;
	truncate table [CH01-01-Dimension].DimGender;
	truncate table [CH01-01-Dimension].DimMaritalStatus;
	truncate table [CH01-01-Dimension].DimOccupation;
	truncate table [CH01-01-Dimension].DimOrderDate;
	truncate table [CH01-01-Dimension].DimTerritory;
	truncate table [CH01-01-Dimension].DimProduct;
	truncate table [CH01-01-Dimension].DimCustomer;
end;
GO