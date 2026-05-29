<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    // VERY IMPORTANT FOR HINDI & KANNADA
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Product</title>
</head>
<body>

<%
    String pid = request.getParameter("productid");
    String pname = request.getParameter("productname");
    String manufacturer = request.getParameter("manufacturer");
    String mfg = request.getParameter("mfg");
    String exp = request.getParameter("exp");
    String price1 = request.getParameter("price");
    String quantity1 = request.getParameter("quantity");
    String descEnglish = request.getParameter("desc_english");
    String descKannada = request.getParameter("desc_kannada");
    String descHindi = request.getParameter("desc_hindi");

    HttpSession httpSession = request.getSession();
    String sid = (String)httpSession.getAttribute("currentuser");

    int price = 0;
    int quantity = 0;

    try {
        price = Integer.parseInt(price1);
        quantity = Integer.parseInt(quantity1);
    } catch(Exception e) {
        response.sendRedirect("AddProductError2.html");
        return;
    }

    Connection conn = null;
    PreparedStatement ps1 = null;
    PreparedStatement ps2 = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        // ✅ FIXED JDBC URL (UTF-8 ENABLED)
        String url = "jdbc:mysql://localhost:3306/drugdatabase"
                   + "?useSSL=false"
                   + "&serverTimezone=UTC"
                   + "&allowPublicKeyRetrieval=true"
                   + "&useUnicode=true"
                   + "&characterEncoding=UTF-8"
                   + "&connectionCollation=utf8mb4_unicode_ci";

        String user = "root";
        String pass = "Admin@123";

        conn = DriverManager.getConnection(url, user, pass);

        // ✅ FORCE UTF8 IN MYSQL SESSION
        PreparedStatement psNames = conn.prepareStatement("SET NAMES utf8mb4");
        psNames.execute();
        psNames.close();

        // Insert into product table
        String query1 = "INSERT INTO product VALUES(?,?,?,?,?,?,?,?,?)";
        ps1 = conn.prepareStatement(query1);
        ps1.setString(1, pid);
        ps1.setString(2, pname);
        ps1.setString(3, manufacturer);
        ps1.setString(4, mfg);
        ps1.setString(5, exp);
        ps1.setInt(6, price);
        ps1.setString(7, descEnglish);
        ps1.setString(8, descKannada);
        ps1.setString(9, descHindi);

        int x = ps1.executeUpdate();

        // Insert into inventory table
        String query2 = "INSERT INTO inventory VALUES(?,?,?,?)";
        ps2 = conn.prepareStatement(query2);
        ps2.setString(1, pid);
        ps2.setString(2, pname);
        ps2.setInt(3, quantity);
        ps2.setString(4, sid);

        int y = ps2.executeUpdate();

        if(x > 0 && y > 0) {
    out.println("Product inserted successfully");
} else {
    out.println("Insert failed");
}

    } catch(SQLIntegrityConstraintViolationException e) {
        response.sendRedirect("AddProductError1.html");
    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
        e.printStackTrace();
    } finally {
        try { if (ps1 != null) ps1.close(); } catch (Exception e) {}
        try { if (ps2 != null) ps2.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>

</body>
</html>