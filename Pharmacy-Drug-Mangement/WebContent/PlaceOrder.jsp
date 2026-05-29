<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>Order Placed</title></head>
<body>
<%@ page import="java.sql.*" %>
<%
String pid = request.getParameter("pid");
int qr = Integer.parseInt(request.getParameter("orderquantity"));
HttpSession httpSession = request.getSession();
String guid = (String)httpSession.getAttribute("currentuser");
Connection conn=null; ResultSet rs=null; PreparedStatement ps=null,ps2=null;
String query1="select P.pid,O.sid,P.price from inventory O,product P where P.pid=? and P.pid=O.pid";
String query2="insert into orders(pid,sid,uid,quantity,price) values(?,?,?,?,?)";
int totalAmount = 0;
String productId = "";
try{
  Class.forName("com.mysql.cj.jdbc.Driver");
  conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/drugdatabase?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true","root","Admin@123");
  ps = conn.prepareStatement(query1);
  ps.setString(1, pid);
  rs = ps.executeQuery();
  if(rs.next()){
    String a = rs.getString("pid");
    String b = rs.getString("sid");
    int c = rs.getInt("price");
    totalAmount = qr * c;
    productId = a;
    ps2 = conn.prepareStatement(query2);
    ps2.setString(1,a); ps2.setString(2,b); ps2.setString(3,guid);
    ps2.setInt(4,qr); ps2.setInt(5,totalAmount);
    ps2.executeUpdate();
    // Order saved successfully — now redirect to UPI payment page
    response.sendRedirect("Payment.jsp?amount="+totalAmount+"&pid="+productId+"&qty="+qr);
  }
} catch(Exception E){ out.println(E); }
finally { try{if(rs!=null)rs.close();}catch(Exception e){} try{if(ps!=null)ps.close();}catch(Exception e){} try{if(ps2!=null)ps2.close();}catch(Exception e){} try{if(conn!=null)conn.close();}catch(Exception e){} }
%>
</body>
</html>
