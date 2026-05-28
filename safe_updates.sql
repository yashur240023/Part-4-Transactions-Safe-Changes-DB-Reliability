-- =====================================================
-- CREATE STAGING TABLES
-- =====================================================

CREATE TABLE staging_students AS
SELECT * FROM students;

CREATE TABLE staging_submissions AS
SELECT * FROM submissions;

CREATE TABLE staging_submission_results AS
SELECT * FROM submission_results;

--------------------------------------------------------
-- UPDATE 1: FIX INVALID EMAIL
--------------------------------------------------------

-- BEFORE

SELECT student_id, email
FROM staging_students
WHERE email = 'amitgmail.com';

-- UPDATE

UPDATE staging_students
SET email = 'amit@gmail.com'
WHERE student_id = 204
  AND email = 'amitgmail.com';

-- AFTER

SELECT student_id, email
FROM staging_students
WHERE student_id = 204;

-- SAFETY NOTE:
-- WHERE clause uses both student_id and old email value.
-- Prevents accidental updates to other students.

--------------------------------------------------------
-- UPDATE 2: FIX MISSING BATCH
--------------------------------------------------------

-- BEFORE

SELECT student_id, batch_id
FROM staging_students
WHERE batch_id IS NULL;

-- UPDATE

UPDATE staging_students
SET batch_id = 12
WHERE student_id = 305
  AND batch_id IS NULL;

-- AFTER

SELECT student_id, batch_id
FROM staging_students
WHERE student_id = 305;

-- SAFETY NOTE:
-- Specific student_id prevents mass update.

--------------------------------------------------------
-- UPDATE 3: FIX INVALID SCORE
--------------------------------------------------------

-- BEFORE

SELECT result_id, score
FROM staging_submission_results
WHERE score = -10;

-- UPDATE

UPDATE staging_submission_results
SET score = 0
WHERE result_id = 5501
  AND score = -10;

-- AFTER

SELECT result_id, score
FROM staging_submission_results
WHERE result_id = 5501;

-- SAFETY NOTE:
-- Uses exact result_id and original score value.

--------------------------------------------------------
-- UPDATE 4: UPDATE SUBMISSION STATUS
--------------------------------------------------------

-- BEFORE

SELECT submission_id, status
FROM staging_submissions
WHERE submission_id = 7002;

-- UPDATE

UPDATE staging_submissions
SET status = 'Accepted'
WHERE submission_id = 7002
AND submission_id IN
(
    SELECT submission_id
    FROM submission_results
    GROUP BY submission_id
    HAVING SUM(
        CASE WHEN verdict = 'Fail' THEN 1 ELSE 0 END
    ) = 0
);

-- AFTER

SELECT submission_id, status
FROM staging_submissions
WHERE submission_id = 7002;

-- SAFETY NOTE:
-- Status changes only if all testcase verdicts are Pass.
