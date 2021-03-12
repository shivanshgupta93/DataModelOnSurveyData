USE [MRP_ROMP]
GO

/****** Object:  StoredProcedure [old].[SP_DIM_PRECEPTOR]    Script Date: 2020-04-09 12:51:21 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE OR ALTER                   PROCEDURE [old].[SP_DIM_PRECEPTOR]
AS
BEGIN

BEGIN TRAN

SET NOCOUNT ON;

DECLARE @TABLE_COUNT INT
DECLARE @TABLE_NAME VARCHAR(1000)
DECLARE @COLUMN VARCHAR(4000)
DECLARE @QUERY_PART1 VARCHAR(MAX) = ''
DECLARE @QUERY_PART2 VARCHAR(MAX) = ''
DECLARE @UNION_QUERY VARCHAR(MAX) = ''

DROP TABLE IF EXISTS ##OldPreceptorStudent

SELECT DISTINCT
COLUMN_NUMBER INTO ##OldPreceptorStudent
FROM generic.table_columns
WHERE 
UPPER(COLUMN_NAME) LIKE '%FOLLOWING%_PRECEPTOR:'
AND TABLE_NAME LIKE 'generic.old_%'

SELECT @COLUMN = COLUMN_NUMBER FROM ##OldPreceptorStudent;

SET @QUERY_PART1 = ' SELECT
CASE WHEN TRIM(LOWER(ANSW)) IN (''unknown'',''numerous'',''-'',''a'',''department'') THEN ''Others''
WHEN ANSW IN (''Eric Brown - Anesthesia'') THEN ''Dr. '' + SUBSTRING(ANSW,0,CHARINDEX(''-'',ANSW))
WHEN ANSW IN (''Osswald too)'') THEN ''Dr. '' + SUBSTRING(ANSW,0,CHARINDEX('' too'',ANSW))
WHEN UPPER(ANSW) = ''NANCY ROSE-JANES'' THEN ''Dr. Nancy Rose-Janes''
WHEN LOWER(ANSW) = ''alan white- overseeing physcian'' THEN ''Dr. Alan White''
WHEN LOWER(ANSW) = ''francis 2 dr. snarr'' THEN ''Dr. Francis''
WHEN UPPER(ANSW) = ''JESSICA ROLLINGS-SCATTERGOOD'' THEN ''Dr. Jessica Rollings-Scattergood''
WHEN UPPER(ANSW) = ''M RODWAY-NORMAN'' THEN ''Dr. M Rodway-Norman''
WHEN UPPER(ANSW) IN (''TREVOR MACE-BRICKMAN'',''TREVOR MACE-BRICKMAN'') THEN ''Dr. Trevor Mace-Brickman''
WHEN UPPER(ANSW) = ''J.KAPALANGA'' THEN ''Dr. J Kapalanga''
WHEN UPPER(ANSW) = ''BRITT LEHMANN-BENDER'' THEN ''Dr. Britt Lehmann-Bender''
WHEN UPPER(ANSW) = ''K. HARDY-BROWN'' THEN ''Dr. K. Hardy-Brown''
WHEN UPPER(ANSW) = ''MANY: GREG BISHOP'' THEN ''Dr. Greg Bishhop''
WHEN UPPER(ANSW) = ''2 DR. CALESH DOOBAY'' THEN ''Dr. Calesh Doobay''
WHEN UPPER(ANSW) = ''1 DR. WILSON'' THEN ''Dr. Wilson''
WHEN UPPER(ANSW) = ''1 DR. CARLYE JENSEN'' THEN ''Dr. Carlye Jensen''
WHEN UPPER(ANSW) = ''?DR. P. CAMERON'' THEN ''Dr. P. Cameron''
WHEN UPPER(ANSW) IN (''MARK RODWAY NORMAN'',''MARK RODWAY-NORMAN'') THEN ''Dr. Mark Rodway Norman''
WHEN UPPER(ANSW) IN (''MARK LANE - SMITH'',''MARK LANE-SMITH'') THEN ''Dr. Mark Lane - Smith''
WHEN UPPER(ANSW) IN (''MARKUS SCHATZMAN'',''MARKUS SCHATZMANN'') THEN ''Dr. Markus Schatzman''
WHEN UPPER(ANSW) IN (''MARTIN MACNAMARA'',''MARTIN MCNAMARA'') THEN ''Dr. Martin Mcnamara''
WHEN TRIM(LOWER(ANSW)) LIKE ''%health%'' THEN ''Others''
WHEN TRIM(LOWER(ANSW)) LIKE ''%medicine%'' THEN ''Others''
WHEN TRIM(LOWER(ANSW)) LIKE ''many%'' THEN ''Others''
WHEN TRIM(LOWER(ANSW)) LIKE ''%other%'' THEN ''Others''
WHEN TRIM(LOWER(ANSW)) LIKE ''%various%'' THEN ''Others''
WHEN TRIM(LOWER(ANSW)) LIKE ''%department%'' THEN ''Others''
WHEN TRIM(LOWER(ANSW)) LIKE ''%multiple%'' THEN ''Others''
WHEN TRIM(LOWER(ANSW)) LIKE ''%orillia%'' THEN ''Others''
WHEN TRIM(LOWER(ANSW)) LIKE ''%different%'' THEN ''Others''
WHEN TRIM(LOWER(ANSW)) LIKE ''%test%'' THEN ''Others''
WHEN TRIM(LOWER(ANSW)) LIKE ''%several%'' THEN ''Others''
WHEN TRIM(LOWER(ANSW)) LIKE ''%rotated%'' THEN ''Others''
WHEN TRIM(LOWER(ANSW)) LIKE ''%teaching%'' THEN ''Others''
WHEN TRIM(LOWER(ANSW)) LIKE ''%team%'' THEN ''Others''
WHEN TRIM(LOWER(ANSW)) LIKE ''%group%'' THEN ''Others''
WHEN TRIM(LOWER(ANSW)) LIKE ''%physician%'' THEN ''Others''
WHEN TRIM(LOWER(ANSW)) LIKE ''%specifically%'' THEN ''Others''
WHEN TRIM(LOWER(ANSW)) LIKE ''%practitioner%'' THEN ''Others''
WHEN TRIM(LOWER(ANSW)) LIKE ''%hospital%'' THEN ''Others''
WHEN TRIM(LOWER(ANSW)) LIKE ''%remember%'' THEN ''Others''
WHEN TRIM(LOWER(ANSW)) IN (''.'',''1'',''j'',''s'') THEN ''Others''
WHEN TRIM(LOWER(ANSW)) IN (''fgdfgdgdf'',''fgdg'') THEN ''Others''
WHEN TRIM(LOWER(ANSW)) IN (''prhc er'',''sdf'',''md'') THEN ''Others''
WHEN TRIM(LOWER(ANSW)) IN (''sdfg'',''sfdgfdg'',''tbd'',''tes'') THEN ''Others''
WHEN TRIM(LOWER(ANSW)) IN (''fdgfd'',''nosm - hsn'') THEN ''Others''
WHEN TRIM(LOWER(ANSW)) = ''not just one'' THEN ''Others''
WHEN TRIM(LOWER(ANSW)) = ''peterborough er'' THEN ''Others''
ELSE ''Dr. '' + TRIM(ANSW) 
END AS ANSW INTO ##FirstOldPreceptor
FROM (
SELECT 
CASE WHEN ANSW LIKE ''%(%'' THEN REPLACE(REPLACE(SUBSTRING(ANSW,0,CHARINDEX(''('',ANSW)),'')'',''''),''also'','''')
ELSE REPLACE(REPLACE(ANSW,'')'',''''),''also'','''')
END AS ANSW
FROM (
SELECT 
CASE 
WHEN UPPER(TRIM(ANSW)) LIKE ''DRS. %'' THEN SUBSTRING(TRIM(ANSW),CHARINDEX(''DRS.'',UPPER(TRIM(ANSW)))+5,LEN(TRIM(ANSW)))
WHEN UPPER(TRIM(ANSW)) LIKE ''DR. %'' THEN SUBSTRING(TRIM(ANSW),CHARINDEX(''DR.'',UPPER(TRIM(ANSW)))+4,LEN(TRIM(ANSW)))
WHEN UPPER(TRIM(ANSW)) LIKE ''DR.%'' THEN SUBSTRING(TRIM(ANSW),CHARINDEX(''DR.'',UPPER(TRIM(ANSW)))+3,LEN(TRIM(ANSW)))
WHEN UPPER(TRIM(ANSW)) LIKE ''DR %'' THEN SUBSTRING(TRIM(ANSW),CHARINDEX(''DR'',UPPER(TRIM(ANSW)))+3,LEN(TRIM(ANSW)))
WHEN UPPER(TRIM(ANSW)) LIKE ''DR%'' THEN SUBSTRING(TRIM(ANSW),CHARINDEX(''DR'',UPPER(TRIM(ANSW)))+2,LEN(TRIM(ANSW)))
ELSE TRIM(ANSW)
END AS ANSW
FROM (
SELECT TRIM(VALUE) AS ANSW
FROM ( 
SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(COLUMN_NUMBER,''(OB/GYN)'',''''),''&'', ''/''),'','',''/''),'';'',''/''),'' and '',''/''),''+'',''/''),''Dr. John MacFadyen''''Dr. Kevin Young'',''Dr. John MacFadyen/Dr. Kevin Young'') AS COLUMN_NUMBER
FROM 
(
SELECT ' + @COLUMN + ' AS COLUMN_NUMBER FROM generic.old_student_survey
UNION ALL
SELECT ' + @COLUMN + ' FROM generic.old_resident_survey
)INITIAL_BASE
) BASE
CROSS APPLY STRING_SPLIT(BASE.COLUMN_NUMBER,''/'')
) BASE2 
) BASE3 WHERE ANSW <> '''') BASE4 '

DROP TABLE IF EXISTS ##FirstOldPreceptor

EXECUTE (@QUERY_PART1)

SET @QUERY_PART2 = 'SELECT DISTINCT 
CASE 
WHEN ANSW IN (''Dr. Andrew Jeffery'',''Dr. Andrew Jeffrey'') THEN ''Dr. Andrew Jeffery''
WHEN ANSW IN (''Dr. Amir Shourideh'',''Dr. Amir Shourideh-ziabari'') THEN ''Dr. Amir Shourideh''
WHEN ANSW IN (''Dr. Andre Bedard'',''Dr. André Bédard'') THEN ''Dr. Andre Bedard''
WHEN ANSW IN (''Dr. Douglas Macintryre'',''Dr. Douglas Macintyre'') THEN ''Dr. Douglas Macintyre''
WHEN ANSW IN (''Dr. Elena Cioata-tomsa'',''Dr. Elena Ciota-tomsa'') THEN ''Dr. Elena Cioata-Tomsa''
WHEN ANSW IN (''Dr. Gillian Yeates'',''Dr. Gillian Yeats'') THEN ''Dr. Gillian Yeats''
WHEN ANSW IN (''Dr. Heidi Deboer'',''Dr. Heidi Deboer-fennell'',''Dr. Heidi Deborr-fennell'',''Dr. Deboer-fennell'') THEN ''Dr. Heidi Deboer-Fennell''
WHEN ANSW IN (''Dr. Jaco Scheeres'',''Dr. Jacob Scheeres'') THEN ''Dr. Jacob Scheeres''
WHEN ANSW IN (''Dr. Karolyn Hardy Brown'',''Dr. Karolyn Hardy-brown'',''Dr. K. Hardy-Brown'') THEN ''Dr. Karolyn Hardy Brown''
WHEN ANSW IN (''Dr. Kimberley Mcintosh'',''Dr. Kimberly Mcintosh'',''Dr. Kim Mcintosh'') THEN ''Dr. Kimberly Mcintosh''
WHEN ANSW IN (''Dr. Rodway-norman'',''Dr. M Rodway-Norman'') THEN ''Dr. M Rodway-Norman''
WHEN ANSW IN (''Dr. Rollings-scattergood'',''Dr. Jessica Rollings-Scattergood'') THEN ''Dr. Jessica Rollings-Scattergood''
WHEN ANSW IN (''Dr. Shourideh'',''Dr. Shourideh Ziabari'') THEN ''Dr. Shourideh Ziabari''
WHEN ANSW IN (''Dr. Vara Mahadevan'',''Dr. Varagunan Mahadevan'') THEN ''Dr. Varagunan Mahadevan''
WHEN ANSW IN (''Dr. Troy Tebbenham'',''Dr. Troy Tebennham'') THEN ''Dr. Troy Tebbenham''
WHEN ANSW IN (''Dr. Tim Oliveira'',''Dr. Tim Oliviera'') THEN ''Dr. Tim Oliviera''
WHEN ANSW IN (''Dr. Terri Suggitt'',''Dr. Terry Suggitt'') THEN ''Dr. Terry Suggitt''
WHEN ANSW IN (''Dr. Tara Lynn Somerville'',''Dr. Tara Somerville'',''Dr. Somerville'') THEN ''Dr. Tara Lynn Somerville''
WHEN ANSW IN (''Dr. Steven Depiero'',''Dr. Steve Depiero'',''Dr. Steve Depeiro'') THEN ''Dr. Steven Depiero''
WHEN ANSW IN (''Dr. Alex Fraser'',''Dr. Alexandra Fraser'') THEN ''Dr. Alexandra Fraser''
WHEN ANSW IN (''Dr. A. Husain'',''Dr. Aisha Husain'',''Dr. A Husain'') THEN ''Dr. Aisha Husain''
WHEN ANSW IN (''Dr. Appelton'',''Dr. Ali Appelton'',''Dr. Ali Appetlon'',''Dr. Alison Appelton'',''Dr. Alison Appleton'',''Dr. Allison Appelton'') THEN ''Dr. Allison Appelton''
WHEN ANSW IN (''Dr. Bonnie'',''Dr. Bonnie Marshall'') THEN ''Dr. Bonnie Marshall''
WHEN ANSW IN (''Dr. Carlye'',''Dr. Carlye Jensen'') THEN ''Dr. Carlye Jensen''
WHEN ANSW IN (''Dr. Derek Haaland'',''Dr. Derek Halaand'',''Dr. Haaland'',''Dr. D Haaland'') THEN ''Dr. Derek Haaland''
WHEN ANSW IN (''Dr. Don Eby'',''Dr. Donald Eby'') THEN ''Dr. Donald Eby''
WHEN ANSW IN (''Dr. Doug Austgaarden'',''Dr. Doug Austgarden'',''Dr. Dough Austgarden'') THEN ''Dr. Doug Austgarden''
WHEN ANSW IN (''Dr. Ed Osborne'',''Dr. Edward Osborne'') THEN ''Dr. Edward Osborne''
WHEN ANSW IN (''Dr. Fred Yoon'',''Dr. Frederick Yoon'') THEN ''Dr. Frederick Yoon''
WHEN ANSW IN (''Dr. Greg Bishop'',''Dr. Gregory Bishop'') THEN ''Dr. Gregory Bishop''
WHEN ANSW IN (''Dr. Greg Bolton'',''Dr. Gregg Bolton'') THEN ''Dr. Greg Bolton''
WHEN ANSW IN (''Dr. Gwen Sampson'',''Dr. Gweneth Sampson'') THEN ''Dr. Gweneth Sampson''
WHEN ANSW IN (''Dr. J Macfadyen'',''Dr. J. Macfadyen'') THEN ''Dr. J Macfadyen''
WHEN ANSW IN (''Dr. Jeffery'',''Dr. Jeffrey Macpherson'') THEN ''Dr. Jeffrey Macpherson''
WHEN ANSW IN (''Dr. Kathryn'',''Dr. Kathryn Armstrong'') THEN ''Dr. Kathryn Armstrong''
WHEN ANSW IN (''Dr. Ken Uffen'',''Dr. Kenneth Uffen'') THEN ''Dr. Kenneth Uffen''
WHEN ANSW IN (''Dr. Kevin You F'',''Dr. Kevin Young'') THEN ''Dr. Kevin Young''
WHEN ANSW IN (''Dr. Lesley Hutchings'',''Dr. Leslie Hutchings'') THEN ''Dr. Leslie Hutchings''
WHEN ANSW IN (''Dr. Marc Newton'',''Dr. Marcus Newton'') THEN ''Dr. Marcus Newton''
WHEN ANSW IN (''Dr. Martin'',''Dr. Martin Mcnamara'') THEN ''Dr. Martin Mcnamara''
WHEN ANSW IN (''Dr. Mathew Moss'',''Dr. Matthew Moss'',''Dr. Matt Moss'') THEN ''Dr. Matthew Moss''
WHEN ANSW IN (''Dr. Matthew Myatt'',''Dr. Mathew Myatt'',''Dr. Matt Myatt'') THEN ''Dr. Matthew Myatt''
WHEN ANSW IN (''Dr. Merilee Brown'',''Dr. Merrilee Brown'') THEN ''Dr. Merilee Brown''
WHEN ANSW IN (''Dr. Michael Marriot'',''Dr. Michael Marriott'') THEN ''Dr. Michael Marriot''
WHEN ANSW IN (''Dr. Norm Bottum'',''Dr. Norman Bottum'') THEN ''Dr. Norman Bottum''
WHEN ANSW IN (''Dr. Rick Sood'',''Dr. Rickesh Sood'') THEN ''Dr. Rickesh Sood''
WHEN ANSW IN (''Dr. Shaun'',''Dr. Shaun Marshall'') THEN ''Dr. Shaun Marshall''
WHEN ANSW IN (''Dr. Agnes Hassa'',''Dr. Agnieszka Hassa'') THEN ''Dr. Agnieszka Hassa''
WHEN ANSW IN (''Dr. Cal Doobay'',''Dr. Calesh Doobay'') THEN ''Dr. Calesh Doobay''
WHEN ANSW IN (''Dr. Erszebet Kiss'',''Dr. Erzsebet Kiss'',''Dr. Kiss'') THEN ''Dr. Erzsebet Kiss''
WHEN ANSW IN (''Dr. J Kapalanga'',''Dr. J. Kapalanga'',''Dr. Kapalanga'') THEN ''Dr. J Kapalanga''
WHEN ANSW IN (''Dr. Lisi'',''Dr. Lisis'',''Dr. M Lisi'',''Dr. M. Lisi'',''Dr. Michael Lisi'') THEN ''Dr. Michael Lisi''
WHEN ANSW IN (''Dr. Emmanuel Caulley'',''Dr. Emmanuel Caulley In Obstetrics'') THEN ''Dr. Emmanuel Caulley''
WHEN ANSW = ''Dr. Coordinated By Dr. Hess'' THEN ''Dr. Hess''
WHEN ANSW IN (''Dr. Collpits'',''Dr. Colpitts'') THEN ''Dr. Colpitts''
WHEN ANSW IN (''Dr. Christina "tina" Stephenson'' ,''Dr. Christina Stephenson'') THEN ''Dr. Christina Stephenson''
WHEN ANSW IN (''Dr. Beamish'',''Dr. Beamish- primary preceptor'') THEN ''Dr. Beamish''
ELSE REPLACE(ANSW,''?'','''')
END AS ANSW
FROM (
SELECT
CASE WHEN ANSW LIKE ''%''''%'' THEN ANSW 
WHEN ANSW LIKE ''%-%'' THEN ANSW 
ELSE dbo.CamelCase(ANSW) 
END AS ANSW
FROM (
SELECT * FROM ##FirstOldPreceptor ) BASE5 ) BASE6'

DROP TABLE IF EXISTS ##OldPreceptor

SET @UNION_QUERY = 'SELECT ROW_NUMBER() OVER(ORDER BY ANSW) AS PRECEPTOR_ID, ANSW AS PRECEPTOR INTO ##OldPreceptor FROM (SELECT DISTINCT ANSW FROM ('
+ @QUERY_PART2 + 
' ) M_BASE WHERE ANSW <> ''Dr.'' ) S_BASE';

EXECUTE (@UNION_QUERY)

SELECT @TABLE_COUNT = COUNT(1) FROM old.DimPreceptor;

IF @TABLE_COUNT > 0
BEGIN

DELETE FROM old.DimPreceptor

END

INSERT INTO old.DimPreceptor
SELECT 
FORMAT(GETDATE(), 'yyyyMMdd') AS CYCL_TIME_ID,
PRECEPTOR_ID,
PRECEPTOR 
FROM ##OldPreceptor;

COMMIT TRAN;

END;
GO


