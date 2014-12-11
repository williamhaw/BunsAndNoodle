<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" src="//normalise-css.googlecode.com/svn/trunk/normalize.css">
        <link rel="stylesheet" type="text/css" href="css/main.css">
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
            
            <sql:query var="result" dataSource="jdbc/bns">
                SELECT title, format, pages, language, authors, publisher, year, 
                    isbn13, subject, copies, price
                FROM book
                WHERE book.isbn13 = ? <sql:param value="${param.isbn13}"/>
            </sql:query>
            <c:forEach var="row" items="${result.rows}">
                <p><b>Title:</b> <c:out value="${row.title}"/></p>
                <p><b>Format:</b> <c:out value="${row.format}"/></p>
                <p><b>Pages:</b> <c:out value="${row.pages}"/></p>
                <p><b>Language:</b> <c:out value="${row.language}"/></p>
                <p><b>Authors:</b> <c:out value="${row.authors}"/></p>
                <p><b>Publisher:</b> <c:out value="${row.publisher}"/></p>
                <p><b>Year:</b> <c:out value="${row.year}"/></p>
                <p><b>ISBN13:</b> <c:out value="${row.isbn13}"/></p>
                <p><b>Subject:</b> <c:out value="${row.subject}"/></p>
                <p><b>Copies Available:</b> 
                    <c:choose>
                        <c:when test="${row.copies>0}"> 
                            <c:out value="${row.copies}"/>
                        </c:when>
                        <c:otherwise>
                            Out of stock
                        </c:otherwise>
                    </c:choose>
                </p>
                <b>Price: </b> $<c:out value="${row.price}"/>
            </c:forEach>
        </div>
    </body>
</html>
 