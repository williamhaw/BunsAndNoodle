<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" src="//normalise-css.googlecode.com/svn/trunk/normalize.css">
        <link rel="stylesheet" type="text/css" href="css/book.css">
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

            <c:choose>
                <c:when test="${param.error != null}">
                    Error: <c:out value="${param.error}"/>
                </c:when>
            </c:choose>

            <sql:query var="result" dataSource="jdbc/bns">
                SELECT title, format, pages, language, authors, publisher, year, 
                isbn13, subject, copies, price
                FROM book
                WHERE book.isbn13 = ? <sql:param value="${param.isbn13}"/>
            </sql:query>

            <div id="book_info">

                <table>
                    <c:forEach var="row" items="${result.rows}">
                        <tr>
                            <td><h2>Title</h2></td><td><c:out value="${row.title}"/></td>
                        </tr>
                        <tr>
                            <td><h2>Format</h2></td><td><c:out value="${row.format}"/></td>
                        </tr>
                        <tr>
                            <td><h2>Pages</h2></td><td><c:out value="${row.pages}"/></td>
                        </tr>
                        <tr>
                            <td><h2>Language</h2></td><td><c:out value="${row.language}"/></td>
                        </tr>
                        <tr>
                            <td><h2>Authors</h2></td><td><c:out value="${row.authors}"/></td>
                        </tr>
                        <tr>
                            <td><h2>Publisher</h2></td><td><c:out value="${row.publisher}"/></td>
                        </tr>
                        <tr>
                            <td><h2>Year</h2></td><td><c:out value="${row.year}"/></td>
                        </tr>
                        <tr>
                            <td><h2>ISBN13</h2></td><td><c:out value="${row.isbn13}"/></td>
                        </tr>
                        <tr>
                            <td><h2>Subject</h2></td><td><c:out value="${row.subject}"/></td>
                        </tr>
                        <tr>
                            <td><h2>Copies Available</h2></td><td><c:choose>
                                    <c:when test="${row.copies>0}"> 
                                        <c:out value="${row.copies}"/>
                                    </c:when>
                                    <c:otherwise>
                                        Out of stock
                                    </c:otherwise>
                                </c:choose></td>
                        </tr>
                        <tr><td><h2>Price Now</h2></td><td>$<c:out value="${row.price}"/></td></tr>
                        <tr><td><h2>Order Copies</h2></td>
                            <td>
                                <c:choose>
                                    <c:when test='${row.copies>0}'>
                                        <form method='post' action='order.jsp'>
                                            <input type = "number" name ="order_number" value="1" min="1" max="${row.copies}" />
                                            <input type='hidden' name ='copy_number' value='${row.copies}'/>
                                            <input type='hidden' name='isbn13' value='${param.isbn13}'/>
                                            <input type='hidden' name='book_name' value='${row.title}' />
                                            <input type ='submit' value='Order Book Now!'/>
                                        </form></c:when>
                                    <c:otherwise><h1>BOOK OUT OF STOCK!</h1></c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </div>
                <br><br>
            <sql:query var="feedbacks" dataSource="jdbc/bns">
                select feedback_text, feedback_score, feedback_customer,name,feedback_date,avg(IFNULL(rating,0)) as avgScore, count(*) as ratingCount from(
                SELECT feedback_customer, feedback_date,feedback_score,feedback_text, name,feedback_isbn13
                FROM gives_feedback inner join customer on customer.login=gives_feedback.feedback_customer
                WHERE feedback_isbn13 =  ? <sql:param value="${param.isbn13}"/>) as K left join rates_feedback on rates_feedback.ratee=feedback_customer
                and ratee_feedback_isbn13=feedback_isbn13 group by feedback_text,feedback_score,feedback_customer,name,feedback_date order by avgScore DESC;
            </sql:query> 
            <c:set var="userid" value = '<%= session.getAttribute("userid")%>'/>
            <%--<c:out value='${userid}'/>--%>
            <c:set var='givenFeedback' value='false'/>
            <c:forEach var="row" items='${feedbacks.rows}'>
                <c:if test='${row.feedback_customer==userid}'>
                    <c:set var='givenFeedback' value='true'/>
                </c:if>
            </c:forEach>
            <h2>Give Feedback</h2>
            <c:choose><c:when test='${givenFeedback}'>        
                    You have given your feedback previously! Thank you!
                </c:when>
                <c:otherwise>
                    <form method='post' action='submit_feedback.jsp'>
                        <label for='feedback'>Feedback: </label><br>
                        <textarea rows="4" cols="50" name="feedback">
