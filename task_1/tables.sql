
CREATE TABLE Students(
    idnr TEXT, 
    name TEXT, 
    login TEXT, 
    program TEXT,
    PRIMARY KEY (idnr));

CREATE TABLE Branches (
    name TEXT, 
    program TEXT,
    PRIMARY KEY (name, program));

CREATE TABLE Courses(
    code TEXT, 
    name TEXT, 
    credits REAL, 
    department TEXT,
    PRIMARY KEY (code));

CREATE TABLE LimitedCourses(
    code TEXT, 
    capacity INT, 
    PRIMARY KEY (code),
    FOREIGN KEY (code) REFERENCES Courses(code));

CREATE TABLE StudentBranches(
    student TEXT, 
    branch TEXT, 
    program TEXT,
    PRIMARY KEY (student),
    FOREIGN KEY (student) REFERENCES Students(idnr),
    FOREIGN KEY (branch, program) REFERENCES Branches(name, program));

CREATE TABLE Classifications(
    name TEXT,
    PRIMARY KEY (name));

CREATE TABLE Classified(
    student TEXT, 
    branch TEXT, 
    program TEXT,  
    PRIMARY KEY (student), 
    FOREIGN KEY (branch, program) REFERENCES Branches(name, program));

CREATE TABLE MandatoryProgram(
    course TEXT,
    program TEXT,
    PRIMARY KEY (course, program),
    FOREIGN KEY (course) REFERENCES Courses(code));

CREATE TABLE MandatoryBranch(
    course TEXT, 
    branch TEXT, 
    program TEXT, 
    PRIMARY KEY (course, branch, program), 
    FOREIGN KEY (course) REFERENCES Courses(code),
    FOREIGN KEY (branch, program) REFERENCES Branches(name, program));

CREATE TABLE RecommendedBranch(
    course TEXT, 
    branch TEXT, 
    program TEXT, 
    PRIMARY KEY (course, branch, program), 
    FOREIGN KEY (course) REFERENCES Courses(code),
    FOREIGN KEY (branch, program) REFERENCES Branches(name, program));

CREATE TABLE Registerd(
    student TEXT, 
    course TEXT,  
    PRIMARY KEY (student, course), 
    FOREIGN KEY (student) REFERENCES Students(idnr),
    FOREIGN KEY (course) REFERENCES LimitedCourses(code));

CREATE TABLE Taken(
    student TEXT, 
    course TEXT, 
    grade INT, 
    PRIMARY KEY (student, course), 
    FOREIGN KEY (student) REFERENCES Students(idnr),
    FOREIGN KEY (course) REFERENCES Courses(code));

CREATE TABLE WaitingList(
    student TEXT, 
    course TEXT, 
    position INT, 
    PRIMARY KEY (student, course), 
    FOREIGN KEY (student) REFERENCES Students(idnr),
    FOREIGN KEY (course) REFERENCES LimitedCourses(code));