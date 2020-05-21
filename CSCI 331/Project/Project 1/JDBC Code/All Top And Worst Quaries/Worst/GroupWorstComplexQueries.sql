--WORST COMPLEX QUERIES 

1.Durga
 --listing all employees who helped the orders and their total sales. ​

use Northwinds2019TSQLV5;​
select E.employeeID​
,   [dbo].getFullName(E.EmployeeFirstName,E.EmployeeLastName) as [Full Name]​
,   O.orderid, O.OrderDate​
,   OD.ProductId​
,   OD.UnitPrice
,   OD.Quantity​
,   OD.DiscountPercentage​
,   [dbo].totalDiscountedPrice(OD.UnitPrice,OD.Quantity, OD.DiscountPercentage) as  TotalSalesAfterDiscount​
from [HumanResources].[Employee] as E
  inner join [Sales].[Order] as O​
      on E.EmployeeId = O.EmployeeId​
  inner join [Sales].[OrderDetail] as OD​
     on O.orderid = OD.orderid​
group by E.employeeID,​
  [dbo].getFullName(E.EmployeeFirstName,E.EmployeeLastName),​
  O.orderid, O.OrderDate, OD.ProductId,OD.UnitPrice,OD.Quantity,   OD.DiscountPercentage,​
  [dbo].totalDiscountedPrice(OD.UnitPrice,OD.Quantity, OD.DiscountPercentage) 
order by orderdate desc

2. Abida
--organizing customer's order information​
use [Northwinds2019TSQLV5]​
SELECT C.CustomerId, A.Orderid, A.orderdate, A.RequiredDate​
FROM [Sales].[Customer] AS C​
  CROSS APPLY​
(SELECT TOP (3) Orderid, EmployeeId, OrderDate, RequiredDate​
  FROM [Sales].[Order] AS O​
  WHERE O.CustomerId = C.CustomerId​
  ORDER BY orderdate DESC, orderid DESC) AS A;

3. Jerry
--Using your own database or Northwinds2019TSQLV5 and create a function to calculate the discount price. 
--Label the column: [HighestOrderPrices] and using the text ‘Highest Order Prices’ for each row, Get the [OrderPrice] 
--by deriving product of UnitPrice and Quantity.
--Your function should take inputs to calculate the [DiscountedOrderPrices].

Use Northwinds2019TSQLV5​
drop function if exists dbo.price ​
go ​
create  FUNCTION dbo.price ​
( ​
        @price int ​
       ,@quantity int
       ,@discount int ​
) ​
RETURNS int
AS ​
BEGIN
       DECLARE @result int ​
       SET @result = ((@price * @quantity) - @price * @quantity * @discount)​
       RETURN @Result ​
END ​

select top(10)'Highest Order Prices' as [Highest Order Prices], c.CustomerCompanyName, o.OrderDate, s.ShipperCompanyName, od.UnitPrice, ​
              od.Quantity, od.DiscountPercentage, (od.UnitPrice * od.Quantity) as OrderPrice,
               dbo.price(od.UnitPrice,od.Quantity,od.DiscountPercentage) as DiscountedOrderPrices              
from Sales.[Order] as o ​
inner join Sales.OrderDetail as od ​
on o.OrderId = od.OrderId 
inner join  Sales.Customer as c ​
on o.CustomerId = c.CustomerId 
inner join Sales.Shipper as s 
on o.ShipperId = s.ShipperId 
where o.OrderDate > N'2014-7-01' and o.OrderDate < N'2014-7-31' ​
order by od.UnitPrice desc ​

4. Naiem
--Proposition - List out all the customers that placed order with their full address

CREATE FUNCTION daysToWeeks (@numDays INT)​
RETURNS FLOAT(2)​
AS​
BEGIN​
DECLARE @numWeeks FLOAT
SET @numWeeks = @numDays / cast(5 AS FLOAT)​
RETURN @numWeeks​
END​
GO​

USE AdventureWorks2014​
SELECT e.JobTitle​
,e.OrganizationLevel​
,[dbo].[daysToWeeks](avg(e.VacationHours)) AS avgVacation​
,[dbo].[daysToWeeks](avg(e.SickLeaveHours)) AS avgSickDays​
FROM HumanResources.Employee AS e​
LEFT JOIN HumanResources.vEmployeeDepartmentHistory AS h ON e.BusinessEntityID = h.BusinessEntityID​
LEFT JOIN HumanResources.vEmployeeDepartment AS d ON e.JobTitle = d.JobTitle​
WHERE e.OrganizationLevel IS NOT NULL​
GROUP BY e.OrganizationLevel​,e.JobTitle​

