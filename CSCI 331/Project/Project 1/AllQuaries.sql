------------------------------------------------------------------------------------------------------------------------------------
-- NAME: Praloy Saha
-- CLASS: CS331, Tu.Thr. 7:45 - 9 AM
-- PROJECT 1 Queries (5 simple, 8 Medium, 7 Complex)
------------------------------------------------------------------------------------------------------------------------------------



-----------------------------------------------------------------------------------------------------------
----------------------------------------------Simple Query-------------------------------------------------
-----------------------------------------------------------------------------------------------------------
--1
--Write a query in TSQL to return list of Marketing manager who have a region.
-- Tables involved: TSQLV4 database, Customers
use TSQLV4
select custid, contactname, contacttitle, region, country
from [Sales].[Customers]
where contacttitle = 'marketing manager' and region is not null and country = N'USA'
for json path, root('RegionList'), include_null_values; 

--2
--Returning the three ship countries with the hightest freight which placed on the last day of the month
-- Tables involved: TSQL database, sales.orders
use TSQLV4
select top(3) shipcountry, max(freight) as maxfreight
from [Sales].[Orders]
where  orderdate = EOMONTH(orderdate)
group by shipcountry
order by maxfreight desc
for json path, root('Top 3 countries with highest flight'), include_null_values; 

--3
--Return customers with orders placed on 2015 along with their orders id
-- Tables involved: TSQLV4 database, sales.customers
use TSQLV4
go
SELECT Customers.custid, Customers.companyname, orders.orderid, Orders.orderdate
FROM Sales.Customers AS Customers
  INNER JOIN Sales.Orders AS orders
    ON orders.custid = Customers.custid
WHERE orders.orderdate >= '20150101' and orders.orderdate < '20160101'
for json path, root('CustomerList')

--4
--Write a query that returns all customers in the output, but matches
-- them with their respective orders only if they were placed between February 12, 2016 and March 12, 2016
-- Tables involved: Northwinds2019TSQLV5 database, customers, order
use Northwinds2019TSQLV5
SELECT C.CustomerId, C.CustomerCompanyName, O.orderid, O.orderdate
FROM [Sales].[Customer] AS C
  LEFT OUTER JOIN [Sales].[Order] AS O
    ON O.CustomerId = C.CustomerId
    AND O.orderdate between '20160212' and '20160312'
	for json path, root('CustomersList'), include_null_values; 
--5
--joins	the Customers and	Orders	tables,	based	on	a	
--match	between	the	customer’s	customer ID and	the order’s	customer ID
-- Tables involved: TSQLV4 database, orders, customers
use TSQLV4
SELECT	C.custid,	C.companyname,	O.orderid 
FROM	Sales.Customers	AS	C		    
  LEFT	OUTER	JOIN	Sales.Orders	AS	O				
  ON	C.custid	=	O.custid
for json path, root('match between  customers and orderers'), include_null_values; 

--6
--What are the player id and career home runs for the ten most career 
--home runs.
--Table used Example.BaseballPlayerBattingStatistics
use Northwinds2019TSQLV5
select TOP 10 SUM(BPS.HomeRun) as [Home Runs], BPS.playerID
from Example.BaseballPlayerBattingStatistics as BPS
Group by BPS.playerID
Order by [Home Runs] desc
--for json path, root('Easy Query 01')

--7
use Northwinds2019TSQLV5
--Which customers orders were delivered after the deadline. 
--What was the deadline and when was it delivered
select O.OrderId As [Order Id],
	   O.CustomerId As [Customer ID],
	   O.ShipToDate As DayOfOrder, 
	   O.RequiredDate As Deadline
