<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*" %>
<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html; charset=UTF-8");
response.setCharacterEncoding("UTF-8");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Buy</title>

<style>
body { font-family: Arial, sans-serif; }

.search-box { text-align:center; margin-top:20px; }

.search-box input {
    padding:8px;
    width:250px;
    border:2px solid #4CAF50;
    border-radius:5px;
}

.search-box button {
    padding:8px 15px;
    background:#4CAF50;
    color:white;
    border:none;
    border-radius:5px;
    cursor:pointer;
}

.language-selector { text-align:center; margin:20px 0; }

.product-container {
    display:flex;
    flex-wrap:wrap;
    justify-content:center;
    gap:25px;
    margin:30px auto;
}

.card {
    width:260px;
    background:#f5f5f5;
    border-radius:10px;
    padding:15px;
    text-align:center;
    box-shadow:0 4px 10px rgba(0,0,0,0.2);
}

.card img { width:150px; height:170px; }

.card button {
    background:black;
    color:white;
    padding:8px;
    width:100%;
    border:none;
    cursor:pointer;
}

.card button:hover { background:green; }

.description-box {
    background:#f9f9f9;
    border:1px solid #ddd;
    padding:8px;
    margin-top:8px;
    min-height:60px;
}
</style>
</head>

<body>

<%!
private String safe(String s){
    if(s==null) return "";
    return s.replace("\\","\\\\")
            .replace("\"","\\\"")
            .replace("\n","\\n")
            .replace("\r","");
}
%>

<%
Connection conn=null;
PreparedStatement ps=null;
ResultSet rs=null;

List<Map<String,String>> products=new ArrayList<>();

try{
    Class.forName("com.mysql.cj.jdbc.Driver");

    String dbUrl="jdbc:mysql://localhost:3306/drugdatabase"
            +"?useSSL=false&serverTimezone=UTC&useUnicode=true&characterEncoding=UTF-8";

    conn=DriverManager.getConnection(dbUrl,"root","Admin@123");

    String search=request.getParameter("search");

    String sql="SELECT p.pname,p.pid,p.manufacturer,p.mfg,p.exp,p.price,"
        +"p.description_english,p.description_kannada,p.description_hindi,"
        +"i.quantity FROM product p JOIN inventory i ON p.pid=i.pid"
        +" WHERE p.exp > CURDATE()";

if(search!=null && !search.trim().isEmpty()){
    sql+=" AND LOWER(p.pname) LIKE ?";   // WHERE → AND
}

    ps=conn.prepareStatement(sql);

    if(search!=null && !search.trim().isEmpty()){
        ps.setString(1,"%"+search.toLowerCase()+"%");
    }

    rs=ps.executeQuery();

    while(rs.next()){
        Map<String,String> p=new HashMap<>();
        p.put("pname",rs.getString("pname"));
        p.put("pid",rs.getString("pid"));
        p.put("mfr",rs.getString("manufacturer"));
        p.put("mfg",rs.getDate("mfg").toString());
        p.put("exp",rs.getDate("exp").toString());   
        p.put("price",String.valueOf(rs.getInt("price")));
        p.put("qty",String.valueOf(rs.getInt("quantity")));
        p.put("de",rs.getString("description_english"));
        p.put("dk",rs.getString("description_kannada"));
        p.put("dh",rs.getString("description_hindi"));
        products.add(p);
    }

}catch(Exception e){
    out.println("Error: "+e);
}finally{
    try{if(rs!=null)rs.close();}catch(Exception e){}
    try{if(ps!=null)ps.close();}catch(Exception e){}
    try{if(conn!=null)conn.close();}catch(Exception e){}
}
%>

<script>
var descMap=[
<% for(int i=0;i<products.size();i++){
   Map<String,String> p=products.get(i); %>
{
english:"<%=safe(p.get("de"))%>",
kannada:"<%=safe(p.get("dk"))%>",
hindi:"<%=safe(p.get("dh"))%>"
}<%=i<products.size()-1?",":""%>
<% } %>
];

function changeLanguage(){
    var lang=document.getElementById("languageSelect").value;
    var boxes=document.getElementsByClassName("description-box");
    for(var i=0;i<boxes.length;i++){
        boxes[i].textContent=descMap[i][lang]||descMap[i]["english"];
    }
}
</script>

<!-- SEARCH BOX -->
<div class="search-box">
<form method="get" action="Buy.jsp">
<input type="text" name="search"
value="<%=request.getParameter("search")!=null?request.getParameter("search"):""%>"
placeholder="Search medicine...">
<button type="submit">Search</button>
</form>
</div>

<!-- LANGUAGE SELECTOR -->
<div class="language-selector">
<b>Choose Language:</b>
<select id="languageSelect" onchange="changeLanguage()">
<option value="english">English</option>
<option value="kannada">Kannada</option>
<option value="hindi">Hindi</option>
</select>
</div>

<% if(products.size()==0){ %>

<div style="text-align:center;color:red;font-size:20px;margin-top:40px;">
Medicine Not Available
</div>

<% } else { %>

<div class="product-container">

<%
for(int i=0;i<products.size();i++){
    Map<String,String> p=products.get(i);
    int qty=Integer.parseInt(p.get("qty"));
    int price=Integer.parseInt(p.get("price"));
%>

<div class="card">
<img src="images/pills.png">

<h2><%=p.get("pname")%></h2>

<p><b>ID:</b> <%=p.get("pid")%></p>
<p><b>Manufacturer:</b> <%=p.get("mfr")%></p>
<p><b>Mfg Date:</b> <%=p.get("mfg")%></p>
<p><b>Exp Date:</b> <%=p.get("exp")%></p>   
<p><b>Stock:</b> <%=qty%></p>
<p><b>Price:</b> ₹<%=price%></p>

<div class="description-box"><%=p.get("de")%></div>

<% if(qty>0){ %>
<form action="PlaceOrder.jsp" method="post">
<input type="number" name="orderquantity"
min="1" max="<%=qty%>" required
placeholder="Enter quantity"
style="width:100%;padding:5px;margin-top:8px;">
<input type="hidden" name="pid" value="<%=p.get("pid")%>">
<input type="hidden" name="price" value="<%=price%>">
<p></p>
<button type="submit">Buy</button>
</form>
<% } else { %>
<button disabled style="background:#ccc;">Out Of Stock</button>
<% } %>

</div>

<% } %>

</div>

<% } %>

</body>
</html>