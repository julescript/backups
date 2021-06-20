-- SQL LABS --
-- ##################################  SQL 1 LAB  ############################### --

--Procedure 1 : insert user
CREATE PROCEDURE addUser (
    @Username nvarchar(30),
    @Password nvarchar(30)
)
AS
BEGIN
    INSERT INTO Users (Username, UPassword, UStatus, UserTupe)
    VALUES (@UserName, @Password, 2, 2)
END

EXEC addUser  'julesript', '12312312'


--Procedure 2 : change user type
CREATE PROCEDURE changeTYPE (
    @ID int,
    @Type int
)
AS 
BEGIN
    update Users set UserType=@Type Where UserID=@ID
END

EXEC changeTYPE  1, 1


--Procedure 3 : lock user
CREATE PROCEDURE lockUSER (
    @ID int
)
AS 
BEGIN
    update Users set UsStatus=1 Where UserID=@ID
END

EXEC lockUSER  2

-- ##################################  SQL 2 LAB  ############################### --

CREATE TABLE AspNetUsers (
    id nvarchar(128),
    UserName nvarchar(MAX),
    PasswordHash nvarchar(MAX),
	SecurityStamp nvarchar(MAX),
	Discriminator nvarchar(128),
    PRIMARY KEY (id)
)

CREATE TABLE AspNetUserRoles (
    UserId nvarchar(128),
	RoleId nvarchar(128),
    CONSTRAINT FK_UID FOREIGN KEY (UserId) REFERENCES AspNetUsers(id),
    CONSTRAINT FK_RID FOREIGN KEY (RoleId) REFERENCES AspNetRoles(id),
	CONSTRAINT PK_UserRoles PRIMARY KEY (UserId,RoleId)
)

CREATE TABLE AspNetUserLogins (
    UserId nvarchar(128),
	LoginProvider nvarchar(128),
    ProviderKey nvarchar(128),
    CONSTRAINT FK_UID FOREIGN KEY (UserId) REFERENCES AspNetUsers(id),
	CONSTRAINT PK_UserLogins PRIMARY KEY (UserId,LoginProvider,ProviderKey)
)


CREATE TABLE AspNetUserClaims (
    Id int,
	ClaimType nvarchar(MAX),
    ClaimValue nvarchar(MAX),
    User_Id nvarchar(128) NOT NULL,
    PRIMARY KEY (Id),
    CONSTRAINT FK_UID FOREIGN KEY (User_Id) REFERENCES AspNetUsers(id),
)

CREATE TABLE AspNetRoles (
    id nvarchar(128),
	Name nvarchar(MAX) NOT NULL,
	PRIMARY KEY (id)
);

-- Function that returns all info for specific user:
CREATE FUNCTION UserInfo (
    @user_id nvarchar(128)
)
returns table as
AS
BEGIN
    return selet * from AspNetUsers where id=@user_id
END

--function execution:
SELECT * FROM UserInfo(1);

-- ##################################  SQL 3 LAB  ############################### --

create table Employee (
  EmpID int PRIMARY KEY, 
  FirstName varchar(50) NULL, 
  LastName varchar(50) NULL, 
  Salary int NULL, 
  Address varchar(100) NULL
)

--inserting values
insert into Employee(EmpID,FirstName,LastName,Salary,Address)
values(1,'elie','aoun',50000,'Beirut');

insert into Employee(EmpID,FirstName,LastName,Salary,Address)
values(2,'ely','ely',30000,'jbeil');


insert into Employee(EmpID,FirstName,LastName,Salary,Address)
values(3,'elon','musk',9999999,'mars');

insert into Employee(EmpID,FirstName,LastName,Salary,Address)
values(4,'aoun','aoun',60000,'lebanon');


--test query
select * from Employee

--Scalar function
--create function to get employee full name
create function fnGetEmpFullName(
@FirstName varchar(50),
@LastName varchar(50)
)
returns varchar(101)
As
begin return (select @FirstName + ' ' + @LastName);
End

--calling the above function
Select dbo.fnGetEmpFullName(FirstName,LastName) as Name,Salary from Employee

--Inline Table-Valued function
--create function to get Employees
create function fnGetEmployee()
returns Table
As
return (Select * from Employee)

--calling the function
Select * from fnGetEmployee()

