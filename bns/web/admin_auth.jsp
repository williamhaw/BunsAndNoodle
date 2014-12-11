<%@ page import ="java.sql.*" %>

<%
    String admin = request.getParameter("admin");   
    String pwd = request.getParameter("admin_pw");
    Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/b_and_n_book_store",
            "bns", "password");
    Statement st = con.createStatement();
    ResultSet rs = st.executeQuery("select * from manager where admin_login='" + admin + "' and admin_password='" + pwd + "'");
    if (rs.next()) {
        session.setAttribute("admin", admin);
        response.sendRedirect("about.jsp");
    } else {
        response.sendRedirect("about.jsp?error=Invalid credentials");
    }
%>
