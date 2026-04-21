<%-- 
    Document   : updatestudent
    Created on : 27 Jun 2022, 12:20:19
    Author     : adrianadewunmi
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="oes.model.StudentsDao"%>
<%@page import="oes.db.Students"%>
<%@page import="java.util.ArrayList"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Management</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Fira+Code:wght@400;500&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --bg:          #f0f2f8;
            --surface:     #ffffff;
            --surface2:    #f7f8fc;
            --border:      #e2e6f0;
            --border2:     #cdd3e4;
            --navy:        #0f1e3d;
            --navy2:       #1a2f5a;
            --blue:        #2563eb;
            --blue-light:  #dbeafe;
            --blue-glow:   rgba(37,99,235,0.12);
            --red:         #dc2626;
            --red-light:   #fee2e2;
            --green:       #16a34a;
            --green-light: #dcfce7;
            --amber:       #d97706;
            --amber-light: #fef3c7;
            --text:        #111827;
            --muted:       #6b7280;
            --muted2:      #9ca3af;
            --edit-row-bg: #eff6ff;
            --edit-border: #93c5fd;
        }

        body {
            background: var(--bg);
            color: var(--text);
            font-family: 'Outfit', sans-serif;
            min-height: 100vh;
            padding: 0;
        }

        /* ── TOP NAV ── */
        .topbar {
            background: var(--navy);
            padding: 0 32px;
            height: 60px;
            display: flex; align-items: center; justify-content: space-between;
            position: sticky; top: 0; z-index: 100;
            box-shadow: 0 2px 12px rgba(0,0,0,0.18);
        }
        .topbar-brand {
            display: flex; align-items: center; gap: 10px;
            font-size: 16px; font-weight: 700; color: #fff; letter-spacing: -0.01em;
        }
        .topbar-brand .dot {
            width: 8px; height: 8px; border-radius: 50%;
            background: var(--blue); box-shadow: 0 0 8px rgba(37,99,235,0.7);
        }
        .topbar-actions { display: flex; gap: 10px; }
        .topbar-btn {
            display: inline-flex; align-items: center; gap: 7px;
            padding: 7px 16px; border-radius: 8px;
            font-family: 'Outfit', sans-serif;
            font-size: 13px; font-weight: 600;
            cursor: pointer; text-decoration: none; border: none;
            transition: all 0.18s ease;
        }
        .topbar-btn.primary { background: var(--blue); color: #fff; }
        .topbar-btn.primary:hover { background: #1d4ed8; box-shadow: 0 0 16px var(--blue-glow); }
        .topbar-btn.ghost { background: rgba(255,255,255,0.08); color: rgba(255,255,255,0.75); border: 1px solid rgba(255,255,255,0.12); }
        .topbar-btn.ghost:hover { background: rgba(255,255,255,0.14); color: #fff; }
        .topbar-btn svg { width: 15px; height: 15px; stroke: currentColor; fill: none; stroke-width: 2.2; }

        /* ── PAGE SHELL ── */
        .page { max-width: 1100px; margin: 0 auto; padding: 36px 24px 60px; }

        /* ── PAGE HEADER ── */
        .page-header {
            display: flex; align-items: flex-end; justify-content: space-between;
            margin-bottom: 28px; gap: 16px; flex-wrap: wrap;
        }
        .page-title-group {}
        .page-eyebrow {
            font-size: 11px; font-weight: 700; letter-spacing: 0.1em;
            text-transform: uppercase; color: var(--blue); margin-bottom: 4px;
        }
        .page-title {
            font-size: 28px; font-weight: 800; color: var(--navy);
            letter-spacing: -0.03em; line-height: 1;
        }
        .page-subtitle { font-size: 14px; color: var(--muted); margin-top: 6px; }

        /* Stats row */
        .stats-row { display: flex; gap: 12px; flex-wrap: wrap; }
        .stat-chip {
            background: var(--surface); border: 1px solid var(--border);
            border-radius: 10px; padding: 10px 18px;
            text-align: center; min-width: 90px;
        }
        .stat-chip .num {
            font-size: 20px; font-weight: 800; color: var(--navy);
            line-height: 1; letter-spacing: -0.02em;
        }
        .stat-chip .lbl {
            font-size: 11px; color: var(--muted); margin-top: 2px; font-weight: 500;
        }

        /* ── CARD / TABLE WRAPPER ── */
        .table-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 4px 24px rgba(0,0,0,0.06);
            animation: fadeUp 0.4s cubic-bezier(0.22,1,0.36,1) both;
        }
        @keyframes fadeUp {
            from { opacity:0; transform: translateY(16px); }
            to   { opacity:1; transform: translateY(0); }
        }

        /* ── TABLE ── */
        table { width: 100%; border-collapse: collapse; }

        /* Head */
        thead tr {
            background: var(--navy);
        }
        thead th {
            padding: 13px 18px;
            font-size: 11px; font-weight: 700; letter-spacing: 0.08em;
            text-transform: uppercase; color: rgba(255,255,255,0.55);
            text-align: left; white-space: nowrap;
        }
        thead th:first-child { border-radius: 0; }

        /* Body rows */
        tbody tr { border-bottom: 1px solid var(--border); transition: background 0.15s; }
        tbody tr:last-child { border-bottom: none; }
        tbody tr.normal-row:hover { background: var(--surface2); }
        tbody td {
            padding: 13px 18px;
            font-size: 14px; color: var(--text); vertical-align: middle;
        }
        .sno { font-family: 'Fira Code', monospace; font-size: 12px; color: var(--muted2); }

        /* Username pill */
        .username-pill {
            display: inline-flex; align-items: center; gap: 7px;
            background: var(--blue-light); color: var(--blue);
            border-radius: 6px; padding: 3px 10px;
            font-family: 'Fira Code', monospace; font-size: 13px; font-weight: 500;
        }
        .username-pill::before {
            content: '@'; opacity: 0.5; font-size: 11px;
        }

        /* Password mask */
        .pass-mask {
            font-family: 'Fira Code', monospace; font-size: 13px;
            color: var(--muted2); letter-spacing: 2px;
        }

        /* ── EDIT ROW ── */
        tbody tr.edit-row { background: var(--edit-row-bg); }
        tbody tr.edit-row td { padding: 10px 14px; }

        .edit-row-indicator {
            width: 3px; height: 100%;
            position: absolute; left: 0; top: 0;
            background: var(--blue);
        }
        tbody tr.edit-row td:first-child { position: relative; }

        .field-wrap { position: relative; }
        .field-label {
            font-size: 10px; font-weight: 700; letter-spacing: 0.07em;
            text-transform: uppercase; color: var(--blue); margin-bottom: 4px;
        }
        .edit-input {
            width: 100%; padding: 8px 12px;
            background: #fff; border: 1.5px solid var(--edit-border);
            border-radius: 8px;
            font-family: 'Fira Code', monospace; font-size: 13px; color: var(--navy);
            outline: none; transition: border-color 0.18s, box-shadow 0.18s;
        }
        .edit-input:focus {
            border-color: var(--blue);
            box-shadow: 0 0 0 3px rgba(37,99,235,0.12);
        }

        /* ── ACTION BUTTONS ── */
        .btn-action {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 6px 13px; border-radius: 7px;
            font-family: 'Outfit', sans-serif;
            font-size: 12px; font-weight: 600;
            text-decoration: none; border: none; cursor: pointer;
            transition: all 0.16s ease; white-space: nowrap;
        }
        .btn-action svg { width: 13px; height: 13px; stroke: currentColor; fill: none; stroke-width: 2.4; }

        .btn-update  { background: var(--blue-light); color: var(--blue); }
        .btn-update:hover  { background: var(--blue); color: #fff; }

        .btn-save    { background: var(--green-light); color: var(--green); }
        .btn-save:hover    { background: var(--green); color: #fff; }

        .btn-delete  { background: var(--red-light); color: var(--red); }
        .btn-delete:hover  { background: var(--red); color: #fff; }

        /* ── TABLE FOOTER ── */
        .table-footer {
            padding: 16px 18px;
            border-top: 1px solid var(--border);
            background: var(--surface2);
            display: flex; align-items: center; justify-content: space-between;
            flex-wrap: wrap; gap: 12px;
        }
        .footer-info { font-size: 13px; color: var(--muted); }
        .footer-info strong { color: var(--text); }
        .footer-actions { display: flex; gap: 10px; }

        .btn-footer {
            display: inline-flex; align-items: center; gap: 7px;
            padding: 9px 20px; border-radius: 9px;
            font-family: 'Outfit', sans-serif;
            font-size: 13px; font-weight: 700;
            text-decoration: none; border: none; cursor: pointer;
            transition: all 0.18s ease;
        }
        .btn-footer svg { width: 15px; height: 15px; stroke: currentColor; fill: none; stroke-width: 2.2; }
        .btn-footer.add { background: var(--blue); color: #fff; box-shadow: 0 2px 12px var(--blue-glow); }
        .btn-footer.add:hover { background: #1d4ed8; transform: translateY(-1px); box-shadow: 0 4px 20px var(--blue-glow); }
        .btn-footer.back { background: var(--surface); border: 1px solid var(--border2); color: var(--muted); }
        .btn-footer.back:hover { color: var(--navy); border-color: var(--navy); }

        /* ── EMPTY STATE ── */
        .empty-state {
            padding: 60px 20px; text-align: center; color: var(--muted);
        }
        .empty-state svg { width: 48px; height: 48px; stroke: var(--muted2); fill: none; stroke-width: 1.5; margin-bottom: 16px; }
        .empty-state p { font-size: 15px; }

        /* Responsive */
        @media (max-width: 700px) {
            thead th:nth-child(4), tbody td:nth-child(4) { display: none; }
            .page { padding: 20px 12px 40px; }
            .topbar { padding: 0 16px; }
        }
    </style>
</head>
<body>

<%
    String selectedUsername = request.getParameter("username");
    ArrayList<Students> allStudents = StudentsDao.getAllRecords();
    int totalCount = allStudents != null ? allStudents.size() : 0;
%>

<!-- Top Navigation -->
<nav class="topbar">
    <div class="topbar-brand">
        <div class="dot"></div>
        OES Admin
    </div>
    <div class="topbar-actions">
        <a href="AddStudent.jsp" class="topbar-btn primary">
            <svg viewBox="0 0 24 24"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
            Add Student
        </a>
        <a href="AdminPanel.jsp" class="topbar-btn ghost">
            <svg viewBox="0 0 24 24"><polyline points="15 18 9 12 15 6"/></svg>
            Back to Panel
        </a>
    </div>
</nav>

<div class="page">

    <!-- Page Header -->
    <div class="page-header">
        <div class="page-title-group">
            <div class="page-eyebrow">Student Management</div>
            <div class="page-title">All Students</div>
            <div class="page-subtitle">
                <% if (selectedUsername != null && !selectedUsername.isEmpty()) { %>
                    Editing record for <strong><%= selectedUsername %></strong>
                <% } else { %>
                    Manage student accounts and credentials
                <% } %>
            </div>
        </div>
        <div class="stats-row">
            <div class="stat-chip">
                <div class="num"><%= totalCount %></div>
                <div class="lbl">Total</div>
            </div>
            <div class="stat-chip">
                <div class="num" style="color:var(--blue)">
                    <%= (selectedUsername != null && !selectedUsername.isEmpty()) ? 1 : 0 %>
                </div>
                <div class="lbl">Editing</div>
            </div>
        </div>
    </div>

    <!-- Table Card -->
    <div class="table-card">
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>User ID</th>
                    <th>Full Name</th>
                    <th>Password</th>
                    <th>Update</th>
                    <th>Delete</th>
                </tr>
            </thead>
            <tbody>
            <%
                if (allStudents == null || allStudents.isEmpty()) {
            %>
                <tr>
                    <td colspan="6">
                        <div class="empty-state">
                            <svg viewBox="0 0 24 24"><circle cx="12" cy="8" r="4"/><path d="M4 20c0-4 3.6-7 8-7s8 3 8 7"/></svg>
                            <p>No students found in the database.</p>
                        </div>
                    </td>
                </tr>
            <%
                } else {
                    int i = 1;
                    for (Students e : allStudents) {
                        boolean isEditing = selectedUsername != null && selectedUsername.equals(e.getUsername());
                        if (isEditing) {
            %>
                <!-- ── EDIT ROW ── -->
                <tr class="edit-row">
                    <form action="updatestudentnow.jsp">
                        <input type="hidden" value="<%= e.getUsername() %>" name="usernameoriginal">
                        <td class="sno" style="position:relative">
                            <div class="edit-row-indicator"></div>
                            <%= i++ %>
                        </td>
                        <td>
                            <div class="field-wrap">
                                <div class="field-label">Username</div>
                                <input class="edit-input" type="text" value="<%= e.getUsername() %>" name="uname">
                            </div>
                        </td>
                        <td>
                            <div class="field-wrap">
                                <div class="field-label">Full Name</div>
                                <input class="edit-input" type="text" value="<%= e.getName() %>" name="name">
                            </div>
                        </td>
                        <td>
                            <div class="field-wrap">
                                <div class="field-label">Password</div>
                                <input class="edit-input" type="text" value="<%= e.getPassword() %>" name="pass">
                            </div>
                        </td>
                        <td>
                            <button type="submit" class="btn-action btn-save">
                                <svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
                                Save
                            </button>
                        </td>
                        <td>
                            <a href="deletestudent.jsp?username=<%= e.getUsername() %>" class="btn-action btn-delete">
                                <svg viewBox="0 0 24 24"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14H6L5 6"/><path d="M10 11v6M14 11v6"/></svg>
                                Delete
                            </a>
                        </td>
                    </form>
                </tr>
            <%
                        } else {
            %>
                <!-- ── NORMAL ROW ── -->
                <tr class="normal-row">
                    <td class="sno"><%= i++ %></td>
                    <td><span class="username-pill"><%= e.getUsername() %></span></td>
                    <td><%= e.getName() %></td>
                    <td><span class="pass-mask">••••••••</span></td>
                    <td>
                        <a href="updatestudent.jsp?username=<%= e.getUsername() %>" class="btn-action btn-update">
                            <svg viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                            Edit
                        </a>
                    </td>
                    <td>
                        <a href="deletestudent.jsp?username=<%= e.getUsername() %>" class="btn-action btn-delete">
                            <svg viewBox="0 0 24 24"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14H6L5 6"/><path d="M10 11v6M14 11v6"/></svg>
                            Delete
                        </a>
                    </td>
                </tr>
            <%
                        }
                    }
                }
            %>
            </tbody>
        </table>

        <!-- Table Footer -->
        <div class="table-footer">
            <div class="footer-info">
                Showing <strong><%= totalCount %></strong> student<%= totalCount != 1 ? "s" : "" %>
            </div>
            <div class="footer-actions">
                <a href="AddStudent.jsp" class="btn-footer add">
                    <svg viewBox="0 0 24 24"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                    Add Student
                </a>
                <a href="AdminPanel.jsp" class="btn-footer back">
                    <svg viewBox="0 0 24 24"><polyline points="15 18 9 12 15 6"/></svg>
                    Back to Panel
                </a>
            </div>
        </div>
    </div>

</div>
</body>
</html>
