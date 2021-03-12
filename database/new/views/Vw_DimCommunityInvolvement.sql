USE [MRP_ROMP]
GO

/****** Object:  View [new].[Vw_DimCommunityInvolvement]    Script Date: 2020-04-09 12:46:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Script for SelectTopNRows command from SSMS  ******/
CREATE OR ALTER   VIEW [new].[Vw_DimCommunityInvolvement] AS
SELECT [RESPONDENT_ID]
      ,[COMMUNITY_INVOLVEMENT]
  FROM [MRP_ROMP].[new].[DimCommunityInvolvement]
GO


