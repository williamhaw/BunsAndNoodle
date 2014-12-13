<!-- this is a java snippet )): remember! -->
<%@ page import ="java.sql.*" %>
<% 
    String title = request.getParameter("title");
    String book_format = request.getParameter("book_format");
    String pages = request.getParameter("pages");
    String language = request.getParameter("language");
    String authors = request.getParameter("authors");
    String publisher = request.getParameter("publisher");
    String year = request.getParameter("year");
    String isbn13 = request.getParameter("isbn13");
    String keywords = request.getParameter("keywords");
    String subject = request.getParameter("subject");
    String copies = request.getParameter("copies");
    String price = request.getParameter("price");
    
    //making sure that mysql recognises apostrophies
    title = title.replace("'", "\\'");
    authors = authors.replace("'", "\\'");
    publisher = publisher.replace("'", "\\'");
    
    try {
        if (title.equals("") || 
        book_format.equals("") || 
        pages.equals("") || 
        language.equals("") || 
        authors.equals("") || 
        publisher.equals("") || 
        year.equals("") || 
        isbn13.equals("") || 
        keywords.equals("") || 
        subject.equals("") || 
        copies.equals("") || 
        price.equals("")) {
            response.sendRedirect("about.jsp?error=Please fill in all fields");
        }
        else if (Integer.parseInt(copies) <= 0) {
            response.sendRedirect("about.jsp?error=Copies cannot be 0 or less");
        }
        else if (Float.parseFloat(price) <= 0.0) {
            response.sendRedirect("about.jsp?error=Price cannot be 0 or less");
        }
        else if (isbn13.length() != 14) {
            response.sendRedirect("about.jsp?error=ISBN13 should be 14 characters long");
        } 
        else {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/b_and_n_book_store",
                    "bns",
                    "password"
            );
            Statement st = con.createStatement();
            int i = st.executeUpdate(
                    "insert into book(title, format, pages, language, authors, publisher, year, isbn13, keywords, subject, copies, price) " +
                    "values ('" + title + "','" + book_format + "','" + Integer.parseInt(pages) + "','"
                            + language + "','" + authors + "','" + publisher + "','"
                            + year + "','" + isbn13 + "','" + keywords + "','" 
                            + subject + "','" + Integer.parseInt(copies) + "','" + Float.parseFloat(price) + "')"
            );
            //registration successful
            if (i > 0) {
                response.sendRedirect("book_search.jsp");
            }
            else {
                response.sendRedirect("about.jsp?error=There was an error with adding of book");
            }
        }
    }
    catch (Exception e) {
        response.sendRedirect("about.jsp?error=" + e.getMessage());
    }
%>
