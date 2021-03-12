USE [MRP_ROMP]
GO

/****** Object:  View [old].[Vw_DimQuestion]    Script Date: 2020-04-09 12:47:01 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   VIEW old.[Vw_DimQuestion] AS
SELECT [QUESTION_ID]
      ,[QUESTION]
  FROM [MRP_ROMP].[new].[DimQuestion]
GO


