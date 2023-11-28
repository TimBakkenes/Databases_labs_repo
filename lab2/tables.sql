CREATE TABLE Department(
   name TEXT NOT NULL,
   abbreviation TEXT NOT NULL,
   PRIMARY KEY (name),
   UNIQUE (abbreviation));

CREATE TABLE Program(
    name TEXT NOT NULL, 
    abbreviation TEXT NOT NULL, 
    PRIMARY KEY (name));

CREATE TABLE Hosted(
    department TEXT,
    program TEXT,
    PRIMARY KEY (department, program),
    FOREIGN KEY (department) REFERENCES Department(name),
    FOREIGN KEY (program) REFERENCES Program(name));

CREATE TABLE Students(
    idnr CHAR(10), 
    name TEXT NOT NULL, 
    login TEXT NOT NULL, 
    program TEXT NOT NULL,
    UNIQUE (idnr, program),
    UNIQUE (login),
    PRIMARY KEY (idnr));

CREATE TABLE Branches (
    name TEXT, 
    program TEXT,
    PRIMARY KEY (name, program),
    FOREIGN KEY (program) REFERENCES Program(name));

CREATE TABLE Courses(
    code TEXT, 
    name TEXT NOT NULL, 
    credits REAL NOT NULL, 
    department TEXT NOT NULL,
    PRIMARY KEY (code),
    FOREIGN KEY (department) REFERENCES Department(name));

CREATE TABLE LimitedCourses(
   code TEXT,
   capacity INT NOT NULL,
   CHECK (capacity > 0),
   PRIMARY KEY (code),
   FOREIGN KEY (code) REFERENCES Courses(code));

CREATE TABLE Prerequisites(
    unlocking TEXT,
    unlocked TEXT,
    PRIMARY KEY(unlocking, unlocked),
    FOREIGN KEY(unlocking) REFERENCES Courses(code),
    FOREIGN KEY(unlocked) REFERENCES Courses(code));

CREATE TABLE StudentBranches(
   student TEXT,
   branch TEXT NOT NULL,
   program TEXT NOT NULL,
   PRIMARY KEY (student),
   FOREIGN KEY (student, program) REFERENCES Students(idnr, program),
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
    FOREIGN KEY (course) REFERENCES Courses(code),
    FOREIGN KEY (program) REFERENCES Program(name));

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
