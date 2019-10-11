CREATE TABLE [dbo].[SQLPresets]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Name] NVARCHAR(50) NOT NULL, 
    [VisibleToRead] BIT NOT NULL, 
    [VisibleToWrite] BIT NOT NULL, 
    [VisibleToUsers] VARCHAR(1000) NOT NULL, 
    [Description] NVARCHAR(500) NOT NULL, 
    [Query] NVARCHAR(4000) NOT NULL
)