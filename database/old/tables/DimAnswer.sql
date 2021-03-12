USE [MRP_ROMP]
GO

/****** Object:  Table [old].[DimAnswer]    Script Date: 2020-04-09 12:43:05 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE old.[DimAnswer](
	[CYCL_TIME_ID] [varchar](10) NULL,
	[ANSWER_ID] [int] NULL,
	[QUESTION_ID] [int] NULL,
	[QUESTION_ANSWER_ID] [bigint] NULL,
	[ANSWER] [varchar](1000) NULL
) ON [PRIMARY]
GO


