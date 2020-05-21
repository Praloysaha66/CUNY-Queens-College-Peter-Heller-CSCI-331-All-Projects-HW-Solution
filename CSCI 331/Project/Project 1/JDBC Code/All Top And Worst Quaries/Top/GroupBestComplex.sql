-- Best Complex Queries --



 ​
	Go   
	create function DaysOnMarket  
		(@SellStartDate AS DATE, @SellEndDate AS DATE)  
	returns INT AS                                  
	BEGIN
	RETURN DATEDIFF(day, @SellStartDate, @SellEndDate) 
	END;
	go  
	
	Use AdventureWorks2014;                            
	Select TOP(100) P.ProductID, P.SellStartDate, P.SellEndDate,	
	dbo.DaysOnMarket(P.SellStartDate,P.SellEndDate) As DaysOnMarket, P.ListPrice,
	LocationID_Bin = CONCAT(PI.LocationID, ' , ', PI.Bin), Sum(PI.Quantity) as Quantity,
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



	---------------------------------------------


	CREATE FUNCTION dbo.Profit​ (​
		@listPrice AS DECIMAL​
		,​ @standardCost AS decimal​​
		) ​​
		RETURNS int​ AS​ Begin​​
		​
		DECLARE @result money​​
		​
		Return​ cast((@listPrice - @standardCost) AS MONEY) ​ END;​
		​
		​ go​ ​​
		​
		SELECT CONCAT (​
		P.ProductName​
		,', '​
		,P.ProductId​
		) AS FullName​
		,C.CategoryName AS [Category Name]​
		,​ P.UnitPrice​
		,P.Discontinued​
		,dbo.Profit(P.UnitPrice, P.Discontinued) AS Savings​​
		FROM Production.Product AS P​​
		INNER JOIN Production.Category AS C​ ON C.CategoryID = P.ProductID​​
		INNER JOIN Production.Supplier AS H​ ON H.SupplierId = P.SupplierId​​
		ORDER BY Savings DESC​

		---------------------------------------------



		use TSQLV4;​

	IF OBJECT_ID(N'QuantityCheck', N'QC') IS NOT NULL​

	DROP FUNCTION QuantityCheck;​

	GO​

	 ​

	Alter function QuantityCheck(​

		@quantity INT​

		)​

	RETURNS VARCHAR(100)​

	AS​

	BEGIN​

		DECLARE @Answer VARCHAR(100)​

		IF(@quantity > 600)​

			BEGIN​

				SET @Answer = 'Surplus'​

			END​

		ELSE IF(@quantity >=400) and (@quantity <600)​

			BEGIN​

				SET @Answer = ' Above Equlibrium'​

			END​

		ELSE IF(@quantity >= 200) and (@quantity <400)​

			BEGIN​

				SET @Answer = 'Equlibrium'​

		END​

		ELSE IF(@quantity >=100) and (@quantity <200)​

			BEGIN​

				SET @Answer = 'Below Equlibrium'​

			END​

		ELSE​

			BEGIN​

				SET @Answer = 'Shortage'​

			END​

		RETURN @Answer​

		END​

	GO​

use TSQLV4;​
    select p.ProductName, avg(od.unitprice) AvgUnitPrice, sum(od.qty) TotalUnitsOrdered, [dbo].[QuantityCheck](sum(od.qty)) as SupplyAndDemond​
    from [Production].[Products] as P​
        inner join​
        [Production].[Suppliers] as S​
        on P.SupplierId = s.SupplierId​
        inner join​
        [Sales].[OrderDetails] as OD​
        on P.ProductId = od.ProductId​
		group by P.ProductName​

		ORDER BY​  P.productname ASC​

--for json path, root('Check supply and demonds'), include_null_values; ​


		---------------------------------------------


		CREATE FUNCTION message (​
				@numOrders INT​
				,@totalDiscount INT​
				)​
				RETURNS NVARCHAR(100)​
				AS​
				BEGIN​
				DECLARE @message NVARCHAR(100)​
				SET @message = CONCAT (​

				'Congrats! You have completed a total of '​
				,@numOrders​
				,' orders! Overall, your customers have saved $'​
				,@totalDiscount​
				,'.'​
				)​

				RETURN @message​

				END​

				GO​

	​Use Northwinds2014;
	SELECT e.EmployeeFirstName​

	,avg(d.TotalDiscountedAmount) AS avgDiscountOffered​

	,sum(eo.TotalDiscountedAmount) totalDiscountOffered​

	,sum(eo.TotalNumberOfOrders) AS numOrders​

	,[dbo].[message](sum(eo.TotalNumberOfOrders), sum(eo.TotalDiscountedAmount)) AS message​

	FROM HumanResources.Employee AS e​

	LEFT JOIN sales.uvw_OrderTotalQuantityAndTotalDiscountedAmount AS d ON d.EmployeeId = e.EmployeeId​

	INNER JOIN sales.uvw_EmployeeOrder AS eo ON e.EmployeeId = eo.EmployeeId​

	GROUP BY e.EmployeeFirstName​
 ​

		---------------------------------------------




Use Northwinds2019TSQLV5​

	drop function if exists dbo.pricecheck​

	go​

	create  FUNCTION dbo.pricecheck​

	(​

		@price int​

	)​

	RETURNS nvarchar(20)​

	AS​

	BEGIN​

		DECLARE @result nvarchar(20)​

		SET @result = CASE​

						WHEN @price > 2500    THEN 'High End Priced'​

						WHEN @price > 600  and @price < 2500 THEN 'Average Priced'​

						WHEN @price < 600    THEN 'Low Priced'​

						ELSE 'Missing Value'​

					  END​

		RETURN @Result​

	END​

	select o.OrderId,c.CustomerCompanyName, c.CustomerContactName, od.UnitPrice,(od.UnitPrice * od.Quantity) as OrderPrice,​
	dbo.pricecheck(od.UnitPrice * od.Quantity) as [Price Category]​
	from Sales.[Order] as o​
	inner join Sales.OrderDetail as od​
	on o.OrderId = od.OrderId​
	inner join  Sales.Customer as c ​
	on o.CustomerId = c.CustomerId​
	inner join Sales.Shipper as s​
	on o.ShipperId = s.ShipperId​
	order by OrderPrice Desc​

​​
	---------------------------------------------



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



---------------------------------------------


	use Northwinds2019TSQLV5;​	
		select C.customerId​
		,   C.CustomerCompanyName​
		,   concat(C.CustomerCity,C.CustomerCountry)  as Location​
		,   O.orderId​
		,   O.OrderDate​
		,   OD.ProductId​
		,   OD.UnitPrice​
		,   OD.Quantity​
		,   OD.DiscountPercentage​
		,   [dbo].totalDiscountedPrice(OD.UnitPrice,OD.Quantity, OD.DiscountPercentage)  as TotalDiscountedPrice​

		from [sales].[customer] as C​

			inner join [sales].[order] as O​

				on C.customerId = O.customerId​

			inner join [sales].[OrderDetail] as OD ​

				on O.orderId = OD.orderId​

		where year(O.orderdate) = 2016​

		group by C.customerId, C.CustomerCompanyName, concat(C.CustomerCity,C.CustomerCountry),O.orderId, O.OrderDate, OD.ProductId,OD.UnitPrice,​

				OD.Quantity, OD.DiscountPercentage​

		order by orderdate desc​

​