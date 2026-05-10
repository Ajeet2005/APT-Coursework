<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.Cookie" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
    String ctx = request.getContextPath();

    String rememberedEmail = "";
    String rememberMeChecked = "";

    Cookie[] cookies = request.getCookies();

    if (cookies != null) {
        for (Cookie c : cookies) {

            if ("rememberedEmail".equals(c.getName())) {
                rememberedEmail = c.getValue();
            }

            if ("rememberMe".equals(c.getName())
                    && "true".equals(c.getValue())) {
                rememberMeChecked = "checked";
            }
        }
    }

    String emailValue =
            (request.getAttribute("emailValue") != null)
                    ? request.getAttribute("emailValue").toString()
                    : rememberedEmail;
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In — Gallery Artisan's</title>

    <meta name="description"
          content="Sign in to Gallery Artisan's to browse, collect, and purchase original acrylic artworks.">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@300;400;600&family=Inter:wght@300;400;500;600&display=swap"
          rel="stylesheet">

    <style>

        *{
            margin:0;
            padding:0;
            box-sizing:border-box;
        }

        :root{
            --clr-bg:#0d0b14;
            --clr-panel:#13101e;
            --clr-border:rgba(255,255,255,.08);
            --clr-accent:#b89a6f;
            --clr-accent2:#d4b896;
            --clr-text:#e8e0d5;
            --clr-muted:#7a7086;
            --clr-error:#e07070;
            --clr-input-bg:rgba(255,255,255,.04);
        }

        body{
            font-family:'Inter',sans-serif;
            background:var(--clr-bg);
            color:var(--clr-text);
            min-height:100vh;
        }

        .auth-shell{
            display:flex;
            min-height:100vh;
        }

        /* LEFT SIDE */

        .auth-visual{
            flex:1;
            position:relative;
            overflow:hidden;
            display:none;
        }

        @media(min-width:860px){
            .auth-visual{
                display:block;
            }
        }

        .slide{
            position:absolute;
            inset:0;
        }

        .slide img{
            width:100%;
            height:100%;
            object-fit:cover;
        }

        .slide::after{
            content:'';
            position:absolute;
            inset:0;
            background:linear-gradient(
                    135deg,
                    rgba(13,11,20,.65),
                    rgba(13,11,20,.2),
                    rgba(13,11,20,.75)
            );
        }

        .visual-brand{
            position:absolute;
            top:32px;
            left:40px;
            z-index:5;
            color:white;
            text-decoration:none;
            font-size:1.7rem;
            font-family:'Cormorant Garamond',serif;
        }

        .slide-caption{
            position:absolute;
            bottom:60px;
            left:50px;
            z-index:5;
        }

        .slide-caption h2{
            font-size:2.7rem;
            font-family:'Cormorant Garamond',serif;
            font-weight:300;
            line-height:1.2;
        }

        .slide-caption p{
            margin-top:10px;
            letter-spacing:.15em;
            text-transform:uppercase;
            color:var(--clr-accent2);
            font-size:.75rem;
        }

        /* RIGHT SIDE */

        .auth-form-wrap{
            width:100%;
            max-width:460px;
            background:var(--clr-panel);
            padding:52px 44px;
            display:flex;
            flex-direction:column;
            justify-content:center;
            position:relative;
        }

        .back-home{
            position:absolute;
            top:25px;
            left:25px;
            color:var(--clr-muted);
            text-decoration:none;
            font-size:.8rem;
        }

        .mobile-brand{
            display:none;
        }

        @media(max-width:859px){
            .mobile-brand{
                display:block;
                text-align:center;
                margin-bottom:30px;
                font-size:2rem;
                color:var(--clr-accent);
                font-family:'Cormorant Garamond',serif;
            }
        }

        .form-header{
            text-align:center;
            margin-bottom:30px;
        }

        .form-header h1{
            font-family:'Cormorant Garamond',serif;
            font-size:2.5rem;
            font-weight:300;
        }

        .form-header p{
            margin-top:8px;
            color:var(--clr-muted);
            font-size:.9rem;
        }

        .ornament{
            width:50px;
            height:1px;
            background:var(--clr-accent);
            margin:0 auto 30px;
        }

        .field{
            margin-bottom:20px;
        }

        .field label{
            display:block;
            margin-bottom:8px;
            font-size:.75rem;
            text-transform:uppercase;
            letter-spacing:.1em;
            color:var(--clr-muted);
        }

        .field input{
            width:100%;
            padding:14px 16px;
            border-radius:8px;
            border:1px solid var(--clr-border);
            background:var(--clr-input-bg);
            color:var(--clr-text);
            outline:none;
            font-size:.95rem;
        }

        .field input:focus{
            border-color:var(--clr-accent);
        }

        .remember-me{
            display:flex;
            align-items:center;
            gap:10px;
            margin-bottom:24px;
            color:var(--clr-muted);
            font-size:.85rem;
        }

        .btn-primary{
            width:100%;
            padding:14px;
            border:none;
            border-radius:8px;
            background:var(--clr-accent);
            color:#111;
            font-weight:600;
            cursor:pointer;
            transition:.3s;
        }

        .btn-primary:hover{
            background:var(--clr-accent2);
        }

        .form-footer{
            margin-top:28px;
            text-align:center;
            color:var(--clr-muted);
            font-size:.85rem;
        }

        .form-footer a{
            color:var(--clr-accent);
            text-decoration:none;
            font-weight:600;
        }

        .error-banner{
            background:rgba(224,112,112,.1);
            border:1px solid rgba(224,112,112,.3);
            color:var(--clr-error);
            padding:12px 16px;
            border-radius:8px;
            margin-bottom:20px;
        }

    </style>
