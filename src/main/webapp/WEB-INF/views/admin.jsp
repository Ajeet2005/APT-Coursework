<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    // Safety net — AuthFilter + AdminServlet already block non-admins,
    // but JSP-level check prevents accidental direct-access renders.
    com.artgallery.model.User adminUser =
        (com.artgallery.model.User) session.getAttribute("loggedInUser");
    if (adminUser == null || !adminUser.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard — Gallery Artisan's</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --clr-bg:      #0d0b14;
            --clr-surface: #13101e;
            --clr-card:    #1a1628;
            --clr-border:  rgba(255,255,255,0.07);
            --clr-accent:  #b89a6f;
            --clr-accent2: #d4b896;
            --clr-text:    #e8e0d5;
            --clr-muted:   #7a7086;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--clr-bg);
            color: var(--clr-text);
            min-height: 100vh;
        }

        /* ── Sidebar ──────────────────────────────────────────── */
        .layout { display: flex; min-height: 100vh; }

        .sidebar {
            width: 240px;
            background: var(--clr-surface);
            border-right: 1px solid var(--clr-border);
            display: flex;
            flex-direction: column;
            flex-shrink: 0;
        }

        .sidebar-brand {
            padding: 28px 24px 20px;
            border-bottom: 1px solid var(--clr-border);
        }
        .sidebar-brand a {
            font-family: 'Cormorant Garamond', serif;
            font-size: 1.3rem;
            font-weight: 600;
            color: var(--clr-accent);
            text-decoration: none;
        }
        .sidebar-brand span {
            display: block;
            font-size: 0.65rem;
            color: var(--clr-muted);
            letter-spacing: 0.15em;
            text-transform: uppercase;
            margin-top: 2px;
        }

        .sidebar-nav {
            padding: 20px 12px;
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .nav-label {
            font-size: 0.65rem;
            letter-spacing: 0.15em;
            text-transform: uppercase;
            color: var(--clr-muted);
            padding: 12px 12px 6px;
        }

        .nav-link {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 12px;
            border-radius: 8px;
            font-size: 0.875rem;
            color: var(--clr-muted);
            text-decoration: none;
            transition: background 0.2s, color 0.2s;
        }
        .nav-link:hover { background: rgba(255,255,255,0.05); color: var(--clr-text); }
        .nav-link.active { background: rgba(184,154,111,0.12); color: var(--clr-accent); }
        .nav-link svg { flex-shrink: 0; opacity: 0.7; }

        .sidebar-footer {
            padding: 16px 12px;
            border-top: 1px solid var(--clr-border);
        }
        .admin-badge {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 12px;
        }
        .avatar {
            width: 32px; height: 32px;
            border-radius: 50%;
            background: var(--clr-accent);
            display: flex; align-items: center; justify-content: center;
            font-size: 0.75rem; font-weight: 600; color: var(--clr-bg);
            flex-shrink: 0;
        }
        .admin-info { overflow: hidden; }
        .admin-name {
            font-size: 0.85rem;
            font-weight: 500;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .admin-role {
            font-size: 0.7rem;
            color: var(--clr-muted);
            text-transform: uppercase;
            letter-spacing: 0.1em;
        }
        .logout-btn {
            display: flex; align-items: center; gap: 8px;
            margin-top: 10px;
            padding: 9px 12px;
            border-radius: 8px;
            font-size: 0.8rem;
            color: var(--clr-muted);
            text-decoration: none;
            transition: background 0.2s, color 0.2s;
        }
        .logout-btn:hover { background: rgba(224,112,112,0.1); color: #e07070; }

        /* ── Main content ─────────────────────────────────────── */
        .main {
            flex: 1;
            padding: 40px 48px;
            overflow-y: auto;
        }

        .page-header {
            margin-bottom: 36px;
        }
        .page-header h1 {
            font-family: 'Cormorant Garamond', serif;
            font-size: 2rem;
            font-weight: 300;
        }
        .page-header p {
            color: var(--clr-muted);
            font-size: 0.875rem;
            margin-top: 4px;
        }

        /* Stat cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }

        .stat-card {
            background: var(--clr-card);
            border: 1px solid var(--clr-border);
            border-radius: 12px;
            padding: 24px;
        }
        .stat-label {
            font-size: 0.7rem;
            letter-spacing: 0.12em;
            text-transform: uppercase;
            color: var(--clr-muted);
            margin-bottom: 12px;
        }
        .stat-value {
            font-family: 'Cormorant Garamond', serif;
            font-size: 2.2rem;
            font-weight: 300;
            color: var(--clr-text);
        }
        .stat-sub {
            font-size: 0.75rem;
            color: var(--clr-muted);
            margin-top: 4px;
        }
        .stat-accent { color: var(--clr-accent); }

        /* Quick-action cards */
        .section-title {
            font-size: 0.7rem;
            letter-spacing: 0.15em;
            text-transform: uppercase;
            color: var(--clr-muted);
            margin-bottom: 16px;
        }

        .actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 16px;
            margin-bottom: 40px;
        }
        .action-card {
            background: var(--clr-card);
            border: 1px solid var(--clr-border);
            border-radius: 12px;
            padding: 22px;
            text-decoration: none;
            color: var(--clr-text);
            display: flex;
            flex-direction: column;
            gap: 10px;
            transition: border-color 0.25s, transform 0.2s;
        }
        .action-card:hover { border-color: var(--clr-accent); transform: translateY(-2px); }
        .action-icon {
            width: 40px; height: 40px;
            border-radius: 10px;
            background: rgba(184,154,111,0.1);
            display: flex; align-items: center; justify-content: center;
        }
        .action-card h3 { font-size: 0.95rem; font-weight: 500; }
        .action-card p { font-size: 0.8rem; color: var(--clr-muted); line-height: 1.5; }

        /* Info note */
        .info-note {
            background: rgba(184,154,111,0.08);
            border: 1px solid rgba(184,154,111,0.2);
            border-radius: 10px;
            padding: 18px 22px;
            font-size: 0.85rem;
            color: var(--clr-muted);
            line-height: 1.7;
        }
        .info-note strong { color: var(--clr-accent); }

        @media (max-width: 768px) {
            .sidebar { display: none; }
            .main { padding: 24px 20px; }
        }
    </style>
</head>
<body>

<div class="layout">

    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="sidebar-brand">
            <a href="${pageContext.request.contextPath}/home">Gallery Artisan's</a>
            <span>Admin Portal</span>
        </div>

        <nav class="sidebar-nav">
            <div class="nav-label">Overview</div>
            <a class="nav-link active" href="${pageContext.request.contextPath}/admin">
                <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                    <rect x="1" y="1" width="6" height="6" rx="1.5" stroke="currentColor" stroke-width="1.4"/>
                    <rect x="9" y="1" width="6" height="6" rx="1.5" stroke="currentColor" stroke-width="1.4"/>
                    <rect x="1" y="9" width="6" height="6" rx="1.5" stroke="currentColor" stroke-width="1.4"/>
                    <rect x="9" y="9" width="6" height="6" rx="1.5" stroke="currentColor" stroke-width="1.4"/>
                </svg>
                Dashboard
            </a>

            <div class="nav-label" style="margin-top:8px;">Catalogue</div>
            <a class="nav-link" href="${pageContext.request.contextPath}/art">
                <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                    <circle cx="8" cy="8" r="6.5" stroke="currentColor" stroke-width="1.4"/>
                    <path d="M8 4v4l3 1.5" stroke="currentColor" stroke-width="1.4" stroke-linecap="round"/>
                </svg>
                Artworks
            </a>
            <a class="nav-link" href="${pageContext.request.contextPath}/artist">
                <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                    <circle cx="8" cy="5.5" r="2.5" stroke="currentColor" stroke-width="1.4"/>
                    <path d="M2.5 14c0-3.038 2.462-5.5 5.5-5.5s5.5 2.462 5.5 5.5" stroke="currentColor" stroke-width="1.4" stroke-linecap="round"/>
                </svg>
                Artists
            </a>
            <a class="nav-link" href="${pageContext.request.contextPath}/categories">
                <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                    <path d="M2 4h12M2 8h12M2 12h8" stroke="currentColor" stroke-width="1.4" stroke-linecap="round"/>
                </svg>
                Categories
            </a>

            <div class="nav-label" style="margin-top:8px;">Front-end</div>
            <a class="nav-link" href="${pageContext.request.contextPath}/home" target="_blank">
                <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                    <path d="M8 1.5L2 7h2v6.5h8V7h2L8 1.5z" stroke="currentColor" stroke-width="1.4" stroke-linejoin="round"/>
                </svg>
                View Site
            </a>
        </nav>

        <div class="sidebar-footer">
            <div class="admin-badge">
                <div class="avatar">
                    <%-- Initials from full name --%>
                    <%= ((com.artgallery.model.User)session.getAttribute("loggedInUser"))
                            .getFullName().trim().substring(0,1).toUpperCase() %>
                </div>
                <div class="admin-info">
                    <div class="admin-name">${sessionScope.loggedInUser.fullName}</div>
                    <div class="admin-role">Administrator</div>
                </div>
            </div>
            <a class="logout-btn" href="${pageContext.request.contextPath}/logout">
                <svg width="14" height="14" viewBox="0 0 14 14" fill="none">
                    <path d="M5 2H2a1 1 0 00-1 1v8a1 1 0 001 1h3M9 10l3-3-3-3M12 7H5" stroke="currentColor" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
                Sign out
            </a>
        </div>
    </aside>

    <!-- Main -->
    <main class="main">
        <div class="page-header">
            <h1>Dashboard</h1>
            <p>Welcome back, ${sessionScope.loggedInUser.fullName}. Here's your gallery at a glance.</p>
        </div>

        <!-- Stats -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-label">Total Artworks</div>
                <div class="stat-value stat-accent">—</div>
                <div class="stat-sub">Connect ArtworkDAO to populate</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Artists</div>
                <div class="stat-value">—</div>
                <div class="stat-sub">Connect ArtistDAO to populate</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Categories</div>
                <div class="stat-value">—</div>
                <div class="stat-sub">Connect CategoryDAO</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Subscribers</div>
                <div class="stat-value">—</div>
                <div class="stat-sub">Connect SubscriberDAO</div>
            </div>
        </div>

        <!-- Quick actions -->
        <div class="section-title">Quick Actions</div>
        <div class="actions-grid">
            <a class="action-card" href="${pageContext.request.contextPath}/art">
                <div class="action-icon">
                    <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                        <rect x="2" y="2" width="16" height="16" rx="3" stroke="#b89a6f" stroke-width="1.5"/>
                        <path d="M6 14l3-5 3 4 2-3 2 4" stroke="#b89a6f" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                </div>
                <h3>Browse Artworks</h3>
                <p>View and manage the full artwork catalogue.</p>
            </a>
            <a class="action-card" href="${pageContext.request.contextPath}/artist">
                <div class="action-icon">
                    <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                        <circle cx="10" cy="7" r="3.5" stroke="#b89a6f" stroke-width="1.5"/>
                        <path d="M3 18c0-3.866 3.134-7 7-7s7 3.134 7 7" stroke="#b89a6f" stroke-width="1.5" stroke-linecap="round"/>
                    </svg>
                </div>
                <h3>Artists</h3>
                <p>Browse artist profiles and their portfolios.</p>
            </a>
            <a class="action-card" href="${pageContext.request.contextPath}/categories">
                <div class="action-icon">
                    <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                        <path d="M3 5h14M3 10h14M3 15h8" stroke="#b89a6f" stroke-width="1.5" stroke-linecap="round"/>
                    </svg>
                </div>
                <h3>Categories</h3>
                <p>View collection categories.</p>
            </a>
            <a class="action-card" href="${pageContext.request.contextPath}/gallery">
                <div class="action-icon">
                    <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                        <rect x="2" y="4" width="7" height="12" rx="2" stroke="#b89a6f" stroke-width="1.5"/>
                        <rect x="11" y="4" width="7" height="5" rx="2" stroke="#b89a6f" stroke-width="1.5"/>
                        <rect x="11" y="11" width="7" height="5" rx="2" stroke="#b89a6f" stroke-width="1.5"/>
                    </svg>
                </div>
                <h3>Gallery Wall</h3>
                <p>View the full gallery exhibition.</p>
            </a>
        </div>

        <div class="info-note">
            <strong>Extend this dashboard</strong> — Add the counts to AdminServlet by injecting
            <code>ArtworkDAO.countAll()</code>, <code>ArtistDAO.countAll()</code>, etc. and passing
            them as request attributes. This dashboard is intentionally minimal so you can build
            on top of it without fighting existing code.
        </div>
    </main>

</div>

</body>
</html>
