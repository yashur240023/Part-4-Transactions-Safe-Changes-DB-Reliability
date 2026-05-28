# Reliability Incident Note

# Incident Description

A developer accidentally executed:

```sql id="06vq4x"
UPDATE submissions
SET status = 'Accepted';
```

without using a WHERE clause.

---

# What Went Wrong

The query updated every submission in the database.

This incorrectly changed:

* failed submissions
* runtime errors
* wrong answers

into Accepted status.

---

# Possible Impact

Affected data includes:

* leaderboard rankings
* contest results
* student performance metrics
* submission statistics

This could compromise the integrity of the entire CodeJudge platform.

---

# Detection Method

The issue could be detected by:

* sudden spike in Accepted submissions
* audit logs
* abnormal success-rate reports
* transaction monitoring

Example:
If Accepted submissions suddenly increase from 40% to 100%, investigation is required.

---

# Recovery Approach

If wrapped inside a transaction:

```sql id="by4m56"
ROLLBACK;
```

could immediately reverse the damage.

If already committed:

* restore from backup
* use point-in-time recovery
* replay audit logs if available

---

# Preventive Measures

## 1. Always Use WHERE Clauses

Every UPDATE and DELETE must include:

* validation SELECT
* restrictive WHERE conditions

---

## 2. Use Transactions

Test risky operations inside:

```sql id="xvq24n"
START TRANSACTION;
```

before committing permanently.

---

## 3. Restrict Production Permissions

Developers should not directly modify production tables without approval.

---

## 4. Use Staging Tables

All repair and debugging operations should occur on staging copies first.

---

## 5. Enable Audit Logging

Track:

* who modified data
* when changes occurred
* which rows were affected

This improves accountability and recovery capability.

---

# Final Conclusion

Unsafe UPDATE or DELETE statements are one of the biggest risks in database systems.

Proper transaction handling, backups, validation queries, and staged workflows are essential for database reliability.
