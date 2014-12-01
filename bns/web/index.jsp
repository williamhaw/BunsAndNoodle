<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Date"%>

<!DOCTYPE html>
<html>
    
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="style.css">
        <script src="js/replaceNullWithWildcard.js"></script>
        <title>BNS Bookstore</title>
    </head>
    
    <body>
        
        <% Date date = new Date(); %>
        <h1>Welcome to BNS Bookstore. Today is <%= date %></h1>
        
        <h2>Search</h2>
        
        <form onsubmit="replaceNullWithWildcard()" action="index.jsp">
            <table border="1">
                <tr>
                    <td>Title</td>
                    <td><input type="text" id="title" name="title" value="" /></td>
                </tr>
                <tr>
                    <td>Author</td>
                    <td><input type="text" id="name" name="authors" value="" /></td>
                </tr>
                <tr>
                    <td>Publisher</td>
                    <td><input type="text" id="publisher" name="publisher" value="" /></td>
                </tr>
                <tr>
                    <td>Subject</td>
                    <td><input type="text" id="subject" name="subject" value="" /></td>
                </tr>
                <tr>
                    <td>Sort By</td>
                    <td>
                        <select id="sort" name="sort">
                            <option value="year">Year (earliest first)</option>
                            <option value="year desc">Year (most recent first)</option>
                            <option value="AVG(gives_feedback.feedback_score) desc">Average score of feedback</option>
                        </select>
                    </td>
                </tr>
            </table>
            
            <p></p>
            <input type="submit" value="Search" name="search" />
           
        </form>
        
        <!-- 
            When page first loads, all param values are null! 
            Param values are not null only when user clicks on submit button-->
        <c:choose>
            
            <c:when test="${param.sort == null}">
                <h2>Top 10 Books</h2>
                <sql:query var="result" dataSource="jdbc/bns" maxRows="10">
                    SELECT title, format, pages, language, authors, publisher, year, 
                        isbn13, subject, copies, price, 
                        AVG(gives_feedback.feedback_score) as avg_score FROM book
                    LEFT JOIN gives_feedback
                    ON book.isbn13 = gives_feedback.feedback_isbn13
                    GROUP BY book.isbn13
                    ORDER BY AVG(gives_feedback.feedback_score) desc
                </sql:query>
            </c:when>
            
            <c:otherwise>
                <h2>Search Results</h2>
                <sql:query var="result" dataSource="jdbc/bns">
                    SELECT title, format, pages, language, authors, publisher, year, 
                        isbn13, subject, copies, price, 
                        AVG(gives_feedback.feedback_score) as avg_score FROM book
                    LEFT JOIN gives_feedback
                    ON book.isbn13 = gives_feedback.feedback_isbn13
                    WHERE book.title rlike ? <sql:param value="${param.title}"/>
                    AND book.authors rlike ? <sql:param value="${param.authors}"/>
                    AND book.publisher rlike ? <sql:param value="${param.publisher}"/>
                    AND book.subject rlike ? <sql:param value="${param.subject}"/>
                    GROUP BY book.isbn13
                    ORDER BY <c:out value="${param.sort}"/> 
                </sql:query>
            </c:otherwise>
                    
        </c:choose>

        <table border="1">
            <!-- column headers -->
            <tr>
                <c:forEach var="columnName" items="${result.columnNames}">
                    <th><c:out value="${columnName}"/></th>
                </c:forEach>
            </tr>
            <!-- column data -->
            <c:forEach var="row" items="${result.rowsByIndex}">
            <tr>
                <c:forEach var="column" items="${row}">
                    <td><c:out value="${column}"/></td>
                </c:forEach>
            </tr>
            </c:forEach>
        </table>

    </body>
    
</html>
