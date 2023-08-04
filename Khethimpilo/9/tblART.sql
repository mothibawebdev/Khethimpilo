USE [Khethimpilo]
GO

INSERT INTO [Khethimpilo]..[tblART] (PATIENT, ART_ID, ART_SD, ART_SD_A, ART_ED, ART_ED_A, ART_RS, ART_FORM, ART_COMB, ARTSTART_RS, PATIENT_ID)
SELECT patientid, art_id, art_sd, art_sd_a, art_ed, art_ed_a, art_rs, art_form, art_comb, artstart_rs, patientid 
FROM [Khethimpilo]..[tblART_raw]

UPDATE [Khethimpilo]..[tblART] SET PATIENT = ID FROM [Dictionary]..[PATIENTID_KI] B
WHERE [patient] = [SERIAL NUMBER]

update [Khethimpilo]..[tblART]                             
	set PATIENT = (CASE WHEN LEN(patient) = 1 THEN CONCAT('KI00000000',patient)
		WHEN LEN(patient) = 2 THEN CONCAT('KI0000000',patient)
		WHEN LEN(patient) = 3 THEN CONCAT('KI000000',patient)
		WHEN LEN(patient) = 4 THEN CONCAT('KI00000',patient)
		WHEN LEN(patient) = 5 THEN CONCAT('KI0000',patient)
		WHEN LEN(patient) = 6 THEN CONCAT('KI000',patient)
		WHEN LEN(patient) = 7 THEN CONCAT('KI00',patient) 
		WHEN LEN(patient) = 8 THEN CONCAT('KI0',patient)
		ELSE patient END)

WITH cte AS 
(SELECT PATIENT, ART_ID, ART_SD, ROW_NUMBER() 
OVER (PARTITION BY PATIENT, ART_ID, ART_SD  order by PATIENT, ART_ID, ART_SD) rownum FROM tblART)
DELETE FROM cte WHERE rownum > 1

UPDATE tblART SET ART_ID = 'J05AJ03' WHERE ART_ID = 'J05AX12'
UPDATE tblART SET ART_ID = 'J05AJ01' WHERE ART_ID = 'J05AX08'
