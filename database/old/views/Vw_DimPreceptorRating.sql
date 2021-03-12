USE [MRP_ROMP]
GO

/****** Object:  View [old].[Vw_DimPreceptorRating]    Script Date: 2020-04-09 12:46:52 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   VIEW old.[Vw_DimPreceptorRating] AS
  SELECT RESPONDENT_ID, ROUND(PRECEPTOR_RATING, 2) AS PRECEPTOR_RATING FROM new.DimPreceptorRating
GO


