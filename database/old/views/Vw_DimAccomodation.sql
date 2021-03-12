USE [MRP_ROMP]
GO

/****** Object:  View [old].[Vw_DimAccomodation]    Script Date: 2020-04-09 12:45:31 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Script for SelectTopNRows command from SSMS  ******/
CREATE OR ALTER   VIEW old.[Vw_DimAccomodation] AS
SELECT [RESPONDENT_ID]
      ,[Accomodation_Rating]
  FROM [MRP_ROMP].[new].[DimAccomodation]
GO


