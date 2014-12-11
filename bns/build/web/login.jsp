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
        <title>Login</title>
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

            <h2>Login</h2>
            <form method='post' action='auth.jsp'>
                <label for='username'>Username</label>
                <input type="text" name='username' value="" />
                <br/>
                <label for='password'>Password</label>
                <input type="password" name='password' value="" />
                <br/>
                <input type='submit' value="Login"/>
            </form>
            <br/>
            <h3>or</h3>
            <h2>Signup</h2>
            <form method='post' action='signup.jsp'>
                <label for='username'>Username</label>
                <input type="text" name='username' value="" />
                <br/>
                <label for='password'>Password</label>
                <input type="password" name='password' value="" />
                <br/>
                <label for='fullname'>Full Name</label>
                <input type="text" name='fullname' value="" />
                <br/>
                <label for='creditcard'>Credit Card</label>
                <input type="text" name='creditcard' value="" />
                <br/>
                <label for='phone'>Phone</label>
                <input type="text" name='phone' value="" />
                <br/>
                <label for='address'>Address</label>
                <input type="text" name='address' value="" />
                <br/>
                
                <input type='submit' value="Signup"/>
            </form>
        </div>
    </body>
    
    
</html>
