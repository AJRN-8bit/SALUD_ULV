-- Try the following commands in a SQL Server evironment to create the database and tables for the Salud ULV App.

CREATE DATABASE SaludULVApp_DB_Test

USE SaludULVApp_DB_Test
GO


---- Main table that stores personal info of the users
CREATE TABLE Users (
	id INT IDENTITY (1,1) PRIMARY KEY,
	UserID INT UNIQUE NOT NULL,
	Name_ NVARCHAR(50) DEFAULT NULL,
	Firstname NVARCHAR(50) DEFAULT NULL,
	Lastname NVARCHAR(50) DEFAULT NULL,
	Email NVARCHAR(255) NOT NULL UNIQUE,
	Password_ NVARCHAR(max) NOT NULL,
	BirthDate DATE DEFAULT NULL,
	Age	TINYINT DEFAULT NULL,
	Gender NVARCHAR(15) DEFAULT NULL,
	CreatedAt DATE DEFAULT CONVERT(DATE, GETDATE()) NOT NULL
);



---- Table that stores anthropometric data of a specific employee
CREATE TABLE AnthropometricData (
	UserID INT FOREIGN KEY REFERENCES Users(UserID) NOT NULL,
	Height DECIMAL(5,2) NOT NULL,
	Weight_ DECIMAL(5,2) NOT NULL,
	SMM DECIMAL(5,2) NOT NULL,
	FatMass DECIMAL(5,2) NOT NULL,
	BodyFatPercentage DECIMAL(5,2) NOT NULL,
	BMI DECIMAL(5,2) NOT NULL,
	WHR DECIMAL(5,2) NOT NULL,
	RegistryDate DATE DEFAULT CONVERT(DATE, GETDATE()) NOT NULL
);


---- Table that stores the physical activities of a specific employee
CREATE TABLE Activities (
	ActivityID INT IDENTITY (1,1) PRIMARY KEY,
	UserID INT FOREIGN KEY REFERENCES Users(UserID) NOT NULL,
	ActivityType NVARCHAR(30) DEFAULT 'None' NOT NULL,
	Distance DECIMAL(10,2) DEFAULT 0 NOT NULL,
	Duration TIME(2) NOT NULL,
	CaloriesBurned DECIMAL(10,2) DEFAULT 0.0 NOT NULL,
	AvgCadence DECIMAL(10,2) DEFAULT 0.0 NOT NULL,
	AvgSpeed DECIMAL(10,2) DEFAULT 0.0 NOT NULL,
	MaxSpeed DECIMAL(10,2) DEFAULT 0.0 NOT NULL,
	ElevationGain DECIMAL (10,2) DEFAULT 0.0 NOT NULL,
	Steps INT DEFAULT 0 NOT NULL,
	RegistryDate DATE DEFAULT CONVERT(DATE, GETDATE()) NOT NULL
);

-- User and activity data insertion.
INSERT INTO Users (UserID, Email, Password_) VALUES (123456, 'user1@gmail.com', '12345678A');
INSERT INTO Activities (UserID, Duration) VALUES (123456, '12:02:23.23');
INSERT INTO Activities (UserID, Duration) VALUES (123456, '21:23:45.03');
INSERT INTO Activities (UserID, Duration) VALUES (123456, '09:09:04.23');



CREATE TABLE Groups(
	GroupID INT IDENTITY (1,1) PRIMARY KEY,
	Name_ NVARCHAR(100) NOT NULL
);


CREATE TABLE GroupActivities(
	ActivityID INT IDENTITY (1,1) PRIMARY KEY,
	GroupID INT FOREIGN KEY REFERENCES Groups(GroupID) NOT NULL,
	ActivityType NVARCHAR(50) NOT NULL,
	TotalDistance DECIMAL(10, 2) DEFAULT 0.0 NOT NULL,
	TotalDuration TIME(2) DEFAULT NULL,
	ReportDate DATE DEFAULT CONVERT(DATE, GETDATE()) NOT NULL
);

-- Data insertion to the tables
INSERT INTO Groups (Name_) VALUES ('Coordinación de Salud Institucional');
INSERT INTO Groups (Name_) VALUES ('Dirección de Excelencia Académica');
INSERT INTO Groups (Name_) VALUES ('Dirección Financiera');

INSERT INTO GroupActivities (GroupID, ActivityType, TotalDistance, TotalDuration) VALUES (1, 'Running', 234.2, '12:02:32');
INSERT INTO GroupActivities (GroupID, ActivityType, TotalDistance, TotalDuration) VALUES (1, 'Walk', 54.1, '02:01:32');
INSERT INTO GroupActivities (GroupID, ActivityType, TotalDistance, TotalDuration) VALUES (2, 'Running', 51.8, '12:12:02');
INSERT INTO GroupActivities (GroupID, ActivityType, TotalDistance, TotalDuration) VALUES (2, 'Cycling', 93.1, '09:03:32');
INSERT INTO GroupActivities (GroupID, ActivityType, TotalDistance, TotalDuration) VALUES (3, 'Walk', 250.3, '22:23:54');