USE [Khethimpilo]
GO

INSERT INTO [Khethimpilo]..[tblBAS] (patient, program, birth_d, birth_d_a, enrol_d, enrol_d_a, sex, mode, naive_y, proph_y, recart_y, recart_d, recart_d_a, aids_y, aids_d, aids_d_a, hiv_pos_d, hiv_pos_d_a, center_enrol, center_last, recordid)
SELECT DISTINCT patientid AS Patient, 
		Upper(program) AS Program, birth_d, birth_d_a, enrol_d, enrol_d_a, sex, mode, naive_y, proph_y, recart_y, recart_d, recart_d_a, aids_y, aids_d, aids_d_a, hiv_pos_d, hiv_pos_d_a, center, center, patientid AS "Keep original ID"
FROM [Khethimpilo]..[tblBAS_raw] A,
[Khethimpilo]..[tblVIS_raw] B
--ON A.patientid = B.patient
--(147073 rows affected)

WITH cte AS 
(SELECT PATIENT, birth_d, ROW_NUMBER() 
OVER (PARTITION BY PATIENT, birth_d  order by PATIENT, birth_d) rownum FROM tblBAS)
DELETE FROM cte WHERE rownum > 1


--Assign/Update patientID
UPDATE [Khethimpilo]..[tblBAS] SET PATIENT = ID FROM [Dictionary]..[PATIENTID_KI] B
WHERE [patient] = [SERIAL NUMBER]

update [Khethimpilo]..[tblBAS]                             
	set PATIENT = (CASE WHEN LEN(patient) = 1 THEN CONCAT('KI00000000',patient)
		WHEN LEN(patient) = 2 THEN CONCAT('KI0000000',patient)
		WHEN LEN(patient) = 3 THEN CONCAT('KI000000',patient)
		WHEN LEN(patient) = 4 THEN CONCAT('KI00000',patient)
		WHEN LEN(patient) = 5 THEN CONCAT('KI0000',patient)
		WHEN LEN(patient) = 6 THEN CONCAT('KI000',patient)
		WHEN LEN(patient) = 7 THEN CONCAT('KI00',patient) 
		WHEN LEN(patient) = 8 THEN CONCAT('KI0',patient)
		ELSE CONCAT('KI',patient) END)

UPDATE [Khethimpilo]..[tblBAS] SET AIDS_D_A = 'U' WHERE AIDS_D IS NULL
--(133179 rows affected)

--All records missing Enrol_d, assign it to Birth_d
Update tblBAS SET enrol_d = birth_d Where enrol_d is null
--241 rows affected




