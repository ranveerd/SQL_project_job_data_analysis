WITH top_paying_jobs AS (
    SELECT 
        job_id,
        job_title,
        salary_year_avg,
        job_posted_date,
        name AS company_name
    FROM job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id=company_dim.company_id
    WHERE
        job_title_short='Data Analyst' AND
        job_location='Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 10
)
SELECT top_paying_jobs.*,
    skills AS skill_name
FROM top_paying_jobs
INNER JOIN skills_job_dim ON skills_job_dim.job_id=top_paying_jobs.job_id
INNER JOIN skills_dim ON skills_dim.skill_id=skills_job_dim.skill_id
ORDER BY salary_year_avg DESC;




/*
📊 Salary Trends
Highest Salary Role: Associate Director – Data Insights at AT&T with an average annual salary of $255,829.5.
Other High-Paying Roles: Data Analyst, Marketing at Pinterest – $232,423
Data Analyst (Hybrid/Remote) at UCLA Healthcare – $217,000
Principal Data Analyst (Remote) at SmartAsset – $205,000
Director, Data Analyst – HYBRID at Inclusively – $189,309
Forecast Insight: Leadership and specialized analyst roles (Director, Principal, Associate Director) consistently command salaries above $180K, suggesting strong demand for senior-level data professionals.

🛠️ Skill Demand Analysis
Across roles, the most frequently required skills are:
SQL – appears in nearly every job.
Python – equally dominant, especially in analyst and director roles.
Tableau – visualization tool in high demand.
Excel and Power BI – remain relevant for reporting.
Cloud Platforms: AWS, Azure, Snowflake.
Emerging Tools: Databricks, Pyspark, GitLab, Jenkins, Jira, Confluence – showing integration of data engineering + DevOps into analyst roles.

Forecast Insight:
Hybrid skill sets (data analysis + cloud + visualization + DevOps) will dominate future job postings.
SQL + Python + Tableau/Power BI remains the “core trio” for analysts.
Cloud and big data tools (Snowflake, Databricks, Hadoop) are becoming mandatory differentiators for higher salaries.
*/
