CREATE VIEW [dbo].[OrdersView]
AS
SELECT
	O.Id AS [OrderId],
	O.ObjectRefId,
	O.ObjectTypeRefId,
	O.StatusRefId,
	O.TaxTypeRefId,
	O.[TimeStamp],
	O.Notes,
	S.Name AS [Status],
	E.Id AS [EmployeeId],
	E.MANR,
	E.Stabsnummer,
	E.Name,
	T.Name AS [TaxType]
	--,LEAD(O.Id) OVER (PARTITION BY O.ObjectTypeRefId, O.ObjectRefId ORDER BY O.Id) NextId
FROM
	[Orders] O
INNER JOIN
	[Status] S ON O.StatusRefId = S.Id
LEFT OUTER JOIN
	[Employees] E ON O.EmployeeRefId = E.Id
LEFT OUTER JOIN
	[TaxTypes] T ON T.Id = O.TaxTypeRefId