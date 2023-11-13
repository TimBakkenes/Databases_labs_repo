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
    FROM WaitingList;

CREATE VIEW PassedCourses AS
    SELECT student, course, credits
    FROM TAKEN, COURSES
    WHERE (course = Courses.code AND TAKEN.grade != 'U');

CREATE VIEW UnreadMandatory AS 
    SELECT idnr as student, course
    FROM Students, MandatoryProgram
    WHERE (Students.program = MandatoryProgram.program)

    UNION 

    SELECT idnr as student, course
    FROM Students, MandatoryBranch
    WHERE (Students.program = MandatoryBranch.program)
    
    EXCEPT

    SELECT student, course 
    FROM PassedCourses;

CREATE VIEW RecommendedCourses AS 
    SELECT student, course, credits
    FROM RecommendedBranch, Students
    LEFT OUTER JOIN PassedCourses 
    ON (Students.program = RecommendedBranch.program AND PassedCourses.course = RecommendedBranch.course)