USE [MRP_ROMP]
GO

/****** Object:  Table [old].[DimPreceptor]    Script Date: 2020-04-09 12:43:42 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE old.[DimPreceptor](
	[Cycl_Time_Id] [varchar](10) NULL,
	[Preceptor_Id] [int] NULL,
	[Preceptor] [varchar](1000) NULL
) ON [PRIMARY]
GO


