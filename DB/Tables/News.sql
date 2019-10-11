CREATE TABLE [dbo].[News]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY,
    [Title] NVARCHAR(50) NOT NULL, 
    [Content] NVARCHAR(4000) NOT NULL, 
    [TimeStamp] DATETIME NOT NULL DEFAULT getdate(),
    [VisibleToRead] BIT NOT NULL,
    [VisibleToWrite] BIT NOT NULL,
    [Sticky] BIT NOT NULL
)