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
        <title>About</title>
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
            
            <!-- error output -->
            <c:choose>
                <c:when test="${param.error != null}">
                    Error: <c:out value="${param.error}"/>
                </c:when>
            </c:choose>

            <h2>Welcome to Buns and Noodles, an SUTD 50.008 Database Project.</h2>
            <h2>Admin Login</h2>
            
            <c:choose>
                <c:when test="${not empty admin}">
                    <form method='post' action='admin_logout.jsp'>
                        <input type='submit' value="Logout"/>
                    </form>
                    
                    <h1>Add New Book</h1>
                    <form method='post' action='add_book.jsp'>
                        <label for='title'>Title</label>
                        <input type='text' name='title' value='' />
                        <br><br>
                        <input type='radio' name='book_format' value='paperback' checked>paperback
                        <input type='radio' name='book_format' value='hardcover'>hardcover
                        <br><br>
                        <label for='pages'>Pages</label>
                        <input type='text' name='pages' values='' />
                        <br><br>
                        <label for='language'>Language</label>
                        <input type='text' name='language' values='' />
                        <br><br>
                        <label for='authors'>Authors</label>
                        <input type='text' name='authors' values='' />
                        <br><br>
                        <label for='publisher'>Publisher</label>
                        <input type='text' name='publisher' values='' />                        
                        <br><br>
                        <!-- test if need stricter forms here -->
                        <label for='year'>Year</label>
                        <input type='text' name='year' values='' />                        
                        <br><br>
                        <label for='isbn13'>ISBN13</label>
                        <input type='text' name='isbn13' values='' />                        
                        <br><br>
                        <label for='keywords'>Keywords</label>
                        <input type='text' name='keywords' values='' />                        
                        <br><br>
                        <label for='subject'>Subject</label>
                        <input type='text' name='subject' values='' />                        
                        <br><br>
                        <label for='copies'>Copies</label>
                        <input type='text' name='copies' values='' />                        
                        <br><br>
                        <label for='price'>Price</label>
                        <input type='text' name='price' values='' />                        
                        <br><br>
                        <input type='submit' value='Add New Book!' />
                    </form>
                    
                    <br><br>
                    
                    <h1>Update Existing Books</h1>
                    <form method="post" action='update_book.jsp'>
                        <label for='isbn13'>ISBN13</label>
                        <input type='text' name="isbn13" values='' />
                        <br><br>
                        <label for='number_new_copies'>Number of New Copies</label>
                        <input type='text' name='number_new_copies' values='' />
                        <br><br>
                        <input type='submit' value='Update Book!' />
                    </form>
                    
                    <br><br>
                    <h1>Bookstore Statistics</h1>
                    <form method='post' action='about.jsp'>
                        <label for="month">Month</label>
                        <input type='text' name='month' values='' />
                        <br><br>
                        <label for="year">Year</label>
                        <input type='text' name='year' values='' />
                        <br><br>
                        <label for='number_results'>Number of Results to Show</label>
                        <input type='text' name="number_results" values="" />
                        <br><br>
                        <input type='submit' value='Search!' />
                    </form>
                    

                    
                    <br><br>
                    <!-- title, author, publisher -->
                    <c:catch var="catchException">
                    <c:choose>
                        <c:when test="${param.month == null}">
                            <h2>Top 10 Titles Sold</h2>
                            <sql:query var="pre_top_titles" dataSource="jdbc/bns" maxRows="10">
                                select title, sum(order_copies) as summed_copies, order_date, order_isbn13
                                from orders inner join book on order_isbn13 = book.isbn13
                                group by order_isbn13
                                order by summed_copies desc
                            </sql:query>
                            <table border='1'>
                                <th>Title</th>
                                <th>Number of Copies</th>
                                <th>Date Ordered</th>
                                <th>ISBN13</th>
                                <c:forEach var="row" items="${pre_top_titles.rowsByIndex}">
                                <tr>
                                    <c:forEach var="column" items="${row}">
                                        <td><c:out value="${column}"/></td>
                                    </c:forEach>
                                </tr>
                                </c:forEach>
                            </table>
                                
                            <br><br>
                            <h2>10 Most Popular Authors</h2>
                            <sql:query var="pre_top_authors" dataSource="jdbc/bns" maxRows="10">
                                select authors, title, sum(order_copies) as summed_copies, order_date, order_isbn13
                                from orders inner join book on order_isbn13 = book.isbn13
                                group by order_isbn13
                                order by summed_copies desc
                            </sql:query>
                            <table border='1'>
                                <th>Author</th>
                                <th>Title</th>
                                <th>Number of Copies</th>
                                <th>Date Ordered</th>
                                <th>ISBN13</th>
                                <c:forEach var="row" items="${pre_top_authors.rowsByIndex}">
                                <tr>
                                    <c:forEach var="column" items="${row}">
                                        <td><c:out value="${column}"/></td>
                                    </c:forEach>
                                </tr>
                                </c:forEach>
                            </table>
                            
                            <br><br>
                            <h2>10 Most Popular Publishers</h2>
                            <sql:query var="pre_top_publishers" dataSource="jdbc/bns" maxRows="10">
                                select publisher, title, sum(order_copies) as summed_copies, order_date, order_isbn13
                                from orders inner join book on order_isbn13 = book.isbn13
                                group by order_isbn13
                                order by summed_copies desc
                            </sql:query>
                            <table border='1'>
                                <th>Publisher</th>
                                <th>Title</th>
                                <th>Number of Copies</th>
                                <th>Date Ordered</th>
                                <th>ISBN13</th>
                                <c:forEach var="row" items="${pre_top_publishers.rowsByIndex}">
                                <tr>
                                    <c:forEach var="column" items="${row}">
                                        <td><c:out value="${column}"/></td>
                                    </c:forEach>
                                </tr>
                                </c:forEach>
                            </table> 
                        </c:when>
                        
                        <c:otherwise>
                            <h2>Top Titles Sold</h2>
                            <sql:query var="top_titles" dataSource="jdbc/bns">
                                select title, sum(order_copies) as summed_copies, order_date, order_isbn13
                                from orders inner join book on order_isbn13 = book.isbn13
                                where month(order_date) rlike ? <sql:param value="${param.month}"/> 
                                and year(order_date) rlike ? <sql:param value="${param.year}"/>
                                group by order_isbn13
                                order by summed_copies desc
                                limit <c:out value="${param.number_results}"/>
                            </sql:query>
                            <table border='1'>
                                <th>Title</th>
                                <th>Number of Copies</th>
                                <th>Date Ordered</th>
                                <th>ISBN13</th>
                                <c:forEach var="row" items="${top_titles.rowsByIndex}">
                                <tr>
                                    <c:forEach var="column" items="${row}">
                                        <td><c:out value="${column}"/></td>
                                    </c:forEach>
                                </tr>
                                </c:forEach>
                            </table>   
                                
                            <br><br>
                            <h2>Most Popular Authors</h2>
                            <sql:query var="top_authors" dataSource="jdbc/bns">
                                select authors, title, sum(order_copies) as summed_copies, order_date, order_isbn13
                                from orders inner join book on order_isbn13 = book.isbn13
                                where month(order_date) rlike ? <sql:param value="${param.month}"/> 
                                and year(order_date) rlike ? <sql:param value="${param.year}"/>
                                group by order_isbn13
                                order by summed_copies desc
                                limit <c:out value="${param.number_results}"/>
                            </sql:query>
                            <table border='1'>
                                <th>Author</th>
                                <th>Title</th>
                                <th>Number of Copies</th>
                                <th>Date Ordered</th>
                                <th>ISBN13</th>
                                <c:forEach var="row" items="${top_authors.rowsByIndex}">
                                <tr>
                                    <c:forEach var="column" items="${row}">
                                        <td><c:out value="${column}"/></td>
                                    </c:forEach>
                                </tr>
                                </c:forEach>
                            </table>  
                                
                            <br><br>
                            <h2>Most Popular Publishers</h2>
                            <sql:query var="top_publishers" dataSource="jdbc/bns">
                                select publisher, title, sum(order_copies) as summed_copies, order_date, order_isbn13
                                from orders inner join book on order_isbn13 = book.isbn13
                                where month(order_date) rlike ? <sql:param value="${param.month}"/> 
                                and year(order_date) rlike ? <sql:param value="${param.year}"/>
                                group by order_isbn13
                                order by summed_copies desc
                                limit <c:out value="${param.number_results}"/>
                            </sql:query>
                            <table border='1'>
                                <th>Publisher</th>
                                <th>Title</th>
                                <th>Number of Copies</th>
                                <th>Date Ordered</th>
                                <th>ISBN13</th>
                                <c:forEach var="row" items="${top_publishers.rowsByIndex}">
                                <tr>
                                    <c:forEach var="column" items="${row}">
                                        <td><c:out value="${column}"/></td>
                                    </c:forEach>
                                </tr>
                                </c:forEach> 
                            </table>                                 
                        </c:otherwise>
                    </c:choose>
                    </c:catch>
                    
                    <c:if test="${catchException != null}">
                        <p>The exception is : ${catchException}</p>
                        <br>
                    </c:if>
                    
                    
                    <br><br>
                    
                    
                </c:when>
                
                <c:otherwise>
                    <form method='post' action='admin_auth.jsp'>
                        <label for='admin'>Username</label>
                        <input type="text" name='admin' value="admin" />
                        <br/>
                        <label for='admin_pw'>Password</label>
                        <input type="password" name='admin_pw' value="PA55w0rd" /> <!-- remove the hardcoded password later -->
                        <br/>
                        <input type='submit' value="Login"/>
                    </form>
                </c:otherwise>
            </c:choose>
        </div>
    </body>
    
    
</html>
