use hospital

/*create table Medication
(
Med_id int primary key,
name varchar(30),
instructions varchar(100),
dosage varchar(40));

exec sp_rename 'Patient.doctor_id','patient_id','column';

alter table patient
add record_id int foreign key references Medical_Record(record_id);

create table Doctor_patient_surgey
(
doc_id int foreign key references Doctor(Doc_id),
patient_id int foreign key references Patient(patient_id),
date varchar(10) not null,
time varchar(10) not null,
);


create table Doctor_patient_examine
(
doc_id int foreign key references Doctor(Doc_id),
patient_id int foreign key references Patient(patient_id)
);


create table Department_Nurse
(
nurse_id int foreign key references Nurse(Nurse_id),
department_id int foreign key references Department(Dep_id),
hours int
);


alter table Department_Nurse
alter column hours int not null;


create table MedicalRecord_Medication
(
record_id int foreign key references Medical_Record(record_id),
medication_id int foreign key references Medication(Med_id),
hours int
);


create table Phones
(
patient_id int foreign key references Patient(patient_id),
phone varchar(11) not null
);*/


/*
Calculate the age of all patients and then display it.
*/

select patient_name, DATEDIFF(year,date_of_birth,GETDATE()) as age from Patient

/*
Arrange the patients according to their ages in descending order. 
If their ages are the same, arrange them according to their names.
*/


/*select queries */
select patient_name, DATEDIFF(year,date_of_birth,GETDATE()) as age from Patient
order by age desc , patient_name

/*
Display each patient's full address.
*/

select patient_name, city+' '+street as address from Patient;

/*
Show a table of patients' phone numbers.
*/

select Patient.patient_name, Phones.phone  from Patient
inner join Phones on Patient.patient_id=Phones.patient_id;

/*
Calculate how many patients each doctor saw.
*/

select Doc_name, count(DPE.patient_id) as NumberOfPatients from Doctor
inner join Doctor_patient_examine DPE on Doctor.Doc_id=DPE.doc_id
group by Doc_name

/*
Show me the patient's name with the doctor examining him
*/

select patient_name, Doctor.Doc_name from Patient
inner join Doctor_patient_examine DPE on Patient.patient_id=DPE.patient_id
inner join Doctor on Doctor.Doc_id =DPE.doc_id;

/*
Show me the name of the patient who will undergo surgery with  
[Dr. John Smith, Dr. Emily Johnson, Dr. Michael Brown, Dr. James Wilson] 
and the name of his surgery
*/

select Patient.patient_name, Doc_name , operation_name from Patient
inner join Doctor_patient_surgey DPS on Patient.patient_id= DPS.patient_id
inner join Doctor on DPS.doc_id=Doctor.Doc_id
where Doctor.Doc_name in ('Dr. John Smith','Dr. Emily Johnson','Dr. Michael Brown','Dr. James Wilson');

/*
How many doctors belong to the department?
*/

select Department.Dep_name, count(Doctor.department_id) as NumberDoctors from Doctor
inner join Department on Department.Dep_id= Doctor.department_id
group by Department.Dep_name;

/*
Show the department manager for each department.
*/

select Doctor.Doc_name, Doctor.specialization, Department.Dep_name from Department
inner join Doctor on Doctor.Doc_id=Department.monitor_doc_id;

/*
How many doctors belong to the department?
*/

select Department.Dep_name, count(Doctor.department_id) as NumberDoctors from Doctor
inner join Department on Department.Dep_id= Doctor.department_id
group by Department.Dep_name;

/*
Show the department manager for each department.
*/

select Doctor.Doc_name, Doctor.specialization, Department.Dep_name from Department
inner join Doctor on Doctor.Doc_id=Department.monitor_doc_id;

/*
Show the name of the patient and the nurse responsible for him
*/

select p.patient_name, N.Nurse_name from Medical_Record MR
inner join Nurse N on MR.nurse_id = N.Nurse_id
inner join Patient p on p.record_id = MR.record_id;

/*
Calculate how many operating rooms are in the department?
*/

select  D.Dep_name, count(SOR.SOR_id) as NumberSORs from Surgical_Operations_Rooms SOR
inner join Department D on D.Dep_id = SOR.department_id
group by D.Dep_name;

/*
Calculate the total working hours of each nurse.
*/

select Nurse.Nurse_name, sum(hours) as SumHours from Nurse
inner join Department_Nurse DN on DN.nurse_id = Nurse.Nurse_id
group by Nurse.Nurse_name;

/*
Show all nurses and each nurse's supervisor.
*/

