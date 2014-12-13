package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.sql.*;

public final class add_005fbook_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.List<String> _jspx_dependants;

  private org.glassfish.jsp.api.ResourceInjector _jspx_resourceInjector;

  public java.util.List<String> getDependants() {
    return _jspx_dependants;
  }

  public void _jspService(HttpServletRequest request, HttpServletResponse response)
        throws java.io.IOException, ServletException {

    PageContext pageContext = null;
    HttpSession session = null;
    ServletContext application = null;
    ServletConfig config = null;
    JspWriter out = null;
    Object page = this;
    JspWriter _jspx_out = null;
    PageContext _jspx_page_context = null;

    try {
      response.setContentType("text/html");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;
      _jspx_resourceInjector = (org.glassfish.jsp.api.ResourceInjector) application.getAttribute("com.sun.appserv.jsp.resource.injector");

      out.write("<!-- this is a java snippet )): remember! -->\r\n");
      out.write("\r\n");
 
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
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/b_and_n_book_store",
                    "bns",
                    "password"
            );
            Statement st = con.createStatement();
            int i = st.executeUpdate(
                    "insert into book(title, format, pages, language, authors, publisher, year, isbn13, keywords, subject, copies, price) " +
                    "values ('" + title + "','" + book_format + "','" + pages + "','"
                            + language + "','" + authors + "','" + publisher + "','"
                            + year + "','" + isbn13 + "','" + keywords + "','" 
                            + subject + "','" + copies + "','" + price + "')'"
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

      out.write("\r\n");
      out.write("\r\n");
    } catch (Throwable t) {
      if (!(t instanceof SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          out.clearBuffer();
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
