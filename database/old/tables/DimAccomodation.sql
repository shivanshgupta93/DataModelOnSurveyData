USE [MRP_ROMP]
GO

/****** Object:  Table [old].[DimAccomodation]    Script Date: 2020-04-09 12:42:48 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE old.[DimAccomodation](
	[CYCL_TIME_ID] [varchar](10) NULL,
	[RESPONDENT_ID] [bigint] NULL,
	[Accomodation_Rating] [varchar](100) NULL
) ON [PRIMARY]
GO


