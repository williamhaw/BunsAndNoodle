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
            
        }
    }
    catch (Exception e) {
    
    }
%>