</head>

<body>

<div class="auth-shell">

    <!-- LEFT SIDE -->
    <div class="auth-visual">

        <a class="visual-brand" href="<%= ctx %>/home">
            Gallery Artisan's
        </a>

        <div class="slide">

            <img src="<%= ctx %>/assets/images/landscape/NB_Gurung-9.jpg"
                 alt="Artwork">

            <div class="slide-caption">
                <h2>
                    Horizons that stretch
                    beyond the canvas
                </h2>

                <p>Landscape Collection</p>
            </div>

        </div>

    </div>

    <!-- RIGHT SIDE -->
    <div class="auth-form-wrap">

        <a class="back-home" href="<%= ctx %>/home">
            ← Back to Gallery
        </a>

        <div class="mobile-brand">
            Gallery Artisan's
        </div>

        <div class="form-header">
            <h1>Welcome back</h1>
            <p>Sign in with your registered credentials</p>
        </div>

        <div class="ornament"></div>

        <!-- ERROR MESSAGE -->
        <c:if test="${not empty error}">
            <div class="error-banner">
                    ${error}
            </div>
        </c:if>

        <!-- LOGIN FORM -->
        <form action="${pageContext.request.contextPath}/login"
              method="post"
              id="loginForm"
              autocomplete="on">

            <div class="field">

                <label for="email">
                    Email Address
                </label>

                <input type="email"
                       id="email"
                       name="email"
                       value="<%= emailValue %>"
                       placeholder="you@example.com"
                       required
                       autocomplete="email">

            </div>

            <div class="field">

                <label for="password">
                    Password
                </label>

                <input type="password"
                       id="password"
                       name="password"
                       placeholder="••••••••"
                       required
                       autocomplete="current-password">

            </div>

            <label class="remember-me">

                <input type="checkbox"
                       name="rememberMe"
                    <%= rememberMeChecked %>>

                <span>Remember me for 30 days</span>

            </label>

            <button type="submit"
                    class="btn-primary">
                Sign In
            </button>

        </form>

        <div class="form-footer">
            Don't have an account?
            <a href="${pageContext.request.contextPath}/register">
                Sign Up
            </a>
        </div>

    </div>

</div>

</body>
</html>