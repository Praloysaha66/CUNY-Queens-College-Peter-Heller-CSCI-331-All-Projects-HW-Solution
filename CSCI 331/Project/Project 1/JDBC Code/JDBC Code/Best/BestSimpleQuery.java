//Timmy
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class BestSimpleQuery {

	public static void main(String[] args) {
		try {

			//1. connecting to the database
			Connection myConnection = DriverManager.getConnection(
					"jdbc:sqlserver://localhost:12001;database=Northwinds2019TSQLV5;user=sa;password=PH@123456789;");

			//2. Create  a Statement
			Statement myStatement = myConnection.createStatement();

			//3.Execute SQL query
			ResultSet myResult = myStatement.executeQuery("SELECT nameGiven AS PlayerName, NumberAtBat, Hits, HomeRun​\r\n" + 
					"FROM Example.ProfessionalBaseballPlayer AS BP​\r\n" + 
					"inner join Example.BaseballPlayerBattingStatistics AS BPBS​\r\n" + 
					"ON BPBS.playerID = BP.playerid​\r\n" + 
					"WHERE HomeRun = Hits AND Hits = NumberAtBat AND Hits > 0");

			//4.Process the result set
			while (myResult.next()) {
				System.out.println(
						"Player Name: "+ myResult.getString("PlayerName")+ " "+ "\t NumberAtBat: "+ myResult.getString("NumberAtBat")+ " "+ "\t Hits: "+ myResult.getString("Hits")+ " "+ "\t HomeRun: "+ myResult.getString("HomeRun"));
			}
			System.out.println("Connected to Microsoft SQL Server");


		} catch (SQLException e) {
			System.out.println("Oops, there's an error:");
			e.printStackTrace();
		}

	}
}