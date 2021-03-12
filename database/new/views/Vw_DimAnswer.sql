USE [MRP_ROMP]
GO

/****** Object:  View [new].[Vw_DimAnswer]    Script Date: 2020-04-09 12:45:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Script for SelectTopNRows command from SSMS  ******/
CREATE OR ALTER   VIEW [new].[Vw_DimAnswer] AS
SELECT [ANSWER_ID]
      ,[QUESTION_ID]
      ,[QUESTION_ANSWER_ID]
      ,[ANSWER]
  FROM [MRP_ROMP].[new].[DimAnswer]
GO


