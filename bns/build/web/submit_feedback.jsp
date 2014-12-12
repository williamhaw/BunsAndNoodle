<%@ page import ="java.sql.*" %>

<%
    String feedback = request.getParameter("feedback");   
    String score = request.getParameter("score");
    String isbn13 = request.getParameter("isbn13");
    String user=request.getParameter("user");
    java.util.Date dt = new java.util.Date();
    java.text.SimpleDateFormat sdf = 
     new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    String currentTime = sdf.format(dt);
    
    // redirect to login page if there is error
    // the error param in the login page will receive the error msg and print it out (if the error param is not null)
    try {
        if ((feedback.equals("")) || (score.equals(""))){        
            response.sendRedirect("book.jsp?isbn13="+isbn13);//+"error=Please fill in all fields");
        } else {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/b_and_n_book_store",
                    "bns", 
                    "password");
            Statement st = con.createStatement();
            int i = st.executeUpdate(
                    "insert into gives_feedback(feedback_isbn13,feedback_customer,feedback_date,feedback_score,feedback_text) " + 
                    "values ('" + isbn13 + "','" + user + "','" + currentTime + "','"
                                + score + "','" + feedback +  "')");
            if (i > 0) { // registration successful
                response.sendRedirect("book.jsp?isbn13="+isbn13);
            } else {
                response.sendRedirect("book.jsp?isbn13="+isbn13);//+"error=There was a submission Error");
            }
        }
    } catch (SQLIntegrityConstraintViolationException ex) {
        response.sendRedirect("book.jsp?isbn13="+isbn13);//+"error=username already exists, please use another username");
    } catch (Exception ex) {
        response.sendRedirect("book.jsp?isbn13="+isbn13);//+"error=" + ex.getMessage());
    }
%>