USE [MRP_ROMP]
GO

/****** Object:  Table [old].[DimCommunityInvolvement]    Script Date: 2020-04-09 12:43:26 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE old.[DimCommunityInvolvement](
	[CYCL_TIME_ID] [varchar](10) NULL,
	[RESPONDENT_ID] [bigint] NULL,
	[COMMUNITY_INVOLVEMENT] [varchar](100) NULL
) ON [PRIMARY]
GO


