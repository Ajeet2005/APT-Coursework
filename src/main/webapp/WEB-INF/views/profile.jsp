<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Edit Profile &mdash; Gallery Artisan's" scope="request"/>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<%
    // Flash type: "success" or "error"
    String flashType = (String) session.getAttribute("flashType");
    if (flashType == null) flashType = "success";
    session.removeAttribute("flashType");
%>

<section class="page-hero botanical-hero">
    <span class="eyebrow">Account</span>
    <h1>My Profile</h1>
    <p>Manage your account details and security settings.</p>
</section>

<section class="profile-wrap">
    <div class="profile-card">

        <%-- ── Avatar ─────────────────────────────────────────────────── --%>
        <div class="profile-avatar-section">
            <div class="profile-avatar">
                <span class="profile-avatar-initials"><%= initials %></span>
            </div>
            <div class="profile-avatar-info">
                <h3 class="profile-user-name"><%= currentUser.getFullName() %></h3>
                <span class="profile-user-role"><%= isAdmin ? "Administrator" : "Member" %></span>
            </div>
        </div>

        <%-- ── Tabs ───────────────────────────────────────────────────── --%>
        <div class="profile-tabs" role="tablist">
            <button class="profile-tab active" data-tab="account" role="tab" aria-selected="true">
                <svg width="16" height="16" viewBox="0 0 20 20" fill="none"><circle cx="10" cy="7" r="4" stroke="currentColor" stroke-width="1.5"/><path d="M3 18c0-3.866 3.134-7 7-7s7 3.134 7 7" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
                Account
            </button>
            <button class="profile-tab" data-tab="security" role="tab" aria-selected="false">
                <svg width="16" height="16" viewBox="0 0 20 20" fill="none"><rect x="4" y="9" width="12" height="8" rx="2" stroke="currentColor" stroke-width="1.5"/><path d="M7 9V6a3 3 0 0 1 6 0v3" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
                Security
            </button>
        </div>

        <%-- ── Account Tab ────────────────────────────────────────────── --%>
        <form action="<%= ctx %>/profile" method="POST" class="profile-form" id="profileForm">

            <div class="profile-tab-content active" id="tab-account">
                <div class="profile-form-group">
                    <label for="profileFullName">Full Name</label>
                    <div class="profile-input-wrap">
                        <svg width="18" height="18" viewBox="0 0 20 20" fill="none"><circle cx="10" cy="7" r="4" stroke="currentColor" stroke-width="1.4"/><path d="M3 18c0-3.866 3.134-7 7-7s7 3.134 7 7" stroke="currentColor" stroke-width="1.4" stroke-linecap="round"/></svg>
                        <input type="text" id="profileFullName" name="fullName"
                               value="<%= currentUser.getFullName() %>"
                               placeholder="Your full name" required>
                    </div>
                </div>

                <div class="profile-form-group">
                    <label for="profileEmail">Email Address</label>
                    <div class="profile-input-wrap">
                        <svg width="18" height="18" viewBox="0 0 20 20" fill="none"><rect x="2" y="4" width="16" height="12" rx="2" stroke="currentColor" stroke-width="1.4"/><path d="M2 6l8 5 8-5" stroke="currentColor" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round"/></svg>
                        <input type="email" id="profileEmail" name="email"
                               value="<%= currentUser.getEmail() %>"
                               placeholder="you@example.com" required>
                    </div>
                </div>
            </div>

            <%-- ── Security Tab ───────────────────────────────────────── --%>
            <div class="profile-tab-content" id="tab-security">
                <p class="profile-security-note">Leave the password fields blank if you don&rsquo;t want to change your password.</p>

                <div class="profile-form-group">
                    <label for="profileCurrentPassword">Current Password</label>
                    <div class="profile-input-wrap">
                        <svg width="18" height="18" viewBox="0 0 20 20" fill="none"><rect x="4" y="9" width="12" height="8" rx="2" stroke="currentColor" stroke-width="1.4"/><path d="M7 9V6a3 3 0 0 1 6 0v3" stroke="currentColor" stroke-width="1.4" stroke-linecap="round"/></svg>
                        <input type="password" id="profileCurrentPassword" name="currentPassword"
                               placeholder="Enter current password" autocomplete="current-password">
                    </div>
                </div>

                <div class="profile-form-group">
                    <label for="profileNewPassword">New Password</label>
                    <div class="profile-input-wrap">
                        <svg width="18" height="18" viewBox="0 0 20 20" fill="none"><rect x="4" y="9" width="12" height="8" rx="2" stroke="currentColor" stroke-width="1.4"/><path d="M7 9V6a3 3 0 0 1 6 0v3" stroke="currentColor" stroke-width="1.4" stroke-linecap="round"/><circle cx="10" cy="13.5" r="1.5" fill="currentColor"/></svg>
                        <input type="password" id="profileNewPassword" name="newPassword"
                               placeholder="Enter new password" autocomplete="new-password"
                               minlength="6">
                    </div>
                    <span class="profile-hint">Minimum 6 characters</span>
                </div>
            </div>

            <%-- ── Actions ────────────────────────────────────────────── --%>
            <div class="profile-actions">
                <button type="submit" class="profile-btn-update" id="profileUpdateBtn">
                    <svg width="18" height="18" viewBox="0 0 20 20" fill="none"><path d="M5 10l3 3 7-7" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>
                    Update Profile
                </button>
                <a href="<%= ctx %>/home" class="profile-btn-cancel">Cancel</a>
            </div>
        </form>
    </div>
</section>

<%-- ── Tab switching JS ───────────────────────────────────────────────── --%>
<script>
(function() {
    var tabs = document.querySelectorAll('.profile-tab');
    var panes = document.querySelectorAll('.profile-tab-content');

    tabs.forEach(function(tab) {
        tab.addEventListener('click', function() {
            var target = this.getAttribute('data-tab');

            tabs.forEach(function(t) {
                t.classList.remove('active');
                t.setAttribute('aria-selected', 'false');
            });
            panes.forEach(function(p) { p.classList.remove('active'); });

            this.classList.add('active');
            this.setAttribute('aria-selected', 'true');
            document.getElementById('tab-' + target).classList.add('active');
        });
    });
})();
</script>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>
