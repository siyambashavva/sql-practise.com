--1.QUERY Show all of the patients grouped into weight groups.Show the total amount of patients in each weight group.
--Order the list by the weight group decending.For example, if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.
select (case when weight between 0 and 9 then 0
        when weight between 10 and 19 then 10
         when weight between 20 and 29 then 20
         when weight between 30 and 39 then 30
         when weight between 40 and 49 then 40
         when weight between 50 and 59 then 50
         when weight between 60 and 69 then 60
         when weight between 70 and 79 then 70
         when weight between 80 and 89 then 80
         when weight between 90 and 99 then 90
         when weight between 100 and 109 then 100
         when weight between 110 and 119 then 110
         when weight between 120 and 129 then 120
         when weight between 130 and 139 then 130
         when weight between 140 and 149 then 140 
       	end) as weighted_group, count(*) as patients_in_group
from patients
group by weighted_group
order by weighted_group desc

--2.QUERY Show patient_id, weight, height, isObese from the patients table.Display isObese as a boolean 0 or 1.
--Obese is defined as weight(kg)/(height(m)2) >= 30.weight is in units kg.height is in units cm.
SELECT patient_id, weight, height,
(case when weight /power((height / 100.0), 2) >= 30 then 1 else 0 end) as isObese
from patients;

--3.QUERY Show patient_id, first_name, last_name, and attending doctor's specialty.
--Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'Check patients, admissions, and doctors tables for required information.
SELECT  p.patient_id, p.first_name, p.last_name , d.specialty 
FROM patients p 
inner join admissions a 
on p.patient_id = a.patient_id
inner join doctors d 
on  a.attending_doctor_id = d.doctor_id
where a.diagnosis like 'Epilepsy' and d.first_name like 'Lisa'

--4.QUERY All patients who have gone through admissions, can see their medical documents on our site. Those patients are given a temporary password after their first admission. Show the patient_id and temp_password.
--The password must be the following, in order:1. patient_id.2. the numerical length of patient's last_name.3. year of patient's birth_date
SELECT distinct
    p.patient_id,
    concat(a.patient_id,
    LEN(p.last_name) ,
    YEAR(p.birth_date)) AS Generated_Column
FROM 
    patients p
INNER JOIN 
    admissions a 
ON 
    p.patient_id = a.patient_id;

--5.QUERY Each admission costs $50 for patients without insurance, and $10 for patients with insurance. All patients with an even patient_id have insurance.
--Give each patient a 'Yes' if they have insurance, and a 'No' if they don't have insurance. Add up the admission_total cost for each has_insurance group.
SELECT 
case when patient_id % 2 = 0 then 'Yes' else 'No' end as has_insurance,
case when patient_id % 2 = 0 then count(*) * 10 else count(*) * 50 end as cost
FROM admissions
group by has_insurance

--6.QUERY Show the provinces that has more patients identified as 'M' than 'F'. Must only show full province_name
SELECT pro.province_name
from province_names pro
join patients p
on pro.province_id = p.province_id 
group by pro.province_name
having count( case  when p.gender = 'M' then 1 end ) > count(case when p.gender = 'F'then 1 end)

--7.QUERY We are looking for a specific patient. Pull all columns for the patient who matches the following criteria:
-- First_name contains an 'r' after the first two letters.
-- Identifies their gender as 'F'
-- Born in February, May, or December
-- Their weight would be between 60kg and 80kg
-- Their patient_id is an odd number
-- They are from the city 'Kingston'

SELECT * FROM patients
where first_name like '__%r%' and gender like 'F' and 
 month(birth_date) in ( 2, 5, 12) and (weight between 60 and 80 )
and patient_id % 2 <> 0 and city like 'Kingston'


--8.QUERY Show the percent of patients that have 'M' as their gender. Round the answer to the nearest hundreth number and in percent form.
select cast(round(sum(gender = 'M') * 100.0 / (select count(*) from  patients) , 2) as varchar(5)) || '%' 
as percent_of_male_patients
from patients

--9.QUERY For each day display the total amount of admissions on that day. Display the amount changed from the previous date.
select admission_date, count(*) as admission_day, 
count(*) - lag(count(*)) over (order by admission_date) as admission_count_change
from admissions
group by admission_date
order by admission_date

--10.QUERY Sort the province names in ascending order in such a way that the province 'Ontario' is always on top.
select province_name
from province_names
group by province_name 
order by(case province_name when 'Ontario' then 0 else 1 end), province_name

--11.QUERY We need a breakdown for the total amount of admissions each doctor has started each year. Show the doctor_id, doctor_full_name, specialty, year, total_admissions for that year.
select d.doctor_id, d.first_name || ' ' || d.last_name as doctor_name, d.specialty , 
year(a.admission_date) as selected_year,
count(a.admission_date) as total_admissions
from doctors d, admissions a
where d.doctor_id = a.attending_doctor_id
group by doctor_name , selected_year
order by doctor_id