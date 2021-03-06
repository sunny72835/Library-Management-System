CREATE PROCEDURE spAddDocument(@docTitle nvarchar(50), @pdate date, @pubid INT, @libid int, @copyno int, @position nvarchar(10), @status INT out)
AS
DECLARE @count1 INT	 -- to check if publisher exists
DECLARE @count2 INT	 -- to check if libid exists
DECLARE @docId INT
BEGIN
	SET @docId=0
	select @count1=count(1) from Publisher where Publisher_id=@pubid	
	if(@count1>0)
	BEGIN
		SELECT @count2=count(1) from Branch where Libid=@libid
		if(@count2>0)
		BEGIN			
			SELECT @docId=MAX(DocID) from Document
			IF @docId is null
				SET @docId = 6000
			SET @docId+=1
			INSERT INTO Document Values(@docId,@docTitle,@pdate,@pubid)
			INSERT INTO Copy Values(@libid,@docId,@copyno,@position)
			SET @status=1
		END
		else
			SET @status=-1
	END
	else
		SET @status=0
END