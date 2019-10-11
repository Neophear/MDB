CREATE TABLE [dbo].[Devices]
(
	[Id] INT NOT NULL IDENTITY, 
	[IMEI] NVARCHAR(50) NOT NULL,
    [Model] NVARCHAR(50) NOT NULL,
    [Provider] NVARCHAR(50) NOT NULL, 
	[OrderNumber] NVARCHAR(50) NOT NULL,
	[BuyDate] DATE NULL,
    [TypeRefId] INT NOT NULL,
    [UnitRefId] INT NOT NULL, 
    [Notes] NVARCHAR(1000) NOT NULL, 
    CONSTRAINT [PK_Devices] PRIMARY KEY ([Id])
)
