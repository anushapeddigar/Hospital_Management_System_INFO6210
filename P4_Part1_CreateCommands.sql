-- Creation of Tables for our Database Implementation

--Create database
CREATE DATABASE MediForms;

USE MediForms;
-- Table Patient

CREATE TABLE Patient
(
PatientID INT NOT NULL PRIMARY KEY ,
FirstName VARCHAR(15),
LastName VARCHAR(15),
DOB DATE NOT NULL CHECK(DOB < getdate()),
Gender VARCHAR(10),
PatientWeight INT,
PhoneNumber CHAR(10)NOT NULL CHECK (PhoneNumber like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
SSN INT 
);

-- Table PatientAddress

CREATE TABLE PatientAddress
(
AddressID INT  NOT NULL PRIMARY KEY,
PatientID INT NOT NULL  REFERENCES Patient(PatientID),
Street VARCHAR(20) NOT NULL,
City VARCHAR(15) NOT NULL ,
State CHAR(2) NOT NULL,
ZipCode CHAR(5) NOT NULL CHECK (ZipCode like '[0-9][0-9][0-9][0-9][0-9]')
);

-- Table PatientMedicalHistory

CREATE TABLE PatientMedicalHistory
(
PatientMedicalHistoryID INT NOT NULL PRIMARY KEY,
PatientID INT NOT NULL  REFERENCES Patient(PatientID),
ExistingIllness VARCHAR(20),
Allergies VARCHAR(20),
Medicines VARCHAR(20),
BloodPressure VARCHAR(20),
BloodType VARCHAR(20)
);

--Table Test

CREATE TABLE Test
(
TestID INT NOT NULL PRIMARY KEY,
TestName VARCHAR(30),
TestType VARCHAR(20)
);

--Table PatientTest

CREATE TABLE PatientTest
(
PatientTestID INT NOT NULL PRIMARY KEY,
TestResult VARCHAR(10),
PatientID INT NOT NULL  REFERENCES Patient(PatientID),
TestID INT NOT NULL REFERENCES Test(TestID)
);

-- Table PatientDiagnosis

CREATE TABLE PatientDiagnosis
(
PatientDiagnosisID INT NOT NULL PRIMARY KEY,
PatientTestID INT NOT NULL REFERENCES PatientTest(PatientTestID),
DiagnosisComments VARCHAR(200)
);

-- Table PatientDiagnosisRelation

CREATE TABLE PatientDiagnosisRelation
(
PatientDiagnosisID INT REFERENCES  PatientDiagnosis(PatientDiagnosisID),
PatientID INT REFERENCES Patient(PatientID),
Constraint PKPatientDiagnosisRelation PRIMARY KEY CLUSTERED(PatientDiagnosisID, PatientID)
);

-- Table Doctor

CREATE TABLE Doctor
(
DoctorID INT NOT NULL PRIMARY KEY,
Position VARCHAR(20) NOT NULL,
FirstName VARCHAR(15) NOT NULL,
LastName VARCHAR(15)NOT NULL,
Address VARCHAR(20) NOT NULL,
City VARCHAR(15) NOT NULL ,
State CHAR(2) NOT NULL,
ZipCode CHAR(5) NOT NULL CHECK (ZipCode like '[0-9][0-9][0-9][0-9][0-9]'),
PhoneNumber CHAR(10)NOT NULL CHECK (PhoneNumber like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
);

-- Table PatientAppointment

CREATE TABLE PatientAppointment
(
AppointmentID INT NOT NULL PRIMARY KEY,
AppointmentDate DATE NOT NULL,
AppointmentTime TIME NOT NULL,
PatientID INT NOT NULL  REFERENCES Patient(PatientID),
DoctorID INT NOT NULL  REFERENCES Doctor(DoctorID)
);

-- Table AppointmentDiagnosisRelation

CREATE TABLE AppointmentDiagnosisRelation
(
AppointmentID INT FOREIGN KEY REFERENCES  PatientAppointment(AppointmentID),
PatientDiagnosisID INT FOREIGN KEY REFERENCES PatientDiagnosis(PatientDiagnosisID),
Constraint PKAppointmentDiagnosisRelation PRIMARY KEY CLUSTERED(AppointmentID, PatientDiagnosisID)
);

-- Table DoctorSchedule

CREATE TABLE DoctorSchedule
(
ScheduleID INT  NOT NULL PRIMARY KEY,
ScheduleDay VARCHAR(10)NOT NULL,
TimeFrom TIME NOT NULL,
TimeTo TIME NOT NULL,
DoctorID INT NOT NULL  REFERENCES Doctor(DoctorID)
);

-- Table Treatment

CREATE TABLE Treatment
(
TreatmentID INT NOT NULL PRIMARY KEY,
TreatmentName VARCHAR(20) NOT NULL,
Cost INT NOT NULL
);

-- Table PatientTreatment

CREATE TABLE PatientTreatment
(
PatientTreatmentID INT  NOT NULL PRIMARY KEY,
AppointmentID INT NOT NULL  REFERENCES PatientAppointment(AppointmentID),
TreatmentID INT NOT NULL  REFERENCES Treatment(TreatmentID)
);

-- Table Prescription

CREATE TABLE Prescription
(
PrescriptionID INT  NOT NULL PRIMARY KEY,
PatientTreatmentID INT NOT NULL  REFERENCES PatientTreatment(PatientTreatmentID),
Comments VARCHAR(20)
);

--Table Insurance Company

CREATE TABLE [InsuranceCompany]
(
 [companyID] Int  NOT NULL PRIMARY KEY,
 [companyName] Varchar(20) NOT NULL,
 [companyContact] CHAR(10) NOT NULL
)
go
select * from InsuranceCompany 

ALTER TABLE InsuranceCompany ALTER COLUMN companyContact CHAR(10)

--Table Insurance

CREATE TABLE [Insurance]
(
 [insuranceID] Int  NOT NULL PRIMARY KEY,
 [policyId] Varchar(15) NOT NULL,
 [policyStartDate] Date NOT NULL,
 [policyEndDate] Date NOT NULL,
 [status] Bit NOT NULL,
 [amountCovered] Int NOT NULL,
 [patientID] Int NOT NULL REFERENCES Patient(PatientID),
 [companyID] Int NOT NULL REFERENCES InsuranceCompany(companyID)
)
go

-- Table Invoice

CREATE TABLE [Invoice]
(
 [invoiceID] Int NOT NULL PRIMARY KEY,
 [appointmentBill] Int NOT NULL,
 [balance] Int NOT NULL,
 [creditDate] Date NOT NULL,
 [dueDate] Date NOT NULL,
 [patientId] Int NOT NULL REFERENCES Patient(PatientID),
 [appointmentId] Int NOT NULL REFERENCES PatientAppointment(appointmentID) ,
 [status] Bit NOT NULL
)
go

-- Table Payment
CREATE TABLE [Payment]
(
 [paymentID] Int  NOT NULL PRIMARY KEY,
 [paymentAmount] Int NOT NULL,
 [paymentType] Varchar(15) NOT NULL,
 [paymentDate] Date NOT NULL,
 [status] Bit NOT NULL,
 [invoiceId] Int NOT NULL REFERENCES Invoice(InvoiceID),
 [patientId] Int NOT NULL REFERENCES Patient(PatientID),
 [insuranceId] Int NOT NULL REFERENCES Insurance(InsuranceID)
)
go




--Table Location

CREATE TABLE [Location]
(
 [locationID] INT NOT NULL PRIMARY KEY,
 [facilityName] Varchar(30) NOT NULL,
 [street] Varchar(30) NOT NULL,
 [city] Varchar(15) NOT NULL,
 [state] Char(2) NOT NULL,
 [zipCode] Char(5) NOT NULL CHECK (zipCode like '[0-9][0-9][0-9][0-9][0-9]'),
 [contactNumber] Char(10) NOT NULL CHECK (contactNumber like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
)
go

--Table Inventory

CREATE TABLE [Inventory]
(
 [inventoryID] Int  NOT NULL PRIMARY KEY,
 [inventoryName] Varchar(20) NOT NULL,
 [installedDate] Date NOT NULL,
 [warrantyYears] INT NOT NULL,
 [orderID] INT NOT NULL,
 [vendorDetails] Varchar(30) NULL,
 [locationID] INT NOT NULL  REFERENCES Location(locationID)
)
go


--Table Room

CREATE TABLE [Room]
(
 [roomID] Int NOT NULL PRIMARY KEY,
 [roomNumber] Int NOT NULL,
 [floorNumber] Int NOT NULL,
  [roomType] varchar(30) NOT NULL,
 [available] Bit NOT NULL,
 [locationID] Int NOT NULL REFERENCES Location (locationID)
)
go

-- Table Patient Room Relation

CREATE TABLE [PatientRoomRelation]
(
 [patientRoomID] Int NOT NULL PRIMARY KEY,
 [patientID] INT NOT NULL REFERENCES Patient(patientID),
 [roomID] INT NOT NULL REFERENCES Room(roomID),
 [admitDate] Date NOT NULL,
 [dischargeDate] Date NOT NULL
)
go

--Table Drug Catalogue

CREATE TABLE [DrugCatalogue]
(
 [drugId] Int NOT NULL PRIMARY KEY,
 [drugName] Varchar(20) NOT NULL,
 [amountOrdered] Int NOT NULL,
 [orderId] Varchar(20) NOT NULL,
 [expiryDate] Date NOT NULL,
 [locationId] Int NOT NULL REFERENCES Location(locationID)
)
go

--Table Patient Drug Relation

CREATE TABLE [PatientDrugRelation]
(
 [patientdDrugID] Int NOT NULL PRIMARY KEY,
 [drugID] Int NOT NULL REFERENCES DrugCatalogue(drugID),
 [patientID] Int NOT NULL REFERENCES Patient(patientID),
 [purchaseDate] Date NOT NULL,
 [quantity] Int 
)

-- We have inserted the Data into Tables using the Data import Wizard

-- VIEW 1

--View to Display Patients currently admitted to a room

CREATE VIEW AdmittedPatients AS
SELECT P.PatientID, P.FirstName, P.LastName, P.PhoneNumber, r.roomNumber, r.FloorNumber, r.RoomType FROM Patient P
INNER JOIN PatientRoomRelation PR
ON P.PatientID = PR.PatientID
INNER JOIN Room R
ON R.RoomID = PR.RoomID
WHERE R.Available = 0 

SELECT * FROM AdmittedPatients
--- ENCRYPTION

--Encryption on Payment

--CREATE MASTER KEY

CREATE MASTER KEY ENCRYPTION 
BY PASSWORD = 'Payment2020$';

 -- CREATE CERTIFICATE

CREATE CERTIFICATE paymentcert

WITH SUBJECT = 'User Payment';


-- CREATE SYMMETRIC KEY

CREATE SYMMETRIC KEY payment_Key_1

WITH ALGORITHM = AES_256  -- it can be AES_128,AES_192,DES etc

ENCRYPTION BY CERTIFICATE paymentcert;

--Encryption

ALTER TABLE Payment ADD paymentamount_encrypt varbinary(MAX),paymentType_encrypt varbinary(MAX),paymentDate_encrypt varbinary(MAX);

OPEN SYMMETRIC KEY payment_Key_1 DECRYPTION BY CERTIFICATE paymentcert;


UPDATE Payment
        SET paymentamount_encrypt = EncryptByKey (Key_GUID('payment_Key_1'),CONVERT(varchar(10), paymentAmount)),
		    paymentType_encrypt = EncryptByKey (Key_GUID('payment_Key_1'),CONVERT(varchar(10), paymentType)),
			paymentDate_encrypt = EncryptByKey (Key_GUID('payment_Key_1'),CONVERT(varchar(10), paymentDate))
        FROM Payment;
        GO

-- Close SYMMETRIC KEY

CLOSE SYMMETRIC KEY payment_Key_1;
            GO

--Verify the records in Payment Table
SELECT * FROM Payment

--Let's remove the old column paymentID

 ALTER TABLE Payment DROP COLUMN paymentAmount,paymentType,paymentDate


 --- Decryption

OPEN SYMMETRIC KEY payment_Key_1

DECRYPTION BY CERTIFICATE paymentcert;

SELECT paymentamount_encrypt, paymentType_encrypt, paymentDate_encrypt,
            CONVERT(varchar, DecryptByKey(paymentamount_encrypt)) AS 'Decrypted Payment amount',
			CONVERT(varchar, DecryptByKey(paymentType_encrypt)) AS 'Decrypted Payment Type ',
			CONVERT(varchar, DecryptByKey(paymentDate_encrypt)) AS 'Decrypted Payment Date'
            FROM Payment;






-- VIEW 2

-- View to view Patient Payment Information

OPEN SYMMETRIC KEY payment_Key_1
DECRYPTION BY CERTIFICATE paymentcert;
CREATE VIEW PatientsPayments AS 
SELECT P.PatientID, P.FirstName, P.LastName, P.PhoneNumber, I.invoiceID, I.balance, PM.status, 
            CONVERT(varchar, DecryptByKey(paymentamount_encrypt)) AS 'Payment amount',
			CONVERT(varchar, DecryptByKey(paymentType_encrypt)) AS 'Payment Type ',
			CONVERT(varchar, DecryptByKey(paymentDate_encrypt)) AS 'Payment Date'
FROM Patient P 
JOIN Invoice I ON P.PatientID = I.PatientID
JOIN Payment PM ON P.PatientID = PM.PatientID

