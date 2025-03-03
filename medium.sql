--1.QUERY  Show unique birth years from patients and order them by ascending. 
select distinct year(birth_date)
from patients
order by year(birth_date);

--2.QUERY Show unique first names from the patients table which only occurs once in the list.
--For example, if two or more people are named 'John' in the first_name column then don't include their name in the output list. If only 1 person is named 'Leo' then include them in the output.
select first_name 
from patients
group by first_name
having count(first_name) = 1 ;

--3.QUERY Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.
select first_name, patient_id
from patients
where first_name like 's____%s';

--4.QUERY Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'.Primary diagnosis is stored in the admissions table.
select patients.patient_id, first_name, last_name
from patients
JOIN admissions
ON patients.patient_id = admissions.patient_id
where diagnosis = 'Dementia'

--5.QUERY Display every patient's first_name.Order the list by the length of each name and then by alphabetically.
SELECT first_name
FROM patients
ORDER BY LENGTH(first_name), first_name;

--6.QUERY Show the total amount of male patients and the total amount of female patients in the patients table.Display the two results in the same row.
SELECT
	count(case gender when  'M' then 1 end ) as male_count,
    count(case gender when  'F' then 1 END ) as female_count
FROM patients

--7.QUERY Show first and last name, allergies from patients which have allergies to either 'Penicillin' or 'Morphine'. Show results ordered ascending by allergies then by first_name then by last_name.
select first_name, last_name, allergies
from patients
where allergies = 'Penicillin' or allergies = 'Morphine'
order by allergies , first_name, last_name;

--8.QUERY Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.
select patient_id, diagnosis
from admissions
group by patient_id , diagnosis
having  count(diagnosis) > 1;

--9.QUERY Show the city and the total number of patients in the city.Order from most to least patients and then by city name ascending.
select city, count(city) as num_patients
from patients
group by city
order by count(city) desc, city ;

--10.QUERY Show first name, last name and role of every person that is either patient or doctor.The roles are either "Patient" or "Doctor"
SELECT 
    p.first_name AS first_name,
    p.last_name AS last_name,
    'Patient' AS role
FROM patients p
UNION ALL
SELECT 
    d.first_name AS first_name,
    d.last_name AS last_name,
    'Doctor' AS role
FROM doctors d;

--11.QUERY Show all allergies ordered by popularity. Remove NULL values from query.
select allergies, COUNT(allergies) as total_diagnosis
from patients
where allergies is NOT null
group by allergies
having COUNT(allergies)
order by total_diagnosis desc;

--12.QUERY Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date.
select first_name, last_name, birth_date
from patients
where birth_date >= '1970-01-01' and birth_date < '1980-01-10'
order by birth_date;

--13.QUERY We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first, then first_name in all lower case letters. Separate the last_name and first_name with a comma. Order the list by the first_name in decending order
--EX: SMITH,jane
select upper(last_name) ||',' ||   lower(first_name) as new_name_format
from patients
order by first_name desc;

--14.QUERY Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.
select province_id, sum(height) as sum_height
from patients
group by province_id
having sum(height) >= 7000

--15.QUERY Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'
select max(weight) - min(weight)
from patients
where last_name = 'Maroni'

--16.QUERY Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions.
select day(admission_date) as day_number,count(patient_id) as  number_of_admissions
from admissions
group by day(admission_date)
having count(patient_id)
order by count(patient_id)

--17.QUERY Show all columns for patient_id 542's most recent admission_date.
select * 
from admissions
where patient_id = 542
group by patient_id
having max(admission_date)

--18.QUERY Show patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria:
--1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19.
--2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters.
select patient_id, attending_doctor_id, diagnosis
from admissions
where (patient_id % 2 = 1 and attending_doctor_id IN (1,5, 19)) 
or (attending_doctor_id like '%2%' and patient_id like '___')

--19.QUERY Show first_name, last_name, and the total number of admissions attended for each doctor.
--Every admission has been attended by a doctor.
SELECT first_name, last_name, count(attending_doctor_id) as admissions_total
FROM doctors d
join admissions a
on d.doctor_id = a.attending_doctor_id 
group by attending_doctor_id
having admissions_total

--20.QUERY For each doctor, display their id, full name, and the first and last admission date they attended.
select doctor_id, first_name || ' ' || last_name as full_name,
min(admission_date) as first_admission_date,
max(admission_date) as last_admission_date
from doctors d 
join admissions a 
on d.doctor_id = a.attending_doctor_id 
group by doctor_id

--21.QUERY Display the total amount of patients for each province. Order by descending.
select province_name, count(patient_id) as patient_count
from province_names pro 
join patients p 
on p.province_id = pro.province_id
group by p.province_id 
order by patient_count desc

--22.QUERY For every admission, display the patient's full name, their admission diagnosis, and their doctor's full name who diagnosed their problem.
select p.first_name || ' ' || p.last_name as patient_name, 
diagnosis,
d.first_name || ' ' || d.last_name as doctor_name
from patients p 
join admissions a 
on p.patient_id = a.patient_id
join doctors d 
on  a.attending_doctor_id = d.doctor_id

--23.QUERY display the first name, last name and number of duplicate patients based on their first name and last name.
--Ex: A patient with an identical name can be considered a duplicate.
select first_name, last_name, count(*) as num_of_duplicates
from patients
group by first_name, last_name
having count(*) = 2

--24.QUERY Display patient's full name,height in the units feet rounded to 1 decimal,weight in the unit pounds rounded to 0 decimals,
--birth_date,gender non abbreviated.Convert CM to feet by dividing by 30.48.Convert KG to pounds by multiplying by 2.205.
SELECT first_name || ' ' || last_name as patient_name,
round(height / 30.48, 1) as height,
round(weight * 2.205, 0) as weight,
birth_date,
(case when gender = 'M' then 'MALE' else 'FEMALE' end) as gender
FROM patients


--25.QUERY Show patient_id, first_name, last_name from patients whose does not have any records in the admissions table. (Their patient_id does not exist in any admissions.patient_id rows.)
select p.patient_id, first_name, last_name
from patients p 
left join admissions a 
on p.patient_id = a. patient_id
where a.patient_id IS null;

--26.QUERY Display a single row with max_visits, min_visits, average_visits where the maximum, minimum and average number of admissions per day is calculated. Average is rounded to 2 decimal places.
select max(visits) as max_visits , min(visits) as min_visits , round(avg(visits), 2) as avg_visits
from (select count(admission_date) as visits from admissions group by admission_date)