--Multi-statement Table-Valued Function
--create function for EmpID,FirstName and Salary of Employee
create function fnGetMulEmployee()
returns @Emp Table
(
EmpID int,
FirstName varchar(50),
Salary int
)
As
begin 
Insert @Emp Select e.EmpID,e.FirstName,e.Salary from Employee e;
--Now update salary of first employee
update @Emp set Salary=25000 where EmpID=1;
return
end

--execute the function
Select * from fnGetMulEmployee()
--to see the original table: it's not affected by the above update command
select * from Employee


--Example 1 :
create function whichContinent (@Country nvarchar(15))
returns varchar(30)
as
begin
declare @Return varchar(30)
select @Return = case @Country
when 'Argentina' then 'South America'
when 'Belgium' then 'Europe'
when 'Brazil' then 'South amercia'
when 'Canada' then 'north america'
when 'Denmark' then 'Europe'
when 'Finland' then 'Europe'
when 'France' then 'Europe'
else 'Unknown'
end
return @Return
end

print dbo.whichContinent('Brazil')

create table test (
Country varchar(15),
Continent as (dbo.whichContinent(Country)))

insert into test (Country) values('USA')
insert into test (Country) values('France')

select * from test


--Example 2 :
create function dbo.ConvertRegional(
@d char(10),
@style TINYINT
)
returns char(10)
as
begin
	return (select CONVERT(CHAR(10),CONVERT(DATEtime,@d),@style));
end

--Example 3 :
create function dbo.ConvertRegional1(
	@d char(10),
	@style TINYINT
)
returns char(10)
as
begin
	return (select case when ISDATE(@d) =1 then CONVERT(char(10),CONVERT(DATEtime,@d),@style)
	end)
end

--Example 4:
create function dbo.ConvertDate(@d char(10))
returns DATEtime
as
begin
	return (select convert(DATEtime,@d));
end

GO
declare @d char(10);
select @d='20120428';

SELECT
	dbo.ConvertDate(@d),
	dbo.ConvertRegional(@d,101),
	dbo.ConvertRegional(@d,103),
	dbo.ConvertRegional(@d,120)


-- ##################################  SQL 4 LAB  ############################### --

CREATE TABLE Address (
    AddressID int PRIMARY KEY,
    Zone nvarchar(50),
    City nvarchar(30),
    quarter nvarchar(30),
    Street nvarchar(30),
    Building nvarchar(30),
    AFloor nvarchar(30),
    CellPhone nvarchar(30),
    NPhone nvarchar(30),
    FaxPhone nvarchar(30),
    Mailbox nvarchar(30),
)

create table Users(
    username nvarchar(30) Primary Key,
    UPassword nvarchar(50),
    UserFullName nvarchar(30),
    UStatus nvarchar(30)
)

CREATE TABLE Company (
    CompanyID int IDENTITY(1,1) PRIMARY KEY,
    CompanyName_Ar nvarchar(50),
    CompanyName_en nvarchar(30),
    CompanyPhone nvarchar(30),
    SSn int,
    AddressID int,
    Email nvarchar(30),
    username nvarchar(30),
    CONSTRAINT FK_AID FOREIGN KEY (AddressID) REFERENCES Address(AddressID),
    CONSTRAINT FK_EU FOREIGN KEY (username) REFERENCES Users(username),
)

-- Procedures:
-- Procedure insert for table company
CREATE PROCEDURE insertCompany (
    @CompanyName_Ar nvarchar(30),
    @CompanyName_en nvarchar(30),
    @CompanyPhone nvarchar(30),
    @SSN int,
    @AddressID int,
    @Email nvarchar(30),
    @username nvarchar(30)
)
AS
BEGIN
    INSERT INTO Company (CompanyName_Ar,CompanyName_en,CompanyPhone,SSN,AddressID,Email,username) 
    VALUES (@CompanyName_Ar,@CompanyName_en,@CompanyPhone,@SSN,@AddressID,@Email,@username)
END

EXEC insertCompany 'elyCo', 'elyCo','12345678',123234,1,'elyCo@hotmail.com','ely3on';

-- procedure that return as result: CompanyID, CompanyName_Ar, CompanyName_en, Zone, City, UserFullname
CREATE PROCEDURE CoInfo
AS
BEGIN
    SELECT c.CompanyID,c.CompanyName_Ar,c.CompanyName_en,a.Zone,a.City,u.UserFullname
    FROM Company c JOIN Address a on c.AddressID = a.AddressID JOIN Users u on c.username = u.username 
END

exec CoInfo

