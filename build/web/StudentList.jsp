<%-- 
    Document   : StudentList
    Created on : 25 March 2026, 09:54:38
    Author     : Samrat
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="oes.model.*"%>
<%@page import="oes.db.Students"%>
<%@page import="java.util.ArrayList"%>
<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Student List — Examily</title>
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    :root {
      --bg:        #0d0f14;
      --surface:   #13161e;
      --surface2:  #1a1e2a;
      --border:    rgba(255,255,255,0.07);
      --accent:    #5b8cff;
      --accent2:   #a78bfa;
      --danger:    #ff5c7a;
      --success:   #34d399;
      --warning:   #fbbf24;
      --text:      #e8ecf4;
      --muted:     #6b7280;
      --radius:    12px;
    }

    body {
      font-family: 'DM Sans', sans-serif;
      background: var(--bg);
      color: var(--text);
      min-height: 100vh;
      padding: 0 0 60px;
    }

    /* ── Header ── */
    .header {
      background: linear-gradient(135deg, #0d0f14 0%, #151929 100%);
      border-bottom: 1px solid var(--border);
      padding: 28px 40px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      position: sticky;
      top: 0;
      z-index: 100;
      backdrop-filter: blur(12px);
    }
    .header-left { display: flex; align-items: center; gap: 14px; }
    .logo-icon {
      width: 42px; height: 42px;
      background: linear-gradient(135deg, var(--accent), var(--accent2));
      border-radius: 10px;
      display: grid; place-items: center;
      font-size: 20px;
    }
    .logo-text {
      font-family: 'Syne', sans-serif;
      font-size: 1.3rem;
      font-weight: 800;
      letter-spacing: -0.02em;
      background: linear-gradient(90deg, var(--accent), var(--accent2));
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }
    .header-right { display: flex; gap: 10px; }

    /* ── Buttons ── */
    .btn {
      font-family: 'DM Sans', sans-serif;
      font-weight: 500;
      font-size: 0.875rem;
      padding: 9px 20px;
      border: none;
      border-radius: 8px;
      cursor: pointer;
      text-decoration: none;
      display: inline-flex; align-items: center; gap: 7px;
      transition: all 0.18s ease;
      letter-spacing: 0.01em;
    }
    .btn-primary {
      background: linear-gradient(135deg, var(--accent), #3b6ee8);
      color: #fff;
      box-shadow: 0 4px 20px rgba(91,140,255,0.3);
    }
    .btn-primary:hover { transform: translateY(-1px); box-shadow: 0 6px 28px rgba(91,140,255,0.45); }
    .btn-ghost {
      background: var(--surface2);
      color: var(--muted);
      border: 1px solid var(--border);
    }
    .btn-ghost:hover { color: var(--text); border-color: rgba(255,255,255,0.18); }

    /* ── Page wrapper ── */
    .page { max-width: 1000px; margin: 0 auto; padding: 40px 32px 0; }

    /* ── Stats row ── */
    .stats-row { display: flex; gap: 16px; margin-bottom: 36px; flex-wrap: wrap; }
    .stat-card {
      background: var(--surface);
      border: 1px solid var(--border);
      border-radius: var(--radius);
      padding: 20px 28px;
      flex: 1; min-width: 150px;
      position: relative; overflow: hidden;
    }
    .stat-card::before {
      content: '';
      position: absolute; top: 0; left: 0; right: 0; height: 2px;
      background: linear-gradient(90deg, var(--accent), var(--accent2));
    }
    .stat-value {
      font-family: 'Syne', sans-serif;
      font-size: 2rem; font-weight: 800;
      background: linear-gradient(135deg, var(--accent), var(--accent2));
      -webkit-background-clip: text; -webkit-text-fill-color: transparent;
    }
    .stat-label { font-size: 0.8rem; color: var(--muted); margin-top: 4px; text-transform: uppercase; letter-spacing: 0.08em; }

    /* ── Section title ── */
    .section-title {
      font-family: 'Syne', sans-serif;
      font-size: 1.5rem; font-weight: 800;
      margin-bottom: 20px;
      display: flex; align-items: center; gap: 10px;
    }
    .section-title span {
      font-size: 0.75rem;
      background: rgba(91,140,255,0.12);
      color: var(--accent);
      padding: 3px 10px;
      border-radius: 20px;
      font-weight: 500;
      font-family: 'DM Sans', sans-serif;
      letter-spacing: 0.04em;
    }

    /* ── Table ── */
    .table-wrapper {
      background: var(--surface);
      border: 1px solid var(--border);
      border-radius: var(--radius);
      overflow: hidden;
      overflow-x: auto;
    }
    table { width: 100%; border-collapse: collapse; min-width: 600px; }
    thead tr {
      background: var(--surface2);
      border-bottom: 1px solid var(--border);
    }
    th {
      font-family: 'Syne', sans-serif;
      font-size: 0.72rem;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.1em;
      color: var(--muted);
      padding: 14px 18px;
      text-align: left;
      white-space: nowrap;
    }
    th:first-child { width: 60px; text-align: center; }
    th:nth-last-child(1), th:nth-last-child(2) { text-align: center; }

    tbody tr {
      border-bottom: 1px solid var(--border);
      transition: background 0.15s ease;
    }
    tbody tr:last-child { border-bottom: none; }
    tbody tr:hover { background: rgba(255,255,255,0.025); }

    td {
      padding: 14px 18px;
      font-size: 0.875rem;
      color: var(--text);
      vertical-align: middle;
    }
    td:first-child {
      text-align: center;
      color: var(--muted);
      font-size: 0.78rem;
      font-family: 'Syne', sans-serif;
      font-weight: 700;
    }

    /* Avatar + name cell */
    .student-cell { display: flex; align-items: center; gap: 10px; }
    .avatar {
      width: 34px; height: 34px;
      border-radius: 50%;
      background: linear-gradient(135deg, var(--accent), var(--accent2));
      display: grid; place-items: center;
      font-family: 'Syne', sans-serif;
      font-size: 0.75rem;
      font-weight: 800;
      color: #fff;
      flex-shrink: 0;
      text-transform: uppercase;
    }

    /* Username badge */
    .username-badge {
      display: inline-flex; align-items: center; gap: 5px;
      background: rgba(167,139,250,0.1);
      color: var(--accent2);
      border: 1px solid rgba(167,139,250,0.2);
      border-radius: 6px;
      padding: 4px 10px;
      font-size: 0.8rem;
      font-family: 'Syne', sans-serif;
      font-weight: 600;
      letter-spacing: 0.02em;
    }

    /* Password mask */
    .pwd-mask {
      font-size: 0.9rem;
      letter-spacing: 0.1em;
      color: var(--muted);
    }

    /* Action links */
    .action-cell { text-align: center; }
    .action-link {
      display: inline-flex; align-items: center; gap: 5px;
      font-size: 0.8rem;
      font-weight: 500;
      padding: 6px 12px;
      border-radius: 6px;
      text-decoration: none;
      transition: all 0.16s ease;
    }
    .action-edit {
      color: var(--accent);
      background: rgba(91,140,255,0.08);
      border: 1px solid rgba(91,140,255,0.2);
    }
    .action-edit:hover { background: rgba(91,140,255,0.18); }
    .action-delete {
      color: var(--danger);
      background: rgba(255,92,122,0.07);
      border: 1px solid rgba(255,92,122,0.18);
    }
    .action-delete:hover { background: rgba(255,92,122,0.16); }

    /* ── Empty state ── */
    .empty-state {
      text-align: center;
      padding: 64px 20px;
      color: var(--muted);
    }
    .empty-state .icon { font-size: 3rem; margin-bottom: 16px; }
    .empty-state p { font-size: 0.95rem; }

    /* ── Footer ── */
    footer {
      text-align: center;
      margin-top: 40px;
      color: var(--muted);
      font-size: 0.8rem;
      letter-spacing: 0.04em;
    }

    @media (max-width: 640px) {
      .header { padding: 18px 20px; }
      .page { padding: 24px 16px 0; }
    }
  </style>
</head>
<body>

  <!-- Header -->
  <div class="header">
    <div class="header-left">
      <div class="logo-icon">🎓</div>
      <span class="logo-text">Examily</span>
    </div>
    <div class="header-right">
      <a href="AddStudent.jsp" class="btn btn-primary">＋ Add Student</a>
      <a href="AdminPanel.jsp" class="btn btn-ghost">← Admin Panel</a>
    </div>
  </div>

  <!-- Page -->
  <div class="page">

    <%
      ArrayList<Students> allstudents = StudentsDao.getAllRecords();
      int totalStudents = (allstudents != null) ? allstudents.size() : 0;
    %>

    <!-- Stats -->
    <div class="stats-row">
      <div class="stat-card">
        <div class="stat-value"><%=totalStudents%></div>
        <div class="stat-label">Total Students</div>
      </div>
      <div class="stat-card">
        <div class="stat-value">Active</div>
        <div class="stat-label">Account Status</div>
      </div>
      <div class="stat-card">
        <div class="stat-value">OES</div>
        <div class="stat-label">Platform</div>
      </div>
    </div>

    <!-- Table title -->
    <div class="section-title">
      Student Records <span><%=totalStudents%> enrolled</span>
    </div>

    <!-- Table -->
    <div class="table-wrapper">
      <table>
        <thead>
          <tr>
            <th>#</th>
            <th>Username</th>
            <th>Full Name</th>
            <th>Password</th>
            <th>Edit</th>
            <th>Delete</th>
          </tr>
        </thead>
        <tbody>
          <%
            if (allstudents == null || allstudents.isEmpty()) {
          %>
          <tr>
            <td colspan="6">
              <div class="empty-state">
                <div class="icon">👥</div>
                <p>No students registered yet. Add your first student to get started.</p>
              </div>
            </td>
          </tr>
          <%
            } else {
              int i = 1;
              for (Students e : allstudents) {
                String initials = "";
                String name = e.getName();
                if (name != null && !name.isEmpty()) {
                  String[] parts = name.trim().split("\\s+");
                  initials += parts[0].charAt(0);
                  if (parts.length > 1) initials += parts[parts.length - 1].charAt(0);
                }
          %>
          <tr>
            <td><%=i++%></td>
            <td><span class="username-badge">@<%=e.getUsername()%></span></td>
            <td>
              <div class="student-cell">
                <div class="avatar"><%=initials%></div>
                <%=e.getName()%>
              </div>
            </td>
            <td><span class="pwd-mask">••••••••</span></td>
            <td class="action-cell">
              <a class="action-link action-edit" href="updatestudent.jsp?username=<%=e.getUsername()%>">✏ Edit</a>
            </td>
            <td class="action-cell">
              <a class="action-link action-delete"
                 href="deletestudent.jsp?username=<%=e.getUsername()%>"
                 onclick="return confirm('Remove <%=e.getName()%> from the system?')">🗑 Delete</a>
            </td>
          </tr>
          <%
              }
            }
          %>
        </tbody>
      </table>
    </div>

    <footer>© 2026 Examily, Inc. — All rights reserved.</footer>
  </div>

</body>
</html>
