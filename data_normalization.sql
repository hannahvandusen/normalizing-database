SELECT advisor_name, advisor_department, advisor_email
FROM college
WHERE advisor_name = 'Sommer';

-- updating email for entries with multiple conditions
UPDATE college
SET advisor_email = 'sophie@college.edu'
WHERE advisor_name = 'Sommer' AND advisor_department = 'Statistics'; 

-- MERGING DATA FROM MULTIPLE COLUMNS TOGETHER
SELECT major_1 as major
FROM college
UNION ALL
SELECT major_2 as major
FROM COLLEGE
WHERE major_2 IS NOT NULL; 

WITH majors AS(SELECT major_1 as major
FROM college
UNION ALL
SELECT major_2 as major
FROM COLLEGE
WHERE major_2 IS NOT NULL)
SELECT major, count(*)
FROM majors
GROUP BY major 
ORDER BY count(*)
  DESC;  

-- only grabs distinct values from the table
CREATE TABLE advisors AS 
SELECT distinct advisor_email, advisor_name,advisor_department
FROM college; 

-- dropping these columns from old table
ALTER TABLE college
DROP COLUMN advisor_name,
DROP COLUMN advisor_department; 

-- checking to see if it worked
SELECT *
FROM advisors
WHERE advisor_name = 'Brunson'; 

-- create new tables for students_majors and update old table to remove columns
CREATE TABLE majors AS
SELECT distinct major_1, major_1_credits_reqd
FROM college; 

CREATE TABLE students_majors AS
SELECT major_1 as major, student_id
FROM college
UNION ALL
SELECT major_2 as major, student_id
FROM college
WHERE major_2 IS NOT NULL; 

ALTER TABLE college
DROP COLUMN major_1,
DROP COLUMN major_1_credits_reqd,
DROP COLUMN major_2, 
DROP COLUMN major_2_credits_reqd; 

SELECT *
FROM students_majors
ORDER BY student_id
LIMIT 10;


-- A well ordered data set including four tables
CREATE TABLE advisors (
  id integer PRIMARY KEY,
  email varchar(50) UNIQUE,
  name varchar(50),
  department varchar(50)
); 

CREATE TABLE students (
  id integer PRIMARY KEY,
  name varchar(100),
  year varchar(50),
  email varchar(100) UNIQUE,
  advisor_id integer REFERENCES advisors(id)
); 

CREATE TABLE majors (
  id integer PRIMARY KEY,
  major varchar(100),
  credits_reqd integer
); 

CREATE TABLE students_majors (
  student_id integer REFERENCES students(id),
  major_id integer REFERENCES majors(id),
    PRIMARY KEY (student_id, major_id)
  );

-- obtain majors and number of students with that major, grouped by major
SELECT major, count(*)
FROM students_majors, majors
WHERE major_id = id
GROUP BY major
ORDER BY count
  DESC;

-- returns error as email is a unique identifier and there is more than one professor with the last name Sommer
UPDATE advisors
SET email = 'sophie@college.edu'
WHERE name = 'Sommer';
 
-- obtain required credits by student id
SELECT student_id, credits_reqd
FROM students, students_majors, majors
WHERE students.id = students_majors.student_id
AND majors.id = students_majors.major_id; 

-- update to do total credits required by student
SELECT student_id, SUM(credits_reqd) as total_credits
FROM students, students_majors, majors
WHERE students.id = students_majors.student_id
AND majors.id = students_majors.major_id
GROUP BY student_id; 

-- update to also return email 
SELECT student_id, SUM(credits_reqd) as total_credits, MIN(email) as student_email
FROM students, students_majors, majors
WHERE students.id = students_majors.student_id
AND majors.id = students_majors.major_id
GROUP BY student_id; 

