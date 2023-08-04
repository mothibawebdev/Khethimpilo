USE [Khethimpilo]
GO

INSERT INTO [Khethimpilo]..[tblLAB_CD4] (PATIENT, CD4_d, CD4_D_A, CD4_V, CD4_U)
SELECT *
FROM [Khethimpilo]..[tblLAB_CD4_raw]

UPDATE [Khethimpilo]..[tblLAB_CD4] SET PATIENT = ID FROM [Dictionary]..[PATIENTID_KI] B
WHERE [patient] = [SERIAL NUMBER]

update [Khethimpilo]..[tblLAB_CD4]                             
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
(SELECT patient, cd4_d, CD4_V, ROW_NUMBER() 
OVER (PARTITION BY patient, cd4_d, CD4_V  order by patient, cd4_d, CD4_V) rownum FROM tblLAB_CD4)
DELETE FROM cte WHERE rownum > 1

/*
SELECT A.[PATIENT] AS "PATIENT CD4"
      ,[CD4_D]
      ,[CD4_D_A]
      ,[CD4_V]
      ,[CD4_U], B.PATIENT AS "PATIENT BAS"
  FROM [Khethimpilo].[dbo].[tblLAB_CD4] A
  LEFT JOIN tblBAS B ON A.PATIENT = B.PATIENT
  --WHERE B.PATIENT IS NULL
  */
