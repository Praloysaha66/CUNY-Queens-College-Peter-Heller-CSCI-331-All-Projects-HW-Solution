import java.sql.*;

public class ComplexFix {

	public static void main(String[] args) {
		try {
			// 1. Get connection to database
			Connection myconn = DriverManager.getConnection(
					"jdbc:sqlserver://localhost:12001;database=Northwinds2019TSQLV5;user=sa;password=MyStrongP@ssword;");
			// 2. Create a statement
			Statement mystmnt = myconn.createStatement();
			// 3. Execute SQL Code to remove function if it already exists
			mystmnt.executeUpdate("drop function if exists [dbo].[getFullName];​");
			mystmnt.executeUpdate("drop function if exists [dbo].[totalDiscountedPrice];​​");
			// 4. Execute SQL Code to create the function
			mystmnt.executeUpdate("create function [dbo].[getFullName](@first nvarchar(100), @last nvarchar(100))​\n"
					+ "\n" + "returns nvarchar(100)​\n" + "\n" + "as ​\n" + "\n" + "begin​\n" + "\n"
					+ "declare @fullname nvarchar(200)​\n" + "\n" + "set @fullname = concat(@last,', ', @first )​\n"
					+ "\n" + "return @fullname​\n" + "\n" + "end;​");
			mystmnt.executeUpdate(
					"create function [dbo].[totalDiscountedPrice](@unitPrice decimal(7,2), @qty int, @discount decimal(4,3))​\n"
							+ "\n" + "returns decimal(7,2)​\n" + "\n" + "as ​\n" + "\n" + "begin ​\n" + "\n"
							+ "declare @result decimal(7,2)​\n" + "\n"
							+ "set @result = (@unitPrice * @qty) - (@unitPrice * @qty*@discount)​\n" + "\n"
							+ "return @result​\n" + "\n" + "end;​");
			// 5. Execute SQL query to call the function and do other things
			ResultSet myrs = mystmnt.executeQuery("select E.employeeID​\n" + "\n"
					+ ",   [dbo].getFullName(E.EmployeeFirstName,E.EmployeeLastName) as FullName\n" + "\n"
					+ ",   O.orderid​\n" + "\n" + ",   O.OrderDate​\n" + "\n" + ",   OD.ProductId​\n" + "\n"
					+ ",   OD.UnitPrice​\n" + "\n" + ",   OD.Quantity​\n" + "\n" + ",   OD.DiscountPercentage​\n" + "\n"
					+ ",   [dbo].totalDiscountedPrice(OD.UnitPrice,OD.Quantity, OD.DiscountPercentage) as TotalSalesAfterDiscount​\n"
					+ "\n" + "from [HumanResources].[Employee] as E​\n" + "\n" + "  inner join [Sales].[Order] as O​\n"
					+ "\n" + "      on E.EmployeeId = O.EmployeeId​\n" + "\n"
					+ "  inner join [Sales].[OrderDetail] as OD​\n" + "\n" + "      on O.orderid = OD.orderid​\n" + "\n"
					+ "where year(O.OrderDate) = 2016 and month(O.orderdate) = 1​\n" + "\n"
					+ "group by E.employeeID, [dbo].getFullName(E.EmployeeFirstName,E.EmployeeLastName),​\n" + "\n"
					+ "               O.orderid, O.OrderDate, OD.ProductId,OD.UnitPrice,​\n" + "\n"
					+ "               OD.Quantity,OD.DiscountPercentage​\n" + "\n" + "order by orderdate desc​\n" + "\n"
					+ "​​");
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