Enter text here...</textarea>
                        <br>
                        <label for='score'>Score: </label>
                        <input type="number" name='score' value="" min='1' max='10'/>
                        <input type='submit' value="Submit Review"/>
                        <input type='text' name='isbn13' value='${param.isbn13}'/>
                        <input type="text" name='user' value="<%= session.getAttribute("userid")%>" />
                    </form>
                </c:otherwise>

            </c:choose>

            <br><br>
            <h2>Submitted feedback</h2>
            <div id="feedback_given">
                <%
                    // doing this to format the column names a bit nicer rather than using the default
                    // column names from our sql table
                    String[] colNames = {"Customer", "Date Given", "Score of Feedback", "Feedback", "Usefulness", "Rate Feedback!"};
                    pageContext.setAttribute("colNames", colNames);
                %> 
                <table>
                    <tr>
                        <c:forEach var="columnName" items="${colNames}">
                            <th><c:out value="${columnName}"/></th>
                            </c:forEach>
                    </tr>
                    <c:forEach var="row" items="${feedbacks.rows}">
                        <tr>
                            <td><c:out value="${row.name}"/></td>
                            <td><c:out value="${row.feedback_date}"/></td>
                            <td><center><c:out value="${row.feedback_score}"/></center></td>
                        <td><c:out value="${row.feedback_text}"/></td>
                        <td><center>
                            <c:choose>
                                <c:when test='${row.avgScore<0.66667}'>
                                    <img src="img/sad0.png" title='${row.avgScore}' width="30" height="30">
                                </c:when>
                                <c:when test='${row.avgScore<1.33333}'>
                                    <img src="img/neutral1.png" title='${row.avgScore}' width="30" height="30">
                                </c:when>
                                <c:otherwise>
                                    <img src="img/happy2.png" title='${row.avgScore}' width="30" height="30">
                                </c:otherwise>
                            </c:choose>
                            <br>
                            <c:out value="${row.ratingCount}"/> user(s).
                        </center>
                        </td>
                        <c:set var="feedbackRated" value='false'/>
                        <sql:query var="feedback_scores" dataSource="jdbc/bns">
                            select rater,rating from rates_feedback where ratee_feedback_isbn13 =  ? <sql:param value="${param.isbn13}"/> and ratee= ?<sql:param value="${row.feedback_customer}"/>;
                        </sql:query>
                        <c:forEach var="ratingsOf" items ='${feedback_scores.rows}'>
                            <%--<c:out value='${ratingsOf.rater}'/>--%>
                            <%--<c:out value='${userid}'/>--%>
                            <c:if test='${ratingsOf.rater==userid}'>
                                <c:set var="feedbackRated" value='true'/>
                                <c:set var="feedbackRating" value='${ratingsOf.rating}'/>
                            </c:if>
                        </c:forEach>
                        <%--<c:out value='${feedbackRated}'/>--%>
                        <%--<c:out value='${row.feedback_customer}'/>--%>
                        <td><c:choose>

                                <c:when test='${feedbackRated}'>
                                    You have rated this feedback as 

                                    <c:choose>
                                        <c:when test='${feedbackRating==0}'>
                                            <img src="img/sad0.png" title='Not Useful' width="30" height="30">
                                        </c:when>
                                        <c:when test='${feedbackRating==1}'>
                                            <img src="img/neutral1.png" title='Neutral' width="30" height="30">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="img/happy2.png" title='Useful' width="30" height="30">
                                        </c:otherwise>
                                    </c:choose>
                                    !

                                </c:when>
                                <c:when test='${userid==row.feedback_customer}'>
                                    You cannot rate your own feedback!
                                </c:when>
                                <c:otherwise>
                                    <form method='post' action='rate_feedback.jsp'>
                                        <label for='score'>How useful is this review? </label><br>
                                        <!--<input type="number" name='score' value="" min='0' max='2'/>-->

                                        <input type='hidden' name='isbn13' value='${param.isbn13}'/>
                                        <input type="hidden" name='user' value="<%= session.getAttribute("userid")%>" />
                                        <input type="hidden" name="ratee_login" value="${row.feedback_customer}"/>
                                        <label>
                                            <input type="radio" name="score" value="0"/><img src="img/sad0.png" title="Not Useful" height="20" width="20"/>
                                        </label>
                                        <label>
                                            <input type="radio" name="score" value="1"/><img src="img/neutral1.png" title="Neutral" height="20" width="20"/>
                                        </label>
                                        <label>
                                            <input type="radio" name="score" value="2"/><img src="img/happy2.png" title="Useful" height="20" width="20"/>
                                        </label>
                                        <input type='submit' value="Submit!"/>
                                    </form>

                                </c:otherwise>
                            </c:choose></td>
                        </tr>


                        <br><br>






                    </c:forEach>
                </table>

                <!--<br><br>-->
            </div>
    </body>
</html>
