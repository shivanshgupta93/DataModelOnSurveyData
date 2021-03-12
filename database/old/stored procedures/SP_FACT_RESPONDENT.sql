USE [MRP_ROMP]
GO

/****** Object:  StoredProcedure [old].[SP_FACT_RESPONDENT]    Script Date: 2020-04-09 12:52:21 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








CREATE OR ALTER                       PROCEDURE [old].[SP_FACT_RESPONDENT]
AS
BEGIN

BEGIN TRAN

SET NOCOUNT ON;

DECLARE @TABLE_COUNT INT
DECLARE @DATA_COUNT INT
DECLARE @TABLE_NAME VARCHAR(1000)
DECLARE @COLUMN_NAME VARCHAR(4000)
DECLARE @COLUMN_NUMBER VARCHAR(4000)
DECLARE @STUD_QUERY VARCHAR(MAX) = ''
DECLARE @RESI_QUERY VARCHAR(MAX) = ''
DECLARE @UNION_QUERY VARCHAR(MAX) = ''
DECLARE @CNT_STUD INT = 1
DECLARE @CNT_RESI INT = 1
DECLARE @CNT_TABLE INT = 1
DECLARE @ROTATION_ID INT
DECLARE @UNIVERSITY_ID INT
DECLARE @PRECEPTOR_ID INT

DROP TABLE IF EXISTS ##OldStdRespondent

SELECT ROW_NUMBER() OVER(ORDER BY COLUMN_NAME) AS ROW_ID,
TABLE_NAME,
REPLACE(
CASE WHEN UPPER(COLUMN_NAME) LIKE '%:' THEN SUBSTRING(COLUMN_NAME,0,CHARINDEX(':',COLUMN_NAME))
	ELSE COLUMN_NAME
	END ,' ','_') AS COLUMN_NAME,
COLUMN_NUMBER INTO ##OldStdRespondent
FROM (
SELECT TABLE_NAME,
CASE 
	WHEN UPPER(COLUMN_NAME) LIKE '%NAME:' THEN SUBSTRING(COLUMN_NAME, CHARINDEX('_',COLUMN_NAME)+1, LEN(COLUMN_NAME))
	WHEN UPPER(COLUMN_NAME) LIKE 'ROTATION DATES%' THEN SUBSTRING(COLUMN_NAME, CHARINDEX('_',COLUMN_NAME)+1, LEN(COLUMN_NAME))
	WHEN UPPER(COLUMN_NAME) LIKE 'LEVEL OF TRAINING%' THEN SUBSTRING(COLUMN_NAME,0, CHARINDEX('_',COLUMN_NAME))
	WHEN UPPER(COLUMN_NAME) LIKE 'YEAR IN PROGRAM%' THEN SUBSTRING(COLUMN_NAME,0, CHARINDEX('_',COLUMN_NAME))
	WHEN UPPER(COLUMN_NAME) LIKE '%COMMUNITY CHOICE%' THEN 'Community_Choice'
	END AS COLUMN_NAME,
COLUMN_NUMBER
FROM generic.table_columns
WHERE UPPER(TABLE_NAME) LIKE 'generic.old_student%'
AND ( UPPER(COLUMN_NAME) LIKE '%NAME:'
OR UPPER(COLUMN_NAME) LIKE 'ROTATION DATES%'
OR UPPER(COLUMN_NAME) LIKE 'LEVEL OF TRAINING%'
OR UPPER(COLUMN_NAME) LIKE 'YEAR IN PROGRAM%' 
OR UPPER(COLUMN_NAME) LIKE '%COMMUNITY CHOICE%'))BASE;

SELECT @DATA_COUNT = COUNT(1) FROM ##OldStdRespondent;

WHILE @CNT_STUD <= @DATA_COUNT
BEGIN

SELECT @TABLE_NAME = TABLE_NAME, @COLUMN_NAME = COLUMN_NAME, @COLUMN_NUMBER = COLUMN_NUMBER FROM ##OldStdRespondent WHERE ROW_ID = @CNT_STUD

SET @STUD_QUERY = @STUD_QUERY + @COLUMN_NUMBER + ' AS ''' + @COLUMN_NAME + ''','

SET @CNT_STUD = @CNT_STUD + 1

END

SET @STUD_QUERY = 'SELECT CAST(CAST(COLUMN1 AS FLOAT) AS BIGINT) AS RESPONDENT_ID,' + SUBSTRING(@STUD_QUERY, 0, LEN(@STUD_QUERY)) + ' INTO ##OldRespondentStudent FROM ' + @TABLE_NAME

DROP TABLE IF EXISTS ##OldRespondentStudent 

EXECUTE (@STUD_QUERY)

DROP TABLE IF EXISTS ##OldResiRespondent

SELECT ROW_NUMBER() OVER(ORDER BY COLUMN_NAME) AS ROW_ID,
TABLE_NAME,
REPLACE(
CASE WHEN UPPER(COLUMN_NAME) LIKE '%:' THEN SUBSTRING(COLUMN_NAME,0,CHARINDEX(':',COLUMN_NAME))
	ELSE COLUMN_NAME
	END ,' ','_') AS COLUMN_NAME,
COLUMN_NUMBER INTO ##OldResiRespondent
FROM (
SELECT TABLE_NAME,
CASE 
	WHEN UPPER(COLUMN_NAME) LIKE '%NAME:' THEN SUBSTRING(COLUMN_NAME, CHARINDEX('_',COLUMN_NAME)+1, LEN(COLUMN_NAME))
	WHEN UPPER(COLUMN_NAME) LIKE 'ROTATION DATES%' THEN SUBSTRING(COLUMN_NAME, CHARINDEX('_',COLUMN_NAME)+1, LEN(COLUMN_NAME))
	WHEN UPPER(COLUMN_NAME) LIKE 'LEVEL OF TRAINING%' THEN SUBSTRING(COLUMN_NAME,0, CHARINDEX('_',COLUMN_NAME))
	WHEN UPPER(COLUMN_NAME) LIKE 'PROGRAM YEAR%' THEN 'Year_in_Program'
	END AS COLUMN_NAME,
COLUMN_NUMBER
FROM generic.table_columns
WHERE UPPER(TABLE_NAME) LIKE 'generic.old_resident%'
AND ( UPPER(COLUMN_NAME) LIKE '%NAME:'
OR UPPER(COLUMN_NAME) LIKE 'ROTATION DATES%'
OR UPPER(COLUMN_NAME) LIKE 'LEVEL OF TRAINING%'
OR UPPER(COLUMN_NAME) LIKE 'PROGRAM YEAR%' ))BASE;

SELECT @DATA_COUNT = COUNT(1) FROM ##OldResiRespondent;

WHILE @CNT_RESI <= @DATA_COUNT
BEGIN

SELECT @TABLE_NAME = TABLE_NAME, @COLUMN_NAME = COLUMN_NAME, @COLUMN_NUMBER = COLUMN_NUMBER FROM ##OldResiRespondent WHERE ROW_ID = @CNT_RESI

SET @RESI_QUERY = @RESI_QUERY + @COLUMN_NUMBER + ' AS ''' + @COLUMN_NAME + ''','

SET @CNT_RESI = @CNT_RESI + 1

END

SET @RESI_QUERY = 'SELECT CAST(CAST(COLUMN1 AS FLOAT) AS BIGINT) AS RESPONDENT_ID, ' + SUBSTRING(@RESI_QUERY, 0, LEN(@RESI_QUERY)) + ' INTO ##OldRespondentResident FROM ' + @TABLE_NAME

DROP TABLE IF EXISTS ##OldRespondentResident

EXECUTE (@RESI_QUERY)

DROP TABLE IF EXISTS ##OldUniversityStudent

SELECT TABLE_NAME,
'University' AS COLUMN_NAME,
STRING_AGG('IIF('+COLUMN_NUMBER+'<> '''','+COLUMN_NUMBER,',') + ',''Others''))))))' AS COLUMN_NUMBER INTO ##OldUniversityStudent
FROM (
SELECT TABLE_NAME,
COLUMN_NUMBER,
COLUMN_NAME
FROM (
SELECT TABLE_NAME,
COLUMN_NAME,
COLUMN_NUMBER
FROM generic.table_columns
WHERE UPPER(TABLE_NAME) LIKE 'generic.old_student%'
AND UPPER(COLUMN_NAME) LIKE 'UNIVERSITY%' 
AND UPPER(COLUMN_NAME) NOT LIKE '%OTHER%') BASE
) UNIV
GROUP BY TABLE_NAME

SELECT @TABLE_NAME = TABLE_NAME, @COLUMN_NAME = COLUMN_NAME, @COLUMN_NUMBER = COLUMN_NUMBER FROM ##OldUniversityStudent

SET @STUD_QUERY = 'SELECT CAST(CAST(COLUMN1 AS FLOAT) AS BIGINT) AS RESPONDENT_ID, ' + @COLUMN_NUMBER + ' AS ''' + @COLUMN_NAME + ''' FROM ' + @TABLE_NAME

DROP TABLE IF EXISTS ##OldUniversityResident

SELECT TABLE_NAME,
'University' AS COLUMN_NAME,
STRING_AGG('IIF('+COLUMN_NUMBER+'<> '''','+COLUMN_NUMBER,',') + ',''Others''))))))' AS COLUMN_NUMBER INTO ##OldUniversityResident
FROM (
SELECT TABLE_NAME,
COLUMN_NUMBER,
COLUMN_NAME
FROM (
SELECT TABLE_NAME,
COLUMN_NAME,
COLUMN_NUMBER
FROM generic.table_columns
WHERE UPPER(TABLE_NAME) LIKE 'generic.old_resident%'
AND UPPER(COLUMN_NAME) LIKE 'UNIVERSITY%' 
AND UPPER(COLUMN_NAME) NOT LIKE '%OTHER%') BASE
) UNIV
GROUP BY TABLE_NAME

SELECT @TABLE_NAME = TABLE_NAME, @COLUMN_NAME = COLUMN_NAME, @COLUMN_NUMBER = COLUMN_NUMBER FROM ##OldUniversityResident

SET @RESI_QUERY = 'SELECT CAST(CAST(COLUMN1 AS FLOAT) AS BIGINT) AS RESPONDENT_ID, ' + @COLUMN_NUMBER + ' AS ''' + @COLUMN_NAME + ''' FROM ' + @TABLE_NAME

DROP TABLE IF EXISTS ##OldFinalUniversity

SET @UNION_QUERY = 'SELECT * INTO ##OldFinalUniversity FROM ( ' + @STUD_QUERY + ' UNION ALL ' + @RESI_QUERY + ') BASE'

EXECUTE (@UNION_QUERY)

DROP TABLE IF EXISTS ##OldRotationStudent

SELECT TABLE_NAME,
'Rotation' AS COLUMN_NAME,
STRING_AGG(' CASE WHEN ' + COLUMN_NUMBER + ' <> '''' THEN ' + COLUMN_NUMBER + ' ELSE ''+'' END',' + ' ) AS COLUMN_NUMBER INTO ##OldRotationStudent
FROM (
SELECT TABLE_NAME,
COLUMN_NUMBER,
COLUMN_NAME
FROM (
SELECT TABLE_NAME,
COLUMN_NAME,
COLUMN_NUMBER
FROM generic.table_columns
WHERE UPPER(TABLE_NAME) LIKE 'generic.old_student%'
AND UPPER(COLUMN_NAME) LIKE 'PROGRAM:%' 
AND UPPER(COLUMN_NAME) NOT LIKE '%OTHER%') BASE
) UNIV
GROUP BY TABLE_NAME

SELECT @TABLE_NAME = TABLE_NAME, @COLUMN_NAME = COLUMN_NAME, @COLUMN_NUMBER = COLUMN_NUMBER FROM ##OldRotationStudent

SET @STUD_QUERY = 'SELECT CAST(CAST(COLUMN1 AS FLOAT) AS BIGINT) AS RESPONDENT_ID, ' + @COLUMN_NUMBER + ' AS ''' + @COLUMN_NAME + ''' FROM ' + @TABLE_NAME

DROP TABLE IF EXISTS ##OldRotationResident

SELECT TABLE_NAME,
'Rotation' AS COLUMN_NAME,
STRING_AGG(' CASE WHEN ' + COLUMN_NUMBER + ' <> '''' THEN ' + COLUMN_NUMBER + ' ELSE ''+'' END',' + ' ) AS COLUMN_NUMBER INTO ##OldRotationResident
FROM (
SELECT TABLE_NAME,
COLUMN_NUMBER,
COLUMN_NAME
FROM (
SELECT TABLE_NAME,
COLUMN_NAME,
COLUMN_NUMBER
FROM generic.table_columns
WHERE UPPER(TABLE_NAME) LIKE 'generic.old_resident%'
AND UPPER(COLUMN_NAME) LIKE 'PROGRAM:%' 
AND UPPER(COLUMN_NAME) NOT LIKE '%OTHER%') BASE
) UNIV
GROUP BY TABLE_NAME

SELECT @TABLE_NAME = TABLE_NAME, @COLUMN_NAME = COLUMN_NAME, @COLUMN_NUMBER = COLUMN_NUMBER FROM ##OldRotationResident

SET @RESI_QUERY = 'SELECT CAST(CAST(COLUMN1 AS FLOAT) AS BIGINT) AS RESPONDENT_ID, ' + @COLUMN_NUMBER + ' AS ''' + @COLUMN_NAME + ''' FROM ' + @TABLE_NAME

DROP TABLE IF EXISTS ##OldFinalRotation

SET @UNION_QUERY = 'SELECT * INTO ##OldFinalRotation FROM ( ' + @STUD_QUERY + ' UNION ALL ' + @RESI_QUERY + ') BASE'

EXECUTE (@UNION_QUERY)

DROP TABLE IF EXISTS ##OldUpdatedRotation;

SELECT DISTINCT
RESPONDENT_ID, 
ROTATION INTO ##OldUpdatedRotation
FROM (
SELECT RESPONDENT_ID,
TRIM(VALUE) AS ROTATION
FROM ##OldFinalRotation
cross apply string_split(##OldFinalRotation.ROTATION, '+')
) BASE WHERE ROTATION <> ''

DROP TABLE IF EXISTS ##OldFactPreceptor

SELECT DISTINCT
COLUMN_NUMBER INTO ##OldFactPreceptor
FROM generic.table_columns
WHERE UPPER(TABLE_NAME) LIKE 'generic.new_%' 
AND UPPER(COLUMN_NAME) LIKE '%FOLLOWING%_PRECEPTOR:'

SELECT @COLUMN_NUMBER = COLUMN_NUMBER FROM ##OldFactPreceptor;

SET @RESI_QUERY = 'SELECT RESPONDENT_ID,
CASE 
WHEN TRIM(LOWER(ANSW)) IN (''unknown'',''numerous'',''-'',''a'',''department'') THEN ''Others''
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
END AS ANSW INTO ##FirstOldFinalPreceptor
FROM (
SELECT RESPONDENT_ID,
CASE WHEN ANSW LIKE ''%(%'' THEN REPLACE(REPLACE(SUBSTRING(ANSW,0,CHARINDEX(''('',ANSW)),'')'',''''),''also'','''')
ELSE REPLACE(REPLACE(ANSW,'')'',''''),''also'','''')
END AS ANSW
FROM (
SELECT RESPONDENT_ID,
CASE 
WHEN UPPER(TRIM(ANSW)) LIKE ''DRS. %'' THEN SUBSTRING(TRIM(ANSW),CHARINDEX(''DRS.'',UPPER(TRIM(ANSW)))+5,LEN(TRIM(ANSW)))
WHEN UPPER(TRIM(ANSW)) LIKE ''DR. %'' THEN SUBSTRING(TRIM(ANSW),CHARINDEX(''DR.'',UPPER(TRIM(ANSW)))+4,LEN(TRIM(ANSW)))
WHEN UPPER(TRIM(ANSW)) LIKE ''DR.%'' THEN SUBSTRING(TRIM(ANSW),CHARINDEX(''DR.'',UPPER(TRIM(ANSW)))+3,LEN(TRIM(ANSW)))
WHEN UPPER(TRIM(ANSW)) LIKE ''DR %'' THEN SUBSTRING(TRIM(ANSW),CHARINDEX(''DR'',UPPER(TRIM(ANSW)))+3,LEN(TRIM(ANSW)))
WHEN UPPER(TRIM(ANSW)) LIKE ''DR%'' THEN SUBSTRING(TRIM(ANSW),CHARINDEX(''DR'',UPPER(TRIM(ANSW)))+2,LEN(TRIM(ANSW)))
ELSE TRIM(ANSW)
END AS ANSW
FROM ( 
SELECT RESPONDENT_ID, TRIM(VALUE) AS ANSW
FROM (
SELECT RESPONDENT_ID, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(COLUMN_NUMBER,''(OB/GYN)'',''''),''&'', ''/''),'','',''/''),'';'',''/''),'' and '',''/''),''+'',''/''),''Dr. John MacFadyen''''Dr. Kevin Young'',''Dr. John MacFadyen/Dr. Kevin Young'') AS COLUMN_NUMBER
FROM 
(
SELECT CAST(CAST(COLUMN1 AS FLOAT) AS BIGINT) AS RESPONDENT_ID, ' + @COLUMN_NUMBER + ' AS COLUMN_NUMBER FROM generic.old_student_survey
UNION ALL
SELECT CAST(CAST(COLUMN1 AS FLOAT) AS BIGINT) AS RESPONDENT_ID, ' + @COLUMN_NUMBER + ' FROM generic.old_resident_survey
)INITIAL_BASE
) BASE
CROSS APPLY STRING_SPLIT(BASE.COLUMN_NUMBER,''/'')
) BASE2 
) BASE3 WHERE ANSW <> '''') BASE4'

DROP TABLE IF EXISTS ##FirstOldFinalPreceptor

EXECUTE (@RESI_QUERY)

SET @STUD_QUERY = 'SELECT DISTINCT RESPONDENT_ID,
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
END AS PRECEPTOR INTO ##OldFinalPreceptor
FROM (
SELECT RESPONDENT_ID,
CASE WHEN ANSW LIKE ''%''''%'' THEN ANSW 
WHEN ANSW LIKE ''%-%'' THEN ANSW 
ELSE dbo.CamelCase(ANSW) 
END AS ANSW
FROM (
SELECT * FROM ##FirstOldFinalPreceptor ) BASE5 ) BASE6'

SET @UNION_QUERY = @STUD_QUERY

DROP TABLE IF EXISTS ##OldFinalPreceptor

EXECUTE (@UNION_QUERY)

SELECT @ROTATION_ID = ROTATION_ID FROM old.DimRotation WHERE ROTATION ='Others'
SELECT @UNIVERSITY_ID = UNIVERSITY_ID FROM old.DimUniversity WHERE UNIVERSITY = 'Others'
SELECT @PRECEPTOR_ID = PRECEPTOR_ID FROM old.DimPreceptor WHERE PRECEPTOR = 'Others'

SELECT @TABLE_COUNT = COUNT(1) FROM old.FactRespondent;

IF @TABLE_COUNT > 0
BEGIN

DELETE FROM old.FactRespondent

END

INSERT INTO old.FactRespondent
SELECT
FORMAT(GETDATE(), 'yyyyMMdd') AS CYCL_TIME_ID,
RSS.RESPONDENT_ID,
dbo.CamelCase(RSS.NAME) AS NAME,
RSS.STUDENT_TYPE,
RSS.FINISH_DATE,
RSS.START_DATE,
DATEDIFF(day, CAST(RSS.START_DATE AS DATE), CAST(RSS.FINISH_DATE AS DATE)) AS ROTATION_DAYS,
RSS.LEVEL_OF_TRAINING,
RSS.YEAR_IN_PROGRAM,
RSS.COMMUNITY_CHOICE,
ISNULL(DR.ROTATION_ID, @ROTATION_ID) AS ROTATION_ID,
ISNULL(DU.UNIVERSITY_ID, @UNIVERSITY_ID) AS UNIVERSITY_ID,
ISNULL(DP.PRECEPTOR_ID, @PRECEPTOR_ID) AS PRECEPTOR_ID
FROM
(
SELECT 
RESPONDENT_ID,
NAME,
'Medical Student' AS STUDENT_TYPE,
REPLACE(FINISH_DATE,'2917','2017') AS FINISH_DATE,
REPLACE(START_DATE,'2917','2017') AS START_DATE,
LEVEL_OF_TRAINING,
YEAR_IN_PROGRAM,
COMMUNITY_CHOICE
FROM ##OldRespondentStudent
UNION ALL
SELECT 
RESPONDENT_ID,
NAME,
'Medical Resident' AS STUDENT_TYPE,
REPLACE(REPLACE(REPLACE(FINISH_DATE,'2917','2017'),'06/31/2006','06/30/2006'),'09/31/2006','09/30/2006') AS FINISH_DATE,
REPLACE(START_DATE,'2917','2017') AS START_DATE,
NULL AS LEVEL_OF_TRAINING,
YEAR_IN_PROGRAM,
NULL AS COMMUNITY_CHOICE
FROM ##OldRespondentResident
) RSS 
LEFT JOIN ##OldFinalUniversity US ON RSS.RESPONDENT_ID = US.RESPONDENT_ID
LEFT JOIN ##OldUpdatedRotation ROS ON RSS.RESPONDENT_ID = ROS.RESPONDENT_ID
LEFT JOIN ##OldFinalPreceptor PRE ON RSS.RESPONDENT_ID = PRE.RESPONDENT_ID
LEFT JOIN old.DimRotation DR ON UPPER(TRIM(DR.ROTATION)) = UPPER(TRIM(ROS.ROTATION))
LEFT JOIN old.DimUniversity DU ON UPPER(TRIM(DU.UNIVERSITY)) = UPPER(TRIM(US.UNIVERSITY))
LEFT JOIN old.DimPreceptor DP ON UPPER(TRIM(DP.PRECEPTOR)) = UPPER(TRIM(PRE.PRECEPTOR))

COMMIT TRAN;

END;
GO


