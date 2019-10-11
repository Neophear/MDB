CREATE TABLE [dbo].[LogUser]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [ActionRefId] INT NOT NULL, 
    [TimeStamp] DATETIME NOT NULL DEFAULT getdate(), 
    [Executor] NVARCHAR(8) NOT NULL, 
    [AffectedUsername] NVARCHAR(8) NOT NULL, 
    [Properties] VARCHAR(100) NULL, 
    [Values] NVARCHAR(1000) NULL
)
