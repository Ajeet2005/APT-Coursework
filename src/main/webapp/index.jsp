<%-- Forward the bare context root to the HomeServlet --%>
<% response.sendRedirect(request.getContextPath() + "/home"); %>
