import java.sql.*;

public class SimpleFix {

	public static void main(String[] args) {
		try {
			// 1. Get connection to database
			Connection myconn = DriverManager.getConnection(
					"jdbc:sqlserver://localhost:12001;database=AdventureWorks2014;user=sa;password=MyStrongP@ssword;");
			// 2. Create a statement
			Statement mystmnt = myconn.createStatement();
			// 3. Execute SQL query
			ResultSet myrs = mystmnt.executeQuery(
					"select e.NationalIDNumber, e.BirthDate, datediff(day, e.BirthDate, SYSDATETIME())/365.25 as age,​\n"
							+ "\n"
							+ "year(DATEADD(year, 65-datediff(day, e.BirthDate, SYSDATETIME())/365.25, SYSDATETIME())) as retirementYear,​\n"
							+ "\n" + "case ​\n" + "\n"
							+ "when datediff(year, e.BirthDate, SYSDATETIME()) >= 65 then concat('Eligible ', datediff(day, e.BirthDate, SYSDATETIME())/365.25-65, ' years ago!')​\n"
							+ "\n"
							+ "else concat('Elegible in ', 65-datediff(day, e.BirthDate, SYSDATETIME())/365.25, ' years from now. . .')​\n"
							+ "\n" + "end as retirementStatus​\n" + "\n" + "from HumanResources.Employee as e​\n" + "\n"
							+ "order by retirementYear;​\n" + "\n" + "​");
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
