CREATE TABLE Branches (name TEXT, program TEXT);

CREATE TABLE Students(idnr TEXT, name TEXT, login TEXT, program TEXT);

CREATE TABLE Courses(code TEXT, name TEXT, credits REAL, department TEXT);

LimitedCourses(code, capacity)
code → Courses.code