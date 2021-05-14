
-- IMPLEMENTATION

--TABLE LEVEL CHECK CONSTRAINT BASED ON FUNCTION

--Add a Constraint to not allow a patient with the same Name and phone Number to register
CREATE OR ALTER FUNCTION isPatientRegistered(@firstName VARCHAR(30), @lastName VARCHAR(30), @phoneNumber CHAR(10))
RETURNS INT
AS 
BEGIN
	DECLARE @COUNT AS INT

	SELECT @COUNT = COUNT(PatientID) FROM Patient
	WHERE FirstName = @firstName AND LastName = @lastName AND PhoneNumber = @phoneNumber
	
	RETURN @COUNT
END

SELECT * FROM Patient

ALTER TABLE Patient WITH NOCHECK ADD CONSTRAINT checkPatientRegistered 
CHECK (dbo.isPatientRegistered(firstName, lastName, phoneNumber) = 1)

INSERT INTO Patient VALUES(191, 'Liam', 'Iran', '1996/02/16', 'Male', 65, 4133211531, 8776598)

--COMPUTE COLUMN BASED ON A FUNCTION

--Calculate Age Column from PatientID and DOB

CREATE FUNCTION calculateAgeFromDOB(@PatientID INT)
RETURNS INT
AS
   BEGIN

   DECLARE @Age AS INT

   SELECT @Age = DATEDIFF(hour,P.DOB,GETDATE())/8766 FROM Patient P
   WHERE P.PatientID = @PatientID

   RETURN @Age
   END

ALTER TABLE dbo.Patient
ADD Age AS (dbo.calculateAgeFromDOB(PatientID));

SELECT * FROM PatientDiagnosisRelation



--STORED PROCEDURE TO CALCULATE REVENUE

CREATE PROCEDURE CalculateRevenue @YEAR INT, @MONTH INT = NULL,@Revenue AS VARCHAR(20) OUTPUT
AS 
BEGIN
	 
	IF @MONTH IS NOT NULL
	BEGIN
		SELECT @Revenue = SUM(Balance) FROM INVOICE 
		WHERE YEAR(CreditDate) = @YEAR AND MONTH(CreditDate) = @MONTH AND Status = 1
	END

	ELSE
	BEGIN
		SELECT @Revenue = SUM(Balance) FROM INVOICE 
		WHERE YEAR(CreditDate) = @YEAR AND Status = 1
	END

END

--To Calculate Yearly Revenue
DECLARE @YearlyRevenue AS VARCHAR(20)
EXEC CalculateRevenue @YEAR=2008, @MONTH = Null,@Revenue = @YearlyRevenue OUTPUT
Select @YearlyRevenue

--To Calculate Revenue for a particular month
DECLARE @MonthlyRevenue AS VARCHAR(20)
EXEC CalculateRevenue @YEAR=2000, @MONTH = 12,@Revenue = @MonthlyRevenue OUTPUT
Select @MonthlyRevenue

-- Stored Procedure To add New Patient
CREATE PROCEDURE usp_AddNewPatient
		 @FirstName VARCHAR(15)
		,@LastName VARCHAR(15)
		,@DOB DATE
		,@Gender VARCHAR(10)
        ,@PatientWeight INT
		,@PhoneNumber VARCHAR(10)
		,@SSN INT
		,@OutputResult VARCHAR(1000) OUTPUT
AS
BEGIN
			Declare @PatientId INT = 0;
            Select @PatientId = PatientId from Patient		
			INSERT INTO dbo.Patient
			(PatientId,FirstName,LastName,DOB,Gender,PatientWeight,PhoneNumber,SSN)
			VALUES
			(@PatientId+1,@FirstName,@LastName,@DOB,@Gender,@PatientWeight,@PhoneNumber,@SSN)
			    
		SET @OutputResult = 'SUCCESS'
		
END

GO 
DECLARE @OutputResult VARCHAR(1000) = ''
EXEC usp_AddNewPatient
		 @FirstName = 'MARTIN',@LastName ='DONNA',@DOB = '1987-04-19',@Gender = 'M',
         @PatientWeight = 156
		,@PhoneNumber = '4089870098',@SSN = 1236666
		,@OutputResult  = @OutputResult OUTPUT
SELECT @OutputResult


-- Stored Procedure To add New Patient Appointment

CREATE PROCEDURE usp_AddNewPatientAppointment
		 @ScheduleDay VARCHAR(10)
		,@TimeFrom Time(7)
		,@TimeTo Time(7)
		,@DoctorFirstName VARCHAR(15)
        ,@DoctorLastName VARCHAR(15)
        ,@PatientFirstName VARCHAR(15)
        ,@PatientLastName VARCHAR(15)
        ,@AppointmentDate Date
		,@OutputResult VARCHAR(1000) OUTPUT
AS
BEGIN
			Declare @PatientId INT =0 ;
            Declare @DoctorId INT=0 ;
            Declare @ScheduleId INT=0 ;
            Declare @AppointmentID INT=0 ;
            Select @PatientId = PatientId from Patient where LastName=@PatientLastName and FirstName = @PatientFirstName		
			 Select @DoctorId = DoctorId from Doctor where LastName=@DoctorLastName and FirstName = @DoctorFirstName
             Select @ScheduleId = ScheduleId from DoctorSchedule 
             Select @AppointmentID = AppointmentId from PatientAppointment 
            INSERT INTO dbo.DoctorSchedule
			(ScheduleID,ScheduleDay,TimeFrom,TimeTo,DoctorID)
			VALUES
			(@ScheduleId+1,@ScheduleDay,@TimeFrom,@TimeTo,@DoctorId)

               INSERT INTO dbo.PatientAppointment
			(AppointmentID,AppointmentDate,AppointmentTime,PatientID,DoctorID)
			VALUES
			(@AppointmentID+1,@AppointmentDate,@TimeFrom,@PatientId,@DoctorId)  
		SET @OutputResult = 'SUCCESS'
		
END

GO 

-- create trigger
create table patient_record_log (
 PatientID int,
 FirstName VARCHAR(15),
	   LastName VARCHAR(15),
 );

create trigger trigger_patient_record_log
On Patient
AFTER INSERT 

AS 
begin 
--SELECT @PatientID= PatientID FROM INSERTED 
	insert into patient_record_log
	SELECT PatientID, FirstName, LastName FROM inserted
end;

INSERT INTO Patient VALUES(191, 'Liam', 'Iran', '1996/02/16', 'Male', 65, 4133211531, 8776598);
SELECT * FROM patient_record_log;
