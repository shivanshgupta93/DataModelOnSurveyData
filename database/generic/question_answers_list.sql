USE [MRP_ROMP]
GO

/****** Object:  Table [generic].[question_answers_list]    Script Date: 2020-04-09 12:41:16 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [generic].[question_answers_list](
	[TABLE_NAME] [varchar](1000) NULL,
	[QUESTION_HEADING] [varchar](1000) NULL,
	[QUESTION] [varchar](4000) NULL,
	[ANSWER] [varchar](1000) NULL
) ON [PRIMARY]
GO


