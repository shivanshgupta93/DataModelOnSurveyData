USE [MRP_ROMP]
GO

/****** Object:  Table [old].[DimPreceptorRating]    Script Date: 2020-04-09 12:43:51 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE old.[DimPreceptorRating](
	[CYCL_TIME_ID] [varchar](10) NULL,
	[RESPONDENT_ID] [bigint] NULL,
	[Preceptor_Rating] [varchar](100) NULL
) ON [PRIMARY]
GO


