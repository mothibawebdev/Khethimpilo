USE [Khethimpilo]
GO

INSERT INTO [Khethimpilo]..[tblLTFU] (PATIENT, DROP_Y, DROP_D, DROP_D_A, DROP_RS, DEATH_Y, DEATH_D, DEATH_D_A, L_ALIVE_D, L_ALIVE_D_A)
SELECT [patient] ,[drop_y],
	(CASE WHEN drop_y = 1 THEN drop_d 
		WHEN drop_rs = '4.0' THEN transfer_d
		WHEN (drop_rs = '1.0' AND drop_d IS NULL) THEN ltfu_d 
	END) AS DROP_D,[drop_d_a],[drop_rs],
	(CASE WHEN [death_y]=9 THEN 0 ELSE [death_y] END),[death_d],[death_d_a],[l_alive_d],[l_alive_d_a]
FROM [Khethimpilo]..[tblLTFU_raw]
--(147073 rows affected)

UPDATE [Khethimpilo]..[tblLTFU] SET PATIENT = ID FROM [Dictionary]..[PATIENTID_KI] B
WHERE [patient] = [SERIAL NUMBER]

update [Khethimpilo]..[tblLTFU]                             
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
(SELECT PATIENT, DROP_D, ROW_NUMBER() 
OVER (PARTITION BY PATIENT, DROP_D  order by PATIENT, DROP_D) rownum FROM tblLTFU)
DELETE FROM cte WHERE rownum > 1
--(0 rows affected)

--Update l_alive_d and drop_d to tranfer_d if drop_rs = 4
UPDATE [Khethimpilo]..[tblLTFU] SET DROP_D = transfer_d FROM [Khethimpilo]..[tblLTFU_raw] WHERE DROP_RS = '4.0'
