/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/
IF SUSER_ID('MDBUser') IS NULL
	CREATE LOGIN XXX WITH PASSWORD=N'XXXXXX', DEFAULT_DATABASE=[MDB], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF

IF SUSER_ID('MDBUserSelect') IS NULL
	CREATE LOGIN XXXX WITH PASSWORD=N'XXXXXX', DEFAULT_DATABASE=[MDB], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

INSERT INTO [ObjectTypes] ([Id], [Name]) VALUES(1, 'Unit'), (2, 'Employee'), (3, 'Device'), (4, 'Simcard'), (5, 'Order'), (6, 'Quota'), (7, 'DataPlan'), (8, 'News'), (9, 'ChangeLog'), (10, 'Comment'), (11, 'SQLPreset')
INSERT INTO [Actions] ([Id], [Name]) VALUES(1, 'Opret'), (2, 'Rediger'), (3, 'Slet')
INSERT INTO [Status] ([Id], [Name], [ObjectTypeRefId], [NeedEmployee]) VALUES(1, 'Lager', 3, 0), (2, 'Tabt', 3, 0), (3, 'Til Rep', 3, 0), (4, 'Udleveret', 3, 1), (5, 'Pulje', 3, 1), (6, 'Kasseret', 3, 0)
INSERT INTO [Status] ([Id], [Name], [ObjectTypeRefId], [NeedEmployee]) VALUES(7, 'Lager', 4, 0), (8, 'Tabt', 4, 0), (9, 'Udleveret', 4, 1), (10, 'Kasseret', 4, 0), (11, 'Opsagt', 4, 0), (12, 'Spærret', 4, 0)
INSERT INTO [DeviceTypes] ([Id], [Name]) VALUES(1, 'Standard'), (2, 'Robust'), (3, '3G'), (4, 'Smartphone')
INSERT INTO [SimcardFormats] ([Id], [Name]) VALUES(0, 'Ikke defineret'), (1, 'Normal'), (2, 'Modular, Normal/Micro'), (3, 'Modular, Normal/Micro/Nano')
INSERT INTO [TaxTypes] ([Id], [Name]) VALUES(1, 'FRI Telefoni'), (2, 'Tj. på arb. og bopæl')
INSERT INTO [Quotas] ([Name]) VALUES('9GB pr. kvartal')
INSERT INTO [DataPlans] ([Name]) VALUES('Flatrate')
:r .\Membership.sql

EXEC dbo.aspnet_Roles_CreateRole 'MDB', 'Admin'
EXEC dbo.aspnet_Roles_CreateRole 'MDB', 'Write'
EXEC dbo.aspnet_Roles_CreateRole 'MDB', 'Read'

DECLARE @result INT
EXEC dbo.UnitInsert 'TRR', 'Trænregimentet', '370929', @result OUTPUT

CREATE USER [MDBUser] FOR LOGIN [MDBUser]
ALTER ROLE [db_datareader] ADD MEMBER [MDBUser]
ALTER ROLE [db_datawriter] ADD MEMBER [MDBUser]
ALTER ROLE [db_owner] ADD MEMBER [MDBUser]

CREATE USER [MDBUserSelect] FOR LOGIN [MDBUserSelect]
ALTER ROLE [db_datareader] ADD MEMBER [MDBUserSelect]

CREATE ROLE [ITMatSync]
GRANT EXECUTE ON OBJECT::OrderInsertFromITMat TO [ITMatSync]
GRANT SELECT ON [dbo].[CurrentOrdersView] TO [ITMatSync]

--Indsæt til test
:r .\InsertTestVariables.sql