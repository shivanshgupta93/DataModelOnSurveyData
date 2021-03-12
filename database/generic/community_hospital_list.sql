USE [MRP_ROMP]
GO

/****** Object:  Table [generic].[community_hospital_list]    Script Date: 2020-04-09 12:39:23 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [generic].[community_hospital_list](
	[Community] [varchar](1000) NULL,
	[Hospital] [varchar](4000) NULL,
	[Location] [varchar](1000) NULL
) ON [PRIMARY]
GO


