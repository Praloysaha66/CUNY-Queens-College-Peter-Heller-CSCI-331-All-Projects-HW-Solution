import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class BestMediumQuery {

	public static void main(String[] args) {
		try {

			//1. connecting to the database
			Connection myConnection = DriverManager.getConnection(
					"jdbc:sqlserver://localhost:12001;database=AdventureWorks2014;user=sa;password=PH@123456789;");

			//2. Create  a Statement
			Statement myStatement = myConnection.createStatement();

			//3.Execute SQL query
			ResultSet myResult = myStatement.executeQuery("SELECT \r\n" + 
					"	COUNT(OD.ProductID) [Count], \r\n" + 
					"	OD.ProductID, PP.[Name],\r\n" + 
					"	SUM(LineTotal) TotalSale,PRP.Rating, PRP.ReviewerName, PRP.Comments\r\n" + 
					"	FROM Sales.SalesOrderDetail  AS OD\r\n" + 
					"	JOIN Production.Product AS PP\r\n" + 
					"	   ON PP.ProductID = OD.ProductID\r\n" + 
					"	JOIN Production.ProductReview AS PRP\r\n" + 
					"	   ON PRP.ProductID = PP.ProductID\r\n" + 
					"	GROUP BY OD.ProductID,\r\n" + 
					"	PP.[Name],\r\n" + 
					"	PRP.Rating, PRP.ReviewerName, PRP.Comments");

			//4.Process the result set
			while (myResult.next()) {
				System.out.println(
						"Count: "+ myResult.getString("Count")+ " "+ "\n"+ "ProductId: "+ myResult.getString("ProductID")
						+ " "+ "\n"+ "Name: "+ myResult.getString("Name")+ " "+ "\n"+"TotalSale: "+ myResult.getString("TotalSale")
						+ " "+ "\n"+ "Rating: "+ myResult.getString("Rating")+ " "+ "\n"+ "ReviewerName: "+ myResult.getString("ReviewerName")
						+ " "+ "\n"+ "Comments: "+ myResult.getString("Comments") + "\n");
			}
			System.out.println("Connected to Microsoft SQL Server");


		} catch (SQLException e) {
			System.out.println("Oops, there's an error:");
			e.printStackTrace();
		}

	}
}