CREATE TABLE [dbo].[Status]
(
	[Id] INT NOT NULL PRIMARY KEY, 
    [Name] NVARCHAR(50) NOT NULL, 
    [ObjectTypeRefId] INT NOT NULL, 
    [NeedEmployee] BIT NOT NULL
)
