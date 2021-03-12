USE [MRP_ROMP]
GO

/****** Object:  View [new].[Vw_DimPreceptor]    Script Date: 2020-04-09 12:46:28 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Script for SelectTopNRows command from SSMS  ******/
CREATE OR ALTER   VIEW [new].[Vw_DimPreceptor] AS
SELECT [Preceptor_Id]
      ,[Preceptor]
  FROM [MRP_ROMP].[new].[DimPreceptor]
GO


