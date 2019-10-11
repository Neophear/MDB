CREATE FUNCTION [dbo].[GetUserFull]
(
	@MANR VARCHAR(8)
)
RETURNS NVARCHAR(150)
AS
BEGIN
	DECLARE @Result NVARCHAR(150)
	SELECT			@Result = ISNULL(E.[Name],CONCAT(UI.Firstname,' ',UI.Lastname))
	FROM			[UserInfo] UI
	FULL OUTER JOIN	[Employees] E
	ON				UI.[Username] = E.MANR
	WHERE			UI.Username = @MANR
	OR				E.MANR = @MANR

	IF @Result IS NULL
		SET @Result = @MANR
	
	RETURN @Result
END