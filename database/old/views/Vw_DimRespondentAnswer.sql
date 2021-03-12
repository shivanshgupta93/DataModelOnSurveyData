USE [MRP_ROMP]
GO

/****** Object:  View [old].[Vw_DimRespondentAnswer]    Script Date: 2020-04-09 12:47:10 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Script for SelectTopNRows command from SSMS  ******/
CREATE OR ALTER   VIEW old.[Vw_DimRespondentAnswer] AS
SELECT [RESPONDENT_ID]
      ,[QUESTION_ANSWER_ID]
  FROM [MRP_ROMP].[new].[DimRespondentAnswer]
GO


