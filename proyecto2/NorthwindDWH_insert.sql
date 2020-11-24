Use NorthwindDWH;
GO

delete from factSales;
delete from factDelivery;
delete from dimCustomer;
delete from dimDate;
delete from dimEmployee;
delete from dimProduct;
delete from dimShipper;


insert into dimDate
select pk_date, 
date_name,
DAY(pk_date), 
MONTH(pk_date), 
YEAR (pk_date), null, null,0
from [Time]

UPDATE dimDate set [DayName] = LEFT([DateName], CHARINDEX(',', [DateName])-1);
UPDATE dimDate set  [MonthName]=SUBSTRING ([DateName],CHARINDEX(',', [DateName])+2,3);
UPDATE dimDate set WeekEndIndicator = 1 where [DayName] in ('Saturday', 'Sunday');

insert into dimCustomer
select customerId, CompanyName,ContactName, Country, Region
from Northwind.dbo.Customers

insert into dimProduct
select ProductID, ProductName, CategoryName, CompanyName
from Northwind.dbo.Products p, Northwind.dbo.Categories c, Northwind.dbo.Suppliers s
where p.CategoryID = c.categoryID AND p.SupplierID = s.SupplierID

insert into dimEmployee
select EmployeeID, LastName, FirstName, BirthDate, HireDate, [Address], Country
from Northwind.dbo.Employees


insert into factSales (EmployeeID, CustomerID, ProductID, OrderDate, OrderNumber, Quantity, unitPrice, total, total_discount)
select o.EmployeeID, o.CustomerID, d.ProductID, o.OrderDate, d.OrderID, d.Quantity, d.unitPrice, (d.Quantity * d.unitPrice), (d.Quantity * d.Discount)
from Northwind.dbo.Orders o, Northwind.dbo.[Order Details] d
where d.OrderID = o.OrderID


insert into dimShipper (ShipperID, ShipperName)
select ShipperID, CompanyName
from Northwind.dbo.Shippers



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE TRIGGER InsertData
   ON  dimCustomer
   INSTEAD OF INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	INSERT INTO dimCustomer
	SELECT CustomerID, CompanyName, ContactName, Country, null
	FROM inserted;

	UPDATE dimCustomer
	SET region = 'Europe';

	UPDATE dimCustomer
	SET region = 'America'
	WHERE Country = 'Argentina' OR Country = 'Brazil' OR Country = 'Mexico' OR Country = 'USA' OR Country = 'Venezuela' OR Country = 'Canada';
END
GO