<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Admin Dashboard &mdash; Gallery Artisan&rsquo;s" scope="request"/>
<% request.setAttribute("activePage", "admin"); %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<section class="page-hero botanical-hero">
    <span class="eyebrow">Administration</span>
    <h1>Admin Dashboard</h1>
    <p>Welcome, <%= currentUser.getFullName() %>. You are signed in as an administrator.</p>
</section>

<section class="adm-wrap">

    <c:choose>
        <%-- ── DASHBOARD VIEW ──────────────────────────────────────────────── --%>
        <c:when test="${view == 'dashboard'}">
            <%-- Metric Cards --%>
            <div class="adm-cards">
                <a href="${pageContext.request.contextPath}/admin/artworks" class="adm-card">
                    <div class="adm-card-icon"><i class="fa-solid fa-image"></i></div>
                    <p class="adm-card-label">Total Artworks</p>
                    <p class="adm-card-metric">${not empty totalArtworks ? totalArtworks : '—'}</p>
                </a>
                <a href="${pageContext.request.contextPath}/admin/artists" class="adm-card">
                    <div class="adm-card-icon"><i class="fa-solid fa-palette"></i></div>
                    <p class="adm-card-label">Total Artists</p>
                    <p class="adm-card-metric">${not empty totalArtists ? totalArtists : '—'}</p>
                </a>
                <a href="${pageContext.request.contextPath}/admin/users" class="adm-card">
                    <div class="adm-card-icon"><i class="fa-solid fa-users"></i></div>
                    <p class="adm-card-label">Registered Users</p>
                    <p class="adm-card-metric">${not empty totalUsers ? totalUsers : '—'}</p>
                </a>

                <a href="${pageContext.request.contextPath}/admin/orders" class="adm-card">
                    <div class="adm-card-icon"><i class="fa-solid fa-box-open"></i></div>
                    <p class="adm-card-label">Total Orders</p>
                    <p class="adm-card-metric">${not empty totalOrders ? totalOrders : '—'}</p>
                </a>
            </div>

            <%-- Charts --%>
            <div class="adm-charts">
                <div class="adm-panel">
                    <h3 class="adm-panel-title">Artworks by Category</h3>
                    <p class="adm-panel-sub">Distribution across gallery categories</p>
                    <div class="adm-chart-wrap"><canvas id="categoryChart"></canvas></div>
                </div>
                <div class="adm-panel">
                    <h3 class="adm-panel-title">Monthly Orders</h3>
                    <p class="adm-panel-sub">Order volume over the last 6 months</p>
                    <div class="adm-chart-wrap"><canvas id="ordersChart"></canvas></div>
                </div>
            </div>

            <%-- Bottom Panel --%>
            <div class="adm-bottom">
                <div class="adm-panel adm-actions">
                    <h3 class="adm-panel-title">Quick Actions</h3>
                    <div class="adm-action-grid">
                        <a href="${pageContext.request.contextPath}/admin/artworks?action=add" class="adm-action-btn"><span><i class="fa-solid fa-image"></i></span>Add Artwork</a>
                        <a href="${pageContext.request.contextPath}/admin/artists?action=add" class="adm-action-btn"><span><i class="fa-solid fa-palette"></i></span>Add Artist</a>
                        <a href="${pageContext.request.contextPath}/admin/categories?action=add" class="adm-action-btn"><span><i class="fa-solid fa-folder-open"></i></span>Add Category</a>
                        <a href="${pageContext.request.contextPath}/admin/users" class="adm-action-btn"><span><i class="fa-solid fa-users"></i></span>View Users</a>
                        <a href="${pageContext.request.contextPath}/admin/orders" class="adm-action-btn"><span><i class="fa-solid fa-box-open"></i></span>View Orders</a>
                    </div>
                </div>
                <div class="adm-panel adm-recent">
                    <h3 class="adm-panel-title">Recent Artworks</h3>
                    <ul class="adm-recent-list">
                        <c:choose>
                            <c:when test="${not empty recentArtworks}">
                                <c:forEach var="art" items="${recentArtworks}">
                                    <li><span class="adm-recent-title">${art.title}</span><span class="adm-recent-meta">${art.artistName}</span></li>
                                </c:forEach>
                            </c:when>
                            <c:otherwise><li class="adm-recent-empty">No artworks yet.</li></c:otherwise>
                        </c:choose>
                    </ul>
                </div>
            </div>
        </c:when>

        <%-- ── LIST VIEWS ────────────────────────────────────────────────── --%>
        <c:when test="${view == 'artworks' || view == 'artists' || view == 'users' || view == 'categories' || view == 'orders'}">
            <div class="adm-panel">
                <div class="adm-panel-header">
                    <h3 class="adm-panel-title">Manage ${view}</h3>
                    <c:if test="${view != 'users' && view != 'orders'}">
                        <a href="${pageContext.request.contextPath}/admin/${view}?action=add" class="btn-primary small">Add New</a>
                    </c:if>
                </div>
                <div class="adm-table-wrap">
                    <table class="adm-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>${view == 'orders' ? 'Customer' : 'Name/Title'}</th>
                                <c:if test="${view == 'artworks'}"><th>Price</th><th>Category</th></c:if>
                                <c:if test="${view == 'users'}"><th>Email</th><th>Role</th></c:if>
                                <c:if test="${view == 'orders'}"><th>Amount</th><th>Status</th><th>Date</th></c:if>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${items}">
                                <tr>
                                    <td>${item.id}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${view == 'artworks'}">${item.title}</c:when>
                                            <c:when test="${view == 'users'}">${item.fullName}</c:when>
                                            <c:when test="${view == 'orders'}">${item.userFullName}</c:when>
                                            <c:otherwise>${item.name}</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <c:if test="${view == 'artworks'}"><td>$${item.price}</td><td>${item.categoryName}</td></c:if>
                                    <c:if test="${view == 'users'}"><td>${item.email}</td><td>${item.role}</td></c:if>
                                    <c:if test="${view == 'orders'}">
                                        <td>$${item.totalAmount}</td>
                                        <td><span class="status-badge ${item.status}">${item.status}</span></td>
                                        <td>${item.createdAt}</td>
                                    </c:if>
                                    <td class="adm-table-actions">
                                        <c:if test="${view != 'users' && view != 'orders'}">
                                            <a href="${pageContext.request.contextPath}/admin/${view}?action=edit&id=${item.id}" class="edit-link"><i class="fa-solid fa-pen-to-square"></i></a>
                                        </c:if>
                                        <c:if test="${view == 'orders'}">
                                            <a href="${pageContext.request.contextPath}/admin/orders?action=view&id=${item.id}" class="edit-link" style="margin-right: 0.5rem; font-size: 1.1rem;" title="View Detail"><i class="fa-solid fa-eye"></i></a>
                                        </c:if>
                                        <c:if test="${view != 'orders'}">
                                            <form action="${pageContext.request.contextPath}/admin/delete" method="POST" style="display:inline;" onsubmit="return confirm('Are you sure?')">
                                                <input type="hidden" name="type" value="${view == 'artworks' ? 'artwork' : (view == 'artists' ? 'artist' : (view == 'users' ? 'user' : 'category'))}">
                                                <input type="hidden" name="id" value="${item.id}">
                                                <button type="submit" class="delete-btn"><i class="fa-solid fa-trash-can"></i></button>
                                            </form>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <div style="margin-top:2rem;"><a href="${pageContext.request.contextPath}/admin" class="back-link">&larr; Back to Dashboard</a></div>
            </div>
        </c:when>

        <%-- ── ORDER DETAIL VIEW ────────────────────────────────────────── --%>
        <c:when test="${view == 'order_detail'}">
            <div class="adm-panel">
                <div class="adm-panel-header">
                    <h3 class="adm-panel-title">Order #${order.id} Details</h3>
                    <span class="status-badge ${order.status}">${order.status}</span>
                </div>
                <div class="order-info-grid" style="display:grid; grid-template-columns: 1fr 1fr; gap: 2rem; margin: 1.5rem 0;">
                    <div>
                        <p><strong>Customer:</strong> ${order.userFullName}</p>
                        <p><strong>Date:</strong> ${order.createdAt}</p>
                    </div>
                    <div style="text-align: right;">
                        <p><strong>Total Amount:</strong> <span style="font-size: 1.5rem; color: var(--purple-soft);">$${order.totalAmount}</span></p>
                    </div>
                </div>
                
                <h4 style="margin: 2rem 0 1rem; font-family: var(--font-sans); text-transform: uppercase; font-size: 0.8rem; letter-spacing: 0.1em; color: var(--muted);">Order Items</h4>
                <div class="adm-table-wrap">
                    <table class="adm-table">
                        <thead>
                            <tr>
                                <th>Artwork ID</th>
                                <th>Artwork Title</th>
                                <th>Quantity</th>
                                <th>Unit Price</th>
                                <th>Subtotal</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="oi" items="${order.items}">
                                <tr>
                                    <td>${oi.artworkId}</td>
                                    <td>${oi.artworkTitle}</td>
                                    <td>${oi.quantity}</td>
                                    <td>$${oi.price}</td>
                                    <td>$${oi.subtotal}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <div style="margin-top:2rem;"><a href="${pageContext.request.contextPath}/admin/orders" class="back-link">&larr; Back to Orders List</a></div>
            </div>
        </c:when>

        <%-- ── FORM VIEWS ────────────────────────────────────────────────── --%>
        <c:when test="${view == 'artwork_form' || view == 'artist_form' || view == 'category_form'}">
            <div class="adm-panel">
                <h3 class="adm-panel-title">${not empty item ? 'Edit' : 'Add'} ${view == 'artwork_form' ? 'Artwork' : (view == 'artist_form' ? 'Artist' : 'Category')}</h3>
                <form action="${pageContext.request.contextPath}/admin/${view == 'artwork_form' ? 'artworks' : (view == 'artist_form' ? 'artists' : 'categories')}" method="POST" class="adm-form" ${view == 'artist_form' ? 'enctype="multipart/form-data"' : ''}>
                    <input type="hidden" name="id" value="${item.id}">
                    
                    <c:if test="${view == 'artwork_form'}">
                        <div class="form-group"><label>Title</label><input type="text" name="title" value="${item.title}" required></div>
                        <div class="form-group"><label>Description</label><textarea name="description" required>${item.description}</textarea></div>
                        <div class="form-group"><label>Image URL</label><input type="text" name="image_url" value="${item.imageUrl}" required></div>
                        <div class="form-group"><label>Price</label><input type="number" step="0.01" name="price" value="${item.price}" required></div>
                        <div class="form-group">
                            <label>Category</label>
                            <select name="category_id" required>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat.id}" ${item.categoryId == cat.id ? 'selected' : ''}>${cat.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Artist</label>
                            <select name="artist_id" required>
                                <c:forEach var="art" items="${artists}">
                                    <option value="${art.id}" ${item.artistId == art.id ? 'selected' : ''}>${art.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group checkbox"><label><input type="checkbox" name="featured" ${item.featured ? 'checked' : ''}> Featured</label></div>
                    </c:if>

                    <c:if test="${view == 'artist_form'}">
                        <div class="form-group"><label>Name</label><input type="text" name="name" value="${item.name}" required></div>
                        <div class="form-group"><label>Bio</label><textarea name="bio" required>${item.bio}</textarea></div>
                        <div class="form-group">
                            <label>Profile Image</label>
                            <div class="drop-zone" id="dropZone">
                                <input type="file" name="profile_image_file" id="profileImageInput" accept=".jpg,.jpeg,.png,.gif,.webp"${empty item ? ' required' : ''} class="drop-zone__input">
                                <div class="drop-zone__prompt" id="dropPrompt">
                                    <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
                                        <polyline points="17 8 12 3 7 8"/>
                                        <line x1="12" y1="3" x2="12" y2="15"/>
                                    </svg>
                                    <span class="drop-zone__title">Drag & drop image here</span>
                                    <span class="drop-zone__or">or</span>
                                    <span class="drop-zone__btn">Browse Files</span>
                                    <span class="drop-zone__hint">JPG, PNG, GIF, WebP &bull; Max 5 MB</span>
                                </div>
                                <div class="drop-zone__preview" id="dropPreview" style="display:none;">
                                    <img id="previewImg" alt="Preview">
                                    <div class="drop-zone__preview-info">
                                        <span id="previewName"></span>
                                        <span id="previewSize"></span>
                                    </div>
                                    <button type="button" class="drop-zone__remove" id="removeBtn" title="Remove">&times;</button>
                                </div>
                            </div>
                            <c:if test="${not empty item.profileImage}">
                                <div class="drop-zone__current">
                                    <img src="${pageContext.request.contextPath}/${item.profileImage}" alt="Current image">
                                    <p>Current image &mdash; upload a new file to replace it.</p>
                                </div>
                            </c:if>
                        </div>
                        <div class="form-group"><label>Country</label><input type="text" name="country" value="${item.country}" required></div>
                    </c:if>

                    <c:if test="${view == 'category_form'}">
                        <div class="form-group"><label>Name</label><input type="text" name="name" value="${item.name}" required></div>
                        <div class="form-group"><label>Description</label><textarea name="description" required>${item.description}</textarea></div>
                        <div class="form-group"><label>Cover Image URL</label><input type="text" name="cover_image" value="${item.coverImage}" required></div>
                    </c:if>

                    <div class="form-actions">
                        <button type="submit" class="btn-primary">Save Changes</button>
                        <a href="${pageContext.request.contextPath}/admin/${view == 'artwork_form' ? 'artworks' : (view == 'artist_form' ? 'artists' : 'categories')}" class="btn-secondary">Cancel</a>
                    </div>
                </form>
            </div>
        </c:when>
        <c:otherwise>
            <div class="adm-panel">
                <p>Unknown view: <c:out value="${view}"/>. <a href="${pageContext.request.contextPath}/admin">Back to Dashboard</a></p>
            </div>
        </c:otherwise>
    </c:choose>

</section>

<c:if test="${view == 'dashboard'}">
<%-- Chart.js --%>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    const purple     = '#7a3bff';
    const purpleSoft = '#c9b6ff';
    const line       = 'rgba(255,255,255,0.08)';
    const ink        = '#f4f1fb';
    const muted      = '#a89ebe';

    /* Artworks by Category — Doughnut */
    const catCtx = document.getElementById('categoryChart');
    const catLabels = ${not empty categoryLabels ? categoryLabels : '["Portrait","Landscape","Botanical","Still Life","Gesture","Gallery"]'};
    const catData   = ${not empty categoryData   ? categoryData   : '[12,19,7,5,10,8]'};
    new Chart(catCtx, {
        type: 'doughnut',
        data: {
            labels: catLabels,
            datasets: [{
                data: catData,
                backgroundColor: ['#7a3bff','#9d5cf6','#c9b6ff','#4b1d9f','#5b21b6','#6d28d9'],
                borderColor: '#0b0910',
                borderWidth: 2
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { position: 'right', labels: { color: ink, padding: 14, font: { size: 12 } } }
            }
        }
    });

    /* Monthly Orders — Bar */
    const ordCtx = document.getElementById('ordersChart');
    const monthLabels = ${not empty monthLabels ? monthLabels : '["Dec","Jan","Feb","Mar","Apr","May"]'};
    const ordersData  = ${not empty ordersData  ? ordersData  : '[4,7,5,12,9,15]'};
    new Chart(ordCtx, {
        type: 'bar',
        data: {
            labels: monthLabels,
            datasets: [{
                label: 'Orders',
                data: ordersData,
                backgroundColor: 'rgba(122,59,255,0.55)',
                borderColor: purpleSoft,
                borderWidth: 1,
                borderRadius: 6
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { labels: { color: ink } } },
            scales: {
                x: { ticks: { color: muted }, grid: { color: line } },
                y: { beginAtZero: true, ticks: { color: muted }, grid: { color: line } }
            }
        }
    });
</script>
</c:if>

<c:if test="${view == 'artist_form'}">
<script>
(function() {
    var zone = document.getElementById('dropZone');
    var input = document.getElementById('profileImageInput');
    var prompt = document.getElementById('dropPrompt');
    var preview = document.getElementById('dropPreview');
    var previewImg = document.getElementById('previewImg');
    var previewName = document.getElementById('previewName');
    var previewSize = document.getElementById('previewSize');
    var removeBtn = document.getElementById('removeBtn');
    if (!zone || !input) return;

    function formatSize(bytes) {
        if (bytes < 1024) return bytes + ' B';
        if (bytes < 1048576) return (bytes / 1024).toFixed(1) + ' KB';
        return (bytes / 1048576).toFixed(1) + ' MB';
    }

    function showPreview(file) {
        var reader = new FileReader();
        reader.onload = function(e) {
            previewImg.src = e.target.result;
            previewName.textContent = file.name;
            previewSize.textContent = formatSize(file.size);
            prompt.style.display = 'none';
            preview.style.display = 'flex';
            zone.classList.add('drop-zone--has-file');
        };
        reader.readAsDataURL(file);
    }

    function clearPreview() {
        input.value = '';
        prompt.style.display = '';
        preview.style.display = 'none';
        zone.classList.remove('drop-zone--has-file');
    }

    zone.addEventListener('click', function(e) {
        if (e.target === removeBtn || e.target.closest('.drop-zone__remove')) return;
        input.click();
    });

    input.addEventListener('change', function() {
        if (input.files.length > 0) showPreview(input.files[0]);
    });

    zone.addEventListener('dragover', function(e) {
        e.preventDefault();
        zone.classList.add('drop-zone--over');
    });

    zone.addEventListener('dragleave', function() {
        zone.classList.remove('drop-zone--over');
    });

    zone.addEventListener('drop', function(e) {
        e.preventDefault();
        zone.classList.remove('drop-zone--over');
        var files = e.dataTransfer.files;
        if (files.length > 0 && files[0].type.startsWith('image/')) {
            input.files = files;
            showPreview(files[0]);
        }
    });

    removeBtn.addEventListener('click', function(e) {
        e.stopPropagation();
        clearPreview();
    });
})();
</script>
</c:if>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>
