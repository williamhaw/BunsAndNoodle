<%
    session.setAttribute("admin", null); // reset to null
    session.invalidate();
    response.sendRedirect("about.jsp");
%>