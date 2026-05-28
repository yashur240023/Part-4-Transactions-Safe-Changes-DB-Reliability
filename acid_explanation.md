# ACID Properties Explanation

# Scenario Used

Transaction Scenario 1:
Student submission with testcase result insertion.

---

# Atomicity

Atomicity ensures that all operations succeed together or fail together.

Example:

* submission inserted
* testcase results inserted
* submission status updated

If any query fails:

* entire transaction is rolled back

This prevents partial submission data.

---

# Consistency

Consistency ensures database rules remain valid.

Example:

* submission must reference valid student_id
* testcase results must reference valid submission_id

Foreign key constraints maintain consistency automatically.

---

# Isolation

Isolation prevents concurrent transactions from interfering.

Example:
While one transaction inserts submission results:

* another transaction cannot see incomplete intermediate data

This prevents dirty reads.

---

# Durability

Durability guarantees committed changes remain permanent.

Example:
After COMMIT:

* submission
* testcase results
* updated status

remain stored even if server crashes afterward.

---

# Importance in CodeJudge

Without ACID properties:

* submissions may partially save
* scores may mismatch
* invalid references may appear
* contest rankings may become incorrect

ACID ensures reliability of the coding platform database.
