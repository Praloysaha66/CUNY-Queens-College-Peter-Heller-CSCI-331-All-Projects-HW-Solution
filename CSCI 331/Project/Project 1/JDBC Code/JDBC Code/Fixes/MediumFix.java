import java.sql.*;

public class MediumFix {

	public static void main(String[] args) {
		try {
			// 1. Get connection to database
			Connection myconn = DriverManager.getConnection(
					"jdbc:sqlserver://localhost:12001;database=AdventureWorks2014;user=sa;password=MyStrongP@ssword;");
			// 2. Create a statement
			Statement mystmnt = myconn.createStatement();
			// 3. Execute SQL query
			ResultSet myrs = mystmnt.executeQuery(
					"-- tables: [person].[person], [person].[personPhone] and [person].[phoneNumberType]​\n" + "\n"
							+ "SELECT   P.FirstName, P.LastName,​\n" + "\n"
							+ "         PP.PhoneNumber, PT.Name as PhoneType​\n" + "\n"
							+ "FROM     Person.Person AS P​\n" + "\n" + "         INNER JOIN​\n" + "\n"
							+ "         Person.PersonPhone AS PP​\n" + "\n"
							+ "         ON P.BusinessEntityID = PP.BusinessEntityID​\n" + "\n"
							+ "         INNER JOIN​\n" + "\n" + "         Person.PhoneNumberType AS PT​\n" + "\n"
							+ "         ON PP.PhoneNumberTypeID = PT.PhoneNumberTypeID​\n" + "\n"
							+ "WHERE    P.LastName LIKE 'C%'​\n" + "\n" + "ORDER BY P.LastName​\n" + "\n" + "​");
			// 6. Process the result set
			ResultSetMetaData rsmd = myrs.getMetaData();
			int columnsNumber = rsmd.getColumnCount();

			while (myrs.next()) {
				for (int i = 1; i <= columnsNumber; i++) {
					if (i > 1)
						System.out.print(", ");
					String columnValue = myrs.getString(i);
					System.out.print(rsmd.getColumnName(i) + ": " + columnValue);
				}
				System.out.println("");
			}

		} catch (Exception exc) {
			exc.printStackTrace();
		}
	}

}
