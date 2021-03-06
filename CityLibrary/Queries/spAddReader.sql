CREATE PROCEDURE spAddReader (@readerName nvarchar(50), @type nvarchar(10), @phoneno nvarchar(12),@address nvarchar(100))
AS
DECLARE @readerId as INT
BEGIN
	SELECT @readerId=MAX(Reader_id) from Reader
	if @readerId is null
		SET @readerId = 1000
	SET @readerId += 1
	INSERT INTO Reader VALUES (@readerId, @type, @readerName, @phoneno, @address)
END