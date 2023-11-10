CREATE VIEW BasicInformation AS
    SELECT idnr, name, login, Students.program, branch 
    FROM Students LEFT JOIN StudentBranches 
    ON Students.idnr = StudentBranches.student;

CREATE VIEW FinishedCourses AS
    SELECT student, course, grade, name AS courseName, credits
    FROM Taken, Courses
    WHERE (course = Courses.code);

CREATE VIEW Registrations AS
    SELECT student, course, 'registered' AS status
    FROM Registered

    UNION

    SELECT student, course, 'waiting' AS status
    FROM WaitingList

PathToGraduation(student, totalCredits, mandatoryLeft, mathCredits, seminarCourses, qualified)



