USE [MRP_ROMP]
GO

/****** Object:  Table [new].[DimRotation]    Script Date: 2020-04-09 12:44:35 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [new].[DimRotation](
	[Cycl_Time_Id] [varchar](10) NULL,
	[Rotation_Id] [int] NULL,
	[Rotation] [varchar](1000) NULL
) ON [PRIMARY]
GO


