\# Normalization Documentation



\## Student Table Normalization (UNF → 3NF)



\### Unnormalized Form (UNF)

A single table storing all student data with repeating course information:



| StudentID | Name | Department | Courses | Instructors |

|-----------|------|------------|---------|-------------|

| 1001 | John | CS | CS101, CS102 | Dr. Smith, Dr. Jones |

| 1002 | Jane | CS | CS101 | Dr. Smith |



\*\*Problems:\*\* Repeating groups, data redundancy



\### First Normal Form (1NF)

Remove repeating groups - one row per course:



| StudentID | Name | Department | CourseCode | Instructor |

|-----------|------|------------|------------|------------|

| 1001 | John | CS | CS101 | Dr. Smith |

| 1001 | John | CS | CS102 | Dr. Jones |

| 1002 | Jane | CS | CS101 | Dr. Smith |



\### Second Normal Form (2NF)

Remove partial dependencies - create separate tables:



\*\*Students Table:\*\* StudentID, Name, Department

\*\*Enrollments Table:\*\* StudentID, CourseCode

\*\*CourseInstructors Table:\*\* CourseCode, Instructor



\### Third Normal Form (3NF)

Remove transitive dependencies:



\*\*Students Table:\*\* StudentID, Name, DepartmentID

\*\*Departments Table:\*\* DepartmentID, DepartmentName

\*\*Enrollments Table:\*\* StudentID, CourseCode

\*\*Courses Table:\*\* CourseCode, Instructor



\---



\## FeePayments Table Normalization



\### UNF

| PaymentID | StudentID | StudentName | FeeType | Amount | Date |

|-----------|-----------|-------------|---------|--------|------|



\### 1NF

Remove repeating groups - each payment separate row



\### 2NF

Remove partial dependencies - separate Student info



\### 3NF

Remove transitive dependencies - separate Fee Structure



\*\*Final Tables:\*\* FeePayments, Students, FeeStructure



\---



\## Sections Table Normalization



\### UNF

| SectionID | CourseCode | CourseName | FacultyName | Semester | Capacity |



\### 1NF

All attributes atomic, no repeating groups



\### 2NF

Remove partial dependencies - separate Course info



\### 3NF

Remove transitive dependencies - separate Faculty info



\*\*Final Tables:\*\* Sections, Courses, Faculty

