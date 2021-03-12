USE [MRP_ROMP]
GO

/****** Object:  StoredProcedure [old].[SP_DIM_ANSWER]    Script Date: 2020-04-09 12:50:51 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE OR ALTER                 PROCEDURE [old].[SP_DIM_ANSWER]
AS
BEGIN

BEGIN TRAN

SET NOCOUNT ON;

DECLARE @TABLE_COUNT INT

SELECT @TABLE_COUNT = COUNT(1) FROM old.DimAnswer

IF(@TABLE_COUNT > 0)
BEGIN
DELETE old.DimAnswer
END

INSERT INTO old.DimAnswer
SELECT FORMAT(GETDATE(), 'yyyyMMdd') AS CYCL_TIME_ID,
ANSWER_ID,
QUESTION_ID,
((QUESTION_ID*10000)+ANSWER_ID) AS QUESTION_ANSWER_ID,
ANSWER
FROM (
SELECT ROW_NUMBER() OVER(PARTITION BY QUESTION ORDER BY ANSWER) AS ANSWER_ID,
QUESTION,
ANSWER
FROM (
SELECT DISTINCT
CASE WHEN UPPER(QUESTION_HEADING) <> 'NONE' THEN TRIM(REPLACE(REPLACE(SUBSTRING(QUESTION, CHARINDEX('.',QUESTION)+1, LEN(QUESTION)),'?',''),':',''))
ELSE REPLACE(REPLACE(QUESTION,'?',''),':','')
END AS QUESTION,
ANSWER
FROM generic.question_answers_list 
WHERE TABLE_NAME LIKE 'generic.old_%') S_BASE 
) BASE
JOIN old.DimQuestion DQ ON DQ.QUESTION = BASE.QUESTION

COMMIT TRAN;

END;
GO


