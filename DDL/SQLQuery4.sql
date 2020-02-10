/* **********
*
*
*************** */

USE SchoolTranscript
GO

INSERT INTO Students(GivenName, Surname, DateOfBirth)
VALUES ('Dan', 'Gilleland', '19720514 10:34:09 PM')

SELECT * FROM Students


INSERT INTO Courses(Number, [Name], Credits, [Hours], Active, Cost)
VALUES ('1000', 'dmit1', '3.0', '15', '1', '500'),
	   ('1001', 'dmit2', '3.0', '15', '1', '500'),
	   ('1002', 'dmit3', '3.0', '15', '1', '500'),
	   ('1003', 'dmit4', '3.0', '15', '1', '500'),
	   ('1004', 'dmit5', '3.0', '15', '1', '500')

SELECT Number, [Name], Credits, [Hours], Active, Cost
FROM  Courses
WHERE [Name] LIKE '%2%'


SELECT GivenName, Surname, DateOfBirth
FROM Students
WHERE Surname LIKE 'g%'