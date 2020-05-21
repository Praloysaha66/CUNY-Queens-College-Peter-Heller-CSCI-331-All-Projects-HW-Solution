USE [master]
GO

/****** Object:  Database [QueensClassScheduleSpring2017]    Script Date: 5/9/2020 9:35:03 PM ******/
CREATE DATABASE [QueensClassScheduleSpring2017]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'QueensClassSchedule', FILENAME = N'C:\SQLServer2017Media\MSSQL14.MSSQLSERVER\MSSQL\DATA\QueensClassSchedule.mdf' , SIZE = 466944KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'QueensClassSchedule_log', FILENAME = N'C:\SQLServer2017Media\MSSQL14.MSSQLSERVER\MSSQL\DATA\QueensClassSchedule_log.ldf' , SIZE = 3350528KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [QueensClassScheduleSpring2017].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [QueensClassScheduleSpring2017] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [QueensClassScheduleSpring2017] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [QueensClassScheduleSpring2017] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [QueensClassScheduleSpring2017] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [QueensClassScheduleSpring2017] SET ARITHABORT OFF 
GO

ALTER DATABASE [QueensClassScheduleSpring2017] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [QueensClassScheduleSpring2017] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [QueensClassScheduleSpring2017] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [QueensClassScheduleSpring2017] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [QueensClassScheduleSpring2017] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [QueensClassScheduleSpring2017] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [QueensClassScheduleSpring2017] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [QueensClassScheduleSpring2017] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [QueensClassScheduleSpring2017] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [QueensClassScheduleSpring2017] SET  DISABLE_BROKER 
GO

ALTER DATABASE [QueensClassScheduleSpring2017] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [QueensClassScheduleSpring2017] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [QueensClassScheduleSpring2017] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [QueensClassScheduleSpring2017] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [QueensClassScheduleSpring2017] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [QueensClassScheduleSpring2017] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [QueensClassScheduleSpring2017] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [QueensClassScheduleSpring2017] SET RECOVERY FULL 
GO

ALTER DATABASE [QueensClassScheduleSpring2017] SET  MULTI_USER 
GO

ALTER DATABASE [QueensClassScheduleSpring2017] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [QueensClassScheduleSpring2017] SET DB_CHAINING OFF 
GO

ALTER DATABASE [QueensClassScheduleSpring2017] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO

ALTER DATABASE [QueensClassScheduleSpring2017] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO

ALTER DATABASE [QueensClassScheduleSpring2017] SET DELAYED_DURABILITY = DISABLED 
GO

ALTER DATABASE [QueensClassScheduleSpring2017] SET QUERY_STORE = OFF
GO

ALTER DATABASE [QueensClassScheduleSpring2017] SET  READ_WRITE 
GO


USE [QueensClassScheduleSpring2017]
GO

