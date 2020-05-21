1. Durga
use Northwinds2019TSQLV5​
select CustomerId​
, CustomerCompanyName​
, CustomerContactName​
, CustomerContactTitle​
, CustomerCountry​
, CustomerPhoneNumber​
from [Sales].[Customer]
where customerCountry = N'USA';

2. Abida
use [Northwinds2019TSQLV5]​
SELECT C.CustomerId, C.CustomerCompanyName, O.OrderId, OD.productid, OD.Quantity ​
FROM Sales.Customer AS C  ​
INNER JOIN [Sales].[Order] AS O ​
ON C.CustomerId = O.CustomerId​
INNER JOIN Sales.OrderDetail AS OD ​
ON O.orderid = OD.orderid;

3. Jerry
USE NORTHWINDS2019TSQLV5​
SELECT CustomerCompanyName,CustomerContactName,CustomerCity,CustomerRegion,CustomerCountry, ​
concat(CustomerCountry,',', CASE WHEN Customerregion IS NULL THEN 'NULL,'​
ELSE concat(CustomerRegion,',')End,CustomerCity)AS LOCATION​
FROM Sales.Customer

4. Naeim
use [AdventureWorks2014]
SELECT p.ProductID​
,p.Name​
,count(th.ProductID) AS transactionCount​
FROM Production.Product AS p​
LEFT OUTER JOIN production.TransactionHistory AS th​
ON p.ProductID = th.ProductID​
GROUP BY p.ProductID, p.Name

5. Praloy
use Northwinds2019TSQLV5​
SELECT C.CustomerId,
       C.CustomerCompanyName, ​
       O.orderid, ​
       O.orderdate​
FROM   [Sales].[Customer] AS C​
       LEFT OUTER JOIN ​
       [Sales].[Order] AS O​
       ON O.CustomerId = C.CustomerId​
       AND O.orderdate between '20160212' and '20160312'​
where O.OrderId is not null​

6. Seth
USE Northwinds2019TSQLV5​​
SELECT TOP 10 SUM(BPS.HomeRun) AS [Home Runs]​
,BPS.playerID​
        from Example.BaseballPlayerBattingStatistics AS BPS​
GROUP BY BPS.playerID​
ORDER BY [Home Runs] DESC;

7. Timmy
Use Northwinds2019TSQLV5​​
SELECT nameGiven AS PlayerName, NumberAtBat, Hits, HomeRun​
FROM Example.ProfessionalBaseballPlayer AS BP​
inner join Example.BaseballPlayerBattingStatistics AS BPBS​
ON BPBS.playerID = BP.playerid​
WHERE HomeRun = Hits AND Hits = NumberAtBat AND Hits > 0















