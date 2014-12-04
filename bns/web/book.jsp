<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Book</title>
    </head>
    <body>
        <sql:query var="result" dataSource="jdbc/bns">
            SELECT title, format, pages, language, authors, publisher, year, 
                isbn13, subject, copies, price
            FROM book
            WHERE book.isbn13 = ?<sql:param value="${param.isbn13}"/>
        </sql:query>
        <table border='1'>
            <c:forEach var="columnName" items="${result.columnNames}">
                <th><c:out value="${columnName}"/></th>
            </c:forEach>
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
