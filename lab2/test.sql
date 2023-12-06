--SELECT jsonb_build_object('student',idnr,'name',name) AS jsondata FROM BasicInformation WHERE idnr='2222222222';

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
        'code', course,
        'status', status)), '[]') FROM Registrations, Courses WHERE (Registrations.student = BasicInformation.idnr AND Registrations.course = Courses.code)),

    'seminarCourses', (SELECT seminarCourses FROM PathToGraduation WHERE (student = BasicInformation.idnr)),
    'mathCredits', (SELECT mathCredits FROM PathToGraduation WHERE (student = BasicInformation.idnr)),
    'totalCredits', (SELECT totalCredits FROM PathToGraduation WHERE (student = BasicInformation.idnr)),
    'canGraduate', (SELECT qualified FROM PathToGraduation WHERE (student = BasicInformation.idnr))
    
    ) AS jsondata FROM BasicInformation WHERE idnr='?';
    



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