<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Not found — Gallery Artisan’s" scope="request"/>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<section class="error-404">
    <div class="error-404-code">404</div>
    <h1>This canvas is empty</h1>
    <p>The masterpiece you&rsquo;re looking for has wandered off the gallery walls.
       Perhaps it was never hung, or maybe it found a new home.</p>
    <div class="error-404-links">
        <a class="btn btn-primary" href="<%= request.getContextPath() %>/home">Back to Home</a>
        <a class="btn btn-ghost" href="<%= request.getContextPath() %>/gallery">Browse Gallery</a>
    </div>
</section>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>