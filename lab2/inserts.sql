INSERT INTO Program VALUES ('Prog1', 'P1');
INSERT INTO Program VALUES ('Prog2', 'P2');


INSERT INTO Department VALUES ('Dep1', 'D1');
INSERT INTO Department VALUES ('Dep2', 'D2');


INSERT INTO Hosted VALUES ('Dep2', 'Prog2');
INSERT INTO Hosted VALUES ('Dep2', 'Prog1');

INSERT INTO Branches VALUES ('B1','Prog1');
INSERT INTO Branches VALUES ('B2','Prog1');
INSERT INTO Branches VALUES ('B1','Prog2');

INSERT INTO Students VALUES ('1111111111','N1','ls1','Prog1');
INSERT INTO Students VALUES ('2222222222','N2','ls2','Prog1');
INSERT INTO Students VALUES ('3333333333','N3','ls3','Prog2');
INSERT INTO Students VALUES ('4444444444','N4','ls4','Prog1');
INSERT INTO Students VALUES ('5555555555','Nx','ls5','Prog2');
INSERT INTO Students VALUES ('6666666666','Nx','ls6','Prog2');

INSERT INTO Courses VALUES ('CCC111','C1',22.5,'Dep1');
INSERT INTO Courses VALUES ('CCC222','C2',20,'Dep1');
INSERT INTO Courses VALUES ('CCC333','C3',30,'Dep1');
INSERT INTO Courses VALUES ('CCC444','C4',60,'Dep1');
INSERT INTO Courses VALUES ('CCC555','C5',50,'Dep1');

INSERT INTO Prerequisites VALUES ('CCC222', 'CCC444');
INSERT INTO Prerequisites VALUES ('CCC111', 'CCC444');

INSERT INTO LimitedCourses VALUES ('CCC222',1);
INSERT INTO LimitedCourses VALUES ('CCC333',1);

INSERT INTO Classifications VALUES ('math');
INSERT INTO Classifications VALUES ('research');
INSERT INTO Classifications VALUES ('seminar');

INSERT INTO Classified VALUES ('CCC333','math');
INSERT INTO Classified VALUES ('CCC444','math');
INSERT INTO Classified VALUES ('CCC444','research');
INSERT INTO Classified VALUES ('CCC444','seminar');


INSERT INTO StudentBranches VALUES ('2222222222','B1','Prog1');
INSERT INTO StudentBranches VALUES ('3333333333','B1','Prog2');
INSERT INTO StudentBranches VALUES ('4444444444','B1','Prog1');
INSERT INTO StudentBranches VALUES ('5555555555','B1','Prog2');

INSERT INTO MandatoryProgram VALUES ('CCC111','Prog1');

INSERT INTO MandatoryBranch VALUES ('CCC333', 'B1', 'Prog1');
INSERT INTO MandatoryBranch VALUES ('CCC444', 'B1', 'Prog2');

INSERT INTO RecommendedBranch VALUES ('CCC222', 'B1', 'Prog1');
INSERT INTO RecommendedBranch VALUES ('CCC333', 'B1', 'Prog2');

INSERT INTO Registered VALUES ('1111111111','CCC222');
INSERT INTO Registered VALUES ('2222222222','CCC222');

INSERT INTO Taken VALUES('4444444444','CCC111','5');
INSERT INTO Taken VALUES('4444444444','CCC222','5');
INSERT INTO Taken VALUES('5555555555','CCC111','5');
INSERT INTO Taken VALUES('2222222222','CCC111','U');
INSERT INTO Taken VALUES('2222222222','CCC222','3');


-- INSERT INTO Registrations VALUES('4444444444', 'CCC444', '-');
-- INSERT INTO Registrations VALUES('4444444444', 'CCC333', '-');
-- INSERT INTO Registrations VALUES('5555555555', 'CCC333', '-');





--DELETE FROM Registrations WHERE student = '4444444444' AND course = 'CCC222';
--DELETE FROM Registrations WHERE student = '4444444444' AND course = 'CCC222';
--DELETE FROM Registrations WHERE student = '4444444444' AND course = 'CCC222';

--DELETE FROM Registrations WHERE student = '1111111111' AND course = 'CCC222';
--DELETE FROM Registrations WHERE student = '1111111111' AND course = 'CCC222';
--DELETE FROM Registrations WHERE student = '1111111111' AND course = 'CCC222';

--DELETE FROM Registrations WHERE student = '2222222222' AND course = 'CCC222';
