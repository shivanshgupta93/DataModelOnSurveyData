USE [MRP_ROMP]
GO

/****** Object:  StoredProcedure [new].[SP_DIM_ROTATION]    Script Date: 2020-04-09 12:50:10 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER       PROCEDURE [new].[SP_DIM_ROTATION]
AS
BEGIN

BEGIN TRAN

SET NOCOUNT ON;

DECLARE @TABLE_COUNT INT

DROP TABLE IF EXISTS #Rotation

SELECT 
FORMAT (GETDATE(), 'yyyyMMdd') AS CYCL_TIME_ID,
ROW_NUMBER() OVER(ORDER BY ROTATION) AS ROW_ID, 
ROTATION INTO #Rotation
FROM(
SELECT DISTINCT
SUBSTRING(COLUMN_NAME,CHARINDEX('_',COLUMN_NAME)+1,LEN(COLUMN_NAME)) AS ROTATION
FROM (
SELECT DISTINCT COLUMN_NAME 
FROM generic.table_columns
WHERE 
(UPPER(COLUMN_NAME) LIKE 'ROTATION%' OR UPPER(COLUMN_NAME) LIKE 'PROGRAM%')
AND UPPER(COLUMN_NAME) NOT LIKE '%OTHER%'
AND UPPER(COLUMN_NAME) NOT LIKE '%DATE%') BASE
) ROT

SELECT @TABLE_COUNT = COUNT(1) FROM new.DimRotation

IF(@TABLE_COUNT > 0)
BEGIN
DELETE new.DimRotation
END

INSERT INTO new.DimRotation
SELECT FORMAT(GETDATE(), 'yyyyMMdd') AS CYCL_TIME_ID,
ROW_ID AS ROTATION_ID,
ROTATION
FROM #Rotation
UNION ALL
SELECT 
FORMAT(GETDATE(), 'yyyyMMdd') AS CYCL_TIME_ID,
MAX(ROW_ID) + 1 AS ROTATION_ID,
'Others' AS ROTATION
FROM #Rotation

COMMIT TRAN;

END;
GO


