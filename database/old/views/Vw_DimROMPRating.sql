USE [MRP_ROMP]
GO

/****** Object:  View [old].[Vw_DimROMPRating]    Script Date: 2020-04-09 12:47:20 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Script for SelectTopNRows command from SSMS  ******/
CREATE OR ALTER   VIEW old.[Vw_DimROMPRating] AS
SELECT [RESPONDENT_ID]
      ,[ROMPStaff_Rating]
  FROM [MRP_ROMP].[new].[DimROMPRating]
GO


