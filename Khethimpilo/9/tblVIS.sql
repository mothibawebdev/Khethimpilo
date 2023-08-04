USE [Khethimpilo]
GO

INSERT INTO [Khethimpilo]..tblVIS (PATIENT, CENTER, VIS_D, VIS_D_A, NEXT_VISIT_D, NEXT_VISIT_D_A, CDC_STAGE, WHO_STAGE, SMOKING_Y, PREG_Y, BREASTF_Y, FEEDOTH_Y, CAREGIVER)
SELECT PATIENT, CENTER, VIS_D, VIS_D_A, NEXT_VIS_D, NEXT_VIS_D_A, CDC_STAGE, WHO_STAGE, SMOKING_Y, PREG_Y, BREASTF_Y, FEEDOTH_Y, CAREGIVER
FROM [Khethimpilo]..tblVIS_raw
--1048575 Records

WITH cte AS 
(SELECT PATIENT, CENTER, VIS_D, ROW_NUMBER() 
OVER (PARTITION BY PATIENT, CENTER, VIS_D  order by PATIENT, CENTER, VIS_D) rownum FROM tblVIS)
DELETE FROM cte WHERE rownum > 1
--3122 Records

UPDATE [Khethimpilo]..[tblVIS] SET PATIENT = ID FROM [Dictionary]..[PATIENTID_KI] B
WHERE [patient] = [SERIAL NUMBER]
--1045453 Records

update [Khethimpilo]..[tblVIS]                             
	set PATIENT = (CASE WHEN LEN(patient) = 1 THEN CONCAT('KI00000000',patient)
		WHEN LEN(patient) = 2 THEN CONCAT('KI0000000',patient)
		WHEN LEN(patient) = 3 THEN CONCAT('KI000000',patient)
		WHEN LEN(patient) = 4 THEN CONCAT('KI00000',patient)
		WHEN LEN(patient) = 5 THEN CONCAT('KI0000',patient)
		WHEN LEN(patient) = 6 THEN CONCAT('KI000',patient)
		WHEN LEN(patient) = 7 THEN CONCAT('KI00',patient) 
		WHEN LEN(patient) = 8 THEN CONCAT('KI0',patient)
		ELSE CONCAT('KI',patient) END)