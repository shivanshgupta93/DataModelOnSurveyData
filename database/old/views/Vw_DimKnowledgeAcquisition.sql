USE [MRP_ROMP]
GO

/****** Object:  View [old].[Vw_DimKnowledgeAcquisition]    Script Date: 2020-04-09 12:46:17 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Script for SelectTopNRows command from SSMS  ******/
CREATE OR ALTER   VIEW old.[Vw_DimKnowledgeAcquisition] AS
SELECT [RESPONDENT_ID]
      ,[Knowledge_Acquisition]
  FROM [MRP_ROMP].[new].[DimKnowledgeAcquisition]
GO


