\# Normalization Documentation



This document shows how three key tables were normalized from Unnormalized Form (UNF) to Third Normal Form (3NF).



\---



\## Table 1: Student Registration Data



\### Unnormalized Form (UNF)



A single spreadsheet storing all student data with repeating course information:



| StudentID | Name | CNIC | Department | Courses | Instructors |

|-----------|------|------|------------|---------|-------------|

| 1001 | Ahmed Raza | 35201-1234567-8 | Computer Science | CS101, CS102 | Dr. Khalid Mahmood, Dr. Saira Batool |

| 1002 | Fatima Akhtar | 35201-2345678-9 | Computer Science | CS101 | Dr. Khalid Mahmood |



\*\*Problems Identified:\*\*

\- Repeating groups (multiple courses in one column)

\- Data redundancy (instructor names repeated)

\- Not atomic (cannot query individual courses easily)



\---



\### First Normal Form (1NF)



Remove repeating groups - one row per course:



| StudentID | Name | CNIC | Department | CourseCode | Instructor |

|-----------|------|------|------------|------------|------------|

| 1001 | Ahmed Raza | 35201-1234567-8 | Computer Science | CS101 | Dr. Khalid Mahmood |

| 1001 | Ahmed Raza | 35201-1234567-8 | Computer Science | CS102 | Dr. Saira Batool |

| 1002 | Fatima Akhtar | 35201-2345678-9 | Computer Science | CS101 | Dr. Khalid Mahmood |



\*\*Remaining Problems:\*\*

\- Partial dependency (Name, CNIC, Department depend only on StudentID, not on CourseCode)



\---



\### Second Normal Form (2NF)



Remove partial dependencies - split into separate tables:



\*\*Students Table:\*\*

| StudentID | Name | CNIC | Department |

|-----------|------|------|------------|

| 1001 | Ahmed Raza | 35201-1234567-8 | Computer Science |

| 1002 | Fatima Akhtar | 35201-2345678-9 | Computer Science |



\*\*Enrollments Table:\*\*

| StudentID | CourseCode |

|-----------|------------|

| 1001 | CS101 |

| 1001 | CS102 |

| 1002 | CS101 |



\*\*CourseInstructors Table:\*\*

| CourseCode | Instructor |

|------------|------------|

| CS101 | Dr. Khalid Mahmood |

| CS102 | Dr. Saira Batool |



\*\*Remaining Problems:\*\*

\- Transitive dependency (Department depends on StudentID)



\---



\### Third Normal Form (3NF)



Remove transitive dependencies:



\*\*Students Table:\*\*

| StudentID | Name | CNIC | DepartmentID |

|-----------|------|------|--------------|

| 1001 | Ahmed Raza | 35201-1234567-8 | 1 |

| 1002 | Fatima Akhtar | 35201-2345678-9 | 1 |



\*\*Departments Table:\*\*

| DepartmentID | DepartmentName |

|--------------|----------------|

| 1 | Computer Science |

| 2 | Business Administration |



\*\*Enrollments Table:\*\*

| StudentID | CourseCode |

|-----------|------------|

| 1001 | CS101 |

| 1001 | CS102 |

| 1002 | CS101 |



\*\*Courses Table:\*\*

| CourseCode | CourseName | Instructor |

|------------|------------|------------|

| CS101 | Programming Fundamentals | Dr. Khalid Mahmood |

| CS102 | Database Systems | Dr. Saira Batool |



\*\*Result:\*\* No redundancy, no update anomalies, fully normalized.



\---



\## Table 2: Fee Payment Records



\### Unnormalized Form (UNF)



| PaymentID | StudentID | StudentName | FeeType | Amount | PaymentDate |

|-----------|-----------|-------------|---------|--------|-------------|

| 1 | 1001 | Ahmed Raza | Tuition, Library | 150000, 5000 | 2024-09-15 |



\*\*Problems:\*\* Multiple fee types in one column



\### 1NF

| PaymentID | StudentID | StudentName | FeeType | Amount | PaymentDate |

|-----------|-----------|-------------|---------|--------|-------------|

| 1 | 1001 | Ahmed Raza | Tuition | 150000 | 2024-09-15 |

| 1 | 1001 | Ahmed Raza | Library | 5000 | 2024-09-15 |



\### 2NF

\*\*Students:\*\* StudentID, StudentName

\*\*Payments:\*\* PaymentID, StudentID, FeeType, Amount, PaymentDate



\### 3NF

\*\*Students:\*\* StudentID, StudentName

\*\*FeeStructure:\*\* FeeType, StandardAmount

\*\*Payments:\*\* PaymentID, StudentID, FeeType, Amount, PaymentDate



\*\*Final Tables:\*\* Students, FeeStructure, FeePayments



\---



\## Table 3: Course Sections



\### Unnormalized Form (UNF)



| SectionID | CourseCode | CourseName | FacultyName | Semester | Capacity |

|-----------|------------|------------|-------------|----------|----------|

| 1 | CS101 | Programming Fundamentals | Dr. Khalid Mahmood | Fall 2024 | 50 |



\*\*Problems:\*\* Course information repeated for each section



\### 1NF

All attributes atomic, no repeating groups ✓



\### 2NF

\*\*Courses:\*\* CourseCode, CourseName

\*\*Sections:\*\* SectionID, CourseCode, FacultyName, Semester, Capacity



\### 3NF

\*\*Courses:\*\* CourseCode, CourseName, DepartmentID

\*\*Faculty:\*\* FacultyID, FacultyName

\*\*Sections:\*\* SectionID, CourseCode, FacultyID, Semester, Capacity



\*\*Final Tables:\*\* Courses, Faculty, Sections



\---



\## Summary of Normalized Schema



| Table | Primary Key | Foreign Keys |

|-------|-------------|--------------|

| Departments | DepartmentID | - |

| Programs | ProgramID | DepartmentID |

| Students | StudentID | DepartmentID, ProgramID |

| Faculty | FacultyID | DepartmentID |

| Courses | CourseID | DepartmentID |

| Sections | SectionID | CourseID, FacultyID |

| Enrollments | EnrollmentID | StudentID, SectionID |

| FeeStructure | FeeID | ProgramID |

| FeePayments | PaymentID | StudentID, FeeID |



All tables are in \*\*3NF (Third Normal Form)\*\* and meet \*\*BCNF (Boyce-Codd Normal Form)\*\* requirements as there are no overlapping candidate keys.

