-- THe project is about Scholastic Aptitude Test (SAT) scores from New York City's public schools.
-- The dataset included the average SAT scores for math, reading, and writing, along with the school name, borough, and building code. 
-- The goal was understand the performance of these schools in different aspects of the SAT.

-- How many schools fail to report information
SELECT COUNT(*) AS num_schools_missing_info
FROM schools_modified
WHERE average_math IS NULL OR average_reading IS NULL OR average_writing IS NULL OR percent_tested IS NULL;
-- 20 schools failed to report their information  and this might be due to lack of participation or administrative errors 

-- Which (or how many) schools are best/worst in each of the three components of the SAT—reading, math, and writing
--  best
WITH avg_math AS (
    SELECT AVG(average_math) AS average_score
    FROM schools_modified
),
avg_reading AS (
    SELECT AVG(average_reading) AS average_score
    FROM schools_modified
),
avg_writing AS (
    SELECT AVG(average_writing) AS average_score
    FROM schools_modified
)

SELECT 
    (SELECT COUNT(*) FROM schools_modified WHERE average_math > avg_math.average_score) AS number_of_schools_above_average_math,
    (SELECT COUNT(*) FROM schools_modified WHERE average_reading > avg_reading.average_score) AS number_of_schools_above_average_reading,
    (SELECT COUNT(*) FROM schools_modified WHERE average_writing > avg_writing.average_score) AS number_of_schools_above_average_writing
FROM avg_math, avg_reading, avg_writing;

-- We had 136, 137, 137 schools that were above average in maths, reading and writing respectively.
-- Worst in each category
WITH avg_math AS (
    SELECT AVG(average_math) AS average_score
    FROM schools_modified
),
avg_reading AS (
    SELECT AVG(average_reading) AS average_score
    FROM schools_modified
),
avg_writing AS (
    SELECT AVG(average_writing) AS average_score
    FROM schools_modified
)

SELECT 
    (SELECT COUNT(*) FROM schools_modified WHERE average_math < avg_math.average_score) AS number_of_schools_below_average_math,
    (SELECT COUNT(*) FROM schools_modified WHERE average_reading < avg_reading.average_score) AS number_of_schools_below_average_reading,
    (SELECT COUNT(*) FROM schools_modified WHERE average_writing < avg_writing.average_score) AS number_of_schools_below_average_writing
FROM avg_math, avg_reading, avg_writing;
-- We had 239, 238, 238 schools that were below average in maths, reading and writing respectively.
-- This information is useful for students and parents who are considering these schools.

-- The best/worst scores for different SAT components
-- Best
SELECT 
       MAX(average_math) AS best_math_score, 
       MAX(average_reading) AS best_reading_score, 
       MAX(average_writing) AS best_writing_score
FROM schools_modified;
-- 754	697	693
-- Worst
SELECT 
       MIN(average_math) AS worst_math_score, 
       MIN(average_reading) AS worst_reading_score, 
       MIN(average_writing) AS worst_writing_score
FROM schools_modified;


-- The top 10 schools by average total SAT scores
SELECT school_name, round((average_math + average_reading + average_writing)/3,0) AS total_score 
FROM schools_modified 
ORDER BY total_score DESC 
LIMIT 10;
-- the top 10 schools were
-- Stuyvesant High School-715
-- Bronx High School of Science-680
-- Staten Island Technical High School-680
-- High School of American Studies at Lehman College-671
-- Townsend Harris High School-660
-- Queens High School for the Sciences at York College-649
-- Bard High School Early College-638
-- Brooklyn Technical High School-632
-- Eleanor Roosevelt High School-630
-- High School for Mathematics, Science, and Engineering at City College-630


-- How the test performance varies by borough
SELECT borough, AVG(average_math) AS avg_math, AVG(average_reading) AS avg_reading, AVG(average_writing) AS avg_writing 
FROM schools_modified 
GROUP BY borough
ORDER by borough;
-- Staten Island was the best and the least was Bronx.

-- The top 5 schools by average SAT scores across all three components (or for a certain component) for a selected borough
(SELECT borough, school_name, round((average_math + average_reading + average_writing)/3,0) AS avg_score 
FROM schools_modified 
WHERE borough = 'Bronx' 
ORDER BY avg_score DESC 
LIMIT 5)

UNION ALL

(SELECT borough, school_name, round((average_math + average_reading + average_writing)/3,0) AS avg_score 
FROM schools_modified 
WHERE borough = 'Brooklyn' 
ORDER BY avg_score DESC 
LIMIT 5)

UNION ALL

(SELECT borough, school_name, round((average_math + average_reading + average_writing)/3,0) AS avg_score 
FROM schools_modified 
WHERE borough = 'Manhattan' 
ORDER BY avg_score DESC 
LIMIT 5)

UNION ALL

(SELECT borough, school_name, round((average_math + average_reading + average_writing)/3,0) AS avg_score 
FROM schools_modified 
WHERE borough = 'Queens' 
ORDER BY avg_score DESC 
LIMIT 5)

UNION ALL

(SELECT borough, school_name, round((average_math + average_reading + average_writing)/3,0) AS avg_score 
FROM schools_modified 
WHERE borough = 'Staten Island' 
ORDER BY avg_score DESC 
LIMIT 5);
-- The top 5 in each borough were
-- Bronx
-- 		Bronx High School of Science-680
-- 		High School of American Studies at Lehman College-671
-- 		Bronx Center for Science and Mathematics-489
-- 		Riverdale/Kingsbridge Academy-486
-- 		Collegiate Institute for Math and Science-469
-- Brooklyn
-- 		Brooklyn Technical High School-632
-- 		Brooklyn Latin School-601
--    	Millennium Brooklyn High School-548
--      Leon M. Goldstein High School for the Sciences-547
-- 		Midwood High School-527
-- Manhattan
--      Stuyvesant High School-715
--      Bard High School Early College-638
--      High School for Mathematics, Science, and Engineering at City College-630
--      Eleanor Roosevelt High School-630
--      New Explorations into Science, Technology and Math High School-620
--  Queens
--      Townsend Harris High School-660
--      Queens High School for the Sciences at York College-649
--      Baccalaureate School for Global Education-627
--      Bard High School Early College Queens-613
--      Scholars' Academy-572
-- Staten Island
--      Staten Island Technical High School-680
--      Susan E. Wagner High School-491
--      Tottenville High School-482
--      Michael J. Petrides School-475
--      CSI High School for International Studies-470



