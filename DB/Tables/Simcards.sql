CREATE TABLE [dbo].[Simcards]
(
	[Id] INT NOT NULL  IDENTITY, 
    [Simnumber] NVARCHAR(50) NOT NULL, 
    [PUK] NVARCHAR(8) NOT NULL, 
    [Number] NVARCHAR(8) NOT NULL, 
    [IsData] BIT NOT NULL,
	[FormatRefId] INT NOT NULL,
    [QuotaRefId] INT NOT NULL, 
    [QuotaEndDate] DATE NULL, 
    [DataPlanRefId] INT NOT NULL, 
    [Provider] NVARCHAR(50) NOT NULL, 
    [OrderNumber] NVARCHAR(50) NOT NULL, 
    [BuyDate] DATE NULL, 
    [UnitRefId] INT NOT NULL, 
    [Notes] NVARCHAR(1000) NOT NULL, 
    CONSTRAINT [PK_Simcards] PRIMARY KEY ([Id], [Simnumber])
)