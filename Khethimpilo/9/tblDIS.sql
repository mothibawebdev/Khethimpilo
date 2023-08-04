USE [Khethimpilo]
GO

--DIS_ID, DIS_SITE retrived from https://icdcodelookup.com/icd-10/codes/77/2017
--https://icd.who.int/browse10/2019/en#/A16.3

INSERT INTO [Khethimpilo]..[tblDIS] (PATIENT, DIS_ID, DIS_D, DIS_D_A, DIS_D_ED, DIS_D_ED_A, DIS_WD, DIS_SITE, DIS_OTH, DIS_OUTCOME, dis_site_txt)
SELECT PATIENT, 
	(CASE WHEN SITE IN ('A16.3','A18.2','A15.4') THEN 'LNTB'
		WHEN SITE IN ('A19.0','A19.1','A19.2','A19.9','A15.6','A18.1','A17.0','A17.0+','A17.1+','A15.0','A15.7','A15.8','A18.3') THEN 'MCP'
		WHEN SITE IN ('A15.1, A15.2, A15.3', 'A16.0') THEN 'BCNE'
		WHEN SITE IN ('B20.0') THEN 'ENC' 
		WHEN SITE IN ('A16.5') THEN 'MC'
		WHEN SITE IN ('A16.8') THEN 'RTIR'
		WHEN SITE IN ('A15.5') THEN 'CANT'
	 ELSE NULL END), TB_START_D, 
	(CASE WHEN TB_START_D IS NOT NULL THEN 'D' ELSE 'U' END), TB_END_D,
	(CASE WHEN TB_END_D IS NOT NULL THEN 'D' ELSE 'U' END), CAT, 
	(CASE WHEN SITE IN ('A18.3') THEN 1
		WHEN SITE IN ('18.0') THEN 2
		WHEN SITE IN ('A17.0','A17.0+','A17.1+') THEN 3
		WHEN SITE IN ('A18.1') THEN 4
		WHEN SITE IN ('A16.3','A18.2') THEN 6
		WHEN SITE IN ('A15.0','A15.1','A15.2','A15.3','A15.4','A15.7','A15.8') THEN 7
		WHEN SITE IN ('A19.0','A19.1','A19.2','A19.9') THEN 8
		WHEN SITE IN ('A18.4','A18.8') THEN 88
		WHEN SITE IN ('A16.5','A15.6') THEN 10
		ELSE 99 END), NULL, TB_OUTCOME, SITE
FROM [Khethimpilo]..[tblTB_raw]
--(17665 rows affected)

UPDATE [Khethimpilo]..[tblDIS] SET PATIENT = ID FROM [Dictionary]..[PATIENTID_KI]
WHERE [patient] = [SERIAL NUMBER]

update [Khethimpilo]..[tblDIS]                             
	set PATIENT = (CASE WHEN LEN(patient) = 1 THEN CONCAT('KI00000000',patient)
		WHEN LEN(patient) = 2 THEN CONCAT('KI0000000',patient)
		WHEN LEN(patient) = 3 THEN CONCAT('KI000000',patient)
		WHEN LEN(patient) = 4 THEN CONCAT('KI00000',patient)
		WHEN LEN(patient) = 5 THEN CONCAT('KI0000',patient)
		WHEN LEN(patient) = 6 THEN CONCAT('KI000',patient)
		WHEN LEN(patient) = 7 THEN CONCAT('KI00',patient) 
		WHEN LEN(patient) = 8 THEN CONCAT('KI0',patient)
		ELSE CONCAT('KI',patient) END)

WITH cte AS 
(SELECT PATIENT, DIS_ID, DIS_D, ROW_NUMBER() 
OVER (PARTITION BY DIS_ID, DIS_D  order by DIS_ID, DIS_D) rownum FROM tblDIS)
DELETE FROM cte WHERE rownum > 1
--(14916 rows affected)

update tblDIS set DIS_OUTCOME = 9 where DIS_OUTCOME in (7,8)
--	(89 rows affected)

update tblDIS set dis_wd = NULL where dis_wd in (99,95)
--(27 rows affected)

select A.*, B.PATIENT from tblDIS A
INNER JOIN tblBAS B
ON A.PATIENT = B.PATIENT
--2749

/*KI000000001
  KI000000001*/

  /*DIS_ID NOT FOUND
'A15.3', 'A16.5', 'A15.1' ,'A15.2',

--A15.3 / A15.1 / A15.2 BCNE found from https://icd.who.int/browse10/2019/en#/A15.3 
A15.0 Tuberculosis of lung, bacteriologically confirmed
Tuberculous:
bronchiectasis
fibrosis of lung
pneumonia **
pneumothorax

A16.5 MC https://icd.who.int/browse10/2019/en#/A16.5
A16.7
Primary respiratory tuberculosis without mention of bacteriological or histological confirmation
Primary:
respiratory tuberculosis NOS
tuberculous complex