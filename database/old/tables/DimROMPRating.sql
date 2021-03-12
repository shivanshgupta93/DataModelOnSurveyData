USE [MRP_ROMP]
GO

/****** Object:  Table [old].[DimROMPRating]    Script Date: 2020-04-09 12:44:25 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE old.[DimROMPRating](
	[CYCL_TIME_ID] [varchar](10) NULL,
	[RESPONDENT_ID] [bigint] NULL,
	[ROMPStaff_Rating] [varchar](100) NULL
) ON [PRIMARY]
GO