from Sales.[Order] As O
where O.ShipToDate > O.RequiredDate
--for json path, root('Easy Query 02'

--8
use Northwinds2019TSQLV5
--What are the total number of deliveries per country, in descending order
select O.shipToCountry as country, SUM(OD.Quantity) as [Total Deliveries]
from Sales.[Order] as O
	left outer join Sales.OrderDetail as OD
		ON OD.OrderId = O.OrderId
Group by O.shipToCountry
Order by [Total Deliveries] desc, country
--for json path, root('Easy Query 03')

--9
use Northwinds2019TSQLV5
--what is the name given, player id, and career home runs ordered by career homeruns.
--tables used: Example.BaseballPlayerBattingStatistics, Example.ProfessionalBaseballPlayer
select top (1000) 
	BP.nameGiven as [Name Given], 
	BPBS.playerID as [Player ID], 
	SUM(BPBS.HomeRun) as [Home Run]

from Example.BaseballPlayerBattingStatistics as BPBS
inner join Example.ProfessionalBaseballPlayer as BP
	on BP.playerID = BPBS.playerID
			
group by BPBS.playerID, BP.nameGiven
order by [Home Run] desc, [Name Given]
--for json path, root('Easy Query 04')

--10
use TSQLV4
--What is the customer id, company name, and whether or not an order was placed on 
--August 30 2017
Select Distinct C.custid, C.companyName,
	CASE WHEN O.orderid is not null then 'Yes' Else 'No' End as [Has Order on 20170830]
From Sales.Customers as C
	Left outer join Sales.Orders as O 
		ON O.custid = c.custid
		AND O.orderdate = '20170830'
--for json path, root('Easy Query 05')

-- 11
-- Pairs of employees who have the same job title.
use AdventureWorks2014
select CONCAT(A.FirstName,' ',A.LastName, ' (', A.BusinessEntityID, ')') as Member1, CONCAT(B.FirstName,' ',B.LastName, ' (', B.BusinessEntityID, ')') as Member2, A.JobTitle
from HumanResources.vEmployee as A
cross join
HumanResources.vEmployee as B
where (A.BusinessEntityID != B.BusinessEntityID) AND (A.JobTitle = B.JobTitle)
order by JobTitle

-- 12
-- Transaction count for each product.
use AdventureWorks2014
select p.ProductID, p.Name, count(th.ProductID) as transactionCount
from Production.Product as p
    left outer JOIN
    production.TransactionHistory as th
    on p.ProductID = th.ProductID
GROUP by p.ProductID, p.Name

-- 13
-- The retirement (65+) year & status of all employees
use AdventureWorks2014
select e.NationalIDNumber, e.BirthDate, datediff(year, e.BirthDate, SYSDATETIME()) as age,
    year(DATEADD(year, 65-datediff(year, e.BirthDate, SYSDATETIME()), SYSDATETIME())) as retirementYear,
    case 
when datediff(year, e.BirthDate, SYSDATETIME()) >= 65 then 'Eligible'
else 'Not Eligible'
end as retirementStatus
from HumanResources.Employee as e
order by retirementYear;

-- 14
-- Each country's sales count
use Northwinds2019TSQLV5
select distinct ShipToCountry, count(ShipToCountry) as count
from sales.[Order]
group by ShipToCountry
order by count DESC;

-- 15
-- The average grade & each student's class standing
use Northwinds2019TSQLV5
declare @classAvg DECIMAL(5,2);
set @classAvg = (select sum(TestScore)/cast(count(TestScore) as decimal)
from stats.Score);
select studentid, avg(TestScore) as avgScore,
    case 
when avg(TestScore) > @classAvg then 'Better Than Average'
else 'Worse Than Average'
end as Standing
from stats.Score
group by studentid
order by studentid;

/* 
--16
Find all of the customers that made no purchases 
Tables: Sales.Customer ,  Sales.Order
*/
USE Northwinds2019TSQLV5
select c.CustomerId, c.CustomerCompanyName
from [Sales].[Customer] as c
where  not exists
      (
          select o.CustomerId
		  from Sales.[Order] as o
		  where o.CustomerId = c.CustomerId
      )
--For json path,root('Customer No Order');

/*
--17
Use Northwinds2019TSQLV5. Make a query that returns orders with total value(qty*unitprice) greater than 5000 but less than 15000 
sorted by total value
Tables involved: Sales.OrderDetails table

*/
Use Northwinds2019TSQLV5;
SELECT orderid, SUM(Quantity*unitprice) AS totalvalue
FROM [Sales].[OrderDetail]
GROUP BY orderid
HAVING SUM(Quantity*unitprice) > 5000 AND SUM(Quantity*unitprice) < 15000
ORDER BY totalvalue DESC
--For json path,root('Total Value')

/* 
--18
Use Northwinds2019TSQLV5. Make a query that return the three ship countries with the highest average freight for orders placed in 2014- 2015
Tables involved: Sales.Orders table
*/
Use Northwinds2019TSQLV5
SELECT TOP (3) ShipToCountry as shipcountry, Orderdate, AVG(freight) AS avgfreight
FROM [Sales].[Order]
WHERE orderdate >= '20140101' AND orderdate < '20160101'
GROUP BY ShipToCountry,orderdate
ORDER BY avgfreight DESC
--For json path,root('Top 3 Average Freight')

/* 
--19
USE NORTHWINDS2019TSQLV5 database 
Using the concat function, create the location alias (rename) from CustomerCountry,CustomerRegion and CustomerCity.  
Make sure that there is a comma space seperation such as Canada, BC, Tsawassen and replace null values with (No Region)
Tables: Sales.Customer
*/
USE NORTHWINDS2019TSQLV5
SELECT CustomerCompanyName,CustomerContactName,CustomerCity,CustomerRegion,CustomerCountry, 
concat(CustomerCountry,',', CASE WHEN Customerregion IS NULL THEN 'NULL,'
ELSE concat(CustomerRegion,',')End,CustomerCity)AS LOCATION
FROM Sales.Customer
--For json path,root('Locate')

/*
--20
USE TSQLV4
Return customers and their orders including customers who placed no orders
Tables:  TSQLV4 database, Customers and Orders tables
*/
USE TSQLV4
SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Sales.Customers AS C
LEFT OUTER JOIN Sales.Orders AS O
ON O.custid = C.custid
--For json path,root('No orders')


--21
--Returns top 100 businessentityId, PWHash, PhoneNumber

	Use AdventureWorks2014;

	SELECT TOP (100)
	P.BusinessEntityID,
	PasswordHash,
	PhoneNumber
	FROM Person.Person as P
	INNER JOIN Person.Password AS PA
		ON PA.BusinessEntityID = P.BusinessEntityID
	INNER JOIN Person.PersonPhone AS PP
		ON PP.BusinessEntityID = PA.BusinessEntityID
	GROUP BY P.BusinessEntityID, PasswordHash, PhoneNumber
	for json path, root('Password')

--22 
--Returns top 100 baseball players and determine their batting averages for seasons where hits 
--and # of times at bat are > 0
	Use Northwinds2019TSQLV5

	SELECT top (100)  nameGiven AS Name, hits, NumberAtBat, (1.0 * hits) / NumberAtBat AS BattingAverage, seasonYear
	FROM Example.BaseballPlayerBattingStatistics as s
	INNER JOIN Example.ProfessionalBaseballPlayer as p
		ON p.playerID = s.playerID
	WHERE hits > 0 AND NumberAtBat > 0
	GROUP BY nameGiven, hits, NumberAtBat,  SeasonYear
	for json path, root('Batting Average')

--23 
--that returns players who have gone to third base more times than second base.
	Use Northwinds2019TSQLV5

	Select top (100)
	BP.nameGiven AS PlayerName,  BPBS.ThridBase AS ThirdBase, BPBS.SecondBase AS SecondBase
	FROM Example.ProfessionalBaseballPlayer as BP
	INNER JOIN Example.BaseballPlayerBattingStatistics as  BPBS
		ON  BPBS.playerID = BP.playerID
	WHERE ThridBase > SecondBase
	for json path, root('Third Base')

--24
--Simple Query 4: that returns player who are perfect at getting home runs
	Use Northwinds2019TSQLV5

	SELECT nameGiven AS PlayerName, NumberAtBat, Hits, HomeRun
	FROM Example.ProfessionalBaseballPlayer AS BP
	INNER JOIN Example.BaseballPlayerBattingStatistics AS BPBS
	ON BPBS.playerID = BP.playerid
	WHERE HomeRun = Hits AND Hits = NumberAtBat AND Hits > 0
	for json path, root('Perfect at Bat')

--25
--Simple Query 5: that returns players who are alive
	
	Use Northwinds2019TSQLV5 		
		SELECT nameGiven, DateOfBirth, DateOfDeath	
		FROM Example.ProfessionalBaseballPlayer AS BP								
		WHERE DateOfDeath = '' AND DateOfBirth != ''
	for json path, root('Still Alive')


--26
--listing all employees with their position and phone number 
use Northwinds2019TSQLV5
select EmployeeID,EmployeePhoneNumber
from [HumanResources].[Employee]
for json path,root('EmployeeContactNumber');

--27
--listing all employees with their orderID numbers

select distinct e.EmployeeId, e.EmployeeFirstName, e.EmployeeLastName, o.OrderId
from [HumanResources].[Employee] as e  
	inner join [sales].[order] as o
		on e.EmployeeId = o.EmployeeId
for json path,root('EmployeeOrder'); 

--28
-- listing 10 recent orders 

select top 10 orderid, orderdate 
from [sales].[order]
order by orderid desc
for json path,root('RecentTenOrders');


--29
-- filtering all customers from USA with their phone number
-- table: [sales].[customer]

select CustomerId, CustomerCompanyName, CustomerContactName, CustomerContactTitle,CustomerCountry,CustomerPhoneNumber
from [Sales].[Customer]
where customerCountry = N'USA'
for json path,root('Customer_USA');

--30
-- listing all orders made on February 3 of 2015
-- table : [sales].[order]

select orderid,customerid, employeeid, orderdate 
from [sales].[order]
where orderdate = '20150203'
order by orderdate desc
for json path,root('orderMadeInFeb032015');

--31
-- Listing all female employees with their job title and names
Use Adventureworks2014;
 SELECT P.FirstName, P.lastName, HR.jobTitle, HR.Gender
 FROM  Person.Person AS P
 INNER JOIN
 [HumanResources].[Employee] AS HR ON P.BusinessEntityID = HR.BusinessEntityID
 where HR.Gender LIKE N'F'
 --for json path,root('Employee')


--32
-- Listing all the employees id, company name, and quantity

use [Northwinds2019TSQLV5]
SELECT C.CustomerId, C.CustomerCompanyName, O.OrderId, OD.productid, OD.Quantity
FROM Sales.Customer AS C  
INNER JOIN [Sales].[Order] AS O
ON C.CustomerId = O.CustomerId
INNER JOIN Sales.OrderDetail AS OD
ON O.orderid = OD.orderid;
 --for json path,root('CustomerSalesTable')

--33
 -- listing  phone number .and employee names
-- tables: [person].[person], [person].[personPhone] and [person].[phoneNumberType]
use AdventureWorks2014
SELECT  Person.FirstName,
    	Person.LastName,
    	PersonPhone.PhoneNumber
 FROM   Person.Person
    	INNER JOIN
    	Person.PersonPhone
    	ON Person.BusinessEntityID =  PersonPhone.BusinessEntityID
   --for json path,root('EmployeeNamesAndPhoneNumber')

--34
-- Listing productName, unitprice and CategoryNames
use Northwinds2019TSQLV5;
SELECT  ProductName,
	unitprice,
	CategoryName
FROM
	Production.Product P
 JOIN Production.Category C
 ON C.Categoryid = P.CategoryId
ORDER BY
	ProductName DESC;
 --for json path,root('ProductionProductTable')

--35
-- Listing ProductID, Name and ProductNumber;
use Adventureworks2014;
SELECT   P1.ProductID,
     	P1.Name,
     	P1.ProductNumber
FROM 	Production.Product AS P1
 --for json path,root('ProductionProductTable2')

--36
-- listing all department name and its group
 select Name as DepartmentName, GroupName
 from [HumanResources].[Department]
 --for json path,root('DepartmentTable')




 -----------------------------------------------------------------------------------------------------------
----------------------------------------------Medium Query-------------------------------------------------
-----------------------------------------------------------------------------------------------------------

  --1
  --return customers who placed orders
  -- Tables involved: Northwinds2019TSQLV5 database, customers, order
use Northwinds2019TSQLV5
go
SELECT Top(100) C.CustomerId, c.CustomerCompanyName, o.OrderId, CONVERT(VARCHAR(10), CAST(o.OrderDate AS DATE), 101) as ModifiedDate,
CONCAT(c.CustomerAddress, c.CustomerCity, c.CustomerPostalCode) as address
FROM [Sales].[Customer] AS C
  INNER JOIN [Sales].[Order] AS O
    ON C.CustomerId= O.CustomerId
WHERE o.orderdate >= '20150101' and o.orderdate < '20160101'
Order By C.CustomerCompanyName, o.OrderDate asc
for json path, root('OrderList'), include_null_values; 

--2
-- Write a query joining three tables, making sure it contains top 100
--rows from SalesOrderHeader
-- Tables involved: Advanture database, SalesOrderHeader,CurrencyRate and ShipMethod
use AdventureWorks2014
SELECT top (100) C.CurrencyRateID, C.AverageRate, S.ShipBase, SalesOrderID
FROM Sales.SalesOrderHeader AS OH
LEFT OUTER JOIN Sales.CurrencyRate AS C
 ON OH.CurrencyRateID = C.CurrencyRateID
LEFT OUTER JOIN Purchasing.ShipMethod AS S
 ON OH.ShipMethodID = S.ShipMethodID 
 where C.AverageRate is not null
 order by c.CurrencyRateID, SalesOrderID desc
 for json path, root('top 100 rows'), include_null_values; 

 --3
 --Return all the different product name and the customer for all Customers who ordered ProductModel 'Racing Socks, M'
-- Tables involved: Advanture database, productModel, product, salesOrderDetails, SalesOrderHeader
use AdventureWorks2014
SELECT Distinct P.name, C.CustomerID
FROM
  [Production].[ProductModel] as PM
  JOIN
   [Production].[Product] as P
    ON PM.ProductModelID = P.ProductModelID
  JOIN
    [Sales].[SalesOrderDetail] as OD
    ON OD.ProductID = P.ProductID
  JOIN
    [Sales].[SalesOrderHeader] as OH
    ON OD.SalesOrderID = OH.SalesOrderID
  JOIN
    [Sales].[Customer] as C
    ON OH.CustomerID = C.CustomerID
WHERE
 P.Name = 'Racing Socks, M' and c.CustomerID % 2 = 0
order by C.CustomerID, P.name
for json path, root('product and customers list'), include_null_values; 


--4
-- write a query where all the customers who atleast had one order
-- Tables involved: TSQLV4 database, customer, order
use Northwinds2019TSQLV5
Select C.CustomerCompanyName, count(O.orderId) as OrderCount
FROM [Sales].[Customer] as C
INNER JOIN [Sales].[Order]as O
On C.CustomerId = O.CustomerId
GROUP BY C.CustomerCompanyName
ORDER BY count(O.orderId)  asc
for json path, root('Customer whon ordered'), include_null_values; 

--5
-- write a query which returns all the companies and their order
-- Tables involved: TSQLV4 database, customer, order
use Northwinds2019TSQLV5
Select C.CustomerCompanyName, count(O.orderId) as OrderCount
FROM [Sales].[Customer] as C
left outer join [Sales].[Order]as O
On C.CustomerId = O.CustomerId
GROUP BY C.CustomerCompanyName
ORDER BY count(O.orderId)  asc
for json path, root('List of companies'), include_null_values; 

--6
-- Return customers and their orders including customers who placed no orders --
-- Tables involved: TSQLV4 database, Customers and Orders tables 
use TSQLV4
SELECT C.custid, COUNT( DISTINCT O.orderid) AS numorders, SUM(OD.qty) AS totalqty
FROM Sales.Customers AS C
	INNER JOIN Sales.Orders AS O
		ON O.custid = C.custid
	INNER JOIN Sales.OrderDetails AS OD
		ON OD.orderid = O.orderid
	WHERE C.country = N'USA'
GROUP BY C.custid
for json path, root('USA Customers'), include_null_values; 

--7
-- Write a query that is similar to the above query but where country is from japan -- 
-- Tables involved: Customers and Order tables --
use TSQLV4
SELECT C.custid, COUNT( DISTINCT O.orderid) AS numorders, SUM(OD.qty) AS totalqty
FROM Sales.Customers AS C
	INNER JOIN Sales.Orders AS O
		ON O.custid = C.custid
	INNER JOIN Sales.OrderDetails AS OD
		ON OD.orderid = O.orderid
		WHERE C.country = N'Japan'
GROUP BY C.custid
for json path, root('JPN Customers'), include_null_values; 

--8
-- Return customers and their orders -- 
-- Tables involved: Customers and Order tables
use TSQLV4
SELECT C.custid, COUNT( DISTINCT O.orderid) AS numorders, SUM(OD.qty) AS totalqty
FROM Sales.Customers AS C
	INNER JOIN Sales.Orders AS O
		ON O.custid = C.custid
	INNER JOIN Sales.OrderDetails AS OD
		ON OD.orderid = O.orderid
GROUP BY C.custid
for json path, root('Customer and order list'), include_null_values; 

--9
use Northwinds2019TSQLV5
--What is the name given, playerid, and their career total home runs
--Tables used: Example.BaseballPlayerBattingStatistics and
--Example.ProfessionalBaseballPlayer
select BP.nameGiven, SUM(BPS.HomeRun) as [Home Runs], BP.playerID
from Example.BaseballPlayerBattingStatistics as BPS
	 left outer join Example.ProfessionalBaseballPlayer as BP
		ON BP.playerID = BPS.playerID
	 
where BP.playerID is not null 
group by BP.nameGiven, BP.playerID
order by [Home Runs] desc
--for json path, root('Moderate Query 01')

--10
use Northwinds2019TSQLV5
--For numbers less than a 1000, if it is less than 500, say it is less than halfway,
--if greater than say more than halfway, for 500 say halfway.
--Table used: dbo.digits
select myNum = (tenths.digit + Hundreths.digit * 10 + Thousanths.digit * 100), 
	   valueCategory = case
						   when tenths.digit + Hundreths.digit * 10+ Thousanths.digit * 100 < 500 then 'less than halfway'
						   when tenths.digit + Hundreths.digit * 10+ Thousanths.digit * 100 > 500 then 'more than halfway'
						   else 'half'
					   end 
from (dbo.Digits as tenths
	 cross join
	 dbo.Digits as Hundreths
	 cross join
	 dbo.Digits as Thousanths)
order by myNum
--for json path, root('Moderate Query 02')

--11
use TSQLV4
--How many orders were there per month in descending order.
--Tables used: Sales.OrderDetails, Sales.Orders
select sum(od.qty) as Quantity, month(o.orderdate) as [Month]
from Sales.OrderDetails as od
	 inner join Sales.Orders as O
		on od.orderid = O.orderid
group by month(o.orderdate)
Order by Quantity desc
--for json path, root('Moderate Query 03')

--12
use TSQLV4
--How many people are there per country in descending order
--tables used: Sales.Customers, Hr.Employees
select country, count(*) [Number of People]
from(select C.country as country from Sales.Customers as C
	 union all
	 select HR.country as country from HR.Employees as HR) as Locations
group by country
Order by [Number of People] desc
--for json path, root('Moderate Query 04')

--13
use tsqlv4
--What are the employee id's, the order id's, and the customer 
--id's for the orders on the first date. 
--Uses table sales.orders
select O.empid, O.orderdate, O.orderid, O.custid
from sales.Orders as O
	inner join(select empid, min(orderdate) as [Min Order Date]
			   from Sales.Orders
			   group by empid) as D
		on O.empid = D.empid
		AND O.orderdate = D.[min Order date]
order by O.orderdate desc, O.orderid
for json path, root('Moderate Query 05')

--14
use AdventureWorks2014

--what are the job candidates pay history
--use human resources.jobcandidate and humanresources.employeepayhistory tables

select jc.businessEntityID as beid, Max(eph.rate) as [pay rate]
from HumanResources.JobCandidate as jc
	inner join
	HumanResources.EmployeePayHistory as eph
		on jc.BusinessEntityID = eph.BusinessEntityID
group by jc.BusinessEntityID
order by [pay rate]
--for json path, root('Moderate Query 06')

--15
use DB7_SethMarcus07

--What are all the combinations of customers and employees where
--the first letter of the customer's name is in the first half of
--the alphabet

select C.CustomerContactName, count(concat(HR.EmployeeFirstName, HR.EmployeeLastName) ) as [Number of Full Names]
from sales.Customer as C
	 cross join HumanResources.Employee as HR 
where C.CustomerContactName like '[A-M]%'
group by C.CustomerContactName
--for json path, root('Moderate Query 07')

--16
use DB7_SethMarcus07

--For each shipper, what is the total freight that they handled?
--Use Sales.Shipper table and Sales.order table
select S.ShipperId, sum(o.Freight) as TotalFreight
from Sales.Shipper as S
	 left outer join Sales.[Order] as o
		on S.ShipperId = o.ShipperId
group by S.ShipperId

--for json path, root('moderate Query 08')

-- 17
-- A rank of each supplier's products by price
use Northwinds2019TSQLV5
select p.ProductName, s.SupplierCompanyName, p.UnitPrice,
    ROW_NUMBER() OVER(PARTITION BY p.SupplierId
                    ORDER BY p.UnitPrice) AS pricerank
from Production.Product as p
    left outer JOIN
    Production.Supplier as s
    on p.SupplierId = s.SupplierId
order by p.SupplierId, p.UnitPrice

-- 18
-- The oldest and most recent order for each employee & the days elapsed between them
use Northwinds2019TSQLV5
select e.EmployeeFirstName, min(o.OrderDate) as earliestOrder, max(O.OrderDate) mostRecentOrder,
    datediff(WEEK, min(o.OrderDate), max(o.OrderDate)) as daysElapsed
from HumanResources.Employee as e
    left outer join sales.[Order] as o
    on e.EmployeeId = o.EmployeeId
group by e.EmployeeId, e.EmployeeFirstName
having (select ROW_NUMBER() OVER(PARTITION BY e.employeeid
                    ORDER BY min(o.OrderDate))) = 1;


-- 19
-- the total amount due and average order amount across all participating credit cards
use AdventureWorks2014
select distinct cc.CardType, SUM(o.TotalDue) OVER(PARTITION BY cc.CardType) AS totalDue,
    avg(o.TotalDue) OVER(PARTITION BY cc.CardType) as averageOrderAmount
from sales.SalesOrderHeader as o
    left join
    sales.CreditCard as cc
    on o.CreditCardID = cc.CreditCardID
where cc.CardNumber is not null;


-- 20
-- the top 5 most frequent non-credit card accounts
use AdventureWorks2014
select top 5
    c.AccountNumber, count(o.CustomerID) as count
from sales.SalesOrderHeader as o
    left join
    sales.CreditCard as cc
    on o.CreditCardID = cc.CreditCardID
    inner JOIN
    sales.Customer as C
    on o.CustomerID = C.CustomerID
group by c.AccountNumber, cc.CardNumber
having cc.CardNumber is null
order by count(o.CustomerID) DESC;

-- 21
-- all players that made atleast one homerun and the year in their career that it was made
use Northwinds2019TSQLV5
select p.nameGiven, abs(year(p.LeagueDebut)- s.SeasonYear) as yearInCareer, s.SeasonYear, s.HomerRun
from example.ProfessionalBaseballPlayer as p
    left join
    example.BaseballPlayerBattingStatistics as s
    on s.playerID = p.playerID
where s.HomerRun >0
order by p.playerID, s.SeasonYear

-- 22
-- the average rate per year over all employees
use AdventureWorks2014
select DISTINCT year(A.RateChangeDate) as yr, avg(A.Rate) OVER(PARTITION by year(A.RateChangeDate)) as average_rate
from HumanResources.EmployeePayHistory as A
    left outer JOIN
    HumanResources.Employee as B
    on year(B.HireDate) = year(A.RateChangeDate)
order by year(A.RateChangeDate)

-- 23
-- the number of customers, average total spending, and average children per customer in each country. 
USE AdventureWorks2014
select IC.CountryRegionName,
    count(IC.CountryRegionName) as numCustomers,
    avg(PD.TotalPurchaseYTD) as AVGTotalPurchases,
    avg(PD.TotalChildren) as AVGChildren
from sales.vIndividualCustomer as IC
    inner join
    sales.vPersonDemographics as PD
    on IC.BusinessEntityID = PD.BusinessEntityID
group by CountryRegionName

-- 24
-- the number of salary changes for each employee and the highest rate of all those changes
use AdventureWorks2014
select PH.BusinessEntityID, count(PH.BusinessEntityID) as NumOfChanges, max(PH.Rate) as HigestRate
from HumanResources.EmployeePayHistory as PH
    left join
    HumanResources.Employee as EMP
    on PH.BusinessEntityID = EMP.BusinessEntityID
group by PH.BusinessEntityID


/*
--25
Using the database AdventureWorks2014. List of employees and their Historical weekly salary (based on 40h a week)
-- List of employees and their Historical weekly salary (based on 40h a week) 
Tables Invovled: Person.Person, HumanResources.EmployeePayHistory
*/
Use AdventureWorks2014;
SELECT CONVERT(VARCHAR, h.RateChangeDate, 103) AS DateFrom
        , CONCAT(LastName, ', ', FirstName, ' ', MiddleName) AS FullName
        , (40 * h.Rate) AS WeeklySalary
    FROM Person.Person AS p
        INNER JOIN HumanResources.EmployeePayHistory AS h
            ON h.BusinessEntityID = p.BusinessEntityID      
    ORDER BY FullName
	--For json path,root('40h/week')
/*
--26
-- Retrieve a list of the different types of contacts and how many of them exist in the database 
Tables involved: Person.BusinessEntityContact, Person.ContactType
*/

Use AdventureWorks2014;
SELECT c.ContactTypeID, c.Name AS ContactTypeName, COUNT(*) AS N_contacts
    FROM Person.BusinessEntityContact AS bec
        INNER JOIN Person.ContactType AS c
            ON c.ContactTypeID = bec.ContactTypeID
    GROUP BY c.ContactTypeID, c.Name
    ORDER BY COUNT(*) DESC
	--For json path,root('Total Contacts')

/*
--27
Find the max order date for each of the customers using a correlated sub-query with the Sales.Orders table
The correlation is based upon the custid.
Tables involved: Sales.Customers and Sales.Orders
*/
			USE NORTHWINDS2019TSQLV5
			select c.CustomerId, c.CustomerCompanyName, O1.OrderId, O1.EmployeeId
			from Sales.[Order]            as O1
				inner join Sales.Customer as c
					on c.CustomerId = O1.CustomerId
			where  O1.OrderDate in
			(
				select max(o.OrderDate)
				from Sales.[Order] as o
				where o.CustomerId = c.CustomerId
			)
			order by O1.CustomerId
			--For json path,root('Max Orderdate')

/*
-28
Using the AdventureWorks2014 database and create a query that show all customers and how many orders each customers have.
Tables invovled: [AdventureWorks2014].Person.Person, AdventureWorks2014.Sales.Customer, AdventureWorks2014.Sales.SalesOrderDetail
*/
Use AdventureWorks2014;
Select Concat(p.FirstName,' ',P.MiddleName,'.',P.LastName) AS [Full Name]
,Count(O.SalesOrderID) OVER(Partition by O.SalesOrderID) AS [Total Orders]
From [AdventureWorks2014].Person.Person AS P
Inner Join AdventureWorks2014.Sales.Customer AS C ON P.BusinessEntityID = C.CustomerID
Inner Join AdventureWorks2014.Sales.SalesOrderDetail AS O ON C.CustomerID = O.SalesOrderDetailID
--For json path,root('Total Orders')

/*
--29
Calculate the Orderdate of the last date of the month
Table: Sales.Order, Sales.OrderDetail
*/
USE NORTHWINDS2019TSQLV5
SELECT o.orderid, o.orderdate, customerid, employeeid asempid
FROM [Sales].[Order]as o
inner join Sales.OrderDetail as od
on o.orderid =  od.orderid
WHERE orderdate = EOMONTH(orderdate)
--For json path,root('LastDayOFMonth')

/* 
--30
Create a query that finds the maximum orderid 
Table Sales.Orders
*/
Use TSQLV4
Select o1.custid,
	   o1.orderid,
	   o1.orderdate,
	   o1.empid
from Sales.Orders as o1
inner join Sales.Orderdetails as od
on o1.orderid = od.orderid
where o1.orderid = ( select max(o2.orderid)
					from Sales.orders as o2
					where o2.custid = o1.custid
					)
order by orderid asc
--For json path,root('Max Orderid')

/*
--31
Using TSQLV4 database and create a query that finds the running total of the quantity (Qty)
Table: Sales.Orders, Sales.OrderDetails
*/
USE TSQLV4
Select
year(o.orderdate) as orderyear,
sum(od.qty) as qty
from Sales.orders as O 
join sales.OrderDetails as OD
on od.orderid = o.orderid
group by year(orderdate)
--For json path,root('Quantity')

/* 
--32
Using Northwinds2019TSQLV5 database and create a query calculates the hired age of all the employee
Tables involved: TSQLV4 database, Employees and Nums tables
*/
USE Northwinds2019TSQLV5
SELECT E.employeeid, E.employeefirstname, E.employeelastname, datediff(Year, max(E.birthdate), E.hiredate) as Age
from Sales.[Order]                as o 
inner join Sales.OrderDetail  as od
        on od.OrderId = o.OrderId
inner join HumanResources.Employee  as e
        on e.EmployeeId = o.EmployeeId
group by  E.employeeid ,year(o.OrderDate), e.EmployeeFirstName, e.EmployeeLastName,e.hiredate
--For json path,root('Hired Age')

 --33
--Returns company name, contact name, their total orders, and total amount purchased.
	USE TSQLV4;
	SELECT TOP 10 c.companyname AS Company_Name
		,c.contactname AS Contact_Name
		,TotalOrders = count(o.orderid)
		,TotalAmountPurchased = sum(unitprice * qty)
	FROM Sales.Customers AS c
	INNER JOIN Sales.Orders AS o 
	   ON o.custid = c.custid
	INNER JOIN Sales.OrderDetails AS od
	   ON od.orderid = o.orderid
	GROUP BY contactname ,companyname
	ORDER BY TotalAmountPurchased DESC
	for json path, root('Total Amount Purchased')

--34
--Returns customer order on 4/3/16, employee who handled order, the product that they ordered, and full address of cust.
	USE TSQLV4;
	SELECT C.custid AS Customer, O.orderdate AS OrderDate, O.empid AS EmployeeId, od.productid AS Product, FullAdress = CONCAT(c.address, c.city, c.postalcode)
	FROM Sales.Customers AS C
	INNER JOIN Sales.Orders AS O 
	  ON O.custid = C.custid
	INNER JOIN Sales.OrderDetails AS od
	  ON od.orderid = O.orderid 
	WHERE O.orderdate = '20160403'
	GROUP BY C.custid, O.orderdate, O.empid, od.productid, c.address, c.city, c.postalcode
	ORDER BY C.custid
	for json path, root('Orders placed on 4/3/16')

--35
--Returns name, price, product quantity, discount %, price they paid, price if discount applied, and
	-- Amount of money the customer could have saved if they used discount
	USE TSQLV4;
	SELECT TOP 10
		C.contactname AS Contact_Name
		,od.unitprice AS Unit_Price
		,od.qty AS Qty
		,od.discount AS Discount_Percentage
		,OrderPrice = sum(od.unitprice * od.qty)
		,DiscountedOrderPrice = (od.unitprice * od.qty) *  (1. - od.discount)
		,CouldHaveSaved =  sum(od.unitprice * od.qty) - (od.unitprice * od.qty) *  (1. - od.discount)
	FROM Sales.Customers AS C
	INNER JOIN sales.orders AS o 
	    ON o.custid = C.custid
	INNER JOIN sales.orderdetails AS od 
	    ON o.orderid = od.orderid
	WHERE od.discount > 0
	GROUP BY discount, C.contactname, od.unitprice
		,od.qty
	ORDER BY DiscountedOrderPrice DESC
	for json path, root('Could Have Saved')

--36
--that returns all customers who purchased an order who lives in Germany
	USE TSQLV4;

	SELECT C.contactname AS Name, COUNT(DISTINCT O.orderid) AS NumberOfOrders, SUM(OD.qty) AS TotalQty
	FROM Sales.Customers AS C
	JOIN Sales.Orders AS O
	   ON O.custid = C.custid
	JOIN Sales.OrderDetails AS OD
	   ON OD.orderid = O.orderid
	WHERE C.country = N'Germany'
	GROUP BY C.contactname
	order by COUNT(DISTINCT O.orderid) DESC
	for json path, root('Lives in Germany')



--37
--Write a Query that returns the total number of products that got a product review. Include id, name of product, total sales of product, 
-- the rating of the product, the person who reviewed the product, and the comment that they made.
	Use AdventureWorks2014;
	SELECT 
	COUNT(OD.ProductID) [Count], 
	OD.ProductID, PP.[Name],
	SUM(LineTotal) TotalSale,PRP.Rating, PRP.ReviewerName, PRP.Comments
	FROM Sales.SalesOrderDetail  AS OD
	JOIN Production.Product AS PP
	   ON PP.ProductID = OD.ProductID
	JOIN Production.ProductReview AS PRP
	   ON PRP.ProductID = PP.ProductID
	GROUP BY OD.ProductID,
	PP.[Name],
	PRP.Rating, PRP.ReviewerName, PRP.Comments
	for json path, root('Reviews')

--38
--Returns products starting sell date, selling end date, price,
--location, quantity available, cost to make, and the profit made per quantity.
	Use AdventureWorks2014;
	SELECT P.SellStartDate, P.SellEndDate, P.ListPrice, 
	LocationID_Bin = CONCAT(PI.LocationID, ' , ', PI.Bin), PI.Quantity,
	PCH.StandardCost, ProfitPerQuantity = SUM(P.ListPrice - PCH.StandardCost)
	FROM Production.Product AS P
	JOIN Production.ProductInventory AS PI
	   ON PI.ProductID = P.ProductID
	JOIN Production.ProductCostHistory AS PCH
	   ON PCH.ProductID = PI.ProductID
	WHERE P.ListPrice - PCH.StandardCost > 20
	GROUP BY P.SellStartDate, P.SellEndDate, P.ListPrice, 
	PI.LocationID, PI.Bin, PI.Quantity,
	PCH.StandardCost
	for json path, root('Profit per Quantity')
 
	 -- Medium Query 7 that returns job title, deptid, rate, and the sum of total hours they have off (Descending Order).
	 Use AdventureWorks2014;
	 SELECT JobTitle, DepartmentID,rate AS Rate, sum(VacationHours + SickLeaveHours) AS 'Total Hours Off'
	 FROM HumanResources.Employee as E
	 INNER JOIN HumanResources.EmployeePayHistory AS H
	    ON H.BusinessEntityID = E.BusinessEntityID
	 INNER JOIN HumanResources.EmployeeDepartmentHistory AS EH
	    ON EH.BusinessEntityID = H.BusinessEntityID
	 GROUP BY JobTitle, DepartmentID,rate
	 ORDER BY Rate DESC
	 for json path, root('Total Hours Off')


--39
--Returns Product Category, name of product and the total product sales of orders in 2015.

	Use Northwinds2019TSQLV5;

	SELECT distinct c.CategoryID, 
		c.CategoryName,  
		p.ProductName, 
		sum(round(od.UnitPrice * od.Quantity * (1 - od.DiscountPercentage), 2)) as ProductSales
	FROM Sales.OrderDetail AS od
	INNER JOIN Sales.[Order] AS o 
		ON o.OrderId = od.OrderID
	INNER JOIN Production.Product AS p
		ON p.ProductID = od.ProductID
	INNER JOIN Production.Category AS c
	on c.CategoryID = p.CategoryID
	where o.OrderDate > ('20150101') and o.OrderDate < ('20151231')
	group by c.CategoryID, c.CategoryName, p.ProductName
	order by c.CategoryName, p.ProductName, ProductSales
	for json path, root('Product Sales 2015')

--40
-- listing all customers who have not made order yet.
-- tables: [sales].[customer] and [sales].[order]

select c.CustomerCompanyName,c.CustomerId,o.OrderId,o.OrderId, O.OrderDate
from [sales].[customer] as c
	left outer join [sales].[order] as o
		on c.CustomerId = o.CustomerId
where o.orderid is null
group by c.CustomerCompanyName,c.CustomerId,o.OrderId,o.OrderId,  O.OrderDate

--41
-- listing all orders with customer company name and order by recent orders to old orders  
-- tables: employee, order, saledetail

select C.CustomerId, C.CustomerCompanyName
	, O.OrderId, O.OrderDate
	, OD.ProductId,OD.UnitPrice,OD.Quantity
from [sales].[customer] as C
	inner join [sales].[order] as O
		on C.CustomerId = O.CustomerId
	inner join [sales].[orderdetail] as OD
		on O.OrderId = OD.OrderId
group by C.CustomerId, C.CustomerCompanyName
	, O.OrderId, O.OrderDate
	, OD.ProductId,OD.UnitPrice,OD.Quantity
order by O.OrderDate desc

--42
-- listing all orders with their expected delievery day to  the Customers
-- tables: customer and order

select C.CustomerId, CustomerCompanyName, O.OrderId,O.OrderDate,O.RequiredDate,
		datediff(day,O.OrderDate, O.RequiredDate) as DaysToDeliver, C.CustomerCountry
from [sales].[customer] as C
	inner join [sales].[order] as O
		on O.CustomerId = C.CustomerId
order by orderdate desc

--43
--listing still available product and Suppliers 
--talbes: supplier and product

select S.SupplierId,S.SupplierCompanyName,S.SupplierCountry,
	P.ProductId,P.ProductName, 
	c	 when P.Discontinued = 1 then N'Yes'
	 end as [Still Available]
from [Production].[Supplier] as S
	right outer join [Production].[Product] as P
		on S.SupplierId = P.SupplierId
	where P.Discontinued <> 0ase 

group by S.SupplierId,S.SupplierCompanyName,S.SupplierCountry,P.ProductId,P.ProductName, P.Discontinued
for json path,root('AvailableProductsAndSuppliers')

--44
-- listing customers and their bills per order.
-- tables: [sales].[customer], [sales].[order] and [sales].[orderdetail]
select  C.CustomerId, C.CustomerCompanyName ,count(O.orderid) as [total Order],
		 O.OrderId, OD.UnitPrice, OD.Quantity, OD.DiscountPercentage, 
		(OD.UnitPrice * OD.Quantity-OD.UnitPrice * OD.Quantity*OD.DiscountPercentage) as TotalPriceAfterDiscount
from [sales].[customer] as C
	inner join [sales].[order] as O
		on C.CustomerId = O.CustomerId
	inner join [sales].[OrderDetail] as OD
		on O.OrderId =OD.OrderId
group by C.customerID,C.customerCompanyName,O.OrderId,OD.UnitPrice, OD.Quantity, OD.DiscountPercentage
for json path,root('CustomersWiththeirBills')

--45
-- listing all students with their test scores and grades.
-- tables:[stats].[score] and [stats].[test]

select T.Testid, S.studentid, S.TestScore, 
	[Grade] = 
	case
	when S.TestScore < 60 then N'F'
	when S.TestScore >= 60 and S.TestScore < 70 then N'D'
	when S.TestScore >= 70 and S.TestScore < 80 then N'C'
	when S.TestScore >= 80 and S.TestScore < 90 then N'B'
	else N'A'
	end
from [stats].[test] as T
	inner join [stats].[score] as S
		on T.TestId = S.TestId
for json path,root('StudentsScoresGrades')

--46
-- listing top 5 students according to their test scores  
-- [stats].[score] and [stats].[test]

select top 5 T.Testid, S.studentid, S.TestScore as [Test Score], 
	[Grade] = 
	case
	when S.TestScore < 60 then N'F'
	when S.TestScore >= 60 and S.TestScore < 70 then N'D'
	when S.TestScore >= 70 and S.TestScore < 80 then N'C'
	when S.TestScore >= 80 and S.TestScore < 90 then N'B'
	else N'A'
	end
from [stats].[test] as T
	inner join [stats].[score] as S
		on T.TestId = S.TestId
order by [Test Score] desc

--47
-- listing all employees who helped for orders made on May 1 , 2015 and their working years. 
-- tables: [HumanResources].[Employee] and [Sales].[Order]
use Northwinds2019TSQLV5

select   E.EmployeeId, concat(EmployeeLastName,', ',E.EmployeeFirstName) as [Full Name],E.Hiredate,
		datediff(year,E.HireDate, getDate()) as HowLongInYears,
		O.orderid, O.orderdate
from [HumanResources].[Employee]as E
	full outer join [Sales].[Order] as O
		on E.EmployeeId = O.EmployeeId
where O.orderdate = '20150501'
group by datediff(year,E.HireDate, getDate())

--48
-- Listing Employee's name and Phone number
use AdventureWorks2014
SELECT	P.FirstName, P.LastName,
      	PP.PhoneNumber
 FROM 	Person.Person as P
      	INNER JOIN
      	Person.PersonPhone as PP
      	ON P.BusinessEntityID = PP.BusinessEntityID
 WHERE	P.LastName LIKE 'A%'
 ORDER BY P.LastName
 --for json path,root('EmployeeLastNameStartingAAndPhoneNumber')

--49
-- listing all employee phone numbers with their type and employee last name starts with C
-- tables: [person].[person], [person].[personPhone] and [person].[phoneNumberType]
use AdventureWorks2014;
SELECT   P.FirstName, P.LastName,
     	PP.PhoneNumber, PT.Name as PhoneType
FROM 	Person.Person AS P
     	INNER JOIN
     	Person.PersonPhone AS PP
     	ON P.BusinessEntityID = PP.BusinessEntityID
     	INNER JOIN
     	Person.PhoneNumberType AS PT
     	ON PP.PhoneNumberTypeID = PT.PhoneNumberTypeID
WHERE	P.LastName LIKE 'C%'
ORDER BY P.LastName
--for json path,root('EmployeesWithPhoneNumberType');

--50
-- Count how many phone number each phone number type has
--Out: [phone type name (work, home ...)][count]
*/
use [AdventureWorks2014]
SELECT PT.Name AS PhoneNumberType, COUNT(PP.PhoneNumber) AS TotalNumber
FROM Person.PhoneNumberType AS PT
INNER JOIN Person.PersonPhone AS PP ON PT.PhoneNumberTypeID = PP.PhoneNumberTypeID
GROUP BY PT.Name
ORDER BY COUNT(PP.PhoneNumber)
--for json path,root('EmployeesWithPhoneNumberType');

--51
--  Get Total order number, price and qty from each customer
-- out: Customer Name|TotalOrder|TotalQty|Total Amount
Use  [Northwinds2019TSQLV5]
SELECT SC.CustomerContactName AS CustomerName, COUNT(SO.OrderId) AS TotalOrder,
SUM(SOD.Quantity) AS TotalQty, SUM(SOD.Quantity * SOD.UnitPrice) AS TotalAmount
FROM [Sales].[Order] AS SO
INNER JOIN [Sales].[Customer] AS SC ON SO.CustomerId = SC.CustomerId
INNER JOIN [Sales].[OrderDetail] AS SOD ON SO.OrderId = SOD.OrderId
GROUP BY SC.CustomerContactName
ORDER BY SUM(SOD.Quantity) DESC
--for json path,root('CustomerContactName');

--52
-- Displays the names of the customers along with the product names that they have --purchased
use [AdventureWorks2014]
SELECT FirstName, LastName, Prod.Name AS ProductName
FROM Sales.Customer AS C INNER JOIN Person.Person AS P ON C.PersonID = P.BusinessEntityID
INNER JOIN Sales.SalesOrderHeader AS SOH ON C.CustomerID = SOH.CustomerID
INNER JOIN Sales.SalesOrderDetail AS SOD ON SOH.SalesOrderID = SOD.SalesOrderID
INNER JOIN Production.Product AS Prod ON SOD.ProductID = Prod.ProductID;
--for json path,root('SalesCustomerTable');

--53
-- Displays product Id, Orderdate and OrderQuantity
use [AdventureWorks2014]
SELECT SUM(OrderQty) SumOfOrderQty, P.ProductID, SOH.OrderDate
 FROM Sales.SalesOrderHeader AS SOH
 INNER JOIN Sales.SalesOrderDetail AS SOD	
  ON SOH.SalesOrderID = SOD.SalesOrderDetailID
 INNER JOIN Production.Product AS P
  ON SOD.ProductID = P.ProductID GROUP BY P.ProductID, SOH.OrderDate;
--for json path,root('SalesOrderTable');

--54
-- Listing all the CustomerID, price and percentage of sales
USE AdventureWorks2014;
GO
--1
WITH SumSale AS (SELECT SUM(TotalDue) AS SumTotalDue, 	
CustomerID 	FROM Sales.SalesOrderHeader  
GROUP BY CustomerID) SELECT o.CustomerID, TotalDue, TotalDue / SumTotalDue * 100 AS PercentOfSales
FROM SumSale INNER JOIN Sales.SalesOrderHeader AS o ON SumSale.CustomerID = o.CustomerID ORDER BY CustomerID;
--for json path,root('SalesOrderTable');

--55
-- Each query contains two calculations: percent of sales by customer and percent of sales by territory.
USE AdventureWorks2014; 
GO
--1
WITH SumSale AS (SELECT SUM(TotalDue) AS SumTotalDue,   	
  CustomerID  
FROM Sales.SalesOrderHeader	
GROUP BY CustomerID),
TerrSales AS	
(SELECT SUM(TotalDue) AS SumTerritoryTotalDue, TerritoryID 	
FROM Sales.SalesOrderHeader  
GROUP BY TerritoryID )
SELECT o.CustomerID, TotalDue, 	TotalDue / SumTotalDue * 100 AS PercentOfCustSales,	
TotalDue / SumTerritoryTotalDue * 100 AS PercentOfTerrSales
FROM SumSale
INNER JOIN Sales.SalesOrderHeader AS o ON SumSale.CustomerID = o.CustomerID
INNER JOIN TerrSales ON TerrSales.TerritoryID = o.TerritoryID ORDER BY CustomerID;
 --for json path,root('SalesOrderTable')

--56
use [Northwinds2019TSQLV5]
SELECT C.CustomerId, A.Orderid, A.orderdate
FROM [Sales].[Customer] AS C
  CROSS APPLY
	(SELECT TOP (3) Orderid, EmployeeId, OrderDate, RequiredDate
 	FROM [Sales].[Order] AS O
 	WHERE O.CustomerId = C.CustomerId
 	ORDER BY orderdate DESC, orderid DESC) AS A;
-- With OFFSET-FETCH
SELECT C.CustomerId, A.orderid, A.orderdate
FROM [Sales].[Customer] AS C
  CROSS APPLY
	(SELECT orderid, EmployeeId, orderdate, requireddate
 	FROM [Sales].[Order] AS O
 	WHERE O.CustomerId = C.CustomerId
 	ORDER BY orderdate DESC, orderid DESC
 	OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY) AS A;
-- 3 most recent orders for each customer, preserve customers
SELECT C.CustomerId, A.OrderId, A.orderdate
FROM [Sales].[Customer] AS C
  OUTER APPLY
	(SELECT TOP (3) orderid, EmployeeId, orderdate, requireddate
 	FROM [Sales].[Order] AS O
 	WHERE O.CustomerId = C.CustomerId
 	ORDER BY orderdate DESC, orderid DESC) AS A;
 --for json path,root('SalesOrderTable')


--57
use [TSQLV4];
SELECT PP.productid, PP.productname, PP.categoryid,PP.UnitPrice, PP.SupplierId,
CASE categoryid WHEN 1 THEN 'Beverages'   
WHEN 2 THEN 'Condiments'  
WHEN 3 THEN 'Confections'   
WHEN 4 THEN 'Dairy Products' 
WHEN 5 THEN 'Grains/Cereals'    
WHEN 6 THEN 'Meat/Poultry' 
WHEN 7 THEN 'Produce' 
WHEN 8 THEN 'Seafood' 
ELSE 'Unknown Category' 
END AS categoryname FROM Production.Products AS PP; 




-----------------------------------------------------------------------------------------------------------
----------------------------------------------Complex Query------------------------------------------------
-----------------------------------------------------------------------------------------------------------

--1
--Create a query that returns custid 
--from Sales.Order, Sales.OrderDetails, and Sales.OrderDetailsAudit where custid is zero
use TSQLV4
drop function if exists dbo.GetCustOrders;
go
create function dbo.GetCustOrders
	(@cid AS INT) RETURNS TABLE
AS
RETURN
	SELECT orderid, custid, empid, orderdate, requireddate, shipregion, shippostalcode, shipcountry
	FROM Sales.Orders
	WHERE custid = @cid
GO
use TSQLV4
SELECT C.custid, COUNT( DISTINCT ODA.orderid) AS numorders, SUM(OD.qty) AS totalqty
FROM dbo.GetCustOrders(5) AS C
	INNER JOIN Sales.Orders AS O
		ON O.custid = C.custid
	INNER JOIN Sales.OrderDetails AS OD
		ON OD.orderid = O.orderid
	LEFT OUTER JOIN [Sales].[OrderDetailsAudit] AS ODA
		ON O.orderid = ODA.orderid
GROUP BY C.custid
for json path, root('list of custid'), include_null_values; 

--2
--Create a function that returns the number of college supplies 
-- each student orders per semester
USE AdventureWorksDW2016;
GO
IF OBJECT_ID(N'GetSeasonByOrder', N'SO') IS NOT NULL
 DROP FUNCTION GetSeasonByOrder;

GO
Alter FUNCTION dbo.GetSeasonByOrder(
	@OrderDate DATETIME
)
RETURNS VARCHAR(20)
AS
BEGIN
	DECLARE @Answer VARCHAR(20)
	IF(MONTH(@OrderDate) >= 1 AND MONTH(@OrderDate) <6)
	BEGIN
		SET @Answer = 'Spring'
	END
	ELSE IF(MONTH(@OrderDate) >= 6 AND MONTH(@OrderDate) < 9)
	BEGIN
		SET @Answer = 'Summer'
	END
	ELSE IF(MONTH(@OrderDate) >= 9 AND MONTH(@OrderDate) <=12)
	BEGIN
		SET @Answer = 'Fall'
	END
	ELSE IF(MONTH(@OrderDate) = 12 OR MONTH(@OrderDate) = 1)
	BEGIN	
		SET @Answer = 'Winter'
	END

	RETURN @Answer
END
GO
USE AdventureWorksDW2016;
SELECT
    S.CustomerKey, C.FirstName, C.LastName, COUNT(S.CustomerKey) AS NumberOfSales, [dbo].[GetSeasonByOrder](S.OrderDate) AS OrderSeason

FROM
    [dbo].[FactInternetSales] AS S
   	 INNER JOIN
    [dbo].[DimCustomer] AS C
   		 ON S.CustomerKey = C.CustomerKey

WHERE c.LastName  LIKE '%e%e%'
GROUP BY
    S.CustomerKey, C.FirstName, C.LastName, [dbo].[GetSeasonByOrder](S.OrderDate)

ORDER BY
    S.CustomerKey ASC


for json path, root('list of orders'), include_null_values; 

--3
-- create a query that returning employees fullname who didn't place a order 

use Northwinds2019TSQLV5
IF OBJECT_ID(N'getFullName', N'FN') IS NOT NULL
 DROP FUNCTION getFullName;

GO

Create function getFullName
(
  @FirstName nvarchar(100),
  @LastName nvarchar(100)
  )


RETURNS VARCHAR(100)
AS
BEGIN

 DECLARE @FullName VARCHAR(200)
set @fullname = concat(@FirstName,', ', @LastName )
return @fullname
END;

use Northwinds2019TSQLV5
go
select E.EmployeeId, [dbo].[getFullName](E. EmployeeFirstName, E.EmployeeLastName) as [Full Name], 
       O.OrderId, C.CustomerCompanyName, C.CustomerContactName, c.CustomerContactTitle,
	   concat(C.CustomerCity, ', ', C.CustomerCountry) as [Location]

from [HumanResources].[Employee] as E
     full outer join [Sales].[Order] as O
	on E.EmployeeID = O.EmployeeId 
	full outer join  [sales].[customer] as C
		on O.customerId = C.customerId
where O.OrderId is not null
group by E.EmployeeId, [dbo].getFullName(E. EmployeeFirstName, E.EmployeeLastName),
	O.orderid, C.CustomerCompanyName, C.CustomerContactName,C.CustomerContactTitle,
	concat(C.CustomerCity, ', ', C.CustomerCountry)
 
order by E.EmployeeId asc
for json path,root('CustomerWithNoOrder')


--4
--Create a query that return the sum of All Sales per Employee in their history of sales, Then assign a category
--to each employee based on their Sales they’ve made
USE AdventureWorksDW2016;
GO
IF OBJECT_ID(N'EmployeeCatagory','C') IS NOT NULL
 DROP FUNCTION EmployeeCatagory;

GO

Alter function [dbo].[EmployeeCatagory](
     @TotalSales INT
)

RETURNS VARCHAR(20)
AS
BEGIN
	DECLARE @Answer VARCHAR(20)
    IF(@TotalSales > 10000000)
   	 BEGIN
   		 SET @Answer = 'Exceptional'
   	 END
    ELSE IF(@TotalSales > 8000000)
   	 BEGIN
   		 SET @Answer = 'Exceeds Expectations'
   	 END
    ELSE IF(@TotalSales > 5000000)
   	 BEGIN
   		 SET @Answer = 'Fully Meets Exceptions'

	END
    ELSE IF(@TotalSales > 30000000)
   	 BEGIN
   		 SET @Answer = 'Needs Development'
   	 END
    ELSE
   	 BEGIN
   		 SET @Answer = 'Unsatisfactory'
   	 END

	RETURN @Answer
END;

USE AdventureWorksDW2016
go
SELECT
    FRS.EmployeeKey, E.FirstName, E.LastName, SUM(FRS.SalesAmount) AS TotalSales,
    [dbo].[EmployeeCatagory](SUM(FRS.SalesAmount)) AS EmployeeCategory
FROM
    [dbo].[FactResellerSales] AS FRS
   	 INNER JOIN
    [dbo].[DimEmployee] AS E
   		 ON FRS.EmployeeKey = E.EmployeeKey
GROUP BY
    FRS.EmployeeKey, E.FirstName, E.LastName
ORDER BY
    TotalSales DESC

for json path, root('list of Employee Category'), include_null_values; 



--5
-- Creat a quary that return all the employees from UK and customers from USA 
-- with their full address
-- tables: [HumanResources].[Employee],[sales].[order] and [sales].[Customer]

use Northwinds2019TSQLV5;
go
create function getLocation(
         @add varchar(100),
		 @city varchar(100),
		 @region varchar(100),
		 @zipCode varchar(100),
		 @Country varchar(100))

returns nvarchar(250)
as 
begin
declare @result nvarchar(250)
set @result = concat(@add,', ', @city,', ',@region,', ', @zipcode,', ',@country)
return @result
end;


use Northwinds2019TSQLV5;
go 

select concat(E.EmployeeFirstName,' ', E.EmployeeLastName) as Fullname,
	   [dbo].[getLocation](E.EmployeeAddress,E.EmployeeCity,E.EmployeeRegion,E.EmployeePostalCode,E.EmployeeCountry)
	   as [Employee Address],
	   O.OrderId, O.OrderDate,
	   C.CustomerCompanyName,
	   [dbo].getLocation(C.CustomerAddress,C.CustomerCity,C.CustomerRegion, C.CustomerPostalCode,C.CustomerCountry)
	   as [Customer Address]

from [HumanResources].[Employee] as E
	inner join [sales].[order] as O
		on E.EmployeeId = O.EmployeeId
	inner join  [sales].[Customer] as C
		on O.CustomerId = C.CustomerId
where E.EmployeeCountry <> N'UK' and C.CustomerCountry  like N'USA'
group by e.EmployeeFirstName, e.EmployeeLastName,
	   [dbo].getLocation(E.EmployeeAddress,E.EmployeeCity,E.EmployeeRegion,E.EmployeePostalCode,E.EmployeeCountry),
	   O.OrderId, O.OrderDate, C.CustomerCompanyName,
	   [dbo].getLocation(C.CustomerAddress,C.CustomerCity,C.CustomerRegion, C.CustomerPostalCode,C.CustomerCountry)
order by fullname
for json path, root('list of Employees and Customers'), include_null_values;



--6
--Create a query that returns custid 
--from Sales.Order, Sales.OrderDetails, and Sales.OrderDetailsAudit where custid is five
use TSQLV4
drop function if exists dbo.GetCustOrders;
go
create function dbo.GetCustOrders
	(@cid AS INT) RETURNS TABLE
AS
RETURN
	SELECT orderid, custid, empid, orderdate, requireddate, shipregion, shippostalcode, shipcountry
	FROM Sales.Orders
	WHERE custid = @cid
GO
use TSQLV4

SELECT C.custid, COUNT( DISTINCT ODA.orderid) AS numorders, SUM(OD.qty) AS totalqty
FROM dbo.GetCustOrders(3) AS C
	INNER JOIN Sales.Orders AS O
		ON O.custid = C.custid
	INNER JOIN Sales.OrderDetails AS OD
		ON OD.orderid = O.orderid
	LEFT OUTER JOIN Sales.OrderDetailsAudit AS ODA
		ON O.orderid = ODA.orderid
GROUP BY C.custid
for json path, root('list of custid'), include_null_values; 


--7
--Creat a query that returns average unit price, total unit order
--and check supply and demond 
use TSQLV4;
IF OBJECT_ID(N'QuantityCheck', N'QC') IS NOT NULL
 DROP FUNCTION QuantityCheck;
 GO

Alter function QuantityCheck(
	@quantity INT
	)
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @Answer VARCHAR(100)
    IF(@quantity > 600)
   	 BEGIN
   		 SET @Answer = 'Surplus'
   	 END
    ELSE IF(@quantity >=400) and (@quantity <600)
   	 BEGIN
   		 SET @Answer = ' Above Equlibrium'
   	 END
    ELSE IF(@quantity >= 200) and (@quantity <400)
   	 BEGIN
   		 SET @Answer = 'Equlibrium'

	END
    ELSE IF(@quantity >=100) and (@quantity <200)
   	 BEGIN
   		 SET @Answer = 'Below Equlibrium'
   	 END
    ELSE
   	 BEGIN
   		 SET @Answer = 'Shortage'
   	 END

	RETURN @Answer

    END
GO
use TSQLV4;
    select p.ProductName, avg(od.unitprice) AvgUnitPrice, sum(od.qty) TotalUnitsOrdered, [dbo].[QuantityCheck](sum(od.qty)) as SupplyAndDemond
    from [Production].[Products] as P
        inner join
        [Production].[Suppliers] as S
        on P.SupplierId = s.SupplierId
        inner join
        [Sales].[OrderDetails] as OD
        on P.ProductId = od.ProductId
    group by 
	        P.ProductName
	ORDER BY
            P.productname ASC
for json path, root('Check supply and demonds'), include_null_values; 

--8
use TSQLV4;

--How many people were born per year, with a random column saying your favorite number.
--tables used: HumanResources.Employee, RelationalCalculii.USSupremeCourtJustices,
--Sales.[Order]

drop function if exists dbo.tryOne
go
CREATE FUNCTION dbo.tryOne
(
	-- Add the parameters for the function here
	@IntegerNumber int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result int
	SELECT @Result = @IntegerNumber-- Add the T-SQL statements to compute the return value here
	-- Return the result of the function
	RETURN @Result
END
GO

Select [Relevant Years].[Year], count(*) as [Num of Persons], dbo.tryOne(69) as FavoriteNumber
From(
	select Year(HR.BirthDate) as [Year]
	from HumanResources.Employee as HR
	UNION ALL
	select YEAR(SPJ.YearOfBirth)as [Year]
	from RelationalCalculii.USSupremeCourtJustices as SPJ
	Union ALL
	select Year(O.OrderDate)
	from Sales.[Order] as O
)as [Relevant Years]

group by [Relevant Years].[Year]
order by [Relevant Years].[Year]
--for json path, root('Complex Query 01')

--9
use TSQLV4;
--What is the full name, employee id, and the employee id twice 
--Tables used: HR.Employees, Sales.Orders, dbo.Nums
drop function if exists dbo.getLen2
go

create function dbo.getLen2
(	 @birthdate as int
)
Returns int
AS
Begin
	declare @result int
	Return
		@birthdate
	end;
go


select concat(HR.EmployeeFirstName, HR.EmployeeLastName) as [Full Name],
	   HR.EmployeeId, dbo.getLen2(O.EmployeeId) as LengthofEmployeeId
--dbo.getLen(O.empid)
from HumanResources.Employee as HR
	inner join Sales.[Order] as O
		on HR.EmployeeId = O.EmployeeId
	inner join dbo.Nums as N
		on O.orderid  = N.n
order by [Full Name]
--for json path, root('Complex Query 02')
	
--10
use TSQLV4;
--What is the full name of the client, the category, the list price,
--the standard cost, the profit, and the quantity of the items sold.
--Tables used: Production.Product, Production.ProductCategory,
--Production.ProductCostHistory, Production.ProductInventory
drop function if exists dbo.Profit
go

create function dbo.Profit
(	 @listPrice as decimal,
	 @standardCost as decimal
)
Returns int
AS
Begin
	declare @result money
	Return
		cast((@listPrice - @standardCost) as MONEY)
	end;
go

select concat(P.ProductName, ', ', P.ProductId) as FullName, C.CategoryName as [Category Name], 
	   P.UnitPrice, P.Discontinued, dbo.Profit(P.UnitPrice, P.Discontinued) as Savings
from Production.Product as P
	inner join Production.Category as C
		on C.CategoryID = P.ProductID
	inner join Production.Supplier as H
		on H.SupplierId = P.SupplierId
order by Savings desc
--for json path, root('Complex Query 03')

--11
use TSQLV4;

--what is the sales order id, the total freight, the percent discount, the quantity, and the first and last
--characters of the credit approval code.
--tables used: Sales.SalesOrderDetail, sales.SalesOrderHeader, Sales.SpecialOffer, Sales.ShoppingCartItem

drop function if exists dbo.getFirstAndLastChar
go
create function dbo.getFirstAndLastChar
( 
	@string as nvarchar
)
Returns nvarchar
As
begin
	declare @result nvarchar(2)
	
	return @string;
end;
go


select o.OrderId as ID, SUM(o.freight) as [Total Freight]
	, concat(od.DiscountPercentage * 100, '%') as [Percent Discount]
	, od.Quantity
	, dbo.getFirstAndLastChar(o.UserAuthenticationId) as UAI
from Sales.OrderDetail as od
		inner join sales.[Order] as O
			on od.OrderId = O.OrderId
		inner join sales.Shipper as S
			on o.ShipperId = S.ShipperId
group by o.OrderId, od.DiscountPercentage, od.Quantity
	, dbo.getFirstAndLastChar(o.UserAuthenticationId)
having od.DiscountPercentage> 0
--order by so.DiscountPct desc
--for json path, root('Complex Query 04')

--12
use TSQLV4;

--what is the customer id, order id, total quantity, product id, and how
--long it has been sicne the last order in days. 
--tables used: Sales.Customer, Sales.[Order], Sales.OrderDetail

drop function if exists dbo.getAge
go

create function dbo.GetAge
(	@birthdate as DATE,
	@eventdate as DATE
)
Returns int
AS
Begin
	declare @result int
	Return
		datediff(day, @birthdate, @eventdate)
	end;
go


select C.customerid,  O.orderid, SUM(od.Quantity) as [Total Quantity], od.productid, dbo.getAge(max(O.orderdate), SYSDATETIME()) as [How long since Last Order] 
from Sales.Customer as C
	inner join Sales.[Order] as O
	on c.CustomerId = o.CustomerId
		inner join Sales.OrderDetail as OD
			on OD.orderid = o.orderid
group by C.customerid, O.orderid, od.productid
order by C.customerid, [Total Quantity] desc, od.productid
--for json path, root('Complex Query 05')

--13
use TSQLV4;

--What is the shipperid, the total number of products they shipped,
--and the total freight. 
--tables used: sales.OrderDetail, Sales.[Order], Sales.Shipper 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
drop function if exists dbo.ShipperId
go
CREATE FUNCTION dbo.ShipperId
(
	-- Add the parameters for the function here
	@IntegerNumber int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result int
	SELECT @Result = @IntegerNumber-- Add the T-SQL statements to compute the return value here
	-- Return the result of the function
	RETURN @Result
END
GO

select dbo.ShipperId(S.ShipperId) as [Shipper Id], count(distinct od.ProductId) as [Total Products], sum(O.Freight) as [Total Freight]
from Sales.[Order] as O
	 left outer join sales.OrderDetail as od
	 on O.OrderId = od.OrderId
		left outer join Sales.Shipper as S
		on O.ShipperId = S.ShipperId
group by dbo.ShipperId(S.ShipperId)
--for json path, root('Complex Query 06')

--14
use TSQLV4;

--what are the hire dates and number of people from that state 
--Tables used: bp.EmployeeId, bps.JusticeId, RelationalCalculii.USSupremeCourtJustices

drop function if exists dbo.getLen
go

create function dbo.getLen
(	 @birthdate as int
)
Returns int
AS
Begin
	declare @result int
	Return
		@birthdate
	end;
go

select bp.HireDate as [Hire Day], count(distinct bps.StateOfBirth) as [States], sum(dbo.getLen(N.n)) as LengthOfSomething
from RelationalCalculii.USSupremeCourtJustices as bps
	 left outer join HumanResources.Employee as bp
		on bps.JusticeId = bp.EmployeeId
		left outer join dbo.Nums as N
		on bp.EmployeeId = N.N
group by bp.HireDate
order by LengthOfSomething
--for json path, root('Complex Query 07')

-- 15
-- The number of orders and shippers for each customer, as well as the average number of orders fulfilled by each shipper.
DROP FUNCTION IF EXISTS [dbo].[avgPackagePerShipper]
GO

create function avgPackagePerShipper(@numberOfOrders INT, @numberOfShippers INT)
returns FLOAT(2)
AS
BEGIN
    declare @averagePerShipper FLOAT
    set @averagePerShipper = @numberOfOrders/cast(@numberOfShippers as FLOAT)
    return @averagePerShipper
END
GO

select C.CustomerContactName, count(o.OrderId) as numOrders, count(distinct S.ShipperId) as NumberShippersUsed,
    [dbo].[avgPackagePerShipper](count(o.OrderId), count(distinct S.ShipperId)) as AveragePerShipper
from sales.[Order] as O
    inner join
    Sales.Customer as C
    on O.CustomerId = C.CustomerId
    inner JOIN
    Sales.Shipper as S
    on O.ShipperId = S.ShipperId
group by c.CustomerContactName
for json auto;

    -- 16
    -- The average vacation and sick days in weeks for each position of each level of the company.
    DROP FUNCTION IF EXISTS [dbo].[daysToWeeks]
GO

    create function daysToWeeks(@numDays INT)
returns FLOAT(2)
AS
BEGIN
        declare @numWeeks FLOAT
        set @numWeeks = @numDays/cast(5 as FLOAT)
        return @numWeeks
    END
GO

    use AdventureWorks2014
    select e.JobTitle, e.OrganizationLevel, [dbo].[daysToWeeks](avg(e.VacationHours)) as avgVacation, [dbo].[daysToWeeks](avg(e.SickLeaveHours)) as avgSickDays
    from HumanResources.Employee as e
        left JOIN
        HumanResources.vEmployeeDepartmentHistory as h
        on e.BusinessEntityID = h.BusinessEntityID
        left JOIN
        HumanResources.vEmployeeDepartment as d
        on e.JobTitle = d.JobTitle
    where e.OrganizationLevel is not null
    group by e.OrganizationLevel, e.JobTitle

-- 17
-- total units ordered for each product
    DROP FUNCTION IF EXISTS [dbo].[isPopular]
GO

    create function isPopular(@orders INT)
returns NVARCHAR
AS
BEGIN
        declare @qualifyTag NVARCHAR;
        select @qualifyTag = case
        when @orders > 500 then 'Yes'
        else 'No'
    end;
        return @qualifyTag
    END
GO

    select p.ProductName, sum(od.Quantity) totalUnitsOrdered, [dbo].[isPopular](sum(od.Quantity)) as isPopular
    from Production.Product as p
        inner join
        Production.Supplier as s
        on p.SupplierId = s.SupplierId
        inner join
        sales.[OrderDetail] as od
        on p.ProductId = od.ProductId
    group by p.ProductName


-- 18
-- each employee's discount and sales offered information, as a message.
DROP FUNCTION IF EXISTS [dbo].[message]
GO

    create function message(@numOrders INT, @totalDiscount INT)
returns nvarchar(100)
AS
BEGIN
        declare @message nvarchar(100)
        set @message = concat('Congrats! You have completed a total of ', @numOrders, ' orders! Overall, your customers have saved $', @totalDiscount,'.')
        return @message
    END
GO

    select e.EmployeeFirstName, avg(d.TotalDiscountedAmount) as avgDiscountOffered, sum(eo.TotalDiscountedAmount) totalDiscountOffered, sum(eo.TotalNumberOfOrders) as numOrders,
        [dbo].[message](sum(eo.TotalNumberOfOrders), sum(eo.TotalDiscountedAmount)) as message
    from HumanResources.Employee as e
        left join
        sales.uvw_OrderTotalQuantityAndTotalDiscountedAmount as d
        on d.EmployeeId = e.EmployeeId
        inner JOIN
        sales.uvw_EmployeeOrder as eo
        on e.EmployeeId = eo.EmployeeId
    group by e.EmployeeFirstName
    for json path, root('messages')

-- 18
-- baseball player's best year with their number of homeruns

        DROP FUNCTION IF EXISTS [dbo].[oneLiner]
GO

        create function oneLiner(@name nvarchar(255), @year INT, @homeruns INT)
returns nvarchar(100)
AS
BEGIN
            declare @message nvarchar(100)
            set @message = concat(@name, ' had their best season in ', @year, ' with ', @homeruns,' homeruns!')
            return @message
        END
GO

        select p.nameGiven, s.seasonYear, max(s.HomerRun) as maxHomeRuns, r.RomanNumeral,
            [dbo].[oneLiner](p.nameGiven, s.seasonYear, max(s.HomerRun)) as OneLiner
        from example.ProfessionalBaseballPlayer as p
            inner join
            example.BaseballPlayerBattingStatistics as s
            on p.playerID = s.playerID
            inner join Example.RomanNumeral as r
            on r.Digit = s.HomerRun
        group by p.nameGiven, s.SeasonYear, r.RomanNumeral
        for json path, root('One Liner');

-- 19
-- The average number of sales per each professional title group.
DROP FUNCTION IF EXISTS [dbo].[perClient]
GO

create function perClient(@totalSales FLOAT(2), @numClients INT)
returns FLOAT(2)
AS
BEGIN
    declare @percent FLOAT(2)
    set @percent = @totalSales / @numClients;
    return @percent
END
GO

select CustomerContactTitle, count(distinct c.CustomerId) as numClients, sum(d.Quantity) as unitsSold, sum(d.UnitPrice * d.Quantity) as salesMade,
    [dbo].[perClient](sum(d.UnitPrice * d.Quantity), count(distinct c.CustomerId)) as perClient
from sales.Customer as c
    inner JOIN
    sales.[Order] as o
    on c.CustomerId = o.CustomerId
    left JOIN
    sales.OrderDetail as d
    on o.OrderId = d.orderid
group by CustomerContactTitle

-- 20
-- The total sales for each currency and the equivalent conversion into that currency.
DROP FUNCTION IF EXISTS [dbo].[convertCurrency]
GO

create function convertCurrency(@totalSales FLOAT(2), @conversionRate FLOAT(2), @currName nvarchar(255))
returns FLOAT(2)
AS
BEGIN
    declare @total NVARCHAR(255)
    set @total = concat((@totalSales * @conversionRate), ' ', @currName)
    return @total
END
GO


select soh.SalesOrderID, soh.CurrencyRateID, soh.TotalDue, concat(cr.AverageRate,' ', cr.ToCurrencyCode) as '1 USD =', st.TerritoryID,
    [dbo].[convertCurrency](soh.TotalDue, cr.AverageRate, cr.ToCurrencyCode) as totalAmountInForeignDollars
from sales.SalesOrderHeader as soh
    left join
    sales.CurrencyRate as cr
    on soh.CurrencyRateID = cr.CurrencyRateID and cr.ModifiedDate >2014
    left join
    sales.SalesTerritory as st
    on soh.TerritoryID = st.TerritoryID


/* 
--21
Use your own database and create a function that categorize each price value of the OrderPrice ( UnitPrice * Quantity)
when price > 2500 :High End Priced 
when price > 600  and  price < 2500 :'Average Priced'
when price < 600 : 'Low Priced'
Table used: Sales.Shipper , Sales.Customer , Sales.[order]
*/
Use DB7_JerryGao40
drop function if exists dbo.pricecheck
go
create  FUNCTION dbo.pricecheck
(
	@price int
)
RETURNS nvarchar(20)
AS
BEGIN
	DECLARE @result nvarchar(20)
	SET @result = CASE
					WHEN @price > 2500	THEN 'High End Priced'
					WHEN @price > 600  and @price < 2500 THEN 'Average Priced'
					WHEN @price < 600	THEN 'Low Priced'
					ELSE 'Missing Value'
				  END
	RETURN @Result
END
select o.OrderId,c.CustomerCompanyName, c.CustomerContactName, od.UnitPrice,(od.UnitPrice * od.Quantity) as OrderPrice,
	   dbo.pricecheck(od.UnitPrice * od.Quantity) as [Price Category]
from Sales.[Order] as o
inner join Sales.OrderDetail as od
on o.OrderId = od.OrderId
inner join  Sales.Customer as c 
on o.CustomerId = c.CustomerId
inner join Sales.Shipper as s
on o.ShipperId = s.ShipperId
order by OrderPrice Desc
--For json path,root('Price Category');


/*
--22
	Using your own database and create a function to calculate the discount price.
	Label the column: column HighestOrderPrices using the text 'Highest Order Prices', OrderPrice alias deriving product of UnitPrice and Quantity. DiscountedOrderPrice alias deriving by extending the OrderPrice calculation and applying the DiscountPercentage (1.-DiscountPercentage).
					DaysFromOrderToShip alias deriving the number of days between orderdate and shippeddate
Tables involved: Sales.[Order] , Sales.OrderDetail , Sales.Customer , Sales.Shipper 
Order: Decending by unitprice
*/
Use DB7_JerryGao40
drop function if exists dbo.price
go
create  FUNCTION dbo.price
(
	 @price int
	,@quantity int
	,@discount int
)
RETURNS int
AS
BEGIN
	DECLARE @result int
	SET @result = ((@price * @quantity) - @price * @quantity * @discount)
	RETURN @Result
END

select top(10)'Highest Order Prices' as [Highest Order Prices], c.CustomerCompanyName, o.OrderDate, s.ShipperCompanyName, od.UnitPrice,
		od.Quantity, od.DiscountPercentage, (od.UnitPrice * od.Quantity) as OrderPrice,
		 dbo.price(od.UnitPrice,od.Quantity,od.DiscountPercentage) as DiscountedOrderPrices
		
from Sales.[Order] as o
inner join Sales.OrderDetail as od
on o.OrderId = od.OrderId
inner join  Sales.Customer as c 
on o.CustomerId = c.CustomerId
inner join Sales.Shipper as s
on o.ShipperId = s.ShipperId
where o.OrderDate > N'2014-7-01' and o.OrderDate < N'2014-7-31'
order by od.UnitPrice desc
--For json path,root('Discount');


 /* 
 --23
Create a function that combines the first name and last name
Write a query that returns all orders placed by an Employee whose name starts with a 's'
Tables involved: Sales.Orders, Sales.OrderDetails and HR.Employees 
Order:Descending by EmployeeFullName, SalesYear
 */
Use DB7_JerryGao40;
drop function if exists dbo.getFullName
go
create function dbo.getFullName(@first nvarchar(100), @last nvarchar(100))

RETURNS nvarchar(100)
AS
BEGIN
declare @fullname nvarchar(200)
set @fullname = concat(@first,N' ',@last)
return @fullname
END	
GO

select  dbo.getFullName(e.EmployeeFirstName,e.EmployeeLastName) as EmployeeFullName, year(o.OrderDate) as SalesYear, count(distinct o.OrderId) as ActualNumberOfOrders, sum(od.Quantity * od.Quantity) as [Total Sales ]
from Sales.[Order]                as o 
    inner join Sales.OrderDetail  as od
        on od.OrderId = o.OrderId
    inner join HumanResources.Employee  as e
        on e.EmployeeId = o.EmployeeId
where concat(E.EmployeeFirstName,' ',e.EmployeeLastName) like N'S%'
group by  year(o.OrderDate), e.EmployeeFirstName, e.EmployeeLastName
order by EmployeeFullName, SalesYear desc
--For json path,root('Full Name');

/* 
--24
Use Your personal database and create a function that adds 2 more purchase to every customer 
and create a query that shows the CustomerID, Orderdate, Customercompanyname, OrderID, ProductID, Quantity, New Quantity
Where Orderdate is at the end of each month ordered in ascending order
Tables: Sales.Customers, Sales.Orders, Sales.OrderDetails
*/
Use DB7_JerryGao40
drop function if exists dbo.twomore
go
CREATE FUNCTION dbo.twomore
(
	@IntegerNumber int
)
RETURNS int
AS
BEGIN

	DECLARE @Result int
	SELECT @Result = @IntegerNumber + 2
	RETURN @Result
END
GO
SELECT C.customerid, o.orderdate, C.customercompanyname, O.orderid,
OD.productid, Quantity ,dbo.twomore(OD.Quantity)as 'New Quantity'
FROM Sales.Customer AS C
INNER JOIN Sales.[Order] AS O
ON C.customerid = O.customerid
INNER JOIN Sales.OrderDetail AS OD
ON O.orderid = OD.orderid
Where orderdate = EOMONTH(orderdate)
order by C.customerid, C.customercompanyname, O.orderid asc
--For json path,root('Addtwo')

/* 
--25
Using TSQLV4 database 
Create a function that combines the CustomerCountry, CustomerRegion, and CustomerCity as Location if the CustomerRegion is Null, display the NULL. 
Create a query that lists the Customerid,Location, Distinct Orderid as numorders, sum of qty as totalqty
Tables involved: Sales.Customers, Sales.Orders, Sales.OrderDetails
*/
Use DB7_JerryGao40
drop function if exists dbo.getlocation
go
CREATE FUNCTION dbo.getlocation
(
@county nvarchar(100), 
@region nvarchar(100),
@city nvarchar(100)
)
RETURNS nvarchar(100)
AS
BEGIN
declare @location nvarchar(300)
set @location = concat(@county,N',', CASE WHEN @region IS NULL THEN 'NULL,' ELSE concat(@region,N',')End,@city)
return @location
END	

SELECT C.customerid,dbo.getlocation(c.customercountry,c.CustomerRegion,c.CustomerCity)as [location] , COUNT(DISTINCT O.orderid) AS numorders, SUM(OD.quantity) AS totalqty
FROM Sales.Customer AS C
INNER JOIN Sales.[Order] AS O
ON O.customerid = C.customerid
INNER JOIN Sales.OrderDetail AS OD
ON OD.orderid = O.orderid
WHERE C.customercountry = N'USA'
Group by c.customerid, dbo.getlocation(c.customercountry,c.CustomerRegion,c.CustomerCity)
HAVING COUNT(DISTINCT O.orderid)>5
--For json path,root('Location')

/*
--26
Write a function that calculates the sum od.Quantity as [Total Quantity]
Create a query with columns CustomerID , OrderID, Total Quantity, Productid
Tables involved: Sales.Customer , Sales.[Order] , Sales.OrderDetail
Order by: C.customerid, [Total Quantity] desc, od.productid
*/
Use DB7_JerryGao40

create function dbo.Total
(	
@num int
)
Returns int
AS
Begin
	declare @result int
	Select @result = sum(@num)
	Return
		@result
	end;
go

select C.customerid,  O.orderid, dbo.Total(od.Quantity) as [Total Quantity], od.productid
from Sales.Customer as C
	inner join Sales.[Order] as O
	on c.CustomerId = o.CustomerId
		inner join Sales.OrderDetail as OD
			on OD.orderid = o.orderid
group by C.customerid, O.orderid, od.productid,od.Quantity
order by C.customerid, [Total Quantity] desc, od.productid
--For json path,root('Total')

/*
--27
Write a function that calculates the days left for ShiptoDate from Orderdate
Create a query with columns CustomerID , OrderID, Total Quantity, Productid, and the function to calculated the days left as [Days Left] 
Tables involved: Sales.Customer , Sales.[Order] , Sales.OrderDetail
*/
Use DB7_JerryGao40
drop function if exists dbo.DateLeft
go

create function dbo.DateLeft
(	@birthdate as DATE,
	@eventdate as DATE
)
Returns int
AS
Begin
	declare @result int
	Return
		datediff(day, @birthdate, @eventdate)
	end;
go

select C.customerid,  O.orderid, SUM(od.Quantity) as [Total Quantity], od.productid, dbo.DateLeft(max(O.orderdate), o.shiptodate) as [Days Left]
from Sales.Customer as C
	inner join Sales.[Order] as O
	on c.CustomerId = o.CustomerId
		inner join Sales.OrderDetail as OD
			on OD.orderid = o.orderid
group by C.customerid, O.orderid, od.productid,o.shiptodate
order by C.customerid, [Total Quantity] desc, od.productid
--For json path,root('Days Left')


--28
--A query to get detailed information for each sale so that a statement can be issued
 
	GO
	create function GetSalePrice
	 (@UnitPrice as money,
	  @qty as DEC(10,2),
		@discount DEC(4,2)
	)
	 RETURNS DEC(10,2)
	 AS
	 BEGIN
		RETURN
			  @qty * @UnitPrice * (1 - @discount);

		
		END;
	 GO

	USE TSQLV4;
	SELECT distinct a.companyname as CompanyName,
		f.ProductName, 
		b.orderid as OrderID,
		concat(c.address,  N' ', c.city, N' ', c.postalcode) as "Full Address", 
		b.OrderDate, 
		b.ShippedDate, 
		e.UnitPrice, 
		sum(e.qty) as Qty, 
		e.Discount,
		dbo.GetSalePrice(e.unitprice,e.qty,e.discount) as SalePrice
	from Sales.Shippers AS a 
	INNER JOIN Sales.Orders as b 
		ON b.shipperid = a.shipperid 
	INNER JOIN Sales.Customers as c
		ON c.custid = b.custid
	INNER JOIN HR.Employees as d
		ON d.empid = b.empid
	INNER JOIN Sales.OrderDetails as e
		ON b.OrderID = e.OrderID
	INNER JOIN	Production.Products as f
		ON f.ProductID = e.ProductID
	GROUP BY a.companyname,
		f.ProductName, 
		b.orderid,
		c.address, 
		c.city,
		c.postalcode, 
		b.OrderDate, 
		b.ShippedDate, 
		e.UnitPrice, 
		e.qty, 
		e.Discount
		for json path, root('Statement')
--------------------------------

--29
--Returns courtesy name, phone number, orderdate, shipdate, shipaddress, and shipregion.
-- Determines if item has not been shipped yet and determines if the shipregion is null.
-- Only returns the people whose orders weren't shipped yet and their ship region is unavailable.
	
	go
	 CREATE FUNCTION isEmpty
	(
	@input as varchar(250),
	@newValue varchar(250)
	)
	RETURNS varchar (250)
	AS
	BEGIN
	-- case where the input value is  NULL --
	Declare @inputFiltered as varchar(250)
	set @inputFiltered=ISNULL(@input,'')
	RETURN (case rtrim(ltrim(@inputFiltered)) when '' then rtrim(ltrim(@newValue)) else rtrim(ltrim(@inputFiltered)) end)
	END

	go

	
	USE TSQLV4;

	SELECT CONCAT(titleofcourtesy, ' ' , FullName) AS 'Cortesy+Name' , a.phone AS PhoneNumber, 
	orderdate AS OrderDate, dbo.isEmpty(shippeddate, 'Not Shipped Yet') AS ShippedDate, shipaddress AS ShipAddress, dbo.isEmpty(shipregion,'Not Available') AS ShipRegion
	FROM Sales.Shippers AS a 
	INNER JOIN Sales.Orders as b 
		ON b.shipperid = a.shipperid 
	INNER JOIN Sales.Customers as c
		ON c.custid = b.custid
	INNER JOIN HR.Employees as d
		ON d.empid = b.empid
	INNER JOIN Sales.OrderDetails as e
		ON b.OrderID = e.OrderID
	INNER JOIN	Production.Products as f 
		ON f.ProductID = e.ProductID
	WHERE shippeddate IS NULL AND shipregion IS NULL
	GROUP BY titleofcourtesy, FullName, orderdate, a.phone, orderdate, shippeddate, shipaddress, shipregion
	for json path, root('Not Shipped')
	--------------------------------
--30
--Returns product category, the Suppliers position + name, supplier country, determines
-- continent from country.

	GO
	create function getContinent
	 (@SupplierCountry as NVARCHAR(15) )
	 RETURNS NVARCHAR(15)
	 AS
	 BEGIN
		RETURN 
			 case when @SupplierCountry in 
					 ('Italy','UK','Sweden','Germany',
					  'Denmark','Netherlands','Norway','Finland','Spain','France')
							then 'Europe'
				  when @SupplierCountry in ('USA','Canada','Brazil') 
							then 'America'
				  when @SupplierCountry in ('Australia')
						    then 'Australia'
			else 'Asia-Pacific'
          
		END
		END;
	 GO


	
	Use Northwinds2019TSQLV5
	SELECT c.CategoryName AS "Category", concat(s.SupplierContactTitle, ' ', s.SupplierContactName) 
			AS "Supplier Position, Supplier Name" , s.SupplierCountry,
			dbo.getContinent(s.SupplierCountry) as "Supplier Continent"
	from Production.Supplier AS s
	INNER JOIN Sales.Customer AS SC
		ON SC.CustomerId = s.SupplierId
	INNER JOIN Production.Product AS p 
		ON p.SupplierID=s.SupplierID
	INNER JOIN Production.Category AS c
		ON c.CategoryID=p.CategoryID 
	group by c.CategoryName, s.SupplierCountry, s.SupplierContactTitle, s.SupplierContactName,
			  dbo.getContinent(s.SupplierCountry)
    for json path, root('Continent')
		--------------------------------
--31
--Returns first name, email address, Shows password hash if it contains an A, if not:
-- Prints "Doesnt Contain A", password Salt, and their phone number.

	 GO
	 Create Function ContainsA( 
	 @PasswordHash VarChar(128) )
	 Returns VarChar(128)
	 AS
	 BEGIN
	 RETURN case WHEN @PasswordHash LIKE 'A%' THEN @PasswordHash ELSE 'Doesnt Contain A'
	 end

	 END;
	 GO

	 
	Use AdventureWorks2014;
	SELECT FirstName, CONCAT(E.EmailAddress, '	 :	 ', 
	dbo.ContainsA(PasswordHash)) AS EmailAddressAndPasswordHashIfContainedA, PasswordSalt, PH.PhoneNumber
	FROM Person.Person AS P
	inner join Person.Password AS PA
		ON PA.BusinessEntityID = P.BusinessEntityID
	inner join Person.EmailAddress AS E
		ON E.BusinessEntityID = PA.BusinessEntityID
	inner join Person.PersonPhone AS PH
	ON PH.BusinessEntityID = E.BusinessEntityID
	WHERE Title = 'Mr.'
	group by FirstName, EmailAddress, PasswordHash, PasswordSalt, PhoneNumber
	for json path, root('PasswordHash Contains A')
	--------------------------------

--32
--returns the amount of days on the market (only the ones that have ended), starting date, 
-- ending date , price, locationId,bin,quantity, standard cost
	go
	create function DaysOnMarket
	(@SellStartDate AS DATE,
	@SellEndDate AS DATE)

	returns INT
	AS 
	BEGIN 
	RETURN
			DATEDIFF(day, @SellStartDate, @SellEndDate)
        
	END;

	go

	
	Use AdventureWorks2014;
	Select TOP(100) P.ProductID, P.SellStartDate, P.SellEndDate, dbo.DaysOnMarket(P.SellStartDate,P.SellEndDate) As DaysOnMarket, P.ListPrice, 
		LocationID_Bin = CONCAT(PI.LocationID, ' , ', PI.Bin), 
		Sum(PI.Quantity) as Quantity,
		PC.StandardCost
	FROM Production.Product AS P
	inner join Production.ProductCostHistory AS PC
		ON PC.ProductID = P.ProductID
	inner  join Production.ProductInventory AS PI
		ON PI.ProductID = P.ProductID
		WHERE SellEndDate IS NOT NULL
	GROUP BY P.ProductID, P.SellStartDate, P.SellEndDate,
	P.SellStartDate,P.SellEndDate, P.ListPrice,  PI.Bin, PI.Quantity,PI.LocationID, PC.StandardCost
	order by ProductID
	for json path, root('Days on Market')


	--------------------------------
--33
--Returns earnings based on the max number of hours they worked and their hourly rate. Also shows their
-- job title
	go
	Create Function HumanResources.Earnings(@Rate as Money,
	@hours as Decimal)
	returns nvarchar(30)
	as
	Begin
	Declare @result nvarchar(30)
	Select @result = (@rate*@hours)
	return @result;
	end
	GO


	
    Use AdventureWorks2014;

	Select  JC.JobTitle, rate AS HourlyRate, Max(dateDiff(hour, S.StartTime, S.endtime)) as
	LongestPossibleShift,
	HumanResources.Earnings(rate, Max(dateDiff(hour, S.StartTime, S.endtime))) as EarningsPerShift
	From HumanResources.Shift as S
	inner join HumanResources.EmployeeDepartmentHistory as E
		ON S.ShiftID=E.ShiftID
	inner join HumanResources.EmployeePayHistory as EPH
		ON E.BusinessEntityID= EPH.BusinessEntityID
	inner join HumanResources.Employee as JC
		ON JC.BusinessEntityID = EPH.BusinessEntityID
	group by rate, JobTitle
	order by EPH.Rate desc 
	for json path, root('Earnings')

	 --------------------------------

--34
--Returns Customer contact name, year, the total spent in that year, and total quantity

	go

	Create Function Sales.Spending(@unitprice as Decimal(8,2), @Quantity
	as Decimal, @discount as Decimal(8,2))
	returns decimal(8,2)
	as
	Begin
	Declare @result Decimal(8,2)
	Select @result =
	((@UnitPrice-@UnitPrice*@discount)*@Quantity)
	return @result;
	end
	GO


	Use Northwinds2019TSQLV5
	Select C.CustomerContactName, Year(orderdate) as "Year",
	format(Sum(Sales.Spending(Od.UnitPrice, OD.Quantity,
	OD.DiscountPercentage)), 'c') as TotalSpent, Sum(Quantity) as
	TotalQuantity
	From Sales.Customer as C
	Inner Join Sales.[Order] as O
		ON C.CustomerId=O.CustomerId
	inner join Sales.OrderDetail as OD
		ON O.OrderId=OD.OrderId
	group by Year(OrderDate), C.CustomerId, C.CustomerContactName
	order by Year(orderdate)
	for json path, root('Total Spent')
	---------------------------------------

--35
-- Listing all employees with their fullname, 
-- their Orderid and geting customers information with contact phone number

USE [Northwinds2019TSQLV5]
GO
/****** Object:  UserDefinedFunction [dbo].[getFullName]    Script Date: 3/13/2020 2:45:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER function [dbo].[getFullName](@first nvarchar(100), @last nvarchar(100))
returns nvarchar(100)
as 
begin
declare @fullname nvarchar(200)
set @fullname = concat(@last,', ', @first )

drop function if exist [sales].TotalAmount;
return @fullname
end;


select E.EmployeeId, [dbo].getFullName(E. EmployeeFirstName, E.EmployeeLastName) as [Full Name],
	O.orderid, C.CustomerCompanyName, C.CustomerContactName,C.CustomerContactTitle,concat
	(C.CustomerCity, ', ', C.CustomerCountry) as [City, Country],C.CustomerPhoneNumber
from [HumanResources].[Employee] as E
	inner join [Sales].[Order] as O
		on E.EmployeeID = O.EmployeeId 
	inner join  [sales].[customer] as C
		on O.customerId = C.customerId
group by E.EmployeeId, [dbo].getFullName(E. EmployeeFirstName, E.EmployeeLastName),
	O.orderid, C.CustomerCompanyName, C.CustomerContactName,C.CustomerContactTitle,concat
	(C.CustomerCity, ', ', C.CustomerCountry), C.CustomerPhoneNumber
order by E.EmployeeId 
for json path,root('EmployeesAndOrderIDsAndCustomerInfo')


--36
-- listing all customers with their other orders made in the year 2016 and total price they 
-- are paying per order.

drop function if exists [dbo].totalDiscoutedPrice
go
create function [dbo].totalDiscountedPrice(@unitPrice decimal(7,2), @qty int, @discount decimal(4,3))
returns decimal(7,2)
as 
begin 
	declare @result decimal(7,2)
	set @result = (@unitPrice * @qty) - (@unitPrice * @qty*@discount)
return @result
end;
go 
-------
select C.customerId, C.CustomerCompanyName,concat(C.CustomerCity,C.CustomerCountry) as Location,
	O.orderId, O.OrderDate, OD.ProductId,OD.UnitPrice,OD.Quantity, OD.DiscountPercentage,
	[dbo].totalDiscountedPrice(OD.UnitPrice,OD.Quantity, OD.DiscountPercentage) as TotalDiscountedPrice
from [sales].[customer] as C
	inner join [sales].[order] as O
		on C.customerId = O.customerId
	inner join [sales].[OrderDetail] as OD 
		on O.orderId = OD.orderId
where year(O.orderdate) = 2016
group by C.customerId, C.CustomerCompanyName,concat(C.CustomerCity,C.CustomerCountry),
	O.orderId, O.OrderDate, OD.ProductId,OD.UnitPrice,OD.Quantity, OD.[DiscountPercentage],
	[dbo].totalDiscountedPrice(OD.UnitPrice,OD.Quantity, OD.DiscountPercentage)
order by orderdate desc



--37
-- listing all employees who helped the orders made in 2016 and their total sales. 
-- tables: [[HumanResources].[Employee], [Sales].[Order] and [Sales].[OrderDetail]

use Northwinds2019TSQLV5;

select E.employeeID,[dbo].getFullName(E.EmployeeFirstName,E.EmployeeLastName) as [Full Name],
	O.orderid, O.OrderDate, OD.ProductId,OD.UnitPrice,OD.Quantity, OD.DiscountPercentage,
	[dbo].totalDiscountedPrice(OD.UnitPrice,OD.Quantity, OD.DiscountPercentage) as TotalSalesAfterDiscount
from [HumanResources].[Employee] as E
	inner join [Sales].[Order] as O
		on E.EmployeeId = O.EmployeeId
	inner join [Sales].[OrderDetail] as OD
		on O.orderid = OD.orderid
where year(O.OrderDate) = 2016
group by E.employeeID,[dbo].getFullName(E.EmployeeFirstName,E.EmployeeLastName),
	O.orderid, O.OrderDate, OD.ProductId,OD.UnitPrice,OD.Quantity, OD.DiscountPercentage,
	[dbo].totalDiscountedPrice(OD.UnitPrice,OD.Quantity, OD.DiscountPercentage) 
order by orderdate desc
 

--38
-- listing all the orders and their travel from prodution to customer in 2016.
-- tables: [Production].[Supplier],[Production].[Product],[Sales].[Order] and [Sales].[Customer]

use Northwinds2019TSQLV5;

select S.SupplierId, S.SupplierCompanyName, [Location] = concat(S.SupplierCity,', ', S.SupplierCountry),
		P.ProductId,P.ProductName,
		O.OrderId, O.OrderDate, C.CustomerCompanyName,
		[Location] = concat(C.CustomerCity,', ',CustomerCountry)
from [Production].[Supplier] as S
		inner join [Production].[Product] as P
			on S.SupplierId = P.SupplierId
		inner join [Sales].[Order] as O
			on P.SupplierId = O.ShipperId
		inner join [Sales].[Customer] as C
			on C.CustomerId = O.CustomerId 
where year(O.orderdate) = 2016
group by S.SupplierId, S.SupplierCompanyName,concat(S.SupplierCity,', ', S.SupplierCountry),
		 P.ProductId,P.ProductName,
		 O.OrderId, O.OrderDate, C.CustomerCompanyName,concat(C.CustomerCity,', ',CustomerCountry)
order by O.orderdate desc


--39
-- listing all customer company of USA with their shipping address and their total amount.
-- tables: [sales].[Customer], [sales].[order] and  [sales].[orderdetail]

use Northwinds2019TSQLV5

---used function for the below query ------ 
drop function if exists [dbo].totalDiscoutedPrice
go
create function [dbo].totalDiscountedPrice(@unitPrice decimal(7,2), @qty int, @discount decimal(4,3))
returns decimal(7,2)
as 
begin 
	declare @result decimal(7,2)
	set @result = (@unitPrice * @qty) - (@unitPrice * @qty*@discount)
return @result
end;
go 
--------------------
select C.CustomerCompanyName,
		[Shipping Address] = 
		concat (O.ShiptoAddress,', ', O.ShipToCity, ', ', O.ShipToRegion,' ',  O.ShipToPostalCode) ,
		O.orderid, O.orderdate,
		OD.UnitPrice,OD.Quantity,[dbo].totalDiscountedPrice(OD.UnitPrice,OD.Quantity,OD.DiscountPercentage)
		as TotalSales
from [Sales].[Customer] as C
	inner join [Sales].[Order] as O
		on C.CustomerId = O.CustomerId
	inner join [sales].[OrderDetail] as OD
		on O.OrderId = OD.OrderId
where ShipToCountry like N'USA'
group by C.CustomerCompanyName,
		concat (O.ShiptoAddress,', ', O.ShipToCity, ', ', O.ShipToRegion,' ',  O.ShipToPostalCode) ,
		O.orderid, O.orderdate,
		OD.UnitPrice,OD.Quantity,[dbo].totalDiscountedPrice(OD.UnitPrice,OD.Quantity,OD.DiscountPercentage) 
order by orderdate desc
for json path,root('CustomerCompanyWithOrderDetails_USA')

--40
-- listing all the employees and customers with their full address along with their orders and order dates. 
-- tables: [HumanResources].[Employee],[sales].[order] and [sales].[Customer]

use Northwinds2019TSQLV5;
go

drop function if exists [dbo].getLocation
create function [dbo].getLocation(@add1 nvarchar(100), @city nvarchar(50), 
								   @region nvarchar(4), @zipcode nvarchar(5),
								   @country nvarchar(50))
returns nvarchar(250)
as 
begin
declare @result nvarchar(250)
set @result = concat(@add1,', ', @city,', ',@region,', ', @zipcode,', ',@country)
return @result
end;
go 

select [dbo].getFullName(E.EmployeeFirstName,E.EmployeeLastName) as [Employee Full Name],
	   [dbo].getLocation(E.EmployeeAddress,E.EmployeeCity,E.EmployeeRegion,E.EmployeePostalCode,E.EmployeeCountry)
	   as [Employee Full Address],
	   O.OrderId, O.OrderDate,
	   C.CustomerCompanyName,
	   [dbo].getLocation(C.CustomerAddress,C.CustomerCity,C.CustomerRegion, C.CustomerPostalCode,C.CustomerCountry)
	   as [Customer Full Address]

from [HumanResources].[Employee] as E
	inner join [sales].[order] as O
		on E.EmployeeId = O.EmployeeId
	inner join  [sales].[Customer] as C
		on O.CustomerId = C.CustomerId
where E.EmployeeCountry <> N'USA' and C.CustomerCountry <> N'USA'
group by [dbo].getFullName(E.EmployeeFirstName,E.EmployeeLastName),
	   [dbo].getLocation(E.EmployeeAddress,E.EmployeeCity,E.EmployeeRegion,E.EmployeePostalCode,E.EmployeeCountry),
	   O.OrderId, O.OrderDate,
	   C.CustomerCompanyName,
	   [dbo].getLocation(C.CustomerAddress,C.CustomerCity,C.CustomerRegion, C.CustomerPostalCode,C.CustomerCountry)
order by [Employee Full Name]

--41
--listing all shipping company with orderdates for orders and their expected delivery days to the customers
-- located in Seattle, USA of 2016


use Northwinds2019TSQLV5
--- this scalar function is implemented beloow---- 

drop function if exists [dbo].getDeliveryDays;
go
create function [dbo].getDeliveryDays(@orderdate date, @requiredDate date)
returns int
as 
begin 
declare @result int
set @result = datediff(day,@orderdate, @requiredDate)
return @result
end;
go
----

select S.ShipperId, S.ShipperCompanyName,
	 O.orderid, O.Orderdate, [dbo].getDeliveryDays( O.Orderdate,O.RequiredDate) as DaysToDelivery,
	 O.RequiredDate,
	 C.CustomerCompanyName,
	 [dbo].getLocation(C.CustomerAddress,C.CustomerCity,C.CustomerRegion,C.CustomerPostalCode,C.CustomerCountry)
	 as CustomerFullAddress
from [sales].[Shipper] as S
	inner join [Sales].[Order] as O
		on S.shipperId = O.shipperId
	inner join [sales].[Customer] as C
		on O.CustomerId = O.CustomerId
where C.CustomerCountry = N'USA' and year(O.OrderDate) = 2016 and C.customerCity like N'Seattle'
group by  S.ShipperId, S.ShipperCompanyName,
	 O.orderid, O.Orderdate, [dbo].getDeliveryDays( O.Orderdate,O.RequiredDate),
	 O.RequiredDate,
	 C.CustomerCompanyName,
	 [dbo].getLocation(C.CustomerAddress,C.CustomerCity,C.CustomerRegion,C.CustomerPostalCode,C.CustomerCountry)
order by S.ShipperId

--42
---
DROP FUNCTION IF exists sales.udf_GetTotalPrice
GO
CREATE FUNCTION Sales.udf_GetTotalPrice(
	@Quantity INT,
	@UnitPrice DEC(10,2),
	@DiscountPercentage DEC(4,2)
)
RETURNS DEC(10,2)
AS
BEGIN
	RETURN @quantity * @UnitPrice * (1 - @DiscountPercentage);
END;
GO
SELECT
	OD.OrderId,
	SUM(Sales.udf_GetTotalPrice(Quantity, UnitPrice, DiscountPercentage)) net_amount
FROM
	Sales.OrderDetail AS OD
GROUP BY
	OD.OrderId
ORDER BY
	net_amount DESC;


--43
---
/*DROP FUNCTION IF EXISTS dbo.GetCustOrders;
 GO
 */
 CREATE FUNCTION [dbo].[GetCustOrders] (
  @cid AS INT) 
 RETURNS TABLE AS RETURN  
SELECT Orderid, CustomerId, EmployeeId, orderdate, RequiredDate,   
  ShipToDate, shipperid, freight, ShipToName, ShipToAddress, ShipToCity,
  ShipToRegion, ShipToPostalCode, ShipToCountry  
 FROM [Sales].[Order]
WHERE CustomerId = @cid;
GO

-- Test Function
SELECT Orderid, CustomerId
FROM [dbo].[GetCustOrders](1) AS O;
SELECT O.orderid, O.CustomerId, OD.productid, OD.Quantity
FROM dbo.GetCustOrders(1) AS O
  INNER JOIN [Sales].[OrderDetail] AS OD
	ON O.orderid = OD.orderid;
GO
-- Cleanup
DROP FUNCTION IF EXISTS dbo.GetCustOrders;
GO


---------------------------------------------------------------------
 ---------------------------------------------------------------------


--44
-- Creation Script for the Function for TopOrders
DROP FUNCTION IF EXISTS dbo.TopOrders;
GO
CREATE FUNCTION dbo.TopOrders
  (@CustomerId AS INT, @n AS INT)
  RETURNS TABLE
AS
RETURN
  SELECT TOP (@n) orderid, EmployeeId, orderdate, requireddate
  FROM [Sales].[Order]
  WHERE CustomerId = @CustomerId
  ORDER BY orderdate DESC, orderid DESC;
GO
SELECT
  C.CustomerId, C.CustomerCompanyName,
  A.orderid, A.EmployeeId, A.orderdate, A.requireddate
FROM [Sales].[Customer] AS C
  CROSS APPLY dbo.TopOrders(C.CustomerId, 3) AS A;
  ---------------------------------------------------------------------



--45
-- The INTERSECT Distinct Set Operator
SELECT EmployeeCountry, EmployeeRegion, EmployeeCity FROM [HumanResources].[Employee]
INTERSECT
SELECT CustomerCountry, CustomerRegion, CustomerCity FROM [Sales].[Customer];
-- The INTERSECT ALL Multiset Operator (Optional, Advanced)
SELECT
  ROW_NUMBER()
	OVER(PARTITION BY EmployeeCountry, EmployeeRegion, EmployeeCity
     	ORDER 	BY (SELECT 0)) AS rownum,
   EmployeeCountry, EmployeeRegion, EmployeeCity
FROM [HumanResources].[Employee]
INTERSECT
SELECT
  ROW_NUMBER()
	OVER(PARTITION BY CustomerCountry, CustomerRegion, CustomerCity
     	ORDER 	BY (SELECT 0)),
CustomerCountry, CustomerRegion, CustomerCity
FROM [Sales].[Customer];
WITH INTERSECT_ALL
AS
(
  SELECT
	ROW_NUMBER()
  	OVER(PARTITION BY EmployeeCountry, EmployeeRegion, EmployeeCity
       	ORDER   BY (SELECT 0)) AS rownum,
   EmployeeCountry, EmployeeRegion, EmployeeCity
  FROM [HumanResources].[Employee]
  INTERSECT
  SELECT
	ROW_NUMBER()
  	OVER(PARTITION BY CustomerCountry, CustomerRegion, CustomerCity
       	ORDER BY (SELECT 0)),
CustomerCountry, CustomerRegion, CustomerCity
  FROM [Sales].[Customer]
)
SELECT EmployeeCountry, EmployeeRegion, EmployeeCity
FROM INTERSECT_ALL;


--46
-- total units ordered for each product
	DROP FUNCTION IF EXISTS [dbo].[isPopular]
GO
	create function isPopular(@orders INT)
returns NVARCHAR
AS
BEGIN
    	declare @qualifyTag NVARCHAR;
    	select @qualifyTag = case
    	when @orders > 500 then 'Yes'
    	else 'No'
	end;
    	return @qualifyTag
	END
GO
	select p.ProductName, sum(od.Quantity) totalUnitsOrdered, [dbo].[isPopular](sum(od.Quantity)) as isPopular
	from Production.Product as p
    	inner join
    	Production.Supplier as s
    	on p.SupplierId = s.SupplierId
    	inner join
    	sales.[OrderDetail] as od
    	on p.ProductId = od.ProductId
	group by p.ProductName


--47
-- listing all customers with their other orders made in the year 2014 and total price they
-- are paying per order.
DROP FUNCTION IF exists [dbo].[totalDiscouted]
GO
CREATE FUNCTION [dbo].[totalDiscounted] (
 @unitPrice DECIMAL(7,2),
 @qty INT,
 @discount DECIMAL(4,3))
RETURNS DECIMAL (7,2)
AS
BEGIN
 declare @result decimal(7,2)
 set @result = (@unitPrice * @qty) - (@unitPrice * @qty*@discount)
return @result
end;
go
-------
SELECT C.customerId, C.CustomerCompanyName,
 CONCAT(C.CustomerCity,C.CustomerCountry) AS Location,
 O.orderId, O.OrderDate, OD.ProductId,OD.UnitPrice,
 OD.Quantity, OD.DiscountPercentage,
 dbo.totalDiscounted(OD.UnitPrice,OD.Quantity, OD.DiscountPercentage) AS TotalDiscounted
FROM [sales].[customer] AS C
 INNER JOIN [sales].[order] AS O
  ON C.customerId = O.customerId
 INNER JOIN [sales].[OrderDetail] AS OD
  on O.orderId = OD.orderId
WHERE YEAR (O.orderdate) = 2015
GROUP BY C.customerId, C.CustomerCompanyName,CONCAT(C.CustomerCity,C.CustomerCountry),
 O.orderId, O.OrderDate, OD.ProductId,OD.UnitPrice,OD.Quantity, OD.[DiscountPercentage],
 dbo.totalDiscounted(OD.UnitPrice,OD.Quantity, OD.DiscountPercentage)
ORDER BY orderdate desc
-- Cleanup
DROP FUNCTION IF EXISTS dbo.totalDiscounted;
GO


--48
SELECT
YEAR(o.OrderDate) as [Sales Year],
MONTH(o.OrderDate) as [Sales Month],
SUM(
 case when c.CategoryId = 1 then o.Freight else 0 end) AS [Dispenser Sales],
SUM(
 case when c.CategoryId = 2 then o.Freight else 0 end) AS [Refill Sales]
FROM [Sales].[Order] o
join [Sales].[OrderDetail] od on o.OrderId = od.OrderId
join [Production].[Product] s on s.ProductId = od.ProductId
join [Production].[Category] c on c.CategoryId = s.CategoryId
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate)
ORDER BY YEAR(o.OrderDate), MONTH(o.OrderDate)

DROP PROC IF EXISTS Sales.GetCustomerOrders;
GO
CREATE PROC Sales.GetCustomerOrders
  @custid   AS INT,
  @fromdate AS DATETIME = '19000101',
  @todate   AS DATETIME = '99991231',
  @numrows  AS INT OUTPUT
AS
SET NOCOUNT ON;
SELECT OrderId, CustomerId, EmployeeId, OrderDate
FROM [Sales].[Order]
WHERE CustomerId = @custid
  AND OrderDate >= @fromdate
  AND OrderDate < @todate;
SET @numrows = @@rowcount;
GO
DECLARE @rc AS INT;
EXEC Sales.GetCustomerOrders
  @custid   = 1, -- Also try with 100
  @fromdate = '20150101',
  @todate   = '20160101',
  @numrows  = @rc OUTPUT;
SELECT @rc AS numrows;
GO

DROP FUNCTION IF EXISTS dbo.GetAge;
GO
CREATE FUNCTION dbo.GetAge
(
  @birthdate AS DATE,
  @eventdate AS DATE
)
RETURNS INT
AS
BEGIN
  RETURN
	DATEDIFF(year, @birthdate, @eventdate)
	- CASE WHEN 100 * MONTH(@eventdate) + DAY(@eventdate)
          	< 100 * MONTH(@birthdate) + DAY(@birthdate)
       	THEN 1 ELSE 0
  	END;
END;
GO
-- Test function
SELECT
  EmployeeId, EmployeeFirstName, EmployeeLastName, BirthDate,
  dbo.GetAge(birthdate, '20160212') AS age
FROM [HumanResources].[Employee]

-- Complex 06
DROP FUNCTION IF EXISTS dbo.TopProducts;
GO
CREATE FUNCTION dbo.TopProducts
  (@ProductId AS INT,
  @n AS INT)
  RETURNS TABLE
AS
RETURN
  SELECT TOP (@n) orderid, UnitPrice, Quantity
  FROM [Sales].[OrderDetail]
  WHERE ProductId = @ProductId
  ORDER BY UnitPrice DESC, orderid DESC;
GO
