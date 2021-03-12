USE [MRP_ROMP]
GO

/****** Object:  View [new].[Vw_DimUniversity]    Script Date: 2020-04-09 12:47:47 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Script for SelectTopNRows command from SSMS  ******/
CREATE OR ALTER   VIEW [new].[Vw_DimUniversity] AS
SELECT [University_Id]
      ,[University]
  FROM [MRP_ROMP].[new].[DimUniversity]
GO


