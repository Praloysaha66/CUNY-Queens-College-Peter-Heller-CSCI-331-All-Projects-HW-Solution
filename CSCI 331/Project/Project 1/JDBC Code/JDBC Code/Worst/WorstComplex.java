//Durga Maharjan
//listing all employees who helped the orders and their total sales. 

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class WorstComplex {

	public static void main(String[] args) {
	
			try {
				//1. connecting to the database
				Connection myConnection = DriverManager.getConnection(
						"jdbc:sqlserver://localhost:12001;databaseName=Northwinds2019TSQLV5;user=sa;password=PH@123456789;");
				//2. Create  a Statement
				Statement myStatement = myConnection.createStatement();
				//3. dropping function if existed
				myStatement.executeUpdate("drop function if exists [dbo].[getFullName]");
				//4.creating funciton 
				myStatement.executeUpdate("create function [dbo].[getFullName](@first nvarchar(100), @last nvarchar(100))\r\n" + 
						"returns nvarchar(100)\r\n" + 
						"as \r\n" + 
						"begin\r\n" + 
						"declare @fullname nvarchar(200)\r\n" + 
						"set @fullname = concat(@last,', ', @first )\r\n" + 
						"return @fullname\r\n" + 
						"end;" );
				 //5. executing SQL query to drop function
				myStatement.executeUpdate("drop function if exists [dbo].[totalDiscountedPrice];\r\n");
				//6. excuting SQL query to create function
				myStatement.executeUpdate("create function [dbo].[totalDiscountedPrice]"
						+ "(@unitPrice decimal(7,2), @qty int, @discount decimal(4,3))\r\n" + 
						"returns decimal(7,2)\r\n" + 
						"as \r\n" + 
						"begin \r\n" + 
						"declare @result decimal(7,2)\r\n" + 
						"set @result = (@unitPrice * @qty) - (@unitPrice * @qty*@discount)\r\n" + 
						"return @result\r\n" + 
						"end;");

				//7.Execute SQL query
				ResultSet myResult = myStatement.executeQuery(
						"select E.employeeID,\r\n" + 
						"	[dbo].getFullName(E.EmployeeFirstName,E.EmployeeLastName) \r\n" + 
						"	as [Full Name], O.orderid, O.OrderDate, OD.ProductId,\r\n" + 
						"	OD.UnitPrice,OD.Quantity, 	OD.DiscountPercentage,\r\n" + 
						"	[dbo].totalDiscountedPrice\r\n" + 
						"	(OD.UnitPrice,OD.Quantity, OD.DiscountPercentage) as \r\n" + 
						"	TotalSalesAfterDiscount\r\n" + 
						"from [HumanResources].[Employee] as E\r\n" + 
						"	inner join [Sales].[Order] as O\r\n" + 
						"		on E.EmployeeId = O.EmployeeId\r\n" + 
						"inner join [Sales].[OrderDetail] as OD\r\n" + 
						"		on O.orderid = OD.orderid\r\n" + 
						"group by E.employeeID,\r\n" + 
						"	[dbo].getFullName(E.EmployeeFirstName,E.EmployeeLastName),\r\n" + 
						"	O.orderid, O.OrderDate, OD.ProductId,OD.UnitPrice,OD.Quantity, 	OD.DiscountPercentage,\r\n" + 
						"	[dbo].totalDiscountedPrice\r\n" + 
						"	(OD.UnitPrice,OD.Quantity, OD.DiscountPercentage) \r\n" + 
						"order by orderdate desc\r\n" + 
						"");

				//8.Process the result set
				while (myResult.next()) {
					System.out.println(
							"EmployeeID: "+ myResult.getString("employeeID")
							+"\t Full Name: "+myResult.getString("Full Name")
							+"\t orderid: "+ myResult.getString("orderid")
							+"\t ProductId: "+ myResult.getString("ProductId")
							+"\t UnitPrice: "+ myResult.getString("UnitPrice")
							+"\t Quantity: "+ myResult.getString("Quantity")
							+"\t DiscountPercentage: "+ myResult.getString("DiscountPercentage")
							+"\t TotalSalesAfterDiscount: "+ myResult.getString("TotalSalesAfterDiscount"));
				}
				System.out.println("Connected to Microsoft SQL Server");


			} catch (SQLException e) {
				System.out.println("Oops, there's an error:");
				e.printStackTrace();
			}
	
	}

}
