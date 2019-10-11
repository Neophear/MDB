CREATE VIEW [dbo].[SimcardView]
	AS SELECT		SC.Id,
					SC.Simnumber,
					SC.PUK,
					SC.Number,
					SC.IsData,
					IIF(SC.IsData = 1, 'Data', 'Tale') AS [Type],
					SC.FormatRefId,
					SF.Name AS [Format],
					SC.QuotaRefId,
					SC.QuotaEndDate,
					Q.Name AS [Quota],
					SC.DataPlanRefId,
					DP.Name AS [DataPlan],
					SC.[Provider],
					SC.OrderNumber,
					SC.BuyDate,
					SC.UnitRefId,
					U.Short AS [Unit],
					SC.Notes,
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
	FROM			[Simcards] SC
	INNER JOIN		[Units] U ON SC.UnitRefId = U.Id
	INNER JOIN		[Quotas] Q ON SC.QuotaRefId = Q.Id
	INNER JOIN		[DataPlans] DP ON SC.DataPlanRefId = DP.Id
	INNER JOIN		[SimcardFormats] SF ON SC.FormatRefId = SF.Id
	LEFT OUTER JOIN	[Orders] O ON O.Id = (SELECT TOP 1 [Id] FROM [Orders] WHERE ObjectTypeRefId = 4 AND ObjectRefId = SC.Id ORDER BY [TimeStamp] DESC, [Id] DESC)
	LEFT OUTER JOIN	[Status] S ON O.StatusRefId = S.Id
	LEFT OUTER JOIN	[Employees] E ON O.EmployeeRefId = E.Id
	LEFT OUTER JOIN	[TaxTypes] T ON O.TaxTypeRefId = T.Id