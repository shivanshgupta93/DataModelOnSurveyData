USE [MRP_ROMP]
GO

/****** Object:  Table [old].[FactRespondent]    Script Date: 2020-04-09 12:45:04 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE old.[FactRespondent](
	[CYCL_TIME_ID] [varchar](10) NULL,
	[RESPONDENT_ID] [bigint] NULL,
	[NAME] [varchar](1000) NULL,
	[STUDENT_TYPE] [varchar](1000) NULL,
	[FINISH_DATE] [varchar](1000) NULL,
	[START_DATE] [varchar](1000) NULL,
	[ROTATION_DAYS] [bigint] NULL,
	[LEVEL_OF_TRAINING] [varchar](1000) NULL,
	[YEAR_IN_PROGRAM] [varchar](1000) NULL,
	[COMMUNITY_CHOICE] [varchar](1000) NULL,
	[ROTATION_ID] [int] NULL,
	[UNIVERSITY_ID] [int] NULL,
	[PRECEPTOR_ID] [int] NULL,
	[COMMUNITY_ID] [int] NULL
) ON [PRIMARY]
GO


