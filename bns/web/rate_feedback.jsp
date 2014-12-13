<%@ page import ="java.sql.*" %>

<%
    String score = request.getParameter("score");
    String isbn13 = request.getParameter("isbn13");
    String user=request.getParameter("user");
    String ratee=request.getParameter("ratee_login");
    java.util.Date dt = new java.util.Date();
    java.text.SimpleDateFormat sdf = 
     new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    String currentTime = sdf.format(dt);
    
    // redirect to login page if there is error
    // the error param in the login page will receive the error msg and print it out (if the error param is not null)
    try {
        if ( (score.equals(""))){        
            response.sendRedirect("book.jsp?isbn13="+isbn13);//+"error=Please fill in all fields");
        } else {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/b_and_n_book_store",
                    "bns", 
                    "password");
            Statement st = con.createStatement();
            int i = st.executeUpdate(
                    "insert into rates_feedback(rater,ratee,ratee_feedback_isbn13,rating) " + 
                    "values ('" + user + "','" + ratee + "','" + isbn13 + "','"
                                + score +"')");
            if (i > 0) { // registration successful
                response.sendRedirect("book.jsp?isbn13="+isbn13);
            } else {
                response.sendRedirect("book.jsp?isbn13="+isbn13+"error=There was a submission Error");
            }
        }
    } catch (SQLIntegrityConstraintViolationException ex) {
        response.sendRedirect("book.jsp?isbn13="+isbn13+"error=username already exists, please use another username");
    } catch (Exception ex) {
        response.sendRedirect("book.jsp?isbn13="+isbn13+"error=" + ex.getMessage());
    }
%>