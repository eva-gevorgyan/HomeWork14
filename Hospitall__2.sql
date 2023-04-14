--create database Hospital__2
--use Hospital__2

create table Doctors(
ProfessionID int primary key(ProfessionID),
Fname nvarchar(50),
Laname nvarchar(50),
Salary int,
DutyDay date
);
create table Profession(
ID int primary key(ID),
foreign key(ID) references Doctors(ProfessionID),
ProfName nvarchar(70)
);

create table Doctors_Salary(
ID int primary key(ID),
foreign key(ID) references Profession(ID),
Salary int
);

create table Users(
UserID int primary key(UserID),
Fname nvarchar(40),
Lname nvarchar(40),
);

create table Users_Diagnoz(
UserID int,
foreign key(UserID) references Users(UserID),
DiagnozID int primary key(DiagnozID),
foreign key(DiagnozID) references Users(UserID),
Diagnoz varchar(100),

);

alter table Users_Diagnoz add DoctorID int,
foreign key(DoctorID) references Doctors(ProfessionID)
select * from Users_Diagnoz
update Users_Diagnoz set DoctorID=5 where DiagnozID=5

create table Anketa(
UserID int,
foreign key(UserID) references Users(UserID),
DiagnozID int,
foreign key(DiagnozID) references Users_Diagnoz(DiagnozID)
--Diagnoz varchar(100),
);
insert into Doctors values
(1,'Erik','Miqaelyan',1,'2023-04-16'),
(2,'Nora','Hakobyan',2,'2023-04-18'),
(3,'Vigen','Karapetyan',3,'2023-04-19'),
(4,'Naira','Kirakosyan',4,'2023-05-01'),
(5,'Hakob','Tovmasyan',5,'2023-05-11'),
(6,'Nora','Nikolyan',4,'2023-04-24');
select * from Doctors


insert into Profession values(1,'Srtaban'),(2,'LOR'),(3,'Psixolog'),(4,'Travmatolog'),(5,'Atamnabuj'),(6,'Mashkaban');
select * from Profession;

insert into Doctors_Salary values(1,250000),(2,230000),(3,290000),(4,180000),(5,214000),(6,150000);
select * from Doctors_Salary;

insert into Users values(1,'Karen','Vardanyan'),
(2,'Andrey','Mkrtchyan'),
(3,'Andriana','Melikyan'),
(4,'Karine','Hakobyan'),
(5,'Siranush','Vardanyan'),
(6,'Yuriy','Ayvazyan'),
(7,'Alex','Beglaryan'),
(8,'Karen','Rubinyan');

select * from Users

insert into Users_Diagnoz values(2,1,'Insult'),
(1,4,'Dzerqi kotrvacq'),
(3,3,'Dipressia'),
(5,2,'Gaymarit'),
(8,5,'Karies');

select * from Users_Diagnoz;

insert into Anketa values(1,3),(2,1),(3,2),(5,4),(8,5),(6,3);
select * from Anketa

create view Doctors_Salaries as
SELECT Doctors.Fname, Doctors.Laname, Profession.ProfName, Doctors_Salary.Salary 
FROM Doctors
INNER JOIN Profession ON Profession.ID = Doctors.ProfessionID
INNER JOIN Doctors_Salary ON Doctors_Salary.ID = Doctors.ProfessionID;

select * from Doctors_Salaries

create view UsersDiagnozes as
select Users.Fname,Users.Lname,Users_Diagnoz.Diagnoz
from Users
left outer join Users_Diagnoz on Users.UserID=Users_Diagnoz.DiagnozID
select * from UsersDiagnozes


select Users.Fname,Users.Lname,Users_Diagnoz.Diagnoz,Doctors.Fname,Doctors.Laname,Profession.ProfName
from Users
left outer join Users_Diagnoz on Users.UserID=Users_Diagnoz.DiagnozID
left outer join Doctors on Users_Diagnoz.DoctorID=Doctors.ProfessionID
left outer join Profession on Profession.ID=Doctors.ProfessionID

create function Count_Doctors()
returns int
as
begin 
declare @count_doc int
select @count_doc=count(*) from Doctors
return @count_doc
end

select dbo.Count_Doctors()


CREATE FUNCTION GetUsersDiagnoz(@UserID int)
RETURNS varchar(50)
AS
BEGIN
    DECLARE @find varchar(50)
    SELECT @find =  Users_Diagnoz.Diagnoz FROM Users_Diagnoz  where Users_Diagnoz.DiagnozID=@UserID
    RETURN @find
END  

select dbo.GetUsersDiagnoz(5)

create proc Total_Salary1
as
select dbo.Count_Doctors()
select sum(salary) from Doctors_Salary 

exec dbo.total_Salary1

create proc FindUserWithDiagnoz(@Diagnoz varchar(50))
as
select Users.fname,users.lname,users_diagnoz.Diagnoz
from users
inner join Users_Diagnoz on Users.UserID=Users_Diagnoz.DiagnozID
where Users_Diagnoz.Diagnoz=@Diagnoz

exec FindUserWithDiagnoz 'Gaymarit'

create proc SentToDoctor(@Diagnoz varchar(50))
as
select Users_Diagnoz.Diagnoz,Doctors.Fname,Doctors.Laname,Profession.ProfName
from Users
inner join Users_Diagnoz on Users.UserID=Users_Diagnoz.DiagnozID
inner join Doctors on Users_Diagnoz.DoctorID=Doctors.ProfessionID
inner join Profession on Profession.ID=Doctors.ProfessionID
where Users_Diagnoz.Diagnoz=@Diagnoz

exec SentToDoctor 'dzerqi kotrvacq'