-- Q1 ¿Cual es el producto más vendido en 1996?
select ProductID, Sum(Quantity) from [Order Details] 
join Orders on [Order Details].OrderID = Orders.OrderID 
where YEAR(OrderDate) = 1996
group by ProductID
having sum(quantity) = (select max(totalQuantity) 
from (select sum(quantity) TotalQuantity 
from [Order Details] OD 
join Orders o on OD.OrderID = o.OrderID 
where YEAR(OrderDate) = 1996 
group by ProductID) T)

-- Q2 ¿Cual es el total de ventas(dinero) en 1996?
SELECT SUM(OD.Quantity*OD.UnitPrice) as Quantity FROM Orders O
JOIN [Order Details] OD ON O.OrderID = OD.OrderID
WHERE YEAR(O.OrderDate) = 1996;

-- Q3 ¿Cual es el total de ventas en 1997? 
SELECT COUNT( DISTINCT OD.OrderID) as Ventas_1997 FROM Orders O
JOIN [Order Details] OD ON O.OrderID = OD.OrderID
WHERE YEAR(O.OrderDate) = 1997;


-- Q4 ¿Cual es el total de ventas en todos los años incluidos en la BD?
SELECT SUM(OD.Quantity*OD.UnitPrice) as Quantity FROM Orders O
JOIN [Order Details] OD ON O.OrderID = OD.OrderID


-- Q5 ¿Cual es la Region que más ventas tuvo (dinero) en 1997?

SELECT SUM(OD.Quantity*OD.UnitPrice) as Sales, E.Region 
FROM Orders O
JOIN [Order Details] OD ON O.OrderID = OD.OrderID
JOIN Employees E ON O.EmployeeID = E.EmployeeID
WHERE YEAR(O.OrderDate) = 1997
GROUP BY E.Region
having sum(OD.Quantity*OD.UnitPrice) = (select max(totalQuantity) 
from (select SUM(OD.Quantity*OD.UnitPrice) TotalQuantity 
FROM Orders O
JOIN [Order Details] OD ON O.OrderID = OD.OrderID
JOIN Employees E ON O.EmployeeID = E.EmployeeID
WHERE YEAR(O.OrderDate) = 1997
GROUP BY E.Region) TQ)


-- Q6 ¿Para la region de Q5 cual es la ciudad (si region es usa) o pais (si region es diferente de USA) que mas vendio en 1997?
SELECT SUM(OD.Quantity*OD.UnitPrice) as Sales, C.City FROM Orders O
JOIN [Order Details] OD ON O.OrderID = OD.OrderID
JOIN Customers C ON O.CustomerID = C.CustomerID
WHERE YEAR(O.OrderDate) = 1997 AND C.Region = 'WA'
GROUP BY C.City
having SUM(OD.Quantity*OD.UnitPrice) = (select max(totalQuantity) 
from (
select sum(OD.Quantity*OD.UnitPrice) TotalQuantity, C.City
FROM Orders O
JOIN [Order Details] OD ON O.OrderID = OD.OrderID
JOIN Customers C ON O.CustomerID = C.CustomerID
WHERE YEAR(O.OrderDate) = 1997 AND C.Region = 'WA'
group by C.City) T)




-- Q7 ¿Cual es el total de ventas en total (todos los años) organizados por Region, Estado y/o País?
SELECT SUM(OD.Quantity * OD.UnitPrice) as Quantity, C.Region, C.Country FROM Orders O
JOIN [Order Details] OD ON O.OrderID = OD.OrderID
JOIN Customers C ON O.CustomerID = C.CustomerID
GROUP BY C.Region, C.Country
ORDER BY C.Region





