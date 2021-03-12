USE [MRP_ROMP]
GO

/****** Object:  Table [new].[DimQuestion]    Script Date: 2020-04-09 12:44:00 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [new].[DimQuestion](
	[CYCL_TIME_ID] [varchar](10) NULL,
	[QUESTION_ID] [int] NULL,
	[QUESTION] [varchar](4000) NULL
) ON [PRIMARY]
GO


