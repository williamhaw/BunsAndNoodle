<%@ page import ="java.sql.*" %>
<%
    String userid = request.getParameter("username");   
    String pwd = request.getParameter("password");
    Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/b_and_n_book_store",
            "bns", "password");
    Statement st = con.createStatement();
    ResultSet rs;
    rs = st.executeQuery("select * from customer where login='" + userid + "' and pw='" + pwd + "'");
    if (rs.next()) {
        session.setAttribute("userid", userid);
        session.setAttribute("username", rs.getString("name")); 
        //out.println("welcome " + userid);
        //out.println("<a href='logout.jsp'>Log out</a>");
        response.sendRedirect("book_search.jsp");
    } else {
        out.println("Invalid password <a href='index.jsp'>try again</a>");
    }
%>
