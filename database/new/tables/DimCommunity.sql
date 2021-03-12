USE [MRP_ROMP]
GO

/****** Object:  Table [new].[DimCommunity]    Script Date: 2020-04-09 12:43:15 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [new].[DimCommunity](
	[Cycl_Time_Id] [varchar](10) NULL,
	[Community_Id] [int] NULL,
	[Community] [varchar](1000) NULL,
	[Hospital] [varchar](4000) NULL
) ON [PRIMARY]
GO


