//Abida Chawdhury
//Proposition – displaying the employee's phone number and type and last name that all starts with "c"​

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class WorstMedium {
	public static void main(String[] args) {
		try {

			//1. connecting to the database
			Connection myConnection = DriverManager.getConnection(
					"jdbc:sqlserver://localhost:12001;databaseName=AdventureWorks2014;user=sa;password=PH@123456789;");

			//2. Create  a Statement
			Statement myStatement = myConnection.createStatement();

			//3.Execute SQL query
			ResultSet myResult = myStatement.executeQuery("SELECT   P.FirstName, P.LastName,​\r\n" + 
					"PP.PhoneNumber, PT.Name as PhoneType​\r\n" +
					"FROM     Person.Person AS P​\r\n" +
					"         INNER JOIN​\r\n" + 
					"         Person.PersonPhone AS PP​\r\n" + 
					"         ON P.BusinessEntityID = PP.BusinessEntityID​\r\n" + 
					"         INNER JOIN​\r\n" + 
					"         Person.PhoneNumberType AS PT​\r\n" + 
					"         ON PP.PhoneNumberTypeID = PT.PhoneNumberTypeID​\r\n" + 
					"WHERE    P.LastName LIKE 'C%'​\r\n" + 
					"ORDER BY P.LastName​");

			//4.Process the result set
			while (myResult.next()) {
				System.out.println(
						"FirstName: "+ myResult.getString("FirstName")
						+"\t LastName: "+myResult.getString("LastName")
						+"\t PhoneNumber: "+ myResult.getString("PhoneNumber")
						+"\t PhoneType : "+ myResult.getString("PhoneType"));
			}
			System.out.println("Connected to Microsoft SQL Server");


		} catch (SQLException e) {
			System.out.println("Oops, there's an error:");
			e.printStackTrace();
		}
	}

}
