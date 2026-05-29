<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Login</title>
</head>
<body>

<%
    String uid1 = request.getParameter("userid");
    String pass1 = request.getParameter("password");
    String u2 = request.getParameter("utype");

    // ? BASIC VALIDATION
    if (uid1 == null || pass1 == null || u2 == null ||
        uid1.trim().isEmpty() || pass1.trim().isEmpty()) {

        response.sendRedirect("LoginError2.html");
        return;
    }

    int u;
    try {
        u = Integer.parseInt(u2);
    } catch (Exception e) {
        response.sendRedirect("LoginError2.html");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String queryCustomer = "SELECT uid, pass FROM customer WHERE uid=?";
    String querySeller   = "SELECT sid, pass FROM seller WHERE sid=?";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

       String url = "jdbc:mysql://localhost:3306/drugdatabase?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
String user = "root";        // Your MySQL username
String pass = "Admin@123"; 

        conn = DriverManager.getConnection(url, user, pass);

        if (u == 1) {
            ps = conn.prepareStatement(queryCustomer);
            ps.setString(1, uid1);
        } else if (u == 2) {
            ps = conn.prepareStatement(querySeller);
            ps.setString(1, uid1);
        } else {
            response.sendRedirect("LoginError2.html");
            return;
        }

        rs = ps.executeQuery();

        if (rs.next()) {
            if (rs.getString(2).equals(pass1)) {

                // ? CREATE SESSION ONLY AFTER SUCCESS
                HttpSession httpSession = request.getSession();
                httpSession.setAttribute("currentuser", uid1);
                httpSession.setAttribute("usertype", u);

                if (u == 1)
                    response.sendRedirect("Homepage.jsp");
                else
                    response.sendRedirect("SellerHomepage.jsp");

            } else {
                response.sendRedirect("LoginError1.html"); // wrong password
            }
        } else {
            response.sendRedirect("LoginError2.html"); // user not found
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>

</body>
</html>
