USE [MRP_ROMP]
GO

/****** Object:  Table [old].[DimUniversity]    Script Date: 2020-04-09 12:44:55 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE old.[DimUniversity](
	[Cycl_Time_Id] [varchar](10) NULL,
	[University_Id] [int] NULL,
	[University] [varchar](1000) NULL
) ON [PRIMARY]
GO


