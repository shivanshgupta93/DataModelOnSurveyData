USE [MRP_ROMP]
GO

/****** Object:  View [new].[Vw_DimCommunity]    Script Date: 2020-04-09 12:45:59 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Script for SelectTopNRows command from SSMS  ******/
CREATE OR ALTER   VIEW [new].[Vw_DimCommunity] AS
SELECT [Community_Id]
      ,[Community]
      ,[Hospital]
  FROM [MRP_ROMP].[new].[DimCommunity]
GO


