
CREATE SCHEMA SaludULV;


GO
CREATE TABLE SaludULV.Users (
    UserUUID     UNIQUEIDENTIFIER PRIMARY KEY NOT NULL,
    UserCode     NVARCHAR (10)    UNIQUE NOT NULL,
    Firstname    NVARCHAR (15)    DEFAULT NULL,
    Surname      NVARCHAR (25)    DEFAULT NULL,
    Lastname     NVARCHAR (25)    DEFAULT NULL,
    Email        NVARCHAR (50)    UNIQUE NOT NULL,
    PasswordHash NVARCHAR (100)   NOT NULL,
    CreatedAt    DATETIME         NOT NULL
);


GO
-- Roles
CREATE TABLE SaludULV.Roles (
    RoleID SMALLINT      IDENTITY (1, 1) PRIMARY KEY,
    Name   NVARCHAR (50) UNIQUE NOT NULL
);


GO
-- User Roles
CREATE TABLE SaludULV.UserRoles (
    UserUUID UNIQUEIDENTIFIER NOT NULL,
    RoleID   INT              NOT NULL,
    PRIMARY KEY (UserUUID, RoleID),
    FOREIGN KEY (UserUUID) REFERENCES SaludULV.Users (UserUUID) ON DELETE CASCADE,
    FOREIGN KEY (RoleID) REFERENCES SaludULV.Roles (RoleID) ON DELETE CASCADE
);


GO
CREATE TABLE SaludULV.MemberType (
    TypeID SMALLINT      IDENTITY (1, 1) PRIMARY KEY,
    Name         NVARCHAR (50) UNIQUE NOT NULL
);

-- Members data
CREATE TABLE SaludULV.Members (
    UserUUID     UNIQUEIDENTIFIER NOT NULL,
    GroupID      INT              DEFAULT NULL,
    DateOfBirth  DATE             DEFAULT NULL,
    Age          TINYINT          DEFAULT NULL,
    --Tier TINYINT NOT NULL,
    Gender       NVARCHAR (15)    DEFAULT NULL,
    TypeID SMALLINT         NULL,

    FOREIGN KEY (UserUUID) REFERENCES SaludULV.Users (UserUUID) ON DELETE CASCADE,
    FOREIGN KEY (TypeID) REFERENCES SaludULV.MemberType (TypeID)
); -- FOREIGN KEY (GroupID) REFERENCES SaludULV.Departments (GroupID),
GO



-- Index on Users table for UUIDs
-- CREATE INDEX IX_Users_UUID ON SaludULV.Users(UserUUID);

-- Roles insertions
INSERT INTO SaludULV.Roles (Name) VALUES ('Admin');
INSERT INTO SaludULV.Roles (Name) VALUES ('Member');

-- Member occupations
INSERT INTO SaludULV.MemberType (Name) VALUES ('Employee');
INSERT INTO SaludULV.MemberType (Name) VALUES ('Student');
