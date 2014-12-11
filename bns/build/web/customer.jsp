<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" src="//normalise-css.googlecode.com/svn/trunk/normalize.css">
        <link rel="stylesheet" type="text/css" href="css/customer.css">
        <title>Account</title>
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

            <c:choose>
                <c:when test="${userid == null}">
                    Please login or signup <a href="login.jsp">here</a>.
                </c:when>
                <c:otherwise>
                    <h1>Account Details</h1>
                    <sql:query var="user" dataSource="jdbc/bns">
                        SELECT name, credit_card, phone, address
                        FROM customer
                        WHERE customer.login = ? <sql:param value="${userid}"/>
                    </sql:query>


                    <c:forEach var="row" items="${user.rows}">
                        Full Name: <c:out value='${row.name}'/>
                        <br/>
                        Credit Card: <c:out value='${row.credit_card}'/>
                        <br/>
                        Phone Number: <c:out value='${row.phone}'/>
                        <br/>
                        Address: <c:out value='${row.address}'/>
                        <br/>

                    </c:forEach>

                    <h1> My Order History</h1>

                    <sql:query var="result" dataSource="jdbc/bns">
                        SELECT title, order_date, order_copies, order_status
                        FROM orders
                        INNER JOIN book
                        ON book.isbn13 = orders.order_isbn13
                        WHERE order_customer = ? <sql:param value="${userid}"/>
                    </sql:query>
                    <table border='1'>
                        <th>Title</th>
                        <th>Order Date</th>
                        <th>Copies</th>
                        <th>Status</th>
                        <c:forEach var="row" items="${result.rowsByIndex}">
                        <tr>
                            <c:forEach var="column" items="${row}">
                                <td><c:out value="${column}"/></td>
                            </c:forEach>
                        </tr>
                        </c:forEach>         
                    </table>

                    <h1> My Feedback History</h1>
                    <sql:query var="rating" dataSource="jdbc/bns">
                        SELECT title, feedback_date, feedback_score, feedback_text
                        FROM gives_feedback
                        INNER JOIN book
                        ON book.isbn13 = gives_feedback.feedback_isbn13
                        WHERE feedback_customer = ? <sql:param value="${userid}"/>
                    </sql:query>
                    <table border='1'>
                        <th>Title</th>
                        <th>Feedback Date</th>
                        <th>Score</th>
                        <th>Comments</th>
                        <c:forEach var="row" items="${rating.rowsByIndex}">
                        <tr>
                            <c:forEach var="column" items="${row}">
                                <td><c:out value="${column}"/></td>
                            </c:forEach>
                        </tr>
                        </c:forEach>         
                    </table>

                    <h1> My Ranked Feedbacks</h1>
                    <sql:query var="ranking" dataSource="jdbc/bns">
                        SELECT name, title, rating
                        FROM rates_feedback
                        INNER JOIN book
                        ON book.isbn13 = rates_feedback.ratee_feedback_isbn13
                        INNER JOIN customer
                        ON rates_feedback.ratee = customer.login
                        WHERE rater = ?<sql:param value="${userid}"/>
                    </sql:query>
                    <table border='1'>
                        <th>Other Customer</th>
                        <th>Title</th>
                        <th>Rating</th>
                        <c:forEach var="row" items="${ranking.rowsByIndex}">
                        <tr>
                            <c:forEach var="column" items="${row}">
                                <td><c:out value="${column}"/></td>
                            </c:forEach>
                        </tr>
                        </c:forEach>         
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </body>
    
    
</html>