5.Praloy
-- List out all the customers that placed order with their full address​
 use Northwinds2019TSQLV5;​
go
create function getLocation(​
         @city varchar(100),​
         @region varchar(100),
         @Country varchar(100))
returns nvarchar(250)​
as ​
begin​
declare @result nvarchar(250)​
set @result = concat( @city,', ',@region,', ',@country)​
return @result​
end;​
use Northwinds2019TSQLV5;
go ​
select   O.OrderId, O.OrderDate, C.CustomerCompanyName,​
       [dbo].[getLocation](E.EmployeeAddress,E.EmployeeCity,E.EmployeeRegion,E.EmployeePostalCode,E.EmployeeCountry)​
       as [Employee Address]    
from [HumanResources].[Employee] as E
    inner join [sales].[order] as O​
        on E.EmployeeId = O.EmployeeId​
    inner join  [sales].[Customer] as C​
        on O.CustomerId = C.CustomerId​
Group by e.EmployeeFirstName, e.EmployeeLastName,​
       [dbo].getLocation(E.EmployeeAddress,E.EmployeeCity,E.EmployeeRegion,E.EmployeePostalCode,E.EmployeeCountry),​
       O.OrderId, O.OrderDate, C.CustomerCompanyName,​
       [dbo].getLocation(C.CustomerAddress,C.CustomerCity,C.CustomerRegion, C.CustomerPostalCode,C.CustomerCountry)​
order by o.OrderId​

6. Seth
--Proposition - What is the sales order id, the total freight,
--the percent discount, and the quantity of each order with the User Authentication Id
create function dbo.getFirstAndLastChar​
( ​
    @string as nvarchar​
)​
Returns nvarchar​
As​
begin
    declare @result nvarchar(2)​
    return @string;​
end;​
go​
select o.OrderId as ID, SUM(o.freight) as [Total Freight]​
    , concat(od.DiscountPercentage * 100, '%') as [Percent Discount]​
    , od.Quantity​
    , dbo.getFirstAndLastChar(o.UserAuthenticationId) as UAI​
from Sales.OrderDetail as od​
        inner join sales.[Order] as O​
            on od.OrderId = O.OrderId​
        inner join sales.Shipper as S​
            on o.ShipperId = S.ShipperId​
group by o.OrderId, od.DiscountPercentage, od.Quantity​
    , dbo.getFirstAndLastChar(o.UserAuthenticationId)​
having od.DiscountPercentage> 0​

7. Timmy
--Proposition - Returns product category, the Suppliers position + name,
--supplier country, determines continent from country. ​ 
GO                                              ​
        create function getContinent​
            (@SupplierCountry as NVARCHAR(15) )  ​
        RETURNS NVARCHAR(15) ​
            AS                                 ​
                BEGIN    
            RETURN  case when @SupplierCountry in ​
            ('Italy','UK','Sweden','Germany',     ​
            'Denmark','Netherlands','Norway','Finland','Spain','France')​
                then 'Europe'                                                ​
            when @SupplierCountry in ('USA','Canada','Brazil')           ​
                then 'America'                                                ​
            when @SupplierCountry in ('Australia')                        ​
                then 'Australia' else 'Asia-Pacific'                        ​
            END                                                           
        END;                                                          ​
        GO​

 ​    Use Northwinds2019TSQLV5​
        SELECT c.CategoryName as "Category", concat(s.SupplierContactTitle, ' ', s.SupplierContactName)​
        AS "Supplier Position, Supplier Name" , s.SupplierCountry,​
        dbo.getContinent(s.SupplierCountry) as "Supplier Continent"    ​
        FROM Production.Supplier AS s                                ​
        INNER JOIN [Sales].[Customer] AS SC                                ​
            ON SC.CustomerId = s.SupplierId                                ​
        INNER JOIN Production.Product AS p                             ​
            ON p.SupplierID=s.SupplierID                                ​
        INNER JOIN Production.Category AS c                                ​
            ON c.CategoryID=p.CategoryID                                 ​
        group by c.CategoryName, s.SupplierCountry, s.SupplierContactTitle,​
        s.SupplierContactName, dbo.getContinent(s.SupplierCountry)​





