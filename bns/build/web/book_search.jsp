<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" src="//normalise-css.googlecode.com/svn/trunk/normalize.css">
        <link rel="stylesheet" type="text/css" href="css/book_search.css">
        <script src="js/replaceNullWithWildcard.js"></script>
        <title>Book Search</title>
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
                        <li><a href="login.jsp">Account</a></li>
                        <li><a href="about.jsp">About</a></li>
                        <li><a href="login.jsp">Home</a></li>
                    </ul>
                </nav>
            </header>
            
            <div id="search_pane"> 
                <h2>Search</h2>

                <form onsubmit="replaceNullWithWildcard()" action="book_search.jsp">
                    <table border="1">
                        <tr>
                            <td>Title</td>
                            <td><input type="text" id="title" name="title" value="" /></td>
                        </tr>
                        <tr>
                            <td>Author</td>
                            <td><input type="text" id="authors" name="authors" value="" /></td>
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
            </div>
            
            <div id="search_result">
                <!-- 
                    When page first loads, all param values are null! 
                    Param values are not null only when user clicks on submit button-->
                <c:choose>
                    <c:when test="${param.sort == null}">
                        <h2>Top 10 Books</h2>
                        <sql:query var="result" dataSource="jdbc/bns" maxRows="10">
                            SELECT title, format, pages, language, authors, publisher, year, 
                                isbn13, subject, copies, price, 
                                ROUND(AVG(gives_feedback.feedback_score),2) as avg_score FROM book
                            LEFT JOIN gives_feedback
                            ON book.isbn13 = gives_feedback.feedback_isbn13
                            GROUP BY book.isbn13
                            ORDER BY AVG(gives_feedback.feedback_score) desc
                        </sql:query>
                    </c:when>

                    <c:otherwise>
                        <h2>Results</h2>
                        <sql:query var="result" dataSource="jdbc/bns">
                            SELECT title, format, pages, language, authors, publisher, year, 
                                isbn13, subject, copies, price, 
                                ROUND(AVG(gives_feedback.feedback_score),2) as avg_score FROM book
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

                <%
                    // doing this to format the column names a bit nicer rather than using the default
                    // column names from our sql table
                    String[] colNames = {"Title", "Format", "Pages", "Language", "Authors", "Publisher", "Year", "ISBN", "Subject", "Qty", "Price", "Avg Rating"};
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
        </div>
    </body>
    
</html>
