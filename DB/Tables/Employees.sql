CREATE TABLE [dbo].[Employees]
(
	[Id] INT NOT NULL IDENTITY, 
    [MANR] NVARCHAR(8) NOT NULL, 
    [Stabsnummer] NVARCHAR(12) NOT NULL, 
    [Name] NVARCHAR(100) NOT NULL, 
    [SignedSolemnDeclaration] BIT NOT NULL DEFAULT 0, 
    [Notes] NVARCHAR(1000) NOT NULL, 
    CONSTRAINT [PK_Employees] PRIMARY KEY ([Id]) 
)
