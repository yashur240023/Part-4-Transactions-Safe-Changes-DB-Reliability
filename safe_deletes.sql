-- =====================================================
-- CREATE STAGING TABLES
-- =====================================================

CREATE TABLE staging_enrollments AS
SELECT * FROM enrollments;

CREATE TABLE staging_submissions AS
SELECT * FROM submissions;

--------------------------------------------------------
-- DELETE 1: REMOVE DUPLICATE ENROLLMENTS
--------------------------------------------------------

-- BEFORE

SELECT student_id, course_id, COUNT(*)
FROM staging_enrollments
GROUP BY student_id, course_id
HAVING COUNT(*) > 1;

-- DELETE

DELETE FROM staging_enrollments
WHERE enrollment_id NOT IN
(
    SELECT MIN(enrollment_id)
    FROM staging_enrollments
    GROUP BY student_id, course_id
);

-- AFTER

SELECT student_id, course_id, COUNT(*)
FROM staging_enrollments
GROUP BY student_id, course_id
HAVING COUNT(*) > 1;

-- SAFETY NOTE:
-- Keeps earliest valid enrollment record only.

--------------------------------------------------------
-- DELETE 2: REMOVE ORPHAN SUBMISSIONS
--------------------------------------------------------

-- BEFORE

SELECT s.submission_id
FROM staging_submissions s
LEFT JOIN students st
ON s.student_id = st.student_id
WHERE st.student_id IS NULL;

-- DELETE

DELETE FROM staging_submissions
WHERE student_id NOT IN
(
    SELECT student_id
    FROM students
);

-- AFTER

SELECT s.submission_id
FROM staging_submissions s
LEFT JOIN students st
ON s.student_id = st.student_id
WHERE st.student_id IS NULL;

-- SAFETY NOTE:
-- Deletes only submissions referencing missing students.
