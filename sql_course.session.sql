SELECT * FROM company_dim LIMIT 5;
SELECT * FROM job_postings_fact LIMIT 5;

SELECT job_posted_date FROM job_postings_fact;

-- DATE & TIME Functions
SELECT '2026-05-17'::DATE,
        'true'::BOOLEAN,
        '123'::INT,
        '3.14'::REAL;

SELECT job_title AS title,
        job_location AS location_,
        job_posted_date::DATE AS date
FROM job_postings_fact
LIMIT 5;

SELECT job_title AS title,
        job_location AS location_,
        job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'IST' AS DATE,
        EXTRACT(MONTH FROM job_posted_date) AS date_month,
        EXTRACT(YEAR FROM job_posted_date) AS date_year
FROM job_postings_fact
LIMIT 5;

SELECT COUNT(job_id) AS job_posted_count,
        EXTRACT(MONTH FROM job_posted_date) AS date_month
FROM job_postings_fact
WHERE job_title_short='Data Analyst'
GROUP BY date_month
ORDER BY job_posted_count DESC;

SELECT job_schedule_type,
        AVG(salary_year_avg) AS yearly_avg_sal,
        AVG(salary_hour_avg) AS hourly_avg_sal
FROM job_postings_fact
WHERE job_posted_date > '2023-06-01'
GROUP BY job_schedule_type;

SELECT EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') AS month,
        COUNT(*) AS job_posted_count
FROM job_postings_fact
WHERE EXTRACT(YEAR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') = 2023
GROUP BY month
ORDER BY month ASC;

SELECT company_dim.name
FROM job_postings_fact AS jpf 
JOIN company_dim ON jpf.company_id=company_dim.company_id
WHERE jpf.job_health_insurance=TRUE AND
        EXTRACT(YEAR FROM jpf.job_posted_date)=2023 AND
        EXTRACT(QUARTER FROM jpf.job_posted_date)=2;


CREATE TABLE january_jobs AS
    SELECT * FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date)=1;

CREATE TABLE february_jobs AS
    SELECT * FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date)=2;

CREATE TABLE march_jobs AS
    SELECT * FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date)=3;

SELECT job_posted_date FROM march_jobs LIMIT 100;

-- CASE EXPRESSIONS
SELECT job_title_short,
        job_location,
        CASE
        WHEN job_location='Anywhere' THEN 'Remote'
        WHEN job_location='India' THEN 'Local'
        ELSE 'OnSite'
        END AS location_category
FROM job_postings_fact;

SELECT COUNT(job_id) AS number_of_jobs,
        CASE
            WHEN job_location='Anywhere' THEN 'Remote'
            WHEN job_location='India' THEN 'Local'
            ELSE 'OnSite'
        END AS location_category
FROM job_postings_fact
WHERE job_title='Data Analyst'
GROUP BY location_category;

SELECT job_id,
        salary_year_avg,
        CASE
        WHEN salary_year_avg BETWEEN 100000 AND 500000 THEN 'low'
        WHEN salary_year_avg BETWEEN 500000 AND 950000 THEN 'standard'
        ELSE 'high'
        END AS salary_bucket
FROM job_postings_fact
WHERE job_title='Data Analyst'
ORDER BY salary_hour_avg DESC;

-- Sub queries
SELECT * FROM (
        SELECT * FROM job_postings_fact
        WHERE EXTRACT(MONTH FROM job_posted_date)=1
) AS january_job;

SELECT company_id,
        name AS company_name
FROM company_dim
WHERE company_id IN(
        SELECT company_id
        FROM job_postings_fact
        WHERE job_no_degree_mention=TRUE
);

SELECT * FROM skills_job_dim LIMIT 5;

SELECT sjd.skill_id,
        sd.skills AS skill_name, 
        COUNT(*) AS skills_count
FROM skills_job_dim AS sjd
LEFT JOIN skills_dim as sd ON sjd.skill_id=sd.skill_id
GROUP BY sjd.skill_id, skill_name
ORDER BY skills_count DESC
LIMIT 10;

SELECT c.company_id,
        c.name AS company_name,
        job_count,
        CASE 
        WHEN job_count<10 THEN 'Small'
        WHEN job_count BETWEEN 10 AND 50 THEN 'Medium'
        ELSE 'Large'
        END AS company_size
FROM (
        SELECT company_id,
        COUNT(job_id) AS job_count
        FROM job_postings_fact
        GROUP BY company_id
) AS sub 
JOIN company_dim AS c ON sub.company_id=c.company_id
ORDER BY job_count DESC;

-- CTE (common table expressions)
WITH jan_jobs AS(
        SELECT * FROM job_postings_fact
        WHERE EXTRACT(MONTH FROM job_posted_date)=1
)
SELECT * FROM jan_jobs;

WITH company_job_counts AS(
        SELECT company_id,
        COUNT(*) AS total_jobs
        FROM job_postings_fact
        GROUP BY company_id
)
SELECT company_dim.name AS company_name,
        company_job_counts.total_jobs
FROM company_dim 
LEFT JOIN company_job_counts ON company_job_counts.company_id=company_dim.company_id
ORDER BY total_jobs DESC;


WITH remote_job_skills AS (
        SELECT skill_id,
                COUNT(*) AS skills_count
        FROM skills_job_dim AS skills_to_job
        INNER JOIN job_postings_fact ON job_postings_fact.job_id=skills_to_job.job_id
        WHERE job_postings_fact.job_work_from_home=TRUE AND 
                job_title_short='Data Analyst'
        GROUP BY skill_id
)
SELECT skill.skill_id,
        skills AS skill_name,
        skills_count
FROM remote_job_skills
INNER JOIN skills_dim AS skill ON remote_job_skills.skill_id=skill.skill_id
ORDER BY skills_count DESC
LIMIT 5;


-- UNION
SELECT job_title_short,
        company_id,
        job_location
FROM january_jobs

UNION

SELECT job_title_short,
        company_id,
        job_location
FROM february_jobs

UNION

SELECT job_title_short,
        company_id,
        job_location
FROM march_jobs;

-- UNION ALL
SELECT job_title_short,
        company_id,
        job_location
FROM january_jobs

UNION ALL

SELECT job_title_short,
        company_id,
        job_location
FROM february_jobs

UNION ALL

SELECT job_title_short,
        company_id,
        job_location
FROM march_jobs;

-- problems 
SELECT s.skills AS skill_name,
        s.skill_id,
        jpf.salary_year_avg
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd ON jpf.job_id=sjd.job_id
LEFT JOIN skills_dim AS s ON sjd.skill_id=s.skill_id
WHERE jpf.salary_year_avg>70000 AND 
        EXTRACT(QUARTER FROM jpf.job_posted_date)=1;

SELECT job_title_short,
        job_location,
        job_via,
        job_posted_date::DATE,
        salary_year_avg
FROM (
        SELECT * FROM january_jobs
        UNION ALL
        SELECT * FROM february_jobs
        UNION ALL
        SELECT * FROM march_jobs
) AS quarter1_job_postings
WHERE salary_year_avg > 70000 AND
        job_title_short='Data Analyst'
ORDER BY salary_year_avg DESC;