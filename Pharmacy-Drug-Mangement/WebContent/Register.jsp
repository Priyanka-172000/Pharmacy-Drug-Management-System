<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.*" %>

<%
    String fname1 = request.getParameter("fname");
    String lname1 = request.getParameter("lname");
    String email1 = request.getParameter("email");
    String phno1 = request.getParameter("phno");
    String uid1 = request.getParameter("uid");
    String address1 = request.getParameter("address");
    String pass1 = request.getParameter("pass1");
    String pass2 = request.getParameter("pass2");

    long phno2 = 0;
    try {
        phno2 = Long.parseLong(phno1);
    } catch (NumberFormatException e) {
        response.sendRedirect("RegisterError3.html"); // invalid phone number
        return;
    }

    PreparedStatement ps1 = null;
    PreparedStatement ps2 = null;
    ResultSet rs = null;
    Connection conn = null;

    String query1 = "SELECT uid FROM customer WHERE uid=?";
    String query2 = "INSERT INTO customer(uid,pass,fname,lname,email,address,phno) VALUES(?,?,?,?,?,?,?)";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        String url = "jdbc:mysql://localhost:3306/drugdatabase?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
        String user = "root";
        String pass = "Admin@123";

        conn = DriverManager.getConnection(url, user, pass);

        // Check if UID already exists
        ps1 = conn.prepareStatement(query1);
        ps1.setString(1, uid1);
        rs = ps1.executeQuery();

        if (rs.next()) {
            response.sendRedirect("RegisterError1.html"); // UID exists
        } else {
            if (pass1 != null && pass1.equals(pass2)) {

                ps2 = conn.prepareStatement(query2);
                ps2.setString(1, uid1);
                ps2.setString(2, pass1);
                ps2.setString(3, fname1);
                ps2.setString(4, lname1);
                ps2.setString(5, email1);
                ps2.setString(6, address1);
                ps2.setLong(7, phno2);

                ps2.executeUpdate();
                response.sendRedirect("Login.html");

            } else {
                response.sendRedirect("RegisterError2.html"); // password mismatch
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
