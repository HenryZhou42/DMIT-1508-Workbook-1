
--CREATE DATABASE SchoolTranscript

USE SchoolTranscript
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'StudentsCourses')
    DROP TABLE StudentsCourses
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Courses')
    DROP TABLE Courses
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Students')
    DROP TABLE Students

CREATE TABLE Students
(
    StudentID   int        
        CONSTRAINT PK_Students_StudentID
            PRIMARY KEY  
        IDENTITY(2020001,1)     NOT NULL,
    GivenName   varchar(50)     NOT NULL,
    Surname     varchar(50) 
	    CONSTRAINT CK_Course_Surname
		     CHECK (Surname LIKE '__%')    --LIKE  allows us to do a pattern-match of values
		  -- CHECK(Surname LIKE '[a-z][a-z]')-- two letters plus many other chars
							    NOT NULL,     
    DateOfBirth datetime    
	   CONSTRAINT CK_Student_DateOfBirth
            CHECK (DateOfBirth < GETDATE())
								NOT NULL,
    Enrolled    bit             
        CONSTRAINT DF_Students_Enrolled
            DEFAULT (1)         NOT NULL
)


CREATE TABLE Courses
(
    Number      varchar(10)  
        CONSTRAINT PK_Courses_StudentID
            PRIMARY KEY         NOT NULL,
    [Name]      varchar(50)     NOT NULL,
    Credits     decimal(3,1) 
			CONSTRAINT CK_Course_Credits
				CHECK (Credits >0 AND Credits <=6)  
							    NOT NULL,
    [Hours]     tinyint     
			CONSTRAINT CK_Course_Hours
				CHECK ([Hours]BETWEEN 15 AND 100)  --BETWEEN operator is inclusive
							    NOT NULL,
    Active      bit     
        CONSTRAINT DF_Course_Active
            DEFAULT (1)         NOT NULL,
    Cost        money    
	     CONSTRAINT COST
				CHECK (Cost>=0)     
							    NOT NULL
)

CREATE TABLE StudentsCourses
(
    StudentID        int
            CONSTRAINT FK_StudentCourses_StudentID_Students_StudentID
            FOREIGN KEY REFERENCES Students(StudentID)       
                                     NOT NULL,
    CourseNumber     varchar(10) 
            CONSTRAINT FK_StudentCourses_CourseNumber_Courses_Number
            FOREIGN KEY REFERENCES Courses(Number)    
                                     NOT NULL,
    [Year]           tinyint         NOT NULL,
    Term             char(3)         NOT NULL,
    FinalMark        tinyint             NULL,
    [Status]         char(1)    
	      CONSTRAINT CK_StudentCourse_Status
                   CHECK ([Status] = 'E' OR
				          [Status] = 'C' OR
						  [Status] = 'W'  )  
						  --CHECK ([Status] in ('E','C','W'))  
						             NOT NULL
    -- Table level constraint for composite keys
    CONSTRAINT PK_StudentCourses_StudentID_CourseNumber
        PRIMARY KEY (StudentID,CourseNumber),
    -- Table level constraint involving more than one column
	CONSTRAINT CK_StudentCourse_FinalMark_Status
		CHECK(([Status] = 'C' AND FinalMark is NOT NULL)
		OR
		([Status] IN ('E','W')AND FinalMark IS  NULL))
)


/*-------Indexed-------*/
--For all foreign keys
CREATE NONCLUSTERED INDEX IX_StudentCourse_StudentID
	ON StudentsCourses (StudentID)

CREATE NONCLUSTERED INDEX IX_StudentCourse_CourseNumber
	ON StudentsCourses (CourseNumber)

---For other columns where searching /sorting might be important
CREATE NONCLUSTERED INDEX IX_StudentCourse_Surname
	ON Students (Surname)

/*------ALTER TABLE statements-----*/
--1) Add a PostalCode for the Students table
ALTER TABLE Students
	ADD PostalCode char(6)
	--Adding this as a nullable columb, because students already exist,
	--and we don`t have postal code for those students.
GO---Break above code as a seperate batch from the following

--2) Make sure the PostalCode follows the correct pattern A#A#A#
ALTER TABLE Students
	ADD CONSTRAINT CK_Students_PostalCode
		CHECK (PostalCode Like'[A-Z][0-9][A-Z][0-9][A-Z][0-9]')
	  --Match for T4R1H2:        T    4    R    1    H    2