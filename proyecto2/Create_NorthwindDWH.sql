Use NorthwindDWH;
GO

create table dimCustomer(
CustomerID nchar(5),
CompanyName nvarchar(40),
ContactName nvarchar(30),
Country nvarchar(15),
Region varchar(15),
primary key(CustomerID)
);

create table dimDate(
DateID datetime,
[DateName] nvarchar(50),
DayNumber int,
MonthNumber int,
[Year] int,
[DayName] nvarchar(50),
[MonthName] nvarchar(50),
WeekEndIndicator int,
primary key(DateID)
);

create table dimProduct(
ProductID int, 
ProductName nvarchar(40),
Category nvarchar(15),
Supplier nvarchar(40),
primary key(ProductID)
);

create table dimEmployee(
EmployeeID int,
LastName nvarchar(20) , 
FirstName nvarchar(10),
BirthDate datetime,
HireDate datetime, 
[Address] nvarchar(60), 
Country nvarchar(15),
primary key(EmployeeID)
);

create table factSales(
ID int identity(1,1),
EmployeeID int,
CustomerID nchar(5),
ProductID int,
OrderDate datetime,
OrderNumber int,
Quantity int,
unitPrice money,
total money,
total_discount money,
primary key(ID),
foreign key (ProductID)     references dimProduct(ProductID),
foreign key (EmployeeID)     references dimEmployee(EmployeeID),
foreign key (CustomerID)     references dimCustomer(CustomerID),
foreign key (OrderDate)  references dimDate(DateID)
);

create table dimShipper(
ShipperID int,
ShipperName nvarchar(40)
primary key(ShipperID)
);

create table factDelivery(
ID int identity(1,1),
EmployeeID int,
CustomerID nchar(5),
ShipperID int,
OrderDate datetime,
RequiredDate datetime,
ShippedDate datetime,
ShipCountry nvarchar(15),
late int,
OnTime int,
OrderNumber int,
Freight money,
TotalAmount money,
primary key(ID),
foreign key (EmployeeID)     references dimEmployee(EmployeeID),
foreign key (CustomerID)     references dimCustomer(CustomerID),
foreign key (OrderDate)  references dimDate(DateID),
foreign key (ShipperID) references dimShipper(ShipperID)
);