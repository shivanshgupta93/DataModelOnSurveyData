USE [MRP_ROMP]
GO

/****** Object:  View [new].[Vw_FactRespondent]    Script Date: 2020-04-09 12:47:57 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/****** Script for SelectTopNRows command from SSMS  ******/
CREATE OR ALTER     VIEW [new].[Vw_FactRespondent] AS
SELECT [RESPONDENT_ID]
      ,[NAME]
      ,dbo.CamelCase([STUDENT_TYPE]) AS STUDENT_TYPE
      ,[FINISH_DATE]
      ,[START_DATE]
      ,[ROTATION_DAYS]
      ,[LEVEL_OF_TRAINING]
      ,[YEAR_IN_PROGRAM]
      ,[COMMUNITY_CHOICE]
      ,[ROTATION_ID]
      ,[UNIVERSITY_ID]
      ,[PRECEPTOR_ID]
      ,[COMMUNITY_ID]
  FROM [MRP_ROMP].[new].[FactRespondent]
GO


