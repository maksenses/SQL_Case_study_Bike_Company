--query 1 question to answer

SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    company_dim.name
FROM    
    job_postings_fact
left JOIN   company_dim
on job_postings_fact.company_id = company_dim.company_id
where 
job_title_short = 'Data Analyst' AND
job_location = 'Anywhere' AND
salary_year_avg is not NULL

order BY
salary_year_avg DESC

limit 10