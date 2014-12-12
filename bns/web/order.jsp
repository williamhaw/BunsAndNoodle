<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%@ page import ="java.util.Calendar" %>
<%@ page import ="java.text.DateFormat" %>
<%@ page import ="java.text.SimpleDateFormat" %>
<%@ page import= "java.lang.Integer" %>

<%
    // Insert JAVA code here to process the book order.
    // You may adapt the code from signup.jsp 
    // in order to update the book inventory once an order is made!
    // Test to ensure that the book count is decremented correctly.

    String cust_name = (String) session.getAttribute("userid");
    String isbn = request.getParameter("isbn13");
    String order_copies = request.getParameter("order_number");
    String old_copies = request.getParameter("copy_number");
    String status = "processing";
    Calendar cal = Calendar.getInstance();
    cal.getTime();
    DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    String date = dateFormat.format(cal.getTime());

    // redirect to login page if there is error
    // the error param in the login page will receive the error msg and print it out (if the error param is not null)
    try {
        if (cust_name.equals("") || isbn.equals("") || order_copies.equals("")
                || status.equals("") || date.equals("")) {
            response.sendRedirect("book.jsp?error=Please fill in all fields");
        }/* else if (pwd.length() < 7) {
         response.sendRedirect("login.jsp?error=Please enter a longer password");
         } else if (creditcard.length() < 12 || creditcard.length() > 19) { // a very SIMPLISTIC check on the credit card num
         response.sendRedirect("login.jsp?error=Please enter a valid credit card num");
         } else if (phone.length() < 8) {
         response.sendRedirect("login.jsp?error=Please enter a valid phone number");
         } else if (address.length() < 8) {
         response.sendRedirect("login.jsp?error=Please enter a valid address");
         }*/ else {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/b_and_n_book_store",
                    "bns",
                    "password");
            Statement st = con.createStatement();
            //insert into orders table
            int i = st.executeUpdate(
                    "insert into orders(order_date, order_status, order_isbn13, order_copies, order_customer) "
                    + "values ('" + date + "','" + status + "','" + isbn + "','"
                    + order_copies + "','" + cust_name + "')");
            int new_copies = Integer.parseInt(old_copies) - Integer.parseInt(order_copies);
            //update in books table
            int j = st.executeUpdate(
                    "update book set copies = '" + new_copies + "'where isbn13='" + isbn + "'");
            if (i > 0 && j > 0) { // order successful

            } else {
                response.sendRedirect("book.jsp?error=Order unsuccessful");
            }
        }
    } catch (Exception ex) {
        response.sendRedirect("book.jsp?error=" + ex.getMessage());
    }
%>

<<!DOCTYPE html>
<<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" src="//normalise-css.googlecode.com/svn/trunk/normalize.css">
        <link rel="stylesheet" type="text/css" href="css/order.css">
        <title>Book</title>
    </head>
    <body>
        <div id="wrapper">
            <header>
                <div id="logo">
                    <img src="http://peopleandplanet.org/cms_graphics/img1279_size1.png" width="50px" alt="Buns and Noodles Bookstore">
                </div>
                <div id="company_name">
                    <h1>Buns and Noodles Bookstore</h1>
                </div>
                <nav> 
                    <ul>
                        <li><a href="book_search.jsp">Search</a></li>
                        <li><a href="customer.jsp">Account</a></li>
                        <li><a href="about.jsp">About</a></li>
                        <li><a href="login.jsp">Home</a></li>
                            <c:if test="${not empty userid}">
                            <li><a href="logout.jsp">Logout</a></li>
                            </c:if>
                    </ul>
                </nav>
            </header>
        </div>
        
        <p>Thank you for purchasing, your order for 
            <%= request.getParameter("book_name")%> was successful!</p>
        
        <p>Our customers who bought this book also bought the books below.</p>
        
        <div id="search_result">
            <!--Below, insert the book recommendations-->
            <sql:query var="result" dataSource="jdbc/bns">
                select title, format, pages, language, authors, publisher, year, 
                                isbn13, subject, copies, price from book
                where isbn13 in(
                select order_isbn13 from orders
                where order_customer in(
                select order_customer from orders 
                where order_isbn13 = "<%= request.getParameter("isbn13")%>"
                having order_customer<> ? <sql:param value="${userid}"/>)
                group by order_isbn13
                having order_isbn13 <> "<%= request.getParameter("isbn13")%>"
                order by count(*) desc);
            </sql:query>
            <%
                    // doing this to format the column names a bit nicer rather than using the default
                // column names from our sql table
                String[] colNames = {"Title", "Format", "Pages", "Language", "Authors", "Publisher", "Year", "ISBN", "Subject", "Qty", "Price"};
                pageContext.setAttribute("colNames", colNames);
            %> 

            <table>

                <!-- column headers -->
                <tr>
                    <c:forEach var="columnName" items="${colNames}">
                        <th><c:out value="${columnName}"/></th>
                        </c:forEach>
                </tr>
                <!-- column data -->
                <c:forEach var="row" items="${result.rowsByIndex}">
                    <tr>
                        <c:forEach var="column" items="${row}">
                            <!--
                                if current column of table is book title:
                                    then set up hyperlink on that title 
                                    where hyperlink is "book.jsp?isbn13=isbn13"
                                    using isbn13 as row[7]
                                 else:
                                    just print out the column normally
                            -->
                            <c:choose>
                                <c:when test="${column == row[0]}"> 
                                    <td>
                                        <a href="book.jsp?isbn13=<c:out value= "${row[7]}"/>"> <!-- isbn13 -->
                                            <c:out value="${column}"/> <!-- book title -->
                                        </a>
                                    </td>
                                </c:when>
                                <c:otherwise>
                                    <td><c:out value="${column}"/></td>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </tr>
                </c:forEach>
            </table>
        </div>
    </body>
</html>
