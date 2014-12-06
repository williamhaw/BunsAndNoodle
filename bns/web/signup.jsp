<%@ page import ="java.sql.*" %>
<%
    String user = request.getParameter("username");   
    String pwd = request.getParameter("password");
    String fullname = request.getParameter("fullname");
    Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/b_and_n_book_store",
            "bns", "password");
    Statement st = con.createStatement();
    //ResultSet rs;
    int i = st.executeUpdate("insert into customer(name, login, pw) values ('" + fullname + "','" + user + "','" + pwd + "')");
    if (i > 0) {
        session.setAttribute("userid", user);
        session.setAttribute("username", fullname);
        response.sendRedirect("book_search.jsp");
    } else {
        response.sendRedirect("login.jsp?error=There%20was%20an%20error.");
    }
%>