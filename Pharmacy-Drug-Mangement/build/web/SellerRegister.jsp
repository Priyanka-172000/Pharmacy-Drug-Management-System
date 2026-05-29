<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Seller Register</title>
</head>
<body>

<%
    String name1 = request.getParameter("name");
    String phno1 = request.getParameter("phno");
    String uid1  = request.getParameter("uid");
    String address1 = request.getParameter("address");
    String pass1 = request.getParameter("pass1");
    String pass2 = request.getParameter("pass2");

    // BASIC NULL CHECK
    if (name1 == null || phno1 == null || uid1 == null ||
        address1 == null || pass1 == null || pass2 == null ||
        name1.trim().isEmpty() || phno1.trim().isEmpty() ||
        uid1.trim().isEmpty() || address1.trim().isEmpty() ||
        pass1.trim().isEmpty() || pass2.trim().isEmpty()) {

        response.sendRedirect("SellerRegisterError3.html");
        return;
    }

    long phno2;
    try {
        phno2 = Long.parseLong(phno1);
    } catch (Exception e) {
        response.sendRedirect("SellerRegisterError3.html");
        return;
    }

    Connection conn = null;
    PreparedStatement ps1 = null;
    PreparedStatement ps2 = null;
    ResultSet rs = null;

    String query1 = "SELECT sid FROM seller WHERE sid=?";
    String query2 = "INSERT INTO seller(sid,pass,sname,address,phno) VALUES(?,?,?,?,?)";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        String url = "jdbc:mysql://localhost:3306/drugdatabase?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
        String user = "root";
        String pass = "Admin@123";

        conn = DriverManager.getConnection(url, user, pass);

        ps1 = conn.prepareStatement(query1);
        ps1.setString(1, uid1);
        rs = ps1.executeQuery();

        if (rs.next()) {
            response.sendRedirect("SellerRegisterError1.html"); // seller exists
        } else {
            if (pass1.equals(pass2)) {

                ps2 = conn.prepareStatement(query2);
                ps2.setString(1, uid1);
                ps2.setString(2, pass1);
                ps2.setString(3, name1);
                ps2.setString(4, address1);
                ps2.setLong(5, phno2);

                ps2.executeUpdate();
                response.sendRedirect("Login.html");

            } else {
                response.sendRedirect("SellerRegisterError2.html"); // password mismatch
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps1 != null) ps1.close(); } catch (Exception e) {}
        try { if (ps2 != null) ps2.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>

</body>
</html>
