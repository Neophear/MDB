CREATE VIEW [dbo].[DeviceView]
	AS SELECT
		D.Id,
		D.IMEI,
		D.Model,
		D.[Provider],
		D.OrderNumber,
		D.BuyDate,
		D.UnitRefId,
		U.Short AS [Unit],
		D.TypeRefId,
		DT.Name AS [Type],
		D.Notes,
		O.Id AS [OrderId],
		O.ObjectRefId,
		O.[TimeStamp] AS [OrderTimeStamp],
		ISNULL(S.Name, 'Lager') AS [Status],
		E.Id AS [EmployeeId],
		E.MANR,
		E.Name,
		E.Stabsnummer,
		O.TaxTypeRefId,
		ISNULL(T.Name, '') AS [TaxType],
		ISNULL(O.Approved, 1) AS [OrderApproved]
	FROM
		[Devices] D
	INNER JOIN
		[Units] U ON D.UnitRefId = U.Id
	INNER JOIN
		[DeviceTypes] DT ON D.TypeRefId = DT.Id
	LEFT OUTER JOIN
		[Orders] O ON O.Id = (SELECT TOP 1 [Id] FROM [Orders] WHERE ObjectTypeRefId = 3 AND ObjectRefId = D.Id ORDER BY [TimeStamp] DESC, [Id] DESC)
	LEFT OUTER JOIN
		[Status] S ON O.StatusRefId = S.Id
	LEFT OUTER JOIN
		[Employees] E ON O.EmployeeRefId = E.Id
	LEFT OUTER JOIN
		[TaxTypes] T ON O.TaxTypeRefId = T.Id