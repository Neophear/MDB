CREATE TABLE [dbo].[Comments]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY,
	[ObjectTypeRefId] INT NOT NULL, 
    [ObjectRefId] INT NOT NULL, 
    [TimeStamp] DATETIME NOT NULL DEFAULT getdate(),
	[Executor] NVARCHAR(8) NOT NULL,
    [Text] NVARCHAR(MAX) NOT NULL 
)
