CREATE PROCEDURE [dbo].[spReserve](@readerId INT,
@docId INT,
@copyNo INT,
@libId INT,
@resDate DATE,
@result INT out)
AS
DECLARE @count1 INT  --To check if book exists
DECLARE @count2 INT  --To check if someone has borrowed it
DECLARE @count3 INT  --To check if someone else has reserved it
DECLARE @count4 INT  --To check if user has already reserved 10 documents
DECLARE @ResNumber INT
BEGIN
	UPDATE Reservation SET Reservation_Status = 'Cancelled' where ResDateTime<SYSDATETIME()
	if(DATEDIFF(Second, CAST(CURRENT_TIMESTAMP as time) , CAST('18:00:00' as time)) < 0)                    --  TO CHECK CURRENT TIME
			UPDATE Reservation SET Reservation_Status = 'Cancelled' where ResDateTime=SYSDATETIME()
	SELECT @count1=count(1) from Copy where DocID=@docId and Copyno=@copyNo and LibId=@libId	
	if @count1>0
	begin
		SELECT @count2=count(1) from Borrows B inner join BOR_Transaction BT on B.BorNumber=BT.BorNumber WHERE DocID=@docId and Copyno=@copyNo and LibId=@libId and RetDateTime is null
		SELECT @count3=count(1) from  Reserves R inner join Reservation RV on R.ResNumber=RV.ResNumber where DocID=@docId and LibId=@libId and Copyno=@copyNo and Reservation_Status = 'Reserved'		
		if @count2=0 and @count3=0
		begin
			SELECT @count4=count(1) from Reserves R inner join Reservation RV on R.ResNumber=RV.ResNumber where ReaderId=@readerId and Reservation_Status = 'Reserved'
			if @count4<10
			begin
				SELECT @ResNumber=MAX(ResNumber) from Reservation
				IF @ResNumber is Null
					SET @ResNumber=4000
				SET @ResNumber += 1
				INSERT INTO Reservation VALUES (@ResNumber,@resDate,'Reserved')
				INSERT INTO Reserves VALUES (@ResNumber,@docId,@libId,@copyNo,@readerId)				
				SET @result = @ResNumber		 			
			end
			else
			begin
				set @result = 0
			end
		end	
		ELSE
		BEGIN
			SET @result = -1
		END					
	end
	else
	begin
		SET @result = -2
	end
END