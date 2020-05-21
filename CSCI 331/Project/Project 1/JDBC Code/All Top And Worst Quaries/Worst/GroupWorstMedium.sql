
-----------------------------------------------------------------------------Worst Simple-------------------------------------------

--Timmy
-- Simple Query 5: that returns players who are alive
	
	Use Northwinds2019TSQLV5 		
		SELECT nameGiven, DateOfBirth, DateOfDeath	
		FROM Example.ProfessionalBaseballPlayer AS BP								
		WHERE DateOfDeath = '' AND DateOfBirth != ''
	for json path, root('Still Alive')


--Seth
--Proposition: Return which customers has an order on August 30, 2014 and
what is the company name
declare @TheDay date = '20140830'

Select Distinct C.custid, C.companyName,

CASE WHEN O.orderid is not null then 'Yes' Else 'No' End
as [Has Order on 20170830]

From Sales.Customers as C

Left outer join Sales.Orders as O

ON O.custid = c.custid

AND O.orderdate = @TheDay

where o.orderdate = @TheDay

--praloy
--Proposition: Listing country who placed max flight in desecending
Use TSQLV4

select shipcountry,

max(freight) as maxfreight

From

[Sales].[Orders]

Group by

shipcountry

Order by

maxfreight desc;

--Naiem
--Proposition - listing all employees with their position and phone number​
use Northwinds2019TSQLV5​

select EmployeeID​

,   EmployeeTitle​

,   EmployeePhoneNumber​

from [HumanResources].[Employee]​


--Jerry
--Simple 1/5
/*
Proposition - Using Northwinds2019TSQLV5 database and create a query to find all of the customers that made no purchases
*/
USE Northwinds2019TSQLV5
select c.CustomerId, c.CustomerCompanyName
from [Sales].[Customer] as c
where not exists
(
select o.CustomerId

from Sales.[Order] as o
where o.CustomerId = c.CustomerId

)
​
--Durga
--Proposition - listing all employees with their position and phone number​
use Northwinds2019TSQLV5​

select EmployeeID​

,   EmployeeTitle​

,   EmployeePhoneNumber​

from [HumanResources].[Employee]​

​
--Abida
--Proposition -   displays all the customer's information such as the  CustomerId, OrderDate, and RequiredDate; 
use [Northwinds2019TSQLV5]​

SELECT C.CustomerId, A.Orderid, A.orderdate, A.RequiredDate​

FROM [Sales].[Customer] AS C​

  CROSS APPLY​

(SELECT TOP (3) Orderid, EmployeeId, OrderDate, RequiredDate​

  FROM [Sales].[Order] AS O​

  WHERE O.CustomerId = C.CustomerId​

  ORDER BY orderdate DESC, orderid DESC) AS A;​


