
CREATE TABLE Students(
    idnr CHAR(10), 
    name TEXT NOT NULL, 
    login TEXT NOT NULL, 
    program TEXT NOT NULL,
    UNIQUE (login),
    PRIMARY KEY (idnr));

CREATE TABLE Branches (
    name TEXT, 
    program TEXT,
    PRIMARY KEY (name, program));

CREATE TABLE Courses(
    code TEXT, 
    name TEXT NOT NULL, 
    credits REAL NOT NULL, 
    department TEXT NOT NULL,
    PRIMARY KEY (code));

CREATE TABLE LimitedCourses(
    code TEXT, 
    capacity INT NOT NULL,
    CHECK (capacity > 0), 
    PRIMARY KEY (code),
    FOREIGN KEY (code) REFERENCES Courses(code));

CREATE TABLE StudentBranches(
    student TEXT, 
    branch TEXT NOT NULL, 
    program TEXT NOT NULL,
    PRIMARY KEY (student),
    FOREIGN KEY (student) REFERENCES Students(idnr),
    FOREIGN KEY (branch, program) REFERENCES Branches(name, program));

CREATE TABLE Classifications(
    name TEXT,
    PRIMARY KEY (name));

CREATE TABLE Classified(
    course TEXT, 
    classification TEXT,   
    PRIMARY KEY (course, classification), 
    FOREIGN KEY (course) REFERENCES Courses(code),
    FOREIGN KEY (classification) REFERENCES Classifications(name));

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

CREATE TABLE Registered(
    student TEXT, 
    course TEXT,  
    PRIMARY KEY (student, course), 
    FOREIGN KEY (student) REFERENCES Students(idnr),
    FOREIGN KEY (course) REFERENCES Courses(code));

CREATE TABLE Taken(
    student TEXT, 
    course TEXT, 
    grade CHAR(1) NOT NULL,
    CHECK (grade IN ('U','3','4','5')),
    PRIMARY KEY (student, course), 
    FOREIGN KEY (student) REFERENCES Students(idnr),
    FOREIGN KEY (course) REFERENCES Courses(code));

CREATE TABLE WaitingList(
    student TEXT, 
    course TEXT, 
    position INT NOT NULL, 
    PRIMARY KEY (student, course), 
    FOREIGN KEY (student) REFERENCES Students(idnr),
    FOREIGN KEY (course) REFERENCES LimitedCourses(code));
    