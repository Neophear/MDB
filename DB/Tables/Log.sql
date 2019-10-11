CREATE TABLE [dbo].[Log]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [ActionRefId] INT NOT NULL,
    [TimeStamp] DATETIME NOT NULL DEFAULT getdate(), 
    [Executor] NVARCHAR(8) NOT NULL, 
    [ObjectTypeRefId] INT NOT NULL, 
    [ObjectRefId] INT NOT NULL,
    [Properties] VARCHAR(200) NULL, 
    [Values] NVARCHAR(MAX) NULL
)
