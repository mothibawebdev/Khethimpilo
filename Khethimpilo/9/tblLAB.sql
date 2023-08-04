USE [Khethimpilo]
GO

INSERT INTO [Khethimpilo]..[tblLAB] (PATIENT, LAB_ID, LAB_D, LAB_D_A, LAB_V, LAB_U)
SELECT *
FROM [Khethimpilo]..[tblLAB_raw]
--167796 Records

WITH cte AS 
(SELECT patient, lab_id, LAB_D, ROW_NUMBER() 
OVER (PARTITION BY patient, lab_id, LAB_D  order by patient, lab_id, LAB_D) rownum FROM tblLAB)
DELETE FROM cte WHERE rownum > 1
-- 1280 Records

UPDATE [Khethimpilo]..[tblLAB] SET PATIENT = ID FROM [Dictionary]..[PATIENTID_KI]
WHERE [patient] = [SERIAL NUMBER]
--166516 Records

update [Khethimpilo]..[tblLAB]                             
	set PATIENT = (CASE WHEN LEN(patient) = 1 THEN CONCAT('KI00000000',patient)
		WHEN LEN(patient) = 2 THEN CONCAT('KI0000000',patient)
		WHEN LEN(patient) = 3 THEN CONCAT('KI000000',patient)
		WHEN LEN(patient) = 4 THEN CONCAT('KI00000',patient)
		WHEN LEN(patient) = 5 THEN CONCAT('KI0000',patient)
		WHEN LEN(patient) = 6 THEN CONCAT('KI000',patient)
		WHEN LEN(patient) = 7 THEN CONCAT('KI00',patient) 
		WHEN LEN(patient) = 8 THEN CONCAT('KI0',patient)
		ELSE CONCAT('KI',patient) END)


UPDATE tblLAB SET LAB_ID = 'TBNAAT' WHERE LAB_ID = 'TBLP'
UPDATE tblLAB SET LAB_ID = 'TBC' WHERE LAB_ID = 'TBCD'
UPDATE tblLAB SET LAB_ID = 'TBGX' WHERE LAB_ID = 'TBGE'

UPDATE [Khethimpilo]..[tblLAB] SET LAB_U = (CASE WHEN LAB_ID = 'ALT' THEN 5
													WHEN LAB_ID IN ('TBNAAT', 'TBGX', 'TBC','TBM') THEN NULL
													WHEN LAB_ID = 'CRE' THEN 6
													WHEN LAB_ID = 'TRIG' THEN 1
													WHEN LAB_ID = 'CHOL' THEN 1
													WHEN LAB_ID = 'PCRA' THEN 15 
													WHEN LAB_ID = 'ALB' THEN 3 
													WHEN LAB_ID = 'AMY' THEN 5 
													WHEN LAB_ID = 'AST' THEN 10
													WHEN LAB_ID = 'HAEM' THEN 3
													WHEN LAB_ID = 'LACT' THEN 1
													WHEN LAB_ID = 'MCV' THEN 16
													WHEN LAB_ID = 'NEU' THEN 10
													WHEN LAB_ID = 'THR' THEN 10 END)


UPDATE tblLAB SET LAB_V = NULL
/*DELETE FROM [Khethimpilo]..[tblLAB] WHERE LAB_ID IN ('TBS','RAP','LAM','SER','MNTX','TBXR','PCR','HIV_UNK','CRAG')*/
