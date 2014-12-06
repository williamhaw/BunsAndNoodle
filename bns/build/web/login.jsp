<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" src="//normalise-css.googlecode.com/svn/trunk/normalize.css">
        <link rel="stylesheet" type="text/css" href="css/login.css">
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
	                </ul>
	            </nav>
	        </header>


	        <h2>Login or Sign Up</h2>
	        <h2>Rmb to handle errors (e.g. user name not unique, user doesn't exist or password don't match etc.)</h2>
        </div>
    </body>
    
    
</html>
