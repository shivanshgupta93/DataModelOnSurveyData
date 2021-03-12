USE [MRP_ROMP]
GO

/****** Object:  View [new].[Vw_DimQuestion]    Script Date: 2020-04-09 12:47:01 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   VIEW [new].[Vw_DimQuestion] AS
SELECT [QUESTION_ID]
      ,[QUESTION]
  FROM [MRP_ROMP].[new].[DimQuestion]
GO


