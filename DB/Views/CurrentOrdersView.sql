CREATE VIEW [dbo].[CurrentOrdersView]
AS
SELECT
	O.Id AS [OrderId],
	O.ObjectRefId,
	O.ObjectTypeRefId,
	O.TaxTypeRefId,
	O.StatusRefId,
	S.Name AS [Status],
	O.[TimeStamp],
	O.Notes,
	O.Approved,
	E.Id AS [EmployeeId],
	E.MANR,
	E.Stabsnummer,
	E.Name,
	T.Name AS [TaxType],
	IIF(O.ObjectTypeRefId = 3, (SELECT [IMEI] FROM [Devices] WHERE [Id] = O.ObjectRefId), (SELECT [Simnumber] FROM [Simcards] WHERE [Id] = O.ObjectRefId)) AS ObjectNumber,
	IIF(O.ObjectTypeRefId = 3, (SELECT [Model] FROM [Devices] WHERE [Id] = O.ObjectRefId), (SELECT [Number] FROM [Simcards] WHERE [Id] = O.ObjectRefId)) AS Info
FROM
	(SELECT *, ROW_NUMBER() OVER(PARTITION BY [ObjectRefId], [ObjectTypeRefId] ORDER BY [TimeStamp] DESC, [Id] DESC) rn FROM [Orders]) O
LEFT OUTER JOIN
	[Employees] E ON O.EmployeeRefId = E.Id
LEFT OUTER JOIN
	[TaxTypes] T ON T.Id = O.TaxTypeRefId
LEFT OUTER JOIN
	[Status] S ON O.StatusRefId = S.Id
WHERE [rn] = 1