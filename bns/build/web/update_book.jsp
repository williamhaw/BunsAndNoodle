<%@page import="java.sql.*" %>
<% 
    String isbn13 = request.getParameter("isbn13");
    String number_new_copies = request.getParameter("number_new_copies");
    
    try {
        if (isbn13.equals("") || number_new_copies.equals("")) {
            response.sendRedirect("about.jsp?error=Please fill in all fields");
        }
        else if (Integer.parseInt(number_new_copies) <= 0) {
            response.sendRedirect("about.jsp?error=Number of copies cannot be 0 or less");
        }
        else {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/b_and_n_book_store",
                    "bns",
                    "password"
            );
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(
                    "select copies from book where isbn13 = '" + isbn13 + "'"
            );
            int current_copies = 0;
            while(rs.next()) {
                current_copies = rs.getInt("copies");
            }
            int total_copies = current_copies + Integer.parseInt(number_new_copies);
            int i = st.executeUpdate(
                    "update book set copies = '" + total_copies + "'where isbn13='" + isbn13 + "'"
            );
            //registration successful
            if (i > 0) {
                response.sendRedirect("book_search.jsp");
            }
            else {
                response.sendRedirect("about.jsp?error=There was an error with updating of book");
            }
        }
    }
    catch (Exception e) {
        response.sendRedirect("about.jsp?error=" + e.getMessage());
    }
%>