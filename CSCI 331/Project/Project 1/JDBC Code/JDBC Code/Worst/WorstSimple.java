//Naiem Gafer
//Proposition - The retirement status of all employees, assuming that the age for retirement is 65.

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class WorstSimple {
	public static void main(String[] args) {
		try {
			//1. connecting to the database
			Connection myConnection = DriverManager.getConnection(
					"jdbc:sqlserver://localhost:12001;databaseName=AdventureWorks2014;user=sa;password=PH@123456789;");
			//2. Create  a Statement
			Statement myStatement = myConnection.createStatement();
			//3.Execute SQL query
			ResultSet myResult = myStatement.executeQuery("SELECT e.NationalIDNumber​\r\n" + 
					",e.BirthDate​\r\n" + 
					",datediff(year, e.BirthDate, SYSDATETIME()) AS age​\r\n" + 
					",year(DATEADD(year, 65 - datediff(year, e.BirthDate, SYSDATETIME()), SYSDATETIME())) AS retirementYear​\r\n" +
					",CASE ​\r\n" + 
					"WHEN datediff(year, e.BirthDate, SYSDATETIME()) >= 65​\r\n" + 
					"THEN 'Eligible'​\r\n" +
					"ELSE 'Not Eligible'​\r\n" + 
					"END AS retirementStatus​\r\n" + 
					"FROM HumanResources.Employee AS e​\r\n" + 
					"ORDER BY retirementYear​​");
			//4.Process the result set
			while (myResult.next()) {
				System.out.println(
						"NationalIDNumber: "+ myResult.getString("NationalIDNumber")
						+"\t BirthDate: "+myResult.getString("BirthDate")
						+"\t age​: "+ myResult.getString("age")
						+"\t retirementYear: "+ myResult.getString("retirementYear")
						+"\t retirementStatus: "+ myResult.getString("retirementStatus"));
			}
			System.out.println("Connected to Microsoft SQL Server");

		} catch (SQLException e) {
			System.out.println("Oops, there's an error:");
			e.printStackTrace();
		}
	}

}
