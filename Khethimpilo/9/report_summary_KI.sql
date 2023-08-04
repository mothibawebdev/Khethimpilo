use [Khethimpilo]
go

--Number of observations per year deaths
select Year(DEATH_D), count(DEATH_Y)
from [Khethimpilo]..tblLTFU
where year(death_d) > 2014
group by year(death_d)
order by year(death_d)

--Number of observations per year CD4
select year(cd4_d), count(*)
from [Khethimpilo]..tblLAB_CD4
where year(cd4_d) > 2014
group by year(cd4_d)
order by year(cd4_d)

--Number of observations per year enrolments
select year(enrol_d), count(*)
from [Khethimpilo]..tblBAS
where year(enrol_d) > 2014
group by year(enrol_d)
order by year(enrol_d)

--Number of observations per year transfer out
select year(drop_d), count(*)
from [Khethimpilo]..tblLTFU
where drop_rs = 4 and year(drop_d) > 2014
group by year(drop_d)
order by year(drop_d)

--Number of observations per year viral load
select year(rna_d), count(*)
from [Khethimpilo]..tblLAB_RNA
where year(rna_d) > 2014
group by year(rna_d)
order by year(rna_d)

--Number of observations per year visits
select year(vis_d), count(*)
from [Khethimpilo]..tblVIS
where year(vis_d) > 2014
group by year(vis_d)
order by year(vis_d)

--summary of errors L_ALIVE_D before DIS_ED
select b.PATIENT, b.dis_d, b.DIS_ED,  a.PATIENT, a.L_ALIVE_D
from [Khethimpilo]..tblLTFU a join [Khethimpilo]..tblDIS b
on a.PATIENT = b.PATIENT
where a.L_ALIVE_D < b.DIS_ED

--summary of errors DROP_D before DIS_D
select a.PATIENT, a.DROP_D, b.PATIENT, b.DIS_ED
from [Khethimpilo]..tblLTFU a join [Khethimpilo]..tblDIS b
on a.PATIENT = b.PATIENT
where a.DROP_D < b.DIS_ED

--summary of errors L_ALIVE_D before DIS_D
select b.PATIENT, b.DIS_D,  a.PATIENT, a.L_ALIVE_D
from [Khethimpilo]..tblLTFU a join [Khethimpilo]..tblDIS b
on a.PATIENT = b.PATIENT
where a.L_ALIVE_D < b.DIS_D

--summary of errors DROP_D before DIS_D
select a.PATIENT, a.DROP_D, a.DROP_D_A, b.PATIENT, b.DIS_D, b.DIS_D_A
from [Khethimpilo]..tblLTFU a join [Khethimpilo]..tblDIS b
on a.PATIENT = b.PATIENT
where a.DROP_D < b.DIS_D
--update
update [Khethimpilo]..tblLTFU set DROP_D_A = 'D' where DROP_D is not null
--update [Khethimpilo]..tblLTFU set DROP_D = tblDIS.DIS_D from [Khethimpilo]..tblDIS where tblLTFU.DROP_D < tblDIS.DIS_D

--summary of errors DEATH_D before L_ALIVE_D
select PATIENT, DEATH_D, L_ALIVE_D
from [Khethimpilo]..tblLTFU
where DEATH_D < L_ALIVE_D
--update
update [Khethimpilo]..tblLTFU set L_ALIVE_D = null, L_ALIVE_D_A = null where DEATH_D < L_ALIVE_D

--summary of errors DROP_D before L_ALIVE_D before BIRTH_D
select a.PATIENT, a.L_ALIVE_D, b.PATIENT, b.BIRTH_D
from [Khethimpilo]..tblLTFU a
join [Khethimpilo]..tblBAS b
on a.PATIENT = b.PATIENT
where a.L_ALIVE_D < b.BIRTH_D

--summary of errors Reason provided but date missing DROP_RS
select *
from [Khethimpilo]..tblLTFU
where drop_rs is not null and DROP_D is null

--summary of errors DEATH_D before RNA_D
select a.PATIENT, a.RNA_D, b.PATIENT, b.DEATH_D
from [Khethimpilo]..tblLAB_RNA a
join [Khethimpilo]..tblLTFU b
on a.PATIENT = b.PATIENT
where b.DEATH_D < a.RNA_D

--summary of errors DROP_D before BIRTH_D
select a.PATIENT, a.BIRTH_D, a.SEX, b.PATIENT, b.DROP_D
from [Khethimpilo]..tblBAS a
join [Khethimpilo]..tblLTFU b
on a.PATIENT = b.PATIENT
where b.DROP_D < a.BIRTH_D

--summary of errors ART_ED before ART_SD
select PATIENT, ART_SD, ART_ED, ART_ID
from [Khethimpilo]..tblART
where ART_ED < ART_SD

--update
update tblART set art_sd = art_ed where ART_ED < ART_SD

--summary of erros ART_SD before BIRTH_D
select A.PATIENT, A.ART_SD, b.PATIENT, b.BIRTH_D
from [Khethimpilo]..tblART A
join [Khethimpilo]..tblBAS b
on a.PATIENT = b.PATIENT
where a.art_sd < b.BIRTH_D

--update
update tblART set art_sd = null, ART_SD_A = null where art_sd = '1911-11-11'

--summary of erros Reason provided but date missing
select a.PATIENT, a.ARTSTART_RS, a.ART_SD, a.ART_ED
from [Khethimpilo]..tblART a
where a.ARTSTART_RS <> 99 and a.art_sd is null

--summary of erros Missing Required Variable
select *
from [Khethimpilo]..tblDIS
where DIS_ID = ''
--update
update [Khethimpilo]..tblDIS set DIS_ID = null where DIS_ID = ''