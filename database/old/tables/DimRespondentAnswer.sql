USE [MRP_ROMP]
GO

/****** Object:  Table [old].[DimRespondentAnswer]    Script Date: 2020-04-09 12:44:12 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE old.[DimRespondentAnswer](
	[CYCL_TIME_ID] [varchar](10) NULL,
	[RESPONDENT_ID] [bigint] NULL,
	[QUESTION_ANSWER_ID] [bigint] NULL
) ON [PRIMARY]
GO


