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
        <script type="text/javascript">

            function toggle2(id, link) {
                var e = document.getElementById(id);
                if (e.style.display == '') {
                    e.style.display = 'none';
                    link.innerHTML = 'Rate Feedback';
                } else {
                    e.style.display = '';
                    link.innerHTML = 'Rate Feedback!';
                }
            }

        </script>
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
                    <c:set var="copyNumber" value='${row.copies}'/>
                    <c:set var="bookName" value = '${row.title}'/>
                </p>
                <b>Price: </b> $<c:out value="${row.price}"/>
            </c:forEach><br><br>
            <c:choose>
                <c:when test='${copyNumber>0}'>
                    <h1>Order Book Now!</h1>
                    <form method='post' action='order.jsp'>
                        <label for="numberOfBooks">Number of books to order: </label>
                        <input type = "number" name ="order_number" value="1" min="1" max="${copyNumber}"/>
                        <input type='hidden' name ='copy_number' value='${copyNumber}'/>
                        <input type='hidden' name='isbn13' value='${param.isbn13}'/>
                        <input type='hidden' name='book_name' value='${bookName}' />
                        <input type ='submit' value='Order Book Now!'/>
                    </form></c:when>
                <c:otherwise><h1>BOOK OUT OF STOCK!</h1></c:otherwise>
            </c:choose>
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

            <c:forEach var="row" items="${feedbacks.rows}">
                <p><b>Customer:</b> <c:out value="${row.name}"/></p> 
                <p><b>Date:</b> <c:out value="${row.feedback_date}"/></p> 
                <p><b>Score:</b> <c:out value="${row.feedback_score}"/></p> 
                <p><b>Text:</b> <c:out value="${row.feedback_text}"/></p>
                <p>This feedback has been graded as: <b><c:out value="${row.avgScore}"/></b> from <b><c:out value="${row.ratingCount}"/></b> user(s).</p>
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
                <c:choose>

                    <c:when test='${feedbackRated}'>
                        You have rated this feedback as <c:out value='${feedbackRating}'/> points.
                    </c:when>
                    <c:when test='${userid==row.feedback_customer}'>
                        You cannot rate your own feedback!
                    </c:when>
                    <c:otherwise>
                        <form method='post' action='rate_feedback.jsp'>
                            <label for='score'>How useful is this review? </label><br>
                            <input type="number" name='score' value="" min='1' max='2'/>
                            <input type='submit' value="Submit Review"/>
                            <input type='hidden' name='isbn13' value='${param.isbn13}'/>
                            <input type="hidden" name='user' value="<%= session.getAttribute("userid")%>" />
                            <input type="hidden" name="ratee_login" value="${row.feedback_customer}"/>
                        </form>
                    </c:otherwise>
                </c:choose>

                <br><br>






            </c:forEach>
            <br><br>
        </div>
    </body>
</html>
