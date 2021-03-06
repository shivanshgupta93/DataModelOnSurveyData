USE [MRP_ROMP]
GO

/****** Object:  StoredProcedure [old].[SP_DIM_KNOWLEDGE_ACQUISITION]    Script Date: 2020-04-09 12:51:09 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE OR ALTER             PROCEDURE [old].[SP_DIM_KNOWLEDGE_ACQUISITION]
AS
BEGIN

BEGIN TRAN

SET NOCOUNT ON;

DECLARE @TABLE_COUNT INT
DECLARE @DATA_COUNT INT
DECLARE @TABLE_NAME VARCHAR(1000)
DECLARE @QUESTION VARCHAR(4000)
DECLARE @COLUMN VARCHAR(4000)
DECLARE @RESI_QUERY VARCHAR(MAX) = ''
DECLARE @CNT_RESI INT = 1
DECLARE @CNT_TABLE INT = 1

DROP TABLE IF EXISTS ##OldKnowledgeResident

SELECT ROW_NUMBER() OVER(ORDER BY COLUMN_NAME) AS ROW_ID,
TABLE_NAME,
COLUMN_NAME,
COLUMN_NUMBER INTO ##OldKnowledgeResident
FROM (
SELECT TABLE_NAME, 
TRIM(SUBSTRING(COLUMN_NAME,CHARINDEX('_',COLUMN_NAME)+4,LEN(COLUMN_NAME))) AS COLUMN_NAME,
COLUMN_NUMBER
FROM generic.table_columns
WHERE 
UPPER(COLUMN_NAME) LIKE '%KNOWLEDGE%'
AND TABLE_NAME LIKE 'generic.old_resident_survey' ) BASE

SELECT @DATA_COUNT = COUNT(1) FROM ##OldKnowledgeResident;

WHILE @CNT_RESI <= @DATA_COUNT
BEGIN

SELECT @TABLE_NAME = TABLE_NAME, @QUESTION = COLUMN_NAME, @COLUMN = COLUMN_NUMBER FROM ##OldKnowledgeResident WHERE ROW_ID = @CNT_RESI

SET @RESI_QUERY = @RESI_QUERY + @COLUMN + ' AS ''Q' + CAST(@CNT_RESI AS VARCHAR) + ''','

SET @CNT_RESI = @CNT_RESI + 1

END

DROP TABLE IF EXISTS ##OldKnowledgeAccResident

SET @RESI_QUERY = 'SELECT CAST(CAST(COLUMN1 AS FLOAT) AS BIGINT) AS RESPONDENT_ID, ' + SUBSTRING(@RESI_QUERY, 0, LEN(@RESI_QUERY)) + ' INTO ##OldKnowledgeAccResident FROM ' + @TABLE_NAME

EXECUTE(@RESI_QUERY)

SELECT @TABLE_COUNT = COUNT(1) FROM old.DimKnowledgeAcquisition;

IF @TABLE_COUNT > 0
BEGIN

DELETE FROM old.DimKnowledgeAcquisition

END

INSERT INTO old.DimKnowledgeAcquisition
SELECT
FORMAT(GETDATE(), 'yyyyMMdd'),
RESPONDENT_ID,
CASE 
	WHEN ACQUISITION >= 3 THEN 'High'
	WHEN ACQUISITION < 3 AND ACQUISITION >= 1 THEN 'Medium'
	WHEN ACQUISITION < 1 AND ACQUISITION >= 0 THEN 'Low'
	END AS KNOWLEDGE_ACQUISITION
FROM (
SELECT 
RESPONDENT_ID,
( Q1_VALUE + Q2_VALUE + Q3_VALUE + Q4_VALUE + Q5_VALUE) AS ACQUISITION
FROM (
SELECT
RESPONDENT_ID,
CASE TRIM(UPPER(Q1))
	WHEN 'YES, WITHOUT QUESTION' THEN 1
	WHEN 'SOMEWHAT' THEN 0.5
	WHEN 'NOT AT ALL' THEN 0
	ELSE 0
	END AS Q1_VALUE,
CASE TRIM(UPPER(Q2))
	WHEN 'YES, WITHOUT QUESTION' THEN 1
	WHEN 'SOMEWHAT' THEN 0.5
	WHEN 'NOT AT ALL' THEN 0
	ELSE 0
	END AS Q2_VALUE,
CASE TRIM(UPPER(Q3))
	WHEN 'YES, WITHOUT QUESTION' THEN 1
	WHEN 'SOMEWHAT' THEN 0.5
	WHEN 'NOT AT ALL' THEN 0
	ELSE 0
	END AS Q3_VALUE,
CASE TRIM(UPPER(Q4))
	WHEN 'YES, WITHOUT QUESTION' THEN 1
	WHEN 'SOMEWHAT' THEN 0.5
	WHEN 'NOT AT ALL' THEN 0
	ELSE 0
	END AS Q4_VALUE,
CASE TRIM(UPPER(Q5))
	WHEN 'YES, WITHOUT QUESTION' THEN 1
	WHEN 'SOMEWHAT' THEN 0.5
	WHEN 'NOT AT ALL' THEN 0
	ELSE 0
	END AS Q5_VALUE
FROM ##OldKnowledgeAccResident) BASE_RESI
) KLDGACQ_RESI;

COMMIT TRAN;

END;
GO


