USE [MRP_ROMP]
GO

/****** Object:  View [old].[Vw_DimRotation]    Script Date: 2020-04-09 12:47:35 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Script for SelectTopNRows command from SSMS  ******/
CREATE OR ALTER   VIEW old.[Vw_DimRotation] AS
SELECT [Rotation_Id]
      ,[Rotation]
  FROM [MRP_ROMP].[new].[DimRotation]
GO


