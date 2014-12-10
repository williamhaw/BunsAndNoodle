<%@ page import ="java.sql.*" %>
<%
    String user = request.getParameter("username");   
    String pwd = request.getParameter("password");
    String fullname = request.getParameter("fullname");
    String creditcard = request.getParameter("creditcard");
    String phone = request.getParameter("phone");
    String address = request.getParameter("address");
    
    // redirect to login page if there is error
    // the error param in the login page will receive the errror msg and print it out (if the error param is not null)
    try {
        if (user.equals("") || pwd.equals("") || fullname.equals("") || 
            creditcard.equals("") || phone.equals("") || address.equals("")) {        
            response.sendRedirect("login.jsp?error=Please fill in all fields");
        } else if (pwd.length() < 7) {
            response.sendRedirect("login.jsp?error=Please enter a longer password");
        } else if (creditcard.length() < 12 || creditcard.length() > 19) { // a very SIMPLISTIC check on the credit card num
            response.sendRedirect("login.jsp?error=Please enter a valid credit card num");
        } else if (phone.length() < 8) {
            response.sendRedirect("login.jsp?error=Please enter a valid phone number");
        } else if (address.length() < 8) {
            response.sendRedirect("login.jsp?error=Please enter a valid address");
        } else {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/b_and_n_book_store",
                    "bns", 
                    "password");
            Statement st = con.createStatement();
            int i = st.executeUpdate(
                    "insert into customer(name, login, pw, credit_card, phone, address) " + 
                    "values ('" + fullname + "','" + user + "','" + pwd + "','"
                                + creditcard + "','" + phone + "','" + address +  "')");
            if (i > 0) { // registration successful
                session.setAttribute("userid", user);
                session.setAttribute("username", fullname);
                response.sendRedirect("book_search.jsp");
            } else {
                response.sendRedirect("login.jsp?error=There was a registration error");
            }
        }
    } catch (SQLIntegrityConstraintViolationException ex) {
        response.sendRedirect("login.jsp?error=username already exists, please use another username");
    } catch (Exception ex) {
        response.sendRedirect("login.jsp?error=" + ex.getMessage());
    }
%>