select Nurse.Nurse_name as nurse, mon.Nurse_name monitor from Nurse
left join Nurse as mon on mon.Nurse_id=Nurse.Monitor_Nurse_id;

/*
Show the name of the doctor who performed the septoplasty for Yasmin Farouk's patient
[Angioplasty  Ali Hassan ,Pacemaker Implant Sara Ahmed ]
*/

select Doc_name from [Doctor_patient_surgey] sur
inner join Doctor on Doctor.Doc_id= sur.doc_id
inner join Patient on Patient.patient_id=sur.patient_id
where sur.operation_name='Septoplasty' and patient_name='Yasmin Farouk' ;

/*
Show the medicines whose names start with the letter A.
*/

select * from Medication M
where M.name like '%A%';

/*
Show the operations that were not performed by the following doctors:
('Dr. John Smith', 'Dr. Rimon Beshara', 'Dr. Robert Taylor', 'Dr. William Lewis')
*/

select Patient.patient_name,operation_name,date from [Doctor_patient_surgey] DPS
inner join Doctor on Doctor.Doc_id = DPS.doc_id
inner join Patient on Patient.patient_id = DPS.patient_id
where Doc_name not in('Dr. John Smith', 'Dr. Rimon Beshara', 'Dr. Robert Taylor', 'Dr. William Lewis');

select Nurse.Nurse_name as nurse, mon.Nurse_name monitor from Nurse
inner join Nurse as mon on mon.Nurse_id=Nurse.Monitor_Nurse_id; --self join

select distinct Doc_name from Doctor_patient_examine
inner join Doctor on Doctor.Doc_id=Doctor_patient_examine.doc_id
--inner join Patient on Patient.patient_id=Doctor_patient_examine.patient_id;

select doc_id from [dbo].[Doctor_patient_surgey]
order by doc_id desc;

/*join
(select patient_id, operation_name, date, time from [dbo].[Doctor_patient_surgey]);*/

select Doc_name from [dbo].[Doctor_patient_surgey] sur
inner join Doctor on Doctor.Doc_id= sur.doc_id
where sur.operation_name='Septoplasty';

select diagnosis as disease, name as medication from [dbo].[MedicalRecord_Medication] as re_med
inner join Medication on re_med.medication_id= Medication.Med_id
inner join Medical_Record rec on re_med.record_id= rec.record_id
where dosage='50mg' --and not treatment like '%atenolol';

select top 10 *from Nurse;

select Dep_name, count(nurse_id) Nurses from Department_Nurse
inner join Department on Department.Dep_id=Department_Nurse.department_id
group by Dep_name
--having Dep_name like '%ics' or Dep_name like '%ology';


select Nurse_id, Nurse_name from Nurse
order by Nurse_id desc
OFFSET 5 ROWS FETCH NEXT 10 ROWS ONLY;

select nurse.nurse_name nurse, Monitor.nurse_name monitor from Nurse
left join Nurse Monitor on Nurse.Monitor_Nurse_id=Monitor.Nurse_id;


select Patient.patient_name, Phones.phone monitor from Patient
right join Phones on Patient.patient_id=Phones.patient_id;


select operation_name from [dbo].[Doctor_patient_surgey]
inner join Doctor on Doctor.Doc_id=[dbo].[Doctor_patient_surgey].doc_id
where Doc_name not in('Dr. John Smith', 'Dr. Rimon Beshara', 'Dr. Robert Taylor', 'Dr. William Lewis');

select * from Patient 
where patient_id not between 13 and 25;

select name from Medication where name in
(select top 5 name from Medication
order by Med_id asc)
union
--except
--intersect
select name from Medication where name in
(select name from Medication
order by Med_id desc
offset 5 rows fetch next 5 rows only);


/*To delete column data
*/

update Doctor_patient_surgey set time=null

/*
Update data according to a specific condition
*/

update DPS set time ='9:00:00'
from Doctor 
inner join Doctor_patient_surgey DPS on  DPS.doc_id=Doctor.Doc_id
where Doctor.Doc_name in ('Dr. John Smith','Dr. Emily Johnson','Dr. Michael Brown','Dr. James Wilson')

update DPS set time ='12:30:00'
from Doctor 
inner join Doctor_patient_surgey DPS on  DPS.doc_id=Doctor.Doc_id
where Doctor.Doc_name not in ('Dr. John Smith','Dr. Emily Johnson','Dr. Michael Brown','Dr. James Wilson')

/*
To delete a table
*/

drop table Phones

/*
To delete data table
*/

delete Surgical_Operations_Rooms