-- procedure that return as result all company created by a user in a specific zone
CREATE PROCEDURE returnCompanies (
    @Zone nvarchar(30),
    @user nvarchar(30)
)
AS
BEGIN
    SELECT c.CompanyID,c.CompanyName_Ar,c.CompanyName_en,c.SSn,c.Email from Company c Join address a on c.AddressID = a.AddressID join Users u on c.username = u.username
    WHERE a.Zone = @Zone AND u.username = @user
END

exec returnCompanies '1','ely3on';

-- Modify the diagram, to save multiple addresses for the same company.
create table CompanyAddress(
    AddressID int PRIMARY KEY,
    CID int,
    Constraint FK_CompID foreign key (CID) references Company(CompanyID)
)

-- TRIGERES
CREATE table template(
    operation nvarchar(20),
    sys_user nvarchar(20),
    ModifiedTable nvarchar(20),
    DateOfOperation datetime
)

CREATE TRIGGER Company_trigger 
ON Company
after UPDATE, INSERT, DELETE
as
declare @table nvarchar(20), @company nvarchar(20), @user nvarchar(20), @operation nvarchar(20);
--UPDATE
begin
    SET @operation = 'UPDATE';
    SET @user = SYSTEM_USER;
	SET @table= 'Company';
    SELECT @company = CompanyName_en from Company c;
    INSERT into template(operation,sys_user, ModifiedTable,DateOfOperation) values (@operation,@user,@table,GETDATE());
end
--INSERT
begin
    SET @operation = 'INSERT';
    SET @user = SYSTEM_USER;
	SET @table = 'Company';
    SELECT @company = CompanyName_en from Company c;
    INSERT into template(operation,sys_user, ModifiedTable,DateOfOperation) values (@operation,@user,@table,GETDATE());
end
--DELETE
begin 
    SET @operation = 'DELETE';
    SET @user = SYSTEM_USER;
	SET @table = 'Company';
    SELECT @company = CompanyName_en from Company c;
    INSERT into template(operation,sys_user, ModifiedTable,DateOfOperation) values (@operation,@user,@table,GETDATE());
end


-- method that record the companyID, SSN, Email when a new company is created.
CREATE TRIGGER company_insert_trigger
on Company
after INSERT
as
declare @CID int,@SSN int,@Email nvarchar(50)
begin
	select @CID=CompanyID from inserted;
	select @SSN=SSN from inserted;
	select @Email = Email from inserted;
	insert into CompanyTrigger(companyID,SSN,email)
	values(@CID,@SSN,@Email);
end

-- BACKUP : to backup a database
BACKUP DATABASE databasename TO DISK = 'filepath'



-- ##################################  SQL 5 LAB  ############################### --
create table Patient(
patientId int Identity(1,1),
fullname nvarchar(50) not null,
age int,
sex nvarchar(20),
patientemail nvarchar(50),
mobile bigint,
visitdate date,
admissionhour time,
visithour time,
doctorName nvarchar(50),
diagnosticArrival date,
diagnosticexit date,
treatmentName nvarchar(30),
CONSTRAINT FK_drName FOREIGN KEY (doctorName)
REFERENCES Doctor(name),
CONSTRAINT FK_trName FOREIGN KEY (treatmentName)
REFERENCES Treatment(treatmentName)
)


create table Doctor(
name nvarchar(50) not null,
specialization nvarchar(100),
primary key (name)
)

create table Treatment(
treatmentName nvarchar(30) not null,
primary key (TreatmentName)
)


--2.a select procedure:
create procedure selectPatient
@patientID int
as
begin
select * from Patient where patientId=@patientID
end

exec selectPatient 2;

--insert procedure:
create procedure insertPatient
@patientName nvarchar(50),
@patientAge int,
@patientSex nvarchar(20),
@patientEmail nvarchar(50),
@phoneNbr bigint,
@visitDate date,
@admissionHour time,
@visitHour time,
@doctorName nvarchar(50),
@diagnosticArrival date,
@diagnosticExit date,
@treatmentName nvarchar(30)
as
begin
insert into Patient(fullname,age,sex,patientemail,mobile,visitdate,admissionhour,visithour,doctorName,diagnosticArrival,diagnosticexit,treatmentName)
values(@patientName,@patientAge,@patientSex,@patientEmail,@phoneNbr,@visitDate,@admissionHour,@visitHour,@doctorName,@diagnosticArrival,@diagnosticExit,@treatmentName)
end

exec insertPatient 'muller',31,'Male','muller@hotmail.com',0000000,'20110610','10:00','13:00','Dr lupo','20210610','20210610','pt';

