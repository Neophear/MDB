CREATE PROCEDURE [dbo].[DeviceInsert]
	@IMEI NVARCHAR(50),
	@Model NVARCHAR(50),
	@Provider NVARCHAR(50),
	@OrderNumber NVARCHAR(50),
	@BuyDate DATE,
	@UnitRefId INT,
	@TypeRefId INT,
	@Notes NVARCHAR(1000),
	@Executor NVARCHAR(8),
	@LastId INT OUTPUT,
	@Type NVARCHAR(50) = NULL OUTPUT,
	@Unit NVARCHAR(100) = NULL OUTPUT
AS
	DECLARE @CanUserWrite BIT
	EXEC @CanUserWrite = dbo.CanUserWrite @Executor
	IF @CanUserWrite = 1
	BEGIN
		IF NOT EXISTS(SELECT [Id] FROM [Devices] WHERE [IMEI] = @IMEI)
		BEGIN
			INSERT INTO [Devices] ([IMEI], [Model], [Provider], [OrderNumber], [BuyDate], [UnitRefId], [TypeRefId], [Notes])
				VALUES(@IMEI, @Model, @Provider, @OrderNumber, @BuyDate, @UnitRefId, @TypeRefId, @Notes)
			DECLARE @Values NVARCHAR(2000) = CONCAT(@IMEI,'|',@Model,'|',@Provider,'|',@OrderNumber,'|',ISNULL(CONVERT(NVARCHAR(10), @BuyDate), 'null'),'|',@UnitRefId,'|',@TypeRefId,'|',@Notes)
			SET @LastId = SCOPE_IDENTITY()
			SET @Type = (SELECT [Name] FROM [DeviceTypes] WHERE [Id] = @TypeRefId)
			SET @Unit = (SELECT [Name] FROM [Units] WHERE [Id] = @UnitRefId)
			EXEC dbo.WriteLog 1, @Executor, 3, @LastId, 'IMEI|Model|Provider|OrderNumber|BuyDate|UnitRefId|TypeRefId|Notes', @Values
		END
	END
RETURN 0