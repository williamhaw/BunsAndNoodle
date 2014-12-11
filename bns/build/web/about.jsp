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
                    
                    <h2>Store manager information - add/update books and view top m books can go here.</h2>
                    <h2>TODO</h2>
                    
                    
                    
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
