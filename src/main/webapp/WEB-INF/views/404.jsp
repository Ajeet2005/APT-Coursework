<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Not found — Gallery Artisan’s" scope="request"/>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>
<section class="page-hero">
    <span class="eyebrow">404</span>
    <h1>This canvas is empty</h1>
    <p>The page you were looking for isn&rsquo;t here. Head back to the gallery.</p>
    <p><a class="btn btn-primary" href="<%= request.getContextPath() %>/home">Back to Home</a></p>
</section>
<%@ incl