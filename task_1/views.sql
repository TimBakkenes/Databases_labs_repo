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

    UNION DISTINCT

    SELECT idnr as student, course
    FROM Students, MandatoryBranch
    WHERE (Students.program = MandatoryBranch.program)
    
    EXCEPT 

    SELECT student, course 
    FROM PassedCourses;

CREATE VIEW RecommendedHelper AS 
    SELECT Students.idnr AS student, course
    FROM Students INNER JOIN RecommendedBranch ON (Students.program = RecommendedBranch.program);

CREATE VIEW RecommendedCourses AS 
    SELECT RecommendedHelper.student AS student, RecommendedHelper.course, PassedCourses.credits
    FROM RecommendedHelper
    INNER JOIN PassedCourses ON (RecommendedHelper.student = PassedCourses.student AND RecommendedHelper.course = PassedCourses.course);

CREATE VIEW TotalCredits AS
    SELECT student, SUM(credits) as totalCredits
    FROM PassedCourses
    GROUP BY student;

CREATE VIEW MandatoryLeft AS
    SELECT student, COUNT(course) as mandatoryLeft
    FROM UnreadMandatory
    GROUP BY student;

CREATE VIEW MathCredits AS
    SELECT student, SUM(credits) AS mathCredits
    FROM PassedCourses, Classified
    WHERE (PassedCourses.course = Classified.course AND Classified.classification = 'math')
    GROUP BY student;

CREATE VIEW SeminarCourses AS 
    SELECT student, COUNT(PassedCourses.course) AS seminarCourses
    FROM PassedCourses, Classified
    WHERE (PassedCourses.course = Classified.course AND Classified.classification = 'seminar')
    GROUP BY student;

CREATE VIEW PathToGraduation AS
    SELECT 
    Students.idnr AS student, 
    COALESCE(totalCredits, 0) AS totalCredits, 
    COALESCE(mandatoryLeft, 0) AS mandatoryLeft, 
    COALESCE(mathCredits, 0) AS mathCredits, 
    COALESCE(seminarCourses, 0) AS seminarCourses, 
    (COALESCE(totalCredits, 0) >= 10 
        AND COALESCE(mandatoryLeft, 0) = 0 
        AND COALESCE(mathCredits, 0) >= 20 
        AND COALESCE(seminarCourses, 0) > 0) 
    AS qualified

    FROM Students 
    LEFT JOIN 
    TotalCredits ON (Students.idnr = TotalCredits.student)
    LEFT JOIN
    MandatoryLeft ON (Students.idnr = MandatoryLeft.student)
    LEFT JOIN
    MathCredits ON (Students.idnr = MathCredits.student)
    LEFT JOIN
    SeminarCourses ON (Students.idnr = SeminarCourses.student);
    
    


    




