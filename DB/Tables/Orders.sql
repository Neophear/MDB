CREATE TABLE [dbo].[Orders]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [ObjectTypeRefId] INT NOT NULL, 
    [ObjectRefId] INT NOT NULL, 
    [TaxTypeRefId] INT NULL,
    [EmployeeRefId] INT NULL, 
    [StatusRefId] INT NOT NULL,
    [TimeStamp] DATETIME NOT NULL DEFAULT getdate(), 
    [Notes] NVARCHAR(1000) NULL, 
    [Approved] BIT NOT NULL DEFAULT 1
)