<%
    session.setAttribute("userid", null); // reset to null
    session.setAttribute("username", null); // reset to null
    session.invalidate();
    response.sendRedirect("login.jsp");
%>