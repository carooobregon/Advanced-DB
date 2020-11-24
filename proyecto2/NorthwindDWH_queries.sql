
-- Q1 �Cual es el producto m�s vendido en 1996?
SELECT p.ProductName, sum(s.Quantity) as Quantity
FROM factSales s JOIN dimProduct p ON s.ProductID = p.ProductID
WHERE year(s.OrderDate) = 1996
GROUP BY s.ProductID, p.ProductName
having sum(Quantity) = (
    SELECT max(st.total)
    FROM (
        SELECT sum(Quantity) as total
        FROM factSales s JOIN dimProduct p ON s.ProductID = p.ProductID
        WHERE year(s.OrderDate) = 1996
        GROUP BY s.ProductID
    ) st
)

-- Q2 �Cual es el total de ventas(dinero) en 1996?
SELECT sum(total) as Total_Dinero_1996
FROM factSales  
WHERE year(OrderDate) = 1996

-- Q3 �Cual es el totall de ventas en 1997? 
SELECT COUNT(DISTINCT OrderNumber) as Total_Ventas_1997
FROM factSales 
WHERE year(OrderDate) = 1997

-- Q4 �Cual es el total de ventas en todos los a�os incluidos en la BD?
SELECT COUNT(DISTINCT OrderNumber) as Total_Ventas_Por_Mes
FROM factSales

-- Q5 �Cual es la Region que m�s ventas tuvo (dinero) en 1997?
SELECT c.Region
FROM factSales s JOIN dimCustomer c ON s.CustomerID = c.CustomerID
WHERE year(s.OrderDate) = 1997
GROUP BY c.Region
having sum(s.Quantity*s.unitPrice) = (
    SELECT max(total)
    FROM (
        SELECT sum(s.Quantity*s.unitPrice) total
        FROM factSales s JOIN dimCustomer c ON s.CustomerID = c.CustomerID
        WHERE year(s.OrderDate) = 1997
        GROUP BY c.Region
    )TR)


-- Q6 �Para la region de Q5 cual es la ciudad (si region es usa) o pais (si region es diferente de USA) que mas vendio en 1997?
    
SELECT c.Country
FROM factSales s JOIN dimCustomer c ON s.CustomerID = c.CustomerID
WHERE year(s.OrderDate) = 1997
GROUP BY c.Country
HAVING sum(s.Quantity*s.unitPrice) = (
    SELECT max(total)
    FROM (
    SELECT sum(s.Quantity*s.unitPrice) total, c.Country
    FROM factSales s JOIN dimCustomer c ON s.CustomerID = c.CustomerID
    WHERE year(s.OrderDate) = 1997 AND C.Region = ('Europe')
    GROUP BY c.Country
    )TR
)

-- Q7 �Cual es el total de ventas en total (todos los a�os) organizados por Region, Estado y/o Pa�s?
SELECT count(ID) as Total_Ventas, c.Region, c.Country 
FROM factSales f JOIN dimCustomer c ON f.CustomerID = c.CustomerID 
GROUP BY c.Country, c.Region
