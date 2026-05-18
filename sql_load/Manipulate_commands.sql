CREATE TABLE job_applied(
    job_id INT,
    application_sent_date DATE,
    custom_resume BOOLEAN,
    resume_file_name VARCHAR(255),
    cover_letter_sent BOOLEAN,
    cover_letter_filename VARCHAR(255),
    status VARCHAR(255)
);

SELECT * FROM job_applied;

INSERT INTO job_applied (job_id, application_sent_date,custom_resume,
    resume_file_name,cover_letter_sent,cover_letter_filename,status)
VALUES (1,'2025-04-04',true,'resume_01.pdf',false,NULL,'submitted'),
        (2,'2025-04-07',false,NULL,true,'cover_letter_01.pdf','ghosted'),
        (3,'2025-04-12',true,'resume_01.pdf',true,'cover_letter_01.pdf','submitted'),
        (4,'2025-04-09',true,'resume_01.pdf',false,NULL,'rejected'),
        (5,'2025-04-17',true,'resume_01.pdf',true,'cover_letter_01.pdf','submitted');

ALTER TABLE job_applied ADD contact VARCHAR(50);

UPDATE job_applied
SET contact = 'Ranveer Deshmukh'
WHERE job_id = 1;

UPDATE job_applied
SET contact = 'Yash Kothule'
WHERE job_id = 2;

UPDATE job_applied
SET contact = 'Atharva Kapadne'
WHERE job_id = 3;

UPDATE job_applied
SET contact = 'Aditya Sharma'
WHERE job_id = 4;

UPDATE job_applied
SET contact = 'Vishal Mohite'
WHERE job_id = 5;

ALTER TABLE job_applied
RENAME contact TO contact_name;

ALTER TABLE job_applied
ALTER COLUMN contact_name TYPE TEXT;

ALTER TABLE job_applied
DROP COLUMN contact_name;

DROP TABLE job_applied;