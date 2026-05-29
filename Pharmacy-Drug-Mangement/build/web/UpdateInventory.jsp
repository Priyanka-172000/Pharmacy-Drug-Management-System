<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Update Inventory</title>
</head>
<body>
<%@ page import="java.sql.*"%>
<%@ page import="javax.sql.*"%>
<%
int qt=Integer.parseInt(request.getParameter("restock"));
String prod=request.getParameter("pid");
HttpSession httpSession = request.getSession();
String guid=(String)httpSession.getAttribute("currentuser");
ResultSet rs=null;
Connection conn=null;
PreparedStatement ps=null;
String query="update inventory set quantity=quantity+? where sid=? and pid=?";
try{
	Class.forName("com.mysql.cj.jdbc.Driver");

	String url = "jdbc:mysql://localhost:3306/drugdatabase?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
	String user = "root";
	String pass = "Admin@123";

	conn = DriverManager.getConnection(url, user, pass);

	ps=conn.prepareStatement(query);
	ps.setInt(1,qt);
	ps.setString(2,guid);
	ps.setString(3,prod);
	int i=ps.executeUpdate();
	response.sendRedirect("AddInventory.jsp");
}
catch(Exception e)
{
	out.println(e);
}
finally {
	try { if (rs != null) rs.close(); } catch (Exception e) {};
	try { if (ps != null) ps.close(); } catch (Exception e) {};
	try { if (conn != null) conn.close(); } catch (Exception e) {};
}

%>

</body>
</html>
