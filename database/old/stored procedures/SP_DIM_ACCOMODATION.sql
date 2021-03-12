USE [MRP_ROMP]
GO

/****** Object:  StoredProcedure [old].[SP_DIM_ACCOMODATION]    Script Date: 2020-04-09 12:50:35 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE OR ALTER            PROCEDURE [old].[SP_DIM_ACCOMODATION]
AS
BEGIN

BEGIN TRAN

SET NOCOUNT ON;

DECLARE @TABLE_COUNT INT
DECLARE @DATA_COUNT INT
DECLARE @TABLE_NAME VARCHAR(1000)
DECLARE @QUESTION VARCHAR(4000)
DECLARE @COLUMN VARCHAR(4000)
DECLARE @QUERY VARCHAR(MAX) = ''
DECLARE @UNION_QUERY VARCHAR(MAX) = ''
DECLARE @CNT_DATA INT = 1
DECLARE @CNT_TABLE INT = 1

DROP TABLE IF EXISTS ##OldAccomodation

SELECT ROW_NUMBER() OVER(PARTITION BY TABLE_NAME ORDER BY COLUMN_NAME) AS ROW_ID,
TABLE_NAME,
TRIM(COLUMN_NAME) AS ACCOMODATION,
COLUMN_NUMBER INTO ##OldAccomodation
FROM (
SELECT 
TABLE_NAME,
COLUMN_NAME,
STRING_AGG('IIF('+COLUMN_NUMBER+'<> '''','+COLUMN_NUMBER,',') + ','''')))))' AS COLUMN_NUMBER
FROM (
SELECT TABLE_NAME,
TRIM(SUBSTRING(SUBSTRING(COLUMN_NAME,CHARINDEX('_',COLUMN_NAME)+4,LEN(COLUMN_NAME)),0,CHARINDEX(':',SUBSTRING(COLUMN_NAME,CHARINDEX('_',COLUMN_NAME)+4,LEN(COLUMN_NAME))))) AS COLUMN_NAME,
COLUMN_NUMBER
FROM generic.table_columns
WHERE 
UPPER(COLUMN_NAME) LIKE '%RATE%ACCOMMODATION%FOLLOWING%'
AND TABLE_NAME LIKE 'generic.old_s%') BASE
GROUP BY TABLE_NAME, COLUMN_NAME
) ACCO;

DROP TABLE IF EXISTS ##OldTableNames

SELECT ROW_NUMBER() OVER(ORDER BY TABLE_NAME) AS ROW_ID, TABLE_NAME INTO ##OldTableNames FROM(SELECT DISTINCT TABLE_NAME FROM ##OldAccomodation) TAB;

SELECT @TABLE_COUNT = COUNT(1) FROM ##OldTableNames;

WHILE @CNT_TABLE <= @TABLE_COUNT
BEGIN

	SELECT @TABLE_NAME = TABLE_NAME FROM ##OldTableNames WHERE ROW_ID = @CNT_TABLE;

	SELECT @DATA_COUNT = COUNT(1) FROM ##OldAccomodation WHERE TABLE_NAME = @TABLE_NAME;

	SET @QUERY = ''
	SET @CNT_DATA = 1
	
	WHILE @CNT_DATA <= @DATA_COUNT
	BEGIN

		SELECT @QUESTION = ACCOMODATION, @COLUMN = COLUMN_NUMBER FROM ##OldAccomodation WHERE ROW_ID = @CNT_DATA AND TABLE_NAME = @TABLE_NAME

		SET @QUERY = @QUERY + @COLUMN + ' AS ''Q' + CAST(@CNT_DATA AS VARCHAR) + ''','

		SET @CNT_DATA = @CNT_DATA + 1
	END

	SET @QUERY = 'SELECT CAST(CAST(COLUMN1 AS FLOAT) AS BIGINT) AS RESPONDENT_ID, ' + SUBSTRING(@QUERY, 0, LEN(@QUERY))
	SET @UNION_QUERY = @UNION_QUERY + @QUERY + ' FROM ' + @TABLE_NAME + ' UNION ALL '

	SET @CNT_TABLE = @CNT_TABLE + 1

END

SET @UNION_QUERY = 'SELECT * INTO ##OldAccomodationRating FROM ( ' + SUBSTRING(@UNION_QUERY,0,LEN(@UNION_QUERY)-8) + ' ) COMIN';

DROP TABLE IF EXISTS ##OldAccomodationRating

EXECUTE (@UNION_QUERY)

SELECT @TABLE_COUNT = COUNT(1) FROM old.DimAccomodation;

IF @TABLE_COUNT > 0
BEGIN

DELETE FROM old.DimAccomodation

END

INSERT INTO old.DimAccomodation
SELECT 
FORMAT(GETDATE(), 'yyyyMMdd') AS CYCL_TIME_ID,
RESPONDENT_ID,
CASE
	WHEN RATING_VALUE > 7.5 THEN 'Excellent'
	WHEN RATING_VALUE <= 7.5 AND RATING_VALUE > 5 THEN 'Good'
	WHEN RATING_VALUE <= 5 AND RATING_VALUE > 2.5 THEN 'Satisfactory'
	WHEN RATING_VALUE <= 2.5 AND RATING_VALUE > 0 THEN 'Poor'
	WHEN RATING_VALUE = 0 THEN 'N/A'
	END AS ACCOMODATION_RATING
FROM(
SELECT RESPONDENT_ID,
(Q1_RATING + Q2_RATING + Q3_RATING + Q4_RATING + Q5_RATING + Q6_RATING + Q7_RATING + Q8_RATING + Q9_RATING + Q10_RATING) AS RATING_VALUE
FROM(
SELECT
RESPONDENT_ID, 
CASE TRIM(UPPER(Q1))
	WHEN 'EXCELLENT' THEN 1
	WHEN 'GOOD' THEN 0.75
	WHEN 'SATISFACTORY' THEN 0.5
	WHEN 'POOR' THEN 0.25
	ELSE 0 
	END AS Q1_RATING,
CASE TRIM(UPPER(Q2))
	WHEN 'EXCELLENT' THEN 1
	WHEN 'GOOD' THEN 0.75
	WHEN 'SATISFACTORY' THEN 0.5
	WHEN 'POOR' THEN 0.25
	ELSE 0 
	END AS Q2_RATING,
CASE TRIM(UPPER(Q3))
	WHEN 'EXCELLENT' THEN 1
	WHEN 'GOOD' THEN 0.75
	WHEN 'SATISFACTORY' THEN 0.5
	WHEN 'POOR' THEN 0.25
	ELSE 0 
	END AS Q3_RATING,
CASE TRIM(UPPER(Q4))
	WHEN 'EXCELLENT' THEN 1
	WHEN 'GOOD' THEN 0.75
	WHEN 'SATISFACTORY' THEN 0.5
	WHEN 'POOR' THEN 0.25
	ELSE 0 
	END AS Q4_RATING,
CASE TRIM(UPPER(Q5))
	WHEN 'EXCELLENT' THEN 1
	WHEN 'GOOD' THEN 0.75
	WHEN 'SATISFACTORY' THEN 0.5
	WHEN 'POOR' THEN 0.25
	ELSE 0 
	END AS Q5_RATING,
CASE TRIM(UPPER(Q6))
	WHEN 'EXCELLENT' THEN 1
	WHEN 'GOOD' THEN 0.75
	WHEN 'SATISFACTORY' THEN 0.5
	WHEN 'POOR' THEN 0.25
	ELSE 0 
	END AS Q6_RATING,
CASE TRIM(UPPER(Q7))
	WHEN 'EXCELLENT' THEN 1
	WHEN 'GOOD' THEN 0.75
	WHEN 'SATISFACTORY' THEN 0.5
	WHEN 'POOR' THEN 0.25
	ELSE 0 
	END AS Q7_RATING,
CASE TRIM(UPPER(Q8))
	WHEN 'EXCELLENT' THEN 1
	WHEN 'GOOD' THEN 0.75
	WHEN 'SATISFACTORY' THEN 0.5
	WHEN 'POOR' THEN 0.25
	ELSE 0 
	END AS Q8_RATING,
CASE TRIM(UPPER(Q9))
	WHEN 'EXCELLENT' THEN 1
	WHEN 'GOOD' THEN 0.75
	WHEN 'SATISFACTORY' THEN 0.5
	WHEN 'POOR' THEN 0.25
	ELSE 0 
	END AS Q9_RATING,
CASE TRIM(UPPER(Q10))
	WHEN 'EXCELLENT' THEN 1
	WHEN 'GOOD' THEN 0.75
	WHEN 'SATISFACTORY' THEN 0.5
	WHEN 'POOR' THEN 0.25
	ELSE 0 
	END AS Q10_RATING
FROM ##OldAccomodationRating ) BASE
) ACCRAT

COMMIT TRAN;

END;
GO


