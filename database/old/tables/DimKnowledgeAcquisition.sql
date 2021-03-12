USE [MRP_ROMP]
GO

/****** Object:  Table [old].[DimKnowledgeAcquisition]    Script Date: 2020-04-09 12:43:34 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE old.[DimKnowledgeAcquisition](
	[CYCL_TIME_ID] [varchar](10) NULL,
	[RESPONDENT_ID] [bigint] NULL,
	[Knowledge_Acquisition] [varchar](100) NULL
) ON [PRIMARY]
GO