/****** Object:  Table [dbo].[BuildingLocation]    Script Date: 5/9/2020 9:35:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[BuildingLocation](
	[BuildingID] [int] IDENTITY(1,1) NOT NULL,
	[BuildingAcronym] [char](3) NOT NULL,
	[ClassTime] [char](5) NULL,
	[LastName] [varchar](30) NULL,
	[FirstName] [varchar](30) NULL,
	[GroupName] [varchar](30) NULL,
	[DateAdded] [datetime2](7) NOT NULL,
	[DateOfLastUpdate] [datetime2](7) NOT NULL,
	[AuthorizedUserId] [int] NOT NULL,
 CONSTRAINT [PK_BuildingLocation] PRIMARY KEY CLUSTERED 
(
	[BuildingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[BuildingLocation] ADD  CONSTRAINT [DF_BuildingLocation_LastName]  DEFAULT ('Your last name') FOR [LastName]
GO

ALTER TABLE [dbo].[BuildingLocation] ADD  CONSTRAINT [DF_BuildingLocation_FirstName]  DEFAULT ('Your first name') FOR [FirstName]
GO

ALTER TABLE [dbo].[BuildingLocation] ADD  CONSTRAINT [DF_BuildingLocation_GroupName]  DEFAULT ('Your group name') FOR [GroupName]
GO

ALTER TABLE [dbo].[BuildingLocation] ADD  CONSTRAINT [DF_BuildingLocation_DateAdded]  DEFAULT (sysdatetime()) FOR [DateAdded]
GO

ALTER TABLE [dbo].[BuildingLocation] ADD  CONSTRAINT [DF_BuildingLocation_DateOfLastUpdate]  DEFAULT (sysdatetime()) FOR [DateOfLastUpdate]
GO

ALTER TABLE [dbo].[BuildingLocation]  WITH CHECK ADD  CONSTRAINT [ClassTime_Constraint_BuildingLocation] CHECK  (([ClassTime]='7:45' OR [ClassTime]='9:15' OR [ClassTime]='10:45'))
GO

ALTER TABLE [dbo].[BuildingLocation] CHECK CONSTRAINT [ClassTime_Constraint_BuildingLocation]
GO


USE [QueensClassScheduleSpring2017]
GO

/****** Object:  Table [dbo].[Class]    Script Date: 5/9/2020 9:36:08 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Class](
	[DepartmentID] [int] NOT NULL,
	[CourseID] [int] NOT NULL,
	[InstructorID] [int] NOT NULL,
	[Code] [int] NOT NULL,
	[ClassID] [int] IDENTITY(1,1) NOT NULL,
	[BuildingID] [int] NOT NULL,
	[RoomID] [int] NOT NULL,
	[CourseName] [char](15) NOT NULL,
	[Section] [char](4) NOT NULL,
	[Day] [char](20) NOT NULL,
	[StartTime] [nchar](10) NOT NULL,
	[EndTime] [nchar](10) NOT NULL,
	[Hour] [int] NOT NULL,
	[ModeID] [int] NOT NULL,
	[Enrolled] [int] NOT NULL,
	[Limit] [int] NOT NULL,
	[ClassTime] [char](5) NULL,
	[LastName] [varchar](30) NULL,
	[FirstName] [varchar](30) NULL,
	[GroupName] [varchar](30) NULL,
	[DateAdded] [datetime2](7) NOT NULL,
	[DateOfLastUpdated] [datetime2](7) NOT NULL,
	[AuthorizedUserId] [int] NOT NULL,
 CONSTRAINT [PK_Class] PRIMARY KEY CLUSTERED 
(
	[DepartmentID] ASC,
	[CourseID] ASC,
	[InstructorID] ASC,
	[Code] ASC,
	[ClassID] ASC,
	[BuildingID] ASC,
	[RoomID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Class] ADD  CONSTRAINT [DF_Class_DateAdded]  DEFAULT (sysdatetime()) FOR [DateAdded]
GO

ALTER TABLE [dbo].[Class] ADD  CONSTRAINT [DF_Class_DateOfLastUpdated]  DEFAULT (sysdatetime()) FOR [DateOfLastUpdated]
GO

ALTER TABLE [dbo].[Class]  WITH CHECK ADD  CONSTRAINT [ClassTime_Constraint_Class] CHECK  (([ClassTime]='7:45' OR [ClassTime]='9:15' OR [ClassTime]='10:45'))
GO

ALTER TABLE [dbo].[Class] CHECK CONSTRAINT [ClassTime_Constraint_Class]
GO

USE [QueensClassScheduleSpring2017]
GO

/****** Object:  Table [dbo].[Course]    Script Date: 5/9/2020 9:36:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Course](
	[DepartmentID] [int] NOT NULL,
	[CourseID] [int] IDENTITY(1,1) NOT NULL,
	[CourseName] [char](15) NOT NULL,
	[Description] [char](50) NOT NULL,
	[Credit] [char](5) NOT NULL,
	[ClassTime] [char](5) NULL,
	[LastName] [varchar](30) NULL,
	[FirstName] [varchar](30) NULL,
	[GroupName] [varchar](30) NULL,
	[DateAdded] [datetime2](7) NOT NULL,
	[DateOfLastUpdate] [datetime2](7) NOT NULL,
	[AuthorizedUserId] [int] NOT NULL,
 CONSTRAINT [PK_Course] PRIMARY KEY CLUSTERED 
(
	[DepartmentID] ASC,
	[CourseID] ASC,
	[CourseName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Course] ADD  CONSTRAINT [DF_Course_DateAdded]  DEFAULT (sysdatetime()) FOR [DateAdded]
GO

ALTER TABLE [dbo].[Course] ADD  CONSTRAINT [DF_Course_DateOfLastUpdate]  DEFAULT (sysdatetime()) FOR [DateOfLastUpdate]
GO

ALTER TABLE [dbo].[Course]  WITH CHECK ADD  CONSTRAINT [ClassTime_Constraint_Course] CHECK  (([ClassTime]='7:45' OR [ClassTime]='9:15' OR [ClassTime]='10:45'))
GO

ALTER TABLE [dbo].[Course] CHECK CONSTRAINT [ClassTime_Constraint_Course]
GO


USE [QueensClassScheduleSpring2017]
GO

/****** Object:  Table [dbo].[Department]    Script Date: 5/9/2020 9:36:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Department](
	[DepartmentID] [int] IDENTITY(1,1) NOT NULL,
	[DepartmentAcronym] [char](6) NOT NULL,
	[ClassTime] [char](5) NULL,
	[LastName] [varchar](30) NULL,
	[FirstName] [varchar](30) NULL,
	[GroupName] [varchar](30) NULL,
	[DateAdded] [datetime2](7) NOT NULL,
	[DateOfLastUpdate] [datetime2](7) NOT NULL,
	[AuthorizedUserId] [int] NOT NULL,
 CONSTRAINT [PK_Department] PRIMARY KEY CLUSTERED 
(
	[DepartmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Department] ADD  CONSTRAINT [DF_Department_LastName]  DEFAULT ('Your last name') FOR [LastName]
GO

ALTER TABLE [dbo].[Department] ADD  CONSTRAINT [DF_Department_FirstName]  DEFAULT ('Your first name') FOR [FirstName]
GO

ALTER TABLE [dbo].[Department] ADD  CONSTRAINT [DF_Department_GroupName]  DEFAULT ('Your group name') FOR [GroupName]
GO

ALTER TABLE [dbo].[Department] ADD  CONSTRAINT [DF_Department_DateAdded]  DEFAULT (sysdatetime()) FOR [DateAdded]
GO

ALTER TABLE [dbo].[Department] ADD  CONSTRAINT [DF_Department_DateOfLastUpdate]  DEFAULT (sysdatetime()) FOR [DateOfLastUpdate]
GO

ALTER TABLE [dbo].[Department]  WITH CHECK ADD  CONSTRAINT [ClassTime_Constraint_Department] CHECK  (([ClassTime]='7:45' OR [ClassTime]='9:15' OR [ClassTime]='10:45'))
GO

ALTER TABLE [dbo].[Department] CHECK CONSTRAINT [ClassTime_Constraint_Department]
GO

USE [QueensClassScheduleSpring2017]
GO

/****** Object:  Table [dbo].[Instructor]    Script Date: 5/9/2020 9:36:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Instructor](
	[InstructorID] [int] IDENTITY(1,1) NOT NULL,
	[InstrFirstName] [varchar](30) NOT NULL,
	[InstrLastName] [varchar](30) NOT NULL,
	[ClassTime] [char](5) NULL,
	[LastName] [varchar](30) NULL,
	[FirstName] [varchar](30) NULL,
	[GroupName] [varchar](30) NULL,
	[DateAdded] [datetime2](7) NOT NULL,
	[DateOfLastUpdate] [datetime2](7) NOT NULL,
	[AuthorizedUserId] [int] NOT NULL,
 CONSTRAINT [PK_Instructor] PRIMARY KEY NONCLUSTERED 
(
	[InstructorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Instructor] ADD  CONSTRAINT [DF_Instructor_LastName]  DEFAULT ('Your last name') FOR [LastName]
GO

ALTER TABLE [dbo].[Instructor] ADD  CONSTRAINT [DF_Instructor_FirstName]  DEFAULT ('Your first name') FOR [FirstName]
GO

ALTER TABLE [dbo].[Instructor] ADD  CONSTRAINT [DF_Instructor_GroupName]  DEFAULT ('Your group name') FOR [GroupName]
GO

ALTER TABLE [dbo].[Instructor] ADD  CONSTRAINT [DF_Instructor_DateAdded]  DEFAULT (sysdatetime()) FOR [DateAdded]
GO

ALTER TABLE [dbo].[Instructor] ADD  CONSTRAINT [DF_Instructor_DateOfLastUpdate]  DEFAULT (sysdatetime()) FOR [DateOfLastUpdate]
GO

ALTER TABLE [dbo].[Instructor]  WITH CHECK ADD  CONSTRAINT [ClassTime_Constraint_Instructor] CHECK  (([ClassTime]='7:45' OR [ClassTime]='9:15' OR [ClassTime]='10:45'))
GO

ALTER TABLE [dbo].[Instructor] CHECK CONSTRAINT [ClassTime_Constraint_Instructor]
GO


USE [QueensClassScheduleSpring2017]
GO

/****** Object:  Table [dbo].[InstructorDepartment]    Script Date: 5/9/2020 9:37:08 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[InstructorDepartment](
	[InstructorID] [int] NOT NULL,
	[DepartmentID] [int] NOT NULL,
	[ClassTime] [char](5) NULL,
	[LastName] [varchar](30) NULL,
	[FirstName] [varchar](30) NULL,
	[GroupName] [varchar](30) NULL,
	[DateAdded] [datetime2](7) NOT NULL,
	[DateOfLastUpdate] [datetime2](7) NOT NULL,
	[AuthorizedUserId] [int] NOT NULL,
 CONSTRAINT [PK_DepartmentInstructor] PRIMARY KEY CLUSTERED 
(
	[InstructorID] ASC,
	[DepartmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[InstructorDepartment] ADD  CONSTRAINT [DF_InstructorDepartment_DateAdded]  DEFAULT (sysdatetime()) FOR [DateAdded]
GO

ALTER TABLE [dbo].[InstructorDepartment] ADD  CONSTRAINT [DF_InstructorDepartment_DateOfLastUpdate]  DEFAULT (sysdatetime()) FOR [DateOfLastUpdate]
GO

ALTER TABLE [dbo].[InstructorDepartment]  WITH CHECK ADD  CONSTRAINT [ClassTime_Constraint_InstructorDepartment] CHECK  (([ClassTime]='7:45' OR [ClassTime]='9:15' OR [ClassTime]='10:45'))
GO

ALTER TABLE [dbo].[InstructorDepartment] CHECK CONSTRAINT [ClassTime_Constraint_InstructorDepartment]
GO


USE [QueensClassScheduleSpring2017]
GO

/****** Object:  Table [dbo].[Mode]    Script Date: 5/9/2020 9:37:18 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Mode](
	[ModeID] [int] IDENTITY(1,1) NOT NULL,
	[ModeDescription] [varchar](15) NOT NULL,
	[ClassTime] [char](5) NULL,
	[LastName] [varchar](30) NULL,
	[FirstName] [varchar](30) NULL,
	[GroupName] [varchar](30) NULL,
	[DateAdded] [datetime2](7) NOT NULL,
	[DateOfLastUpdated] [datetime2](7) NOT NULL,
	[AuthorizedUserId] [int] NOT NULL,
 CONSTRAINT [PK_Mode] PRIMARY KEY CLUSTERED 
(
	[ModeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Mode] ADD  CONSTRAINT [DF_Mode_DateAdded]  DEFAULT (sysdatetime()) FOR [DateAdded]
GO

ALTER TABLE [dbo].[Mode] ADD  CONSTRAINT [DF_Mode_DateOfLastUpdated]  DEFAULT (sysdatetime()) FOR [DateOfLastUpdated]
GO

ALTER TABLE [dbo].[Mode]  WITH CHECK ADD  CONSTRAINT [ClassTime_Constraint_Mode] CHECK  (([ClassTime]='7:45' OR [ClassTime]='9:15' OR [ClassTime]='10:45'))
GO

ALTER TABLE [dbo].[Mode] CHECK CONSTRAINT [ClassTime_Constraint_Mode]
GO


USE [QueensClassScheduleSpring2017]
GO

/****** Object:  Table [dbo].[RoomLocation]    Script Date: 5/9/2020 9:37:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[RoomLocation](
	[BuildingID] [int] NOT NULL,
	[RoomID] [int] IDENTITY(1,1) NOT NULL,
	[RoomNumber] [char](5) NOT NULL,
	[ClassTime] [char](5) NULL,
	[LastName] [varchar](30) NULL,
	[FirstName] [varchar](30) NULL,
	[GroupName] [varchar](30) NULL,
	[DateAdded] [datetime2](7) NOT NULL,
	[DateOfLastUpdate] [datetime2](7) NOT NULL,
	[AuthorizedUserId] [int] NOT NULL,
 CONSTRAINT [PK_RoomLocation] PRIMARY KEY CLUSTERED 
(
	[BuildingID] ASC,
	[RoomID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[RoomLocation] ADD  CONSTRAINT [DF_RoomLocation_DateAdded]  DEFAULT (sysdatetime()) FOR [DateAdded]
GO

ALTER TABLE [dbo].[RoomLocation] ADD  CONSTRAINT [DF_RoomLocation_DateOfLastUpdate]  DEFAULT (sysdatetime()) FOR [DateOfLastUpdate]
GO

ALTER TABLE [dbo].[RoomLocation]  WITH CHECK ADD  CONSTRAINT [ClassTime_Constraint_RoomLocation] CHECK  (([ClassTime]='7:45' OR [ClassTime]='9:15' OR [ClassTime]='10:45'))
GO

ALTER TABLE [dbo].[RoomLocation] CHECK CONSTRAINT [ClassTime_Constraint_RoomLocation]
GO

USE [QueensClassScheduleSpring2017]
GO

/****** Object:  Table [DbSecurity].[UserAuthorization]    Script Date: 5/9/2020 9:37:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [DbSecurity].[UserAuthorization](
	[UserAuthorizationKey] [int] NOT NULL,
	[ClassTime] [char](5) NULL,
	[individual Project] [nvarchar](60) NULL,
	[GroupMemberLastName] [varchar](30) NOT NULL,
	[GroupMemberFirstName] [varchar](30) NOT NULL,
	[GroupName] [varchar](30) NOT NULL,
	[DateAdded] [datetime2](7) NULL,
	[DateOfLastUpdate] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[UserAuthorizationKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [DbSecurity].[UserAuthorization] ADD  DEFAULT (NEXT VALUE FOR [PkSequence].[UserAuthorization]) FOR [UserAuthorizationKey]
GO

ALTER TABLE [DbSecurity].[UserAuthorization] ADD  DEFAULT ('7:45') FOR [ClassTime]
GO

ALTER TABLE [DbSecurity].[UserAuthorization] ADD  DEFAULT ('PROJECT 3: QueensClassScheduleSpring2017 DB RECONSTRUCTION ') FOR [individual Project]
GO

ALTER TABLE [DbSecurity].[UserAuthorization] ADD  DEFAULT (sysdatetime()) FOR [DateAdded]
GO

ALTER TABLE [DbSecurity].[UserAuthorization] ADD  DEFAULT (sysdatetime()) FOR [DateOfLastUpdate]
GO


USE [QueensClassScheduleSpring2017]
GO

/****** Object:  Table [groupnUploadfile].[CoursesSpring2017]    Script Date: 5/9/2020 9:37:57 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [groupnUploadfile].[CoursesSpring2017](
	[Sec] [varchar](50) NULL,
	[Code] [varchar](50) NULL,
	[Course (hr, crd)] [varchar](50) NULL,
	[Description] [varchar](50) NULL,
	[Day] [varchar](50) NULL,
	[Time] [varchar](50) NULL,
	[Instructor] [varchar](50) NULL,
	[Location] [varchar](50) NULL,
	[Enrolled] [varchar](50) NULL,
	[Limit] [varchar](50) NULL,
	[Mode of Instruction] [varchar](50) NULL
) ON [PRIMARY]
GO

USE [QueensClassScheduleSpring2017]
GO

/****** Object:  Table [Process].[WorkflowSteps]    Script Date: 5/9/2020 9:38:08 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Process].[WorkflowSteps](
	[WorkFlowStepKey] [int] IDENTITY(1,1) NOT NULL,
	[WorkFlowStepDescription] [nvarchar](100) NOT NULL,
	[WorkFlowStepTableRowCount] [int] NULL,
	[StartingDateTime] [datetime2](7) NULL,
	[EndingDateTime] [datetime2](7) NULL,
	[ClassTime] [char](5) NULL,
	[LastName] [varchar](30) NULL,
	[FirstName] [varchar](30) NULL,
	[GroupName] [varchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[WorkFlowStepKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Process].[WorkflowSteps] ADD  DEFAULT ((0)) FOR [WorkFlowStepTableRowCount]
GO

ALTER TABLE [Process].[WorkflowSteps] ADD  DEFAULT (sysdatetime()) FOR [StartingDateTime]
GO

ALTER TABLE [Process].[WorkflowSteps] ADD  DEFAULT (sysdatetime()) FOR [EndingDateTime]
GO

ALTER TABLE [Process].[WorkflowSteps] ADD  DEFAULT ('07:45') FOR [ClassTime]
GO

ALTER TABLE [Process].[WorkflowSteps] ADD  DEFAULT ('Your last name') FOR [LastName]
GO

ALTER TABLE [Process].[WorkflowSteps] ADD  DEFAULT ('Your first name') FOR [FirstName]
GO

ALTER TABLE [Process].[WorkflowSteps] ADD  DEFAULT ('Your group name') FOR [GroupName]
GO


USE [QueensClassScheduleSpring2017]
GO

/****** Object:  Table [dbo].[sysdiagrams]    Script Date: 5/9/2020 9:38:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[sysdiagrams](
	[name] [sysname] NOT NULL,
	[principal_id] [int] NOT NULL,
	[diagram_id] [int] IDENTITY(1,1) NOT NULL,
	[version] [int] NULL,
	[definition] [varbinary](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[diagram_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_principal_name] UNIQUE NONCLUSTERED 
(
	[principal_id] ASC,
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'microsoft_database_tools_support', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sysdiagrams'
GO


USE [QueensClassScheduleSpring2017]
GO

/****** Object:  StoredProcedure [Process].[usp_ShowWorkflowSteps]    Script Date: 5/9/2020 9:38:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [Process].[usp_ShowWorkflowSteps]
AS
BEGIN
    select *
    from Process.WorkflowSteps
    select concat(sum(B.time_elapsed), ' MILLISECONDS') as total_time_elapsed
    from
        (select time_elapsed = datediff(MILLISECOND, A.StartingDateTime, A.EndingDateTime)
        from Process.WorkflowSteps as A) as B

END;
GO


USE [QueensClassScheduleSpring2017]
GO

/****** Object:  StoredProcedure [Process].[usp_TrackWorkFlow]    Script Date: 5/9/2020 9:39:08 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [Process].[usp_TrackWorkFlow]
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
        (WorkFlowStepDescription, WorkFlowStepTableRowCount, StartingDateTime, EndingDateTime, ClassTime, LastName, FirstName, GroupName)
    VALUES
        (@WorkFlowDescription, @WorkFlowStepTableRowCount, @startTime, @endTime,
            (SELECT ClassTime
            FROM DbSecurity.UserAuthorization
            where UserAuthorizationKey = @UserAuthorization),
            (SELECT GroupMemberLastName
            FROM DbSecurity.UserAuthorization
            where UserAuthorizationKey = @UserAuthorization),
            (SELECT GroupMemberFirstName
            FROM DbSecurity.UserAuthorization
            where UserAuthorizationKey = @UserAuthorization),
            (SELECT GroupName
            FROM DbSecurity.UserAuthorization
            where UserAuthorizationKey = @UserAuthorization));
END;


-- ===========================================================
-- Author: NAIEM GAFAR
-- Procedure: [Process].[usp_ShowWorkflowSteps]
-- Create date: 05-03-20
-- Description:	Displays the [Process].[WorkflowSteps] after all stored 
-- 				procedures have been called & executed. This allows you
-- 				to confirm that the load was successful, i.e, that all
-- 				of the tables were loaded with their correct values. We also
-- 				can calculate the time elapsed to see which procedures take the longest
-- 				and what the overall execution time is.
-- ===========================================================
GO

USE [QueensClassScheduleSpring2017]
GO

/****** Object:  StoredProcedure [Project3_SP].[AddForeignKeysToData]    Script Date: 5/9/2020 9:41:18 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Project3_SP].[AddForeignKeysToData]
	-- Add the parameters for the stored procedure here
	@GroupMemberUserAuthorizationKey INT
AS
BEGIN
	ALTER TABLE [dbo].[Class]
		WITH CHECK ADD CONSTRAINT [FK_156] FOREIGN KEY ([InstructorID]) REFERENCES [dbo].[Instructor]([InstructorID]) ON
	DELETE CASCADE
	ALTER TABLE [dbo].[Class] CHECK CONSTRAINT [FK_156]

	ALTER TABLE [dbo].[Class]
		WITH CHECK ADD CONSTRAINT [FK_41] FOREIGN KEY ([ModeID]) REFERENCES [dbo].[Mode]([ModeID]) ON
	DELETE CASCADE
	ALTER TABLE [dbo].[Class] CHECK CONSTRAINT [FK_41]

	ALTER TABLE [dbo].[Class]
		WITH CHECK ADD CONSTRAINT [FK_77] FOREIGN KEY (
				[DepartmentID]
				,[CourseID]
				,[CourseName]
				) REFERENCES [dbo].[Course]([DepartmentID], [CourseID], [CourseName]) ON
	DELETE CASCADE
	ALTER TABLE [dbo].[Class] CHECK CONSTRAINT [FK_77]

	ALTER TABLE [dbo].[Class]
		WITH CHECK ADD CONSTRAINT [FK_1000] FOREIGN KEY (
				[BuildingId],
				[RoomId]
				) REFERENCES [dbo].[RoomLocation]([BuildingId], [RoomId]) ON
	DELETE CASCADE
	ALTER TABLE [dbo].[Class] CHECK CONSTRAINT [FK_1000]

	ALTER TABLE [dbo].[Course]  
		WITH CHECK ADD  CONSTRAINT [FK_38] FOREIGN KEY([DepartmentID]) REFERENCES [dbo].[Department] ([DepartmentID])ON 
		DELETE CASCADE
	ALTER TABLE [dbo].[Course] CHECK CONSTRAINT [FK_38]


	ALTER TABLE [dbo].[InstructorDepartment]  
		WITH CHECK ADD  CONSTRAINT [FK_63] FOREIGN KEY([DepartmentID]) REFERENCES [dbo].[Department] ([DepartmentID]) ON 
		DELETE CASCADE
	ALTER TABLE [dbo].[InstructorDepartment] CHECK CONSTRAINT [FK_63]


	ALTER TABLE [dbo].[InstructorDepartment]  
		WITH CHECK ADD  CONSTRAINT [FK_67] FOREIGN KEY([InstructorID]) REFERENCES [dbo].[Instructor] ([InstructorID]) ON 
		DELETE CASCADE
	ALTER TABLE [dbo].[InstructorDepartment] CHECK CONSTRAINT [FK_67]

	ALTER TABLE [dbo].[RoomLocation]  
		WITH CHECK ADD  CONSTRAINT [FK_33] FOREIGN KEY([BuildingID]) REFERENCES [dbo].[BuildingLocation] ([BuildingID]) ON 
		DELETE CASCADE
	ALTER TABLE [dbo].[RoomLocation] CHECK CONSTRAINT [FK_33]

END;
GO


USE [QueensClassScheduleSpring2017]
GO

/****** Object:  StoredProcedure [Project3_SP].[DropForeignKeysFromData]    Script Date: 5/9/2020 9:42:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Project3_SP].[DropForeignKeysFromData]
	@GroupMemberUserAuthorizationKey INT
AS
BEGIN
	-- Dropping All foreign keys as part of the load process to for referential integrity purposes.
	ALTER TABLE dbo.class
DROP CONSTRAINT IF EXISTS fk_156
	ALTER TABLE dbo.class
DROP CONSTRAINT IF EXISTS fk_41
	ALTER TABLE dbo.class
DROP CONSTRAINT IF EXISTS fk_77
	ALTER TABLE dbo.Course
DROP CONSTRAINT IF EXISTS fk_38
	ALTER TABLE dbo.InstructorDepartment
DROP CONSTRAINT IF EXISTS fk_63
	ALTER TABLE dbo.InstructorDepartment
DROP CONSTRAINT IF EXISTS fk_67
	ALTER TABLE dbo.RoomLocation
DROP CONSTRAINT IF EXISTS fk_33
	ALTER TABLE dbo.class
DROP CONSTRAINT IF EXISTS fk_1000
	
END;
GO


USE [QueensClassScheduleSpring2017]
GO

/****** Object:  StoredProcedure [Project3_SP].[Load_BuildingLocation]    Script Date: 5/9/2020 9:42:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [Project3_SP].[Load_BuildingLocation]
    @GroupMemberUserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;
    declare @start as datetime2, @end as datetime2;
    set @start = SYSDATETIME()

    INSERT INTO [dbo].BuildingLocation
        (BuildingAcronym, AuthorizedUserId)
    select distinct
        REPLACE(LEFT([Location], CHARINDEX(' ', [Location])), ' ', ''),
        @GroupMemberUserAuthorizationKey
    FROM groupnUploadfile.CoursesSpring2017;
    update [dbo].BuildingLocation
    SET
    ClassTime = SEC.ClassTime,
    LastName = SEC.GroupMemberLastName,
    FirstName = SEC.GroupMemberFirstName, 
    GroupName = SEC.GroupName
    from [dbo].BuildingLocation
        inner join DbSecurity.UserAuthorization as SEC
        on SEC.UserAuthorizationKey = @GroupMemberUserAuthorizationKey;

    declare @rowcount as int
    set @rowcount = (select count(*)
    from [dbo].BuildingLocation);
    set @end = SYSDATETIME();

    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowDescription = 'Populate BuildingLocation Table',
        @WorkFlowStepTableRowCount = @rowcount,
        @UserAuthorization = @GroupMemberUserAuthorizationKey,
        @startTime = @start,
        @endTime = @end

END;



GO


USE [QueensClassScheduleSpring2017]
GO

/****** Object:  StoredProcedure [Project3_SP].[Load_Class]    Script Date: 5/9/2020 9:42:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [Project3_SP].[Load_Class]
    @GroupMemberUserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;
    declare @start as datetime2, @end as datetime2;
    set @start = SYSDATETIME()

    INSERT INTO [dbo].Class
        ([DepartmentID], Code, CourseID, InstructorID, BuildingID, RoomID,
        Day, [StartTime], [EndTime], [hour], enrolled, limit, ModeID, Section,
        CourseName, AuthorizedUserId)
    select distinct
        D.DepartmentID, Code, C.CourseID, I.InstructorID, BL.BuildingID, RL.RoomID, [Day],
        REPLACE(left([Time], CHARINDEX('-', [Time])), '-', ''),
        REPLACE(right([Time], CHARINDEX('-', [Time])), '-', ''),
        SUBSTRING([Course (hr, crd)], CHARINDEX(')', [Course (hr, crd)])-1, 1),
        enrolled, [limit], M.ModeID, Sec, C.CourseName,
        @GroupMemberUserAuthorizationKey
    FROM groupnUploadfile.CoursesSpring2017
        left join dbo.department as D
        on(LEFT([Course (hr, crd)], CHARINDEX(' ', [Course (hr, crd)])) = D.DepartmentAcronym)
        left join dbo.Instructor as I
        on (RIGHT(Instructor, len(Instructor)-charindex(',', Instructor)) = I.InstrFirstName and LEFT(Instructor, CHARINDEX(',', Instructor)-1) = I.InstrLastName)
        left join dbo.BuildingLocation as BL
        on REPLACE(LEFT([Location], CHARINDEX(' ', [Location])), ' ', '') = BL.BuildingAcronym
        left join dbo.RoomLocation as RL
        on REPLACE(RIGHT([Location], CHARINDEX(' ', [Location])+1), ' ', '') = RL.RoomNumber
        left JOIN dbo.Mode as M
        on M.ModeDescription = [Mode of Instruction]
        left join dbo.Course as C
        on LEFT([Course (hr, crd)], CHARINDEX('(', [Course (hr, crd)])-1) = C.CourseName
    update [dbo].Class
    SET
    ClassTime = SEC.ClassTime,
    LastName = SEC.GroupMemberLastName,
    FirstName = SEC.GroupMemberFirstName, 
    GroupName = SEC.GroupName
    from [dbo].Class
        inner join DbSecurity.UserAuthorization as SEC
        on SEC.UserAuthorizationKey = @GroupMemberUserAuthorizationKey;

    declare @rowcount as int
    set @rowcount = (select count(*)
    from [dbo].Class);
    set @end = SYSDATETIME();

    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowDescription = 'Populate Class Table',
        @WorkFlowStepTableRowCount = @rowcount,
        @UserAuthorization = @GroupMemberUserAuthorizationKey,
        @startTime = @start,
        @endTime = @end

END;


-- ===========================================================
--                  TESTING STORED PROCEDURES
-- ===========================================================


GO

USE [QueensClassScheduleSpring2017]
GO

/****** Object:  StoredProcedure [Project3_SP].[Load_Course]    Script Date: 5/9/2020 9:43:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [Project3_SP].[Load_Course]
    @GroupMemberUserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;
    declare @start as datetime2, @end as datetime2;
    set @start = SYSDATETIME()

    INSERT INTO [dbo].Course
        (DepartmentID, [Description], CourseName, Credit, AuthorizedUserId)
    select distinct
        DepartmentID,
        [Description],
        LEFT([Course (hr, crd)], CHARINDEX('(', [Course (hr, crd)])-1),
        REPLACE(SUBSTRING([Course (hr, crd)], CHARINDEX('(', [Course (hr, crd)])+1, 2), ',',''),
        @GroupMemberUserAuthorizationKey
    from groupnUploadfile.CoursesSpring2017
        left join dbo.Department as D
        on(LEFT([Course (hr, crd)], CHARINDEX(' ', [Course (hr, crd)])) = D.DepartmentAcronym)
    update [dbo].[Course]
    SET
    ClassTime = SEC.ClassTime,
    LastName = SEC.GroupMemberLastName,
    FirstName = SEC.GroupMemberFirstName, 
    GroupName = SEC.GroupName
    from [dbo].Course
        inner join DbSecurity.UserAuthorization as SEC
        on SEC.UserAuthorizationKey = @GroupMemberUserAuthorizationKey;

    declare @rowcount as int
    set @rowcount = (select count(*)
    from [dbo].Course);
    set @end = SYSDATETIME();

    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowDescription = 'Populate Course Table',
        @WorkFlowStepTableRowCount = @rowcount,
        @UserAuthorization = @GroupMemberUserAuthorizationKey,
        @startTime = @start,
        @endTime = @end

END;


-- ===========================================================
-- Author: YOUR NAME HERE
-- Procedure: [Project3_SP].[Load_Class]
-- Create date: 05-03-2020
-- Description:	 Populate the dbo.Class table.
-- ===========================================================
GO


USE [QueensClassScheduleSpring2017]
GO

/****** Object:  StoredProcedure [Project3_SP].[Load_Department]    Script Date: 5/9/2020 9:43:55 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [Project3_SP].[Load_Department]
    @GroupMemberUserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;
    declare @start as datetime2, @end as datetime2;
    set @start = SYSDATETIME()
    INSERT INTO [dbo].Department
        (DepartmentAcronym, AuthorizedUserId)
    select distinct
        LEFT([Course (hr, crd)], CHARINDEX(' ', [Course (hr, crd)])),
        @GroupMemberUserAuthorizationKey
    FROM groupnUploadfile.CoursesSpring2017;
    update [dbo].Department
    
    SET
    ClassTime = SEC.ClassTime,
    LastName = SEC.GroupMemberLastName,
    FirstName = SEC.GroupMemberFirstName, 
    GroupName = SEC.GroupName
    from [dbo].Department
        inner join DbSecurity.UserAuthorization as SEC
        on SEC.UserAuthorizationKey = @GroupMemberUserAuthorizationKey;

    declare @rowcount as int
    set @rowcount = (select count(*)
    from [dbo].Department);
    set @end = SYSDATETIME();

    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowDescription = 'Populate Department Table',
        @WorkFlowStepTableRowCount = @rowcount,
        @UserAuthorization = @GroupMemberUserAuthorizationKey,
        @startTime = @start,
        @endTime = @end

END;


-- ===========================================================
-- Author: YOUR NAME HERE
-- Procedure: [Project3_SP].[Load_BuildingLocation]
-- Create date: 05-03-2020
-- Description:	 Populate the dbo.BuildingLocation table.
-- ===========================================================
GO


USE [QueensClassScheduleSpring2017]
GO

/****** Object:  StoredProcedure [Project3_SP].[Load_Instructor]    Script Date: 5/9/2020 9:44:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [Project3_SP].[Load_Instructor]
    @GroupMemberUserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;
    declare @start as datetime2, @end as datetime2;
    set @start = SYSDATETIME()

    INSERT INTO [dbo].Instructor
        (InstrFirstName, InstrLastName, AuthorizedUserId)
    select distinct
        RIGHT(Instructor, len(Instructor)-charindex(',', Instructor)),
        LEFT(Instructor, CHARINDEX(',', Instructor)-1),
        @GroupMemberUserAuthorizationKey
    FROM groupnUploadfile.CoursesSpring2017;
    update [dbo].Instructor
    SET
    ClassTime = SEC.ClassTime,
    LastName = SEC.GroupMemberLastName,
    FirstName = SEC.GroupMemberFirstName, 
    GroupName = SEC.GroupName
    from dbo.Instructor
        inner join DbSecurity.UserAuthorization as SEC
        on SEC.UserAuthorizationKey = @GroupMemberUserAuthorizationKey;

    declare @rowcount as int
    set @rowcount = (select count(*)
    from [dbo].Instructor);
    set @end = SYSDATETIME();

    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowDescription = 'Populate Instructor Table',
        @WorkFlowStepTableRowCount = @rowcount,
        @UserAuthorization = @GroupMemberUserAuthorizationKey,
        @startTime = @start,
        @endTime = @end
END;


-- ===========================================================
-- Author: YOUR NAME HERE
-- Procedure: [Project3_SP].[Load_Department]
-- Create date: 05-03-2020
-- Description:	 Populate the dbo.Department table.
-- ===========================================================
GO


USE [QueensClassScheduleSpring2017]
GO

/****** Object:  StoredProcedure [Project3_SP].[Load_InstructorDepartment]    Script Date: 5/9/2020 9:44:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [Project3_SP].[Load_InstructorDepartment]
    @GroupMemberUserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;
    declare @start as datetime2, @end as datetime2;
    set @start = SYSDATETIME()

    INSERT INTO [dbo].InstructorDepartment
        (InstructorID, DepartmentID, AuthorizedUserId)
    select distinct I.InstructorID, D.DepartmentID, @GroupMemberUserAuthorizationKey
    from
        groupnUploadfile.CoursesSpring2017
        left JOIN
        dbo.Instructor as I
        on (RIGHT(Instructor, len(Instructor)-charindex(',', Instructor)) = I.InstrFirstName and LEFT(Instructor, CHARINDEX(',', Instructor)-1) = I.InstrLastName)
        left JOIN
        dbo.Department as D
        on(LEFT([Course (hr, crd)], CHARINDEX(' ', [Course (hr, crd)])) = D.DepartmentAcronym)
    order by I.InstructorID ASC;
    update [dbo].[InstructorDepartment]
    SET
    ClassTime = SEC.ClassTime,
    LastName = SEC.GroupMemberLastName,
    FirstName = SEC.GroupMemberFirstName, 
    GroupName = SEC.GroupName
    from [dbo].Mode
        inner join DbSecurity.UserAuthorization as SEC
        on SEC.UserAuthorizationKey = @GroupMemberUserAuthorizationKey;

    declare @rowcount as int
    set @rowcount = (select count(*)
    from [dbo].InstructorDepartment);
    set @end = SYSDATETIME();

    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowDescription = 'Populate InstructorDepartment Table',
        @WorkFlowStepTableRowCount = @rowcount,
        @UserAuthorization = @GroupMemberUserAuthorizationKey,
        @startTime = @start,
        @endTime = @end

END;


-- ===========================================================
-- Author: YOUR NAME HERE
-- Procedure: [Project3_SP].[Load_RoomLocation]
-- Create date: 05-03-2020
-- Description:	 Populate the dbo.RoomLocation table.
-- ===========================================================
GO


USE [QueensClassScheduleSpring2017]
GO

/****** Object:  StoredProcedure [Project3_SP].[Load_Mode]    Script Date: 5/9/2020 9:44:38 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [Project3_SP].[Load_Mode]
    @GroupMemberUserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;
    declare @start as datetime2, @end as datetime2;
    set @start = SYSDATETIME()

    INSERT INTO [dbo].Mode
        (ModeDescription, AuthorizedUserId)
    select distinct
        [Mode of Instruction],
        @GroupMemberUserAuthorizationKey
    FROM groupnUploadfile.CoursesSpring2017;
    update [dbo].Mode
    SET
    ClassTime = SEC.ClassTime,
    LastName = SEC.GroupMemberLastName,
    FirstName = SEC.GroupMemberFirstName, 
    GroupName = SEC.GroupName
    from [dbo].Mode
        inner join DbSecurity.UserAuthorization as SEC
        on SEC.UserAuthorizationKey = @GroupMemberUserAuthorizationKey;

    declare @rowcount as int
    set @rowcount = (select count(*)
    from [dbo].Mode);
    set @end = SYSDATETIME();

    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowDescription = 'Populate Mode Table',
        @WorkFlowStepTableRowCount = @rowcount,
        @UserAuthorization = @GroupMemberUserAuthorizationKey,
        @startTime = @start,
        @endTime = @end

END;


-- ===========================================================
-- Author: YOUR NAME HERE
-- Procedure: [Project3_SP].[Load_InstructorDepartment]
-- Create date: 05-03-2020
-- Description:	 Populate the dbo.InstructorDepartment table.
-- ===========================================================
GO


USE [QueensClassScheduleSpring2017]
GO

/****** Object:  StoredProcedure [Project3_SP].[Load_RoomLocation]    Script Date: 5/9/2020 9:44:49 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [Project3_SP].[Load_RoomLocation]
    @GroupMemberUserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;
    declare @start as datetime2, @end as datetime2;
    set @start = SYSDATETIME()

    INSERT INTO [dbo].RoomLocation
        (BuildingID, RoomNumber, AuthorizedUserId)
    select distinct BL.BuildingID, REPLACE(RIGHT([Location], CHARINDEX(' ', [Location])+1), ' ', ''), @GroupMemberUserAuthorizationKey
    from
        groupnUploadfile.CoursesSpring2017
        left join dbo.BuildingLocation as BL
        on REPLACE(LEFT([Location], CHARINDEX(' ', [Location])), ' ', '') = BL.BuildingAcronym;
    update [dbo].[RoomLocation]
    SET
    ClassTime = SEC.ClassTime,
    LastName = SEC.GroupMemberLastName,
    FirstName = SEC.GroupMemberFirstName, 
    GroupName = SEC.GroupName
    from [dbo].RoomLocation
        inner join DbSecurity.UserAuthorization as SEC
        on SEC.UserAuthorizationKey = @GroupMemberUserAuthorizationKey;

    declare @rowcount as int
    set @rowcount = (select count(*)
    from [dbo].RoomLocation);
    set @end = SYSDATETIME();

    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowDescription = 'Populate RoomLocation Table',
        @WorkFlowStepTableRowCount = @rowcount,
        @UserAuthorization = @GroupMemberUserAuthorizationKey,
        @startTime = @start,
        @endTime = @end

END;


-- ===========================================================
-- Author: YOUR NAME HERE
-- Procedure: [Project3_SP].[Load_Course]
-- Create date: 05-03-2020
-- Description:	 Populate the dbo.Course table.
-- ===========================================================
GO


USE [QueensClassScheduleSpring2017]
GO

/****** Object:  StoredProcedure [Project3_SP].[LoadData]    Script Date: 5/9/2020 9:44:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Project3_SP].[LoadData]
-- Add the parameters for the stored procedure here
@GroupMemberUserAuthorizationKey int
AS
BEGIN
	SET NOCOUNT ON;

	--
	--	Drop All of the foreign keys prior to truncating tables in the star schema
	--
	EXEC  [Project3_SP].[DropForeignKeysFromData]@GroupMemberUserAuthorizationKey = 6;
	--
	--	Check row count before truncation
	EXEC	[Project3_SP].[ShowTableStatusRowCount]
		@GroupMemberUserAuthorizationKey = 2,  -- Change -1 to the appropriate UserAuthorizationKey
		@TableStatus = N'''Pre truncate of tables'''
	--
	--	Always truncate the Star Schema Data
	--
	EXEC  [Project3_SP].[TruncateData] @GroupMemberUserAuthorizationKey = 6;
	--
	--	Load the star schema
	--
	EXEC  [Project3_SP].[Load_Mode] @GroupMemberUserAuthorizationKey = 3;
	-- Change -1 to the appropriate UserAuthorizationKey
	EXEC  [Project3_SP].[Load_BuildingLocation] @GroupMemberUserAuthorizationKey = 5;
	-- Change -1 to the appropriate UserAuthorizationKey
	EXEC  [Project3_SP].[Load_Instructor] @GroupMemberUserAuthorizationKey = 1;
	-- Change -1 to the appropriate UserAuthorizationKey
	EXEC  [Project3_SP].[Load_Department] @GroupMemberUserAuthorizationKey = 3;
	-- Change -1 to the appropriate UserAuthorizationKey
	EXEC  [Project3_SP].[Load_RoomLocation] @GroupMemberUserAuthorizationKey = 6;
	-- Change -1 to the appropriate UserAuthorizationKey
	EXEC  [Project3_SP].[Load_Course] @GroupMemberUserAuthorizationKey = 2;
	-- Change -1 to the appropriate UserAuthorizationKey
	EXEC  [Project3_SP].[Load_InstructorDepartment] @GroupMemberUserAuthorizationKey = 4;
	-- Change -1 to the appropriate UserAuthorizationKey
	EXEC  [Project3_SP].[Load_Class] @GroupMemberUserAuthorizationKey = 1;
	-- Change -1 to the appropriate UserAuthorizationKey
	
	--
	--	Check row count before truncation
	EXEC [Project3_SP].[ShowTableStatusRowCount]
		@GroupMemberUserAuthorizationKey = 2,  -- Change -1 to the appropriate UserAuthorizationKey
		@TableStatus = N'''Row Count after loading the star schema'''
	--

	EXEC [Project3_SP].[AddForeignKeysToData] @GroupMemberUserAuthorizationKey = 6;
-- Change -1 to the appropriate UserAuthorizationKey
--
END;
GO


USE [QueensClassScheduleSpring2017]
GO

/****** Object:  StoredProcedure [Project3_SP].[ShowTableStatusRowCount]    Script Date: 5/9/2020 9:45:10 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Project3_SP].[ShowTableStatusRowCount]
	@GroupMemberUserAuthorizationKey int,
	@TableStatus NVARCHAR(30)

AS
BEGIN
	SET NOCOUNT ON;
	select TableStatus = @TableStatus, TableName ='dbo.BuildingLocation', COUNT(*) as numRows
	FROM dbo.BuildingLocation
	select TableStatus = @TableStatus, TableName ='dbo.Class', COUNT(*) as numRows
	FROM dbo.Class
	select TableStatus = @TableStatus, TableName ='dbo.Course', COUNT(*) as numRows
	FROM dbo.Course
	select TableStatus = @TableStatus, TableName ='dbo.Department', COUNT(*) as numRows
	FROM dbo.Department
	select TableStatus = @TableStatus, TableName ='dbo.Instructor', COUNT(*) as numRows
	FROM dbo.Instructor
	select TableStatus = @TableStatus, TableName ='dbo.InstructorDepartment', COUNT(*) as numRows
	FROM dbo.InstructorDepartment
	select TableStatus = @TableStatus, TableName ='dbo.Mode', COUNT(*) as numRows
	FROM dbo.Mode
	select TableStatus = @TableStatus, TableName ='dbo.RoomLocation', COUNT(*) as numRows
	FROM dbo.RoomLocation
	select TableStatus = @TableStatus, TableName ='groupnUploadfile.CoursesSpring2017', COUNT(*) as numRows
	FROM groupnUploadfile.CoursesSpring2017

END;
GO


USE [QueensClassScheduleSpring2017]
GO

/****** Object:  StoredProcedure [Project3_SP].[TruncateData]    Script Date: 5/9/2020 9:45:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Project3_SP].[TruncateData]
	@GroupMemberUserAuthorizationKey int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	truncate table dbo.BuildingLocation;
	truncate table dbo.Class;
	truncate table dbo.Course;
	truncate table dbo.Department;
	truncate table dbo.Instructor;
	truncate table dbo.InstructorDepartment;
	truncate table dbo.Mode
	truncate table dbo.RoomLocation
end;
GO


USE [QueensClassScheduleSpring2017]
GO

USE [QueensClassScheduleSpring2017]
GO

/****** Object:  Sequence [PkSequence].[UserAuthorization]    Script Date: 5/9/2020 9:45:57 PM ******/
CREATE SEQUENCE [PkSequence].[UserAuthorization] 
 AS [bigint]
 START WITH 1
 INCREMENT BY 1
 MINVALUE -9223372036854775808
 MAXVALUE 9223372036854775807
 CACHE 
GO








