USE [MRP_ROMP]
GO

/****** Object:  StoredProcedure [new].[SP_DIM_UNIVERSITY]    Script Date: 2020-04-09 12:50:18 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE OR ALTER     PROCEDURE [new].[SP_DIM_UNIVERSITY]
AS
BEGIN

BEGIN TRAN

SET NOCOUNT ON;

DECLARE @TABLE_COUNT INT

DROP TABLE IF EXISTS #University

SELECT 
ROW_NUMBER() OVER(ORDER BY UNIVERSITY) AS ROW_ID,
UNIVERSITY INTO #University
FROM(
SELECT DISTINCT
SUBSTRING(COLUMN_NAME,CHARINDEX('_',COLUMN_NAME)+1,LEN(COLUMN_NAME)) AS UNIVERSITY
FROM (
SELECT DISTINCT COLUMN_NAME 
FROM generic.table_columns
WHERE 
UPPER(COLUMN_NAME) LIKE 'UNIVERSITY%'
AND UPPER(COLUMN_NAME) NOT LIKE '%OTHER%') AS BASE
) UVI

SELECT @TABLE_COUNT = COUNT(1) FROM new.DimUniversity

IF(@TABLE_COUNT > 0)
BEGIN
DELETE new.DimUniversity
END

INSERT INTO new.DimUniversity
SELECT FORMAT(GETDATE(), 'yyyyMMdd') AS CYCL_TIME_ID,
ROW_ID AS UNIVERSITY_ID,
UNIVERSITY
FROM #University
UNION ALL
SELECT 
FORMAT(GETDATE(), 'yyyyMMdd') AS CYCL_TIME_ID,
MAX(ROW_ID) + 1 AS UNIVERSITY_ID,
'Others' AS UNIVERSITY
FROM #University

COMMIT TRAN;

END;
GO


