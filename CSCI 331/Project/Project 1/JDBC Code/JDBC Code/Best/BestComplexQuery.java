import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class BestComplexQuery {

	public static void main(String[] args) {
		try {

			//1. connecting to the database
			Connection myConnection = DriverManager.getConnection(
					"jdbc:sqlserver://localhost:12001;database=Northwinds2019TSQLV5;user=sa;password=PH@123456789;");

			//2. Create  a Statement
			Statement myStatement = myConnection.createStatement();
			
			//3. Execute SQL code to remove function if it already exists
			myStatement.executeUpdate("drop function if exists dbo.Profit");
			
			//4. Execute SQL code to create the function
			myStatement.executeUpdate("create function dbo.Profit(@listPrice as decimal, @standardCost as decimal)\r\n" + 
					"\r\n" + 
					"Returns int\r\n" + 
					"\r\n" + 
					"AS\r\n" + 
					"\r\n" + 
					"Begin\r\n" + 
					"\r\n" + 
					"declare @result money\r\n" + 
					"\r\n" + 
					"Return\r\n" + 
					"\r\n" + 
					"cast((@listPrice - @standardCost) as MONEY)\r\n" + 
					"\r\n" + 
					"end;");
			

			//5.Execute SQL query
			ResultSet myResult = myStatement.executeQuery("select concat(P.ProductName, ', ', P.ProductId) as FullName,\r\n" + 
					"\r\n" + 
					"C.CategoryName as [Category Name],\r\n" + 
					"\r\n" + 
					"P.UnitPrice, P.Discontinued, dbo.Profit(P.UnitPrice, P.Discontinued) as Savings\r\n" + 
					"\r\n" + 
					"from Production.Product as P\r\n" + 
					"\r\n" + 
					"inner join Production.Category as C\r\n" + 
					"\r\n" + 
					"on C.CategoryID = P.ProductID\r\n" + 
					"\r\n" + 
					"inner join Production.Supplier as H\r\n" + 
					"\r\n" + 
					"on H.SupplierId = P.SupplierId\r\n" + 
					"");

			//6.Process the result set
			while (myResult.next()) {
				System.out.println(
						"FullName: "+ myResult.getString("FullName")+ " "+ "\t Category Name: "+ myResult.getString("Category Name")
						+ " "+ "\t UnitPrice: "+ myResult.getString("UnitPrice")+ " "+ "\t Discontinued: "+ myResult.getString("Discontinued")
						+ " "+ "\t Savings: "+ myResult.getString("Savings"));
			}
			System.out.println("Connected to Microsoft SQL Server");


		} catch (SQLException e) {
			System.out.println("Oops, there's an error:");
			e.printStackTrace();
		}

	}
}