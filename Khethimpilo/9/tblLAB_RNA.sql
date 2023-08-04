USE [Khethimpilo]
GO

INSERT INTO [Khethimpilo]..[tblLAB_RNA] (PATIENT, RNA_D, RNA_D_A, RNA_V, RNA_L, RNA_T)
SELECT *
FROM [Khethimpilo]..[tblLAB_RNA_raw]
--(157966 rows affected)

UPDATE [Khethimpilo]..[tblLAB_RNA] SET PATIENT = ID FROM [Dictionary]..[PATIENTID_KI] B
WHERE [patient] = [SERIAL NUMBER]

update [Khethimpilo]..[tblLAB_RNA]                             
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
(SELECT patient, RNA_D, RNA_D, ROW_NUMBER() 
OVER (PARTITION BY patient, RNA_D, RNA_D  order by patient, RNA_D, RNA_D) rownum FROM tblLAB_RNA)
DELETE FROM cte WHERE rownum > 1
--(385 rows affected)
--(385 rows affected)