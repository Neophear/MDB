CREATE VIEW [dbo].[AllObjectsView]
	AS
SELECT
	tbl.TypeId,
	tbl.Id,
	tbl.[UniqueIdentifier],
	O.Name AS TypeName,
	tbl.[Status],
	MANR,
	Stabsnummer,
	tbl.[Name],
	tbl.Info
FROM
	(SELECT
		2 AS TypeId,
		Id,
		MANR AS [UniqueIdentifier],
		'' AS Info,
		'' AS [Status],
		MANR,
		Stabsnummer,
		[Name]
	FROM
		dbo.Employees
	UNION
    SELECT
		3 AS TypeId,
		Id,
		IMEI,
		Model,
		COV.[Status],
		COV.MANR,
		COV.Stabsnummer,
		COV.[Name]
    FROM
		dbo.Devices D
	LEFT OUTER JOIN
		CurrentOrdersView COV ON D.Id = COV.ObjectRefId AND COV.ObjectTypeRefId = 3
	UNION
	SELECT
		4 AS TypeId,
		Id,
		Simnumber,
		Number,
		COV.[Status],
		COV.MANR,
		COV.Stabsnummer,
		COV.[Name]
	FROM
		dbo.Simcards S
	LEFT OUTER JOIN
		CurrentOrdersView COV ON S.Id = COV.ObjectRefId AND COV.ObjectTypeRefId = 4
	) AS tbl
INNER JOIN
	dbo.ObjectTypes O ON tbl.TypeId = O.Id