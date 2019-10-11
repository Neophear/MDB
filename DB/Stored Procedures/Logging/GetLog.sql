CREATE PROCEDURE [dbo].[GetLog]
	@DateFrom DATE = NULL,
	@DateTo DATE = NULL,
	@Executor VARCHAR(20) = null,
	@SearchTerm VARCHAR(50) = null
AS
	DECLARE @SearchWithWild VARCHAR(50) = ('%' + @SearchTerm + '%')
	SELECT TOP 500 * FROM [LogView] WHERE 
		(@DateFrom IS NULL OR CONVERT(DATE, [TimeStamp]) >= @DateFrom) AND
		(@DateTo IS NULL OR CONVERT(DATE, [TimeStamp]) <= @DateTo) AND
		(@Executor IS NULL OR [Executor] = @Executor) AND
		(@SearchTerm IS NULL OR [Values] LIKE @SearchWithWild)
	ORDER BY [TimeStamp] DESC, [Id] DESC
RETURN 0