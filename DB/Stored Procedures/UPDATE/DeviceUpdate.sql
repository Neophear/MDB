CREATE PROCEDURE [dbo].[DeviceUpdate]
	@Id INT,
	@IMEI NVARCHAR(50),
	@Model NVARCHAR(50),
	@Provider NVARCHAR(50),
	@OrderNumber NVARCHAR(50),
	@BuyDate DATE,
	@UnitRefId INT,
	@TypeRefId INT,
	@Notes NVARCHAR(1000),
	@Executor NVARCHAR(8),
	@Type NVARCHAR(50) = NULL OUTPUT,
	@Unit NVARCHAR(100) = NULL OUTPUT
AS
	DECLARE @CanUserWrite BIT
	EXEC @CanUserWrite = dbo.CanUserWrite @Executor
	IF @CanUserWrite = 1
	BEGIN
		IF EXISTS(SELECT [Id] FROM [Devices] WHERE [Id] = @Id) AND NOT EXISTS(SELECT [Id] FROM [Devices] WHERE [IMEI] = @IMEI AND [Id] <> @Id)
		BEGIN
			DECLARE @oldIMEI NVARCHAR(50)
			DECLARE @oldModel NVARCHAR(50)
			DECLARE @oldProvider NVARCHAR(50)
			DECLARE @oldOrderNumber NVARCHAR(50)
			DECLARE @oldBuyDate DATE
			DECLARE @oldUnitRefId INT
			DECLARE @oldTypeRefId INT
			DECLARE @oldNotes NVARCHAR(1000)
			DECLARE @Properties VARCHAR(1000)
			DECLARE @Values NVARCHAR(2000)

			SELECT @oldIMEI = [IMEI], @oldModel = [Model], @oldProvider = [Provider], @oldOrderNumber = [OrderNumber], @oldBuyDate = [BuyDate], @oldUnitRefId = [UnitRefId], @oldTypeRefId = [TypeRefId], @oldNotes = [Notes] FROM [Devices] WHERE [Id] = @Id

			--Update IMEI
			IF @oldIMEI <> @IMEI
			BEGIN
				SET @Properties = 'IMEI'
				SET @Values = @IMEI
			END

			--Update Model
			IF @oldModel <> @Model COLLATE Latin1_General_CS_AS
			BEGIN
				SET @Properties = CONCAT(@Properties, '|Model')
				SET @Values = CONCAT(@Values, '|', @Model)
			END

			--Update Provider
			IF @oldProvider <> @Provider COLLATE Latin1_General_CS_AS
			BEGIN
				SET @Properties = CONCAT(@Properties, '|Provider')
				SET @Values = CONCAT(@Values, '|', @Provider)
			END

			--Update OrderNumber
			IF @oldOrderNumber <> @OrderNumber
			BEGIN
				SET @Properties = CONCAT(@Properties, '|OrderNumber')
				SET @Values = CONCAT(@Values, '|', @OrderNumber)
			END

			--Update BuyTime
			IF ISNULL(NULLIF(@BuyDate, @oldBuyDate),NULLIF(@oldBuyDate,@BuyDate)) IS NOT NULL --IF @oldBuyDate <> @BuyDate OR (@oldBuyDate IS NULL AND @BuyDate IS NOT NULL) OR (@oldBuyDate IS NOT NULL AND @BuyDate IS NULL)
			BEGIN
				SET @Properties = CONCAT(@Properties, '|BuyDate')
				SET @Values = CONCAT(@Values, '|', ISNULL(CONVERT(NVARCHAR(10), @BuyDate), 'null'))
			END

			--Update UnitRefId
			IF @oldUnitRefId <> @UnitRefId
			BEGIN
				SET @Properties = CONCAT(@Properties, '|UnitRefId')
				SET @Values = CONCAT(@Values, '|', @UnitRefId)
			END

			--Update TypeRefId
			IF @oldTypeRefId <> @TypeRefId
			BEGIN
				SET @Properties = CONCAT(@Properties, '|TypeRefId')
				SET @Values = CONCAT(@Values, '|', @TypeRefId)
			END

			--Update Notes
			IF @oldNotes <> @Notes COLLATE Latin1_General_CS_AS
			BEGIN
				SET @Properties = CONCAT(@Properties, '|Notes')
				SET @Values = CONCAT(@Values, '|', @Notes)
			END

			--Update device and write to log if anything changed
			IF @Properties <> ''
			BEGIN
				UPDATE [Devices] SET [IMEI] = @IMEI, [Model] = @Model, [Provider] = @Provider, [OrderNumber] = @OrderNumber, [BuyDate] = @BuyDate, [UnitRefId] = @UnitRefId, [TypeRefId] = @TypeRefId, [Notes] = @Notes WHERE [Id] = @Id
			
				SET @Type = (SELECT [Name] FROM [DeviceTypes] WHERE [Id] = @TypeRefId)
				SET @Unit = (SELECT [Name] FROM [Units] WHERE [Id] = @UnitRefId)

				SET @Properties = dbo.Trim(@Properties, '|')
				SET @Values = dbo.Trim(@Values, '|')

				EXEC dbo.WriteLog 2, @Executor, 3, @Id, @Properties, @Values
			END
		END
	END
RETURN 0