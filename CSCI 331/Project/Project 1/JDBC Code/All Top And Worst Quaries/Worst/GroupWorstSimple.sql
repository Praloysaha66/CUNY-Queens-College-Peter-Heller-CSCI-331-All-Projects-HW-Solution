-----------------------------------------------------------------------------Worst Medium-------------------------------------------

--Timmy
--Medium Query 6: Returns products starting sell date, selling end date, price,
	-- location, quantity available, cost to make, and the profit made per quantity.
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


--Seth
--For numbers less than one thousand, determine if they are more, less
--than, or exactly halfway to one thousand
use Northwinds2019TSQLV5

select myNum = (tenths.digit + Hundreths.digit * 10 + Thousanths.digit * 100),

valueCategory = case

when tenths.digit + Hundreths.digit * 10+
Thousanths.digit * 100 < 500 then 'less than halfway'

when tenths.digit + Hundreths.digit * 10+
Thousanths.digit * 100 > 500 then 'more than halfway'

else 'half'

end

from (dbo.Digits as tenths

cross join

dbo.Digits as Hundreths

cross join

dbo.Digits as Thousanths)

order by myNum

--for json path, root(‘Seth Marcus Moderate Query 02’)

--praloy
--Proposition: List top 100 customers who placed order in 2015
Use Northwinds2019TSQLV5

Go

SELECT Top(100) C.CustomerId,

C.CustomerCompanyName,

O.OrderId,

CONVERT(VARCHAR(10), CAST(o.OrderDate AS DATE), 101) as ModifiedDate,

CONCAT(c.CustomerAddress, c.CustomerCity, c.CustomerPostalCode) as address

FROM

[Sales].[Customer] AS C

INNER JOIN

[Sales].[Order] AS O

ON C.CustomerId= O.CustomerId

WHERE

O.orderdate >= '20150101' and o.orderdate < '20160101'

Order By

C.CustomerCompanyName, o.OrderDate asc;


--Naiem
--Proposition - listing all customers with order details 
use Northwinds2019TSQLV5;​

select  C.CustomerId​

,   C.CustomerCompanyName ​

,   O.OrderId​

,   OD.ProductId​

,   OD.UnitPrice​

,  OD.Quantity​

,   OD.DiscountPercentage​

from [sales].[customer] as C​

     inner join [sales].[order] as O​

          on C.CustomerId = O.CustomerId​

     inner join [sales].[OrderDetail] as OD​

         on O.OrderId =OD.OrderId​

group by C.customerID,C.customerCompanyName,​

               O.OrderId,OD.ProductId,OD.UnitPrice,​

              OD.Quantity, OD.DiscountPercentage​

​--Jerry
--Proposition - Using Northwinds2019TSQLV5 database and create a query calculates the hired age of all the employee​
USE Northwinds2019TSQLV5
SELECT E.employeeid, E.employeefirstname, E.employeelastname, datediff(Year,
max(E.birthdate), E.hiredate) as Age
from Sales.[Order] as o
inner join Sales.OrderDetail as od
on od.OrderId = o.OrderId
inner join HumanResources.Employee as e
on e.EmployeeId = o.EmployeeId
group by E.employeeid ,year(o.OrderDate), e.EmployeeFirstName,
e.EmployeeLastName,e.hiredate
For json path,root(&#39;Hired Age&#39;)


--Durga
--Proposition - listing all customers with order details ​
use Northwinds2019TSQLV5;​

select  C.CustomerId​

,   C.CustomerCompanyName ​

,   O.OrderId​

,   OD.ProductId​

,   OD.UnitPrice​

,  OD.Quantity​

,   OD.DiscountPercentage​

from [sales].[customer] as C​

     inner join [sales].[order] as O​

          on C.CustomerId = O.CustomerId​

     inner join [sales].[OrderDetail] as OD​

         on O.OrderId =OD.OrderId​

group by C.customerID,C.customerCompanyName,​

               O.OrderId,OD.ProductId,OD.UnitPrice,​

              OD.Quantity, OD.DiscountPercentage​

​
--Abida
--Proposition – displaying the employee's phone number and type and last name that all starts with "c"​
use AdventureWorks2014;​

-- tables: [person].[person], [person].[personPhone] and [person].[phoneNumberType]​

SELECT   P.FirstName, P.LastName,​

         PP.PhoneNumber, PT.Name as PhoneType​

FROM     Person.Person AS P​

         INNER JOIN​

         Person.PersonPhone AS PP​

         ON P.BusinessEntityID = PP.BusinessEntityID​

         INNER JOIN​

         Person.PhoneNumberType AS PT​

         ON PP.PhoneNumberTypeID = PT.PhoneNumberTypeID​

WHERE    P.LastName LIKE 'C%'​

ORDER BY P.LastName​

