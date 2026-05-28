-- =====================================================
-- TRANSACTION SCENARIO 1
-- Student Submission with Test Results
-- =====================================================

START TRANSACTION;

INSERT INTO submissions
(
    submission_id,
    student_id,
    problem_id,
    language,
    status,
    submission_time
)
VALUES
(
    9001,
    101,
    3001,
    'Python',
    'Pending',
    NOW()
);

INSERT INTO submission_results
(
    result_id,
    submission_id,
    testcase_id,
    score,
    verdict
)
VALUES
(8001, 9001, 101, 20, 'Pass'),
(8002, 9001, 102, 20, 'Pass');

UPDATE submissions
SET status = 'Accepted'
WHERE submission_id = 9001;

COMMIT;

-- EXPECTED RESULT:
-- Submission and all testcase results are permanently saved.

--------------------------------------------------------
-- TRANSACTION SCENARIO 2
-- Enrollment Rollback Example
--------------------------------------------------------

START TRANSACTION;

INSERT INTO enrollments
(
    enrollment_id,
    student_id,
    course_id,
    enrollment_date
)
VALUES
(
    6001,
    99999,
    15,
    CURRENT_DATE
);

-- VALIDATION CHECK FAILED
-- student_id does not exist

ROLLBACK;

-- EXPECTED RESULT:
-- Invalid enrollment is completely removed.

--------------------------------------------------------
-- TRANSACTION SCENARIO 3
-- SAVEPOINT Example
--------------------------------------------------------

START TRANSACTION;

UPDATE submission_results
SET score = 95
WHERE result_id = 5501;

SAVEPOINT score_update_done;

UPDATE submissions
SET status = 'Accepted'
WHERE submission_id = 7005;

-- DETECTED ISSUE:
-- Submission still contains failed testcase

ROLLBACK TO score_update_done;

COMMIT;

-- EXPECTED RESULT:
-- Score update remains.
-- Incorrect submission status update is reversed.

--------------------------------------------------------
-- TRANSACTION SCENARIO 4
-- Regrade Request Resolution
--------------------------------------------------------

START TRANSACTION;

UPDATE regrade_requests
SET status = 'Resolved'
WHERE request_id = 4001;

UPDATE submission_results
SET score = 85
WHERE result_id = 5005;

UPDATE submissions
SET status = 'Accepted'
WHERE submission_id = 7007;

COMMIT;

-- EXPECTED RESULT:
-- Regrade workflow completes successfully.
