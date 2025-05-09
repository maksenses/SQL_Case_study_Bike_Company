select 
    skills,
    count(skills_job_dim.job_id) as demand_count
from job_postings_fact 
inner join skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' and 
    job_location = 'Singapore'
group BY    skills
order BY    
    demand_count desc
limit 5 