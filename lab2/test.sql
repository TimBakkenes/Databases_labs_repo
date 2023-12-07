--SELECT jsonb_build_object('student',idnr,'name',name) AS jsondata FROM BasicInformation WHERE idnr='2222222222';


SELECT * FROM Registrations;

SELECT * FROM WaitingList;


SELECT jsonb_build_object(
    'student', idnr,
    'name', name,
    'login', login,
    'program', program,
    'branch', branch,
    'finished', (SELECT COALESCE(jsonb_agg(jsonb_build_object(
        'course', name,
        'code', course,
        'credits', credits,
        'grade', grade)), '[]') FROM Taken, Courses WHERE (Taken.student = BasicInformation.idnr AND Taken.course = Courses.code)),
    
    'registered', (SELECT COALESCE(jsonb_agg(jsonb_build_object(
        'course', name,
        'code', ExtendedRegistrations.course,
        'status', status,
        'position', position)), '[]') FROM ExtendedRegistrations, Courses WHERE (ExtendedRegistrations.student = BasicInformation.idnr AND ExtendedRegistrations.course = Courses.code)),

    'seminarCourses', (SELECT seminarCourses FROM PathToGraduation WHERE (student = BasicInformation.idnr)),
    'mathCredits', (SELECT mathCredits FROM PathToGraduation WHERE (student = BasicInformation.idnr)),
    'totalCredits', (SELECT totalCredits FROM PathToGraduation WHERE (student = BasicInformation.idnr)),
    'canGraduate', (SELECT qualified FROM PathToGraduation WHERE (student = BasicInformation.idnr))
    
    ) AS jsondata FROM BasicInformation WHERE idnr='1111111111';




/*
"student",
"name",
"login",
"program",
"branch",
"finished",
"registered",
"seminarCourses",
"mathCredits",
"totalCredits",
"canGraduate"
*/