--delete procedure
create procedure deletePatient
@patientID int
as
begin
delete from Patient where patientId=@patientID
end

exec deletePatient 8;

--update procedure
create procedure updatePatient
@patientid int,
@visithour time
as
begin
update Patient set visithour=@visithour where patientId=@patientid
end

exec updatePatient 1,'4:10';


--2.b
create procedure Proc1
@drName nvarchar(50)
as
begin
select * from Patient where doctorName=@drName
end

exec Proc1 'Dr.Dre';

--2.c
create procedure Proc2
@visitDate date,
@visitHour time
as
begin
select p.patientId,p.fullname,p.doctorName,d.specialization,p.treatmentName from Patient p join Doctor d on p.doctorName=d.name where p.visithour = @visitHour and p.visitdate=@visitDate
end

exec Proc2 '2021-06-10','12:30';


create table trig1Log(
modificationType nvarchar(30),
modificationDate datetime,
username nvarchar(30),
)

--3: Triggers:
--3.a
--creating log table
create table trig1Log(
modificationType nvarchar(30),
modificationDate datetime,
username nvarchar(30),
)
--creating trigger
create trigger Patient_Trigger
on Patient
after UPDATE, INSERT, DELETE
as
declare @modification nvarchar(30),@user varchar(30);
if exists(SELECT * from inserted) and exists (SELECT * from deleted)
begin
    SET @modification = 'UPDATE';
    SET @user = SYSTEM_USER;
    INSERT into trig1Log(modificationType,modificationDate, username) values (@modification,GETDATE(),@user);
end

If exists (Select * from inserted) and not exists(Select * from deleted)
begin
    SET @modification = 'INSERT';
    SET @user = SYSTEM_USER;
    INSERT into trig1Log(modificationType,modificationDate, username) values (@modification,GETDATE(),@user);
end

If exists(select * from deleted) and not exists(Select * from inserted)
begin 
    SET @modification = 'DELETE';
    SET @user = SYSTEM_USER;
    INSERT into trig1Log(modificationType,modificationDate, username) values(@modification,GETDATE(),@user);
end


--3.b
create table trig2Log(
columnName nvarchar(20),
modificationDate datetime,
oldValue nvarchar(50),
newValue nvarchar(50)
)

create TRIGGER update_email_mobile
   ON Patient
   AFTER UPDATE
AS
declare @columnName nvarchar(20),@oldValue nvarchar(50),@newValue nvarchar(50);
BEGIN
    SET NOCOUNT ON;
    IF UPDATE (mobile) 
    BEGIN
		set @columnName='mobile';
		select @oldValue = d.mobile FROM deleted d;
		select @newValue = i.mobile FROM inserted i;
        insert into trig2Log(columnName,modificationDate,oldValue,newValue) values(@columnName,GETDATE(),@oldValue,@newValue)
    END
	IF UPDATE (patientemail) 
    BEGIN
		set @columnName='patientemail';
		select @oldValue = d.patientemail FROM deleted d;
		select @newValue = i.patientemail FROM inserted i;
        insert into trig2Log(columnName,modificationDate,oldValue,newValue) values(@columnName,GETDATE(),@oldValue,@newValue)
    END 
END

update Patient set patientemail='elielie' where patientId=1;


-- ##################################  SQL 7 LAB  ############################### --
--1
create procedure TableContent
@table nvarchar(20)
as
declare @query nvarchar(1000)
begin
set @query = 'select * from '+@table;
exec(@query)
end

exec TableContent 'Doctor';


--2 
create procedure Column_DataType
@table nvarchar(20)
as
declare @query nvarchar(1000)
begin
set @query ='select COLUMN_NAME, DATA_TYPE from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='''+@table+'''';
exec(@query)
end

exec Column_DataType 'Doctor';


--3
create procedure ViewOtherProcedure
@procedure nvarchar(20)
as
declare @query nvarchar(1000);
begin
set @query='sp_helptext '+ @procedure;
exec(@query)
end

exec ViewOtherProcedure 'TableContent';


--4 
create procedure ReturnProcedures
@tableName nvarchar(50)
as
declare @query nvarchar(1000);
begin
set @query='SELECT name FROM sys.procedures WHERE name LIKE ''%'+@tableName+'%''';
exec(@query)
end

exec ReturnProcedures 'Patient';


--5
create procedure displayConstraints
as
begin
SELECT * FROM sys.objects WHERE type_desc LIKE '%CONSTRAINT'
end

exec displayConstraints;
