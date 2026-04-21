<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@page import="oes.db.*" %>
    <%@page import="oes.model.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Delete Student</title>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --bg:       #0d0f14;
            --surface:  #161920;
            --border:   #252830;
            --red:      #e8423a;
            --red-glow: rgba(232, 66, 58, 0.18);
            --red-soft: rgba(232, 66, 58, 0.08);
            --green:    #34c97e;
            --green-glow: rgba(52, 201, 126, 0.18);
            --text:     #e8eaf0;
            --muted:    #6b7080;
        }

        body {
            background: var(--bg);
            color: var(--text);
            font-family: 'DM Sans', sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }

        /* Ambient background blobs */
        body::before, body::after {
            content: '';
            position: fixed;
            border-radius: 50%;
            filter: blur(90px);
            pointer-events: none;
            z-index: 0;
        }
        body::before {
            width: 500px; height: 500px;
            top: -150px; left: -150px;
            background: radial-gradient(circle, rgba(232,66,58,0.10) 0%, transparent 70%);
        }
        body::after {
            width: 400px; height: 400px;
            bottom: -120px; right: -120px;
            background: radial-gradient(circle, rgba(52,201,126,0.07) 0%, transparent 70%);
        }

        .card {
            position: relative;
            z-index: 1;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 20px;
            padding: 48px 44px 44px;
            width: 420px;
            max-width: 95vw;
            box-shadow: 0 24px 80px rgba(0,0,0,0.5);
            animation: slideUp 0.5s cubic-bezier(0.22, 1, 0.36, 1) both;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px) scale(0.97); }
            to   { opacity: 1; transform: translateY(0)   scale(1);    }
        }

        /* ?? SUCCESS state ?? */
        .card.success .icon-wrap { background: var(--green-glow); border-color: rgba(52,201,126,0.3); }
        .card.success .icon-wrap svg { stroke: var(--green); }
        .card.success .status-badge { background: rgba(52,201,126,0.12); color: var(--green); border-color: rgba(52,201,126,0.25); }
        .card.success .headline { color: var(--green); }
        .card.success .btn-primary { background: var(--green); box-shadow: 0 0 24px var(--green-glow); }
        .card.success .btn-primary:hover { box-shadow: 0 0 38px rgba(52,201,126,0.35); }
        .card.success .progress-bar-fill { background: var(--green); }

        /* ?? ERROR state ?? */
        .card.error .icon-wrap { background: var(--red-soft); border-color: rgba(232,66,58,0.3); }
        .card.error .icon-wrap svg { stroke: var(--red); }
        .card.error .status-badge { background: rgba(232,66,58,0.10); color: var(--red); border-color: rgba(232,66,58,0.25); }
        .card.error .headline { color: var(--red); }
        .card.error .btn-primary { background: var(--red); box-shadow: 0 0 24px var(--red-glow); }
        .card.error .btn-primary:hover { box-shadow: 0 0 38px rgba(232,66,58,0.35); }
        .card.error .progress-bar-fill { background: var(--red); }

        /* Icon */
        .icon-wrap {
            width: 64px; height: 64px;
            border-radius: 16px;
            border: 1px solid transparent;
            display: flex; align-items: center; justify-content: center;
            margin-bottom: 24px;
        }
        .icon-wrap svg { width: 28px; height: 28px; stroke-width: 2.2; fill: none; }

        .status-badge {
            display: inline-flex; align-items: center; gap: 6px;
            font-family: 'Syne', sans-serif;
            font-size: 11px; font-weight: 600; letter-spacing: 0.08em;
            text-transform: uppercase;
            padding: 4px 12px; border-radius: 99px;
            border: 1px solid transparent;
            margin-bottom: 14px;
        }
        .status-badge::before {
            content: '';
            width: 6px; height: 6px;
            border-radius: 50%;
            background: currentColor;
            animation: pulse 1.8s ease-in-out infinite;
        }
        @keyframes pulse { 0%,100% { opacity: 1; } 50% { opacity: 0.4; } }

        .headline {
            font-family: 'Syne', sans-serif;
            font-size: 26px; font-weight: 800;
            line-height: 1.15;
            margin-bottom: 10px;
        }

        .sub {
            font-size: 14px; color: var(--muted);
            line-height: 1.6;
            margin-bottom: 28px;
        }
        .sub strong { color: var(--text); font-weight: 500; }

        /* Divider */
        .divider {
            height: 1px;
            background: var(--border);
            margin: 28px 0;
        }

        /* Meta row */
        .meta {
            display: flex; gap: 12px;
            margin-bottom: 28px;
        }
        .meta-item {
            flex: 1;
            background: rgba(255,255,255,0.03);
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 12px 14px;
        }
        .meta-label {
            font-size: 10px; letter-spacing: 0.07em; text-transform: uppercase;
            color: var(--muted); font-weight: 600; margin-bottom: 4px;
        }
        .meta-value {
            font-family: 'Syne', sans-serif;
            font-size: 14px; font-weight: 700; color: var(--text);
        }

        /* Buttons */
        .btn-primary {
            display: block; width: 100%;
            padding: 14px;
            border: none; border-radius: 10px;
            font-family: 'Syne', sans-serif;
            font-size: 14px; font-weight: 700; letter-spacing: 0.03em;
            color: #fff; cursor: pointer;
            transition: transform 0.15s ease, box-shadow 0.25s ease;
            text-decoration: none; text-align: center;
        }
        .btn-primary:hover  { transform: translateY(-1px); }
        .btn-primary:active { transform: translateY(0); }

        .btn-ghost {
            display: block; width: 100%;
            padding: 13px;
            border: 1px solid var(--border); border-radius: 10px;
            background: transparent;
            font-family: 'Syne', sans-serif;
            font-size: 14px; font-weight: 600; letter-spacing: 0.02em;
            color: var(--muted); cursor: pointer;
            text-decoration: none; text-align: center;
            margin-top: 10px;
            transition: border-color 0.2s, color 0.2s, background 0.2s;
        }
        .btn-ghost:hover { border-color: #3a3d4a; color: var(--text); background: rgba(255,255,255,0.03); }

        /* Auto-redirect progress bar */
        .progress-wrap {
            height: 3px;
            background: rgba(255,255,255,0.06);
            border-radius: 99px;
            overflow: hidden;
            margin-top: 20px;
        }
        .progress-bar-fill {
            height: 100%;
            border-radius: 99px;
            width: 100%;
            transform-origin: left;
            animation: shrink 3s linear forwards;
        }
        @keyframes shrink { from { transform: scaleX(1); } to { transform: scaleX(0); } }

        .redirect-note {
            font-size: 12px; color: var(--muted);
            text-align: center; margin-top: 8px;
        }
    </style>
</head>
<body>

<%
    Students s = new Students();
    String username = request.getParameter("username");
    s.setUsername(username);
    int status = StudentsDao.deleteRecord(s);
    boolean success = (status > 0);

    if (success) {
        // Auto-redirect after 3 seconds
        response.setHeader("Refresh", "3;url=StudentList.jsp");
    }
%>

<div class="card <%= success ? "success" : "error" %>">

    <div class="icon-wrap">
        <% if (success) { %>
        <!-- Checkmark icon -->
        <svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
        <% } else { %>
        <!-- Alert icon -->
        <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
        <% } %>
    </div>

    <div class="status-badge"><%= success ? "Completed" : "Failed" %></div>

    <div class="headline"><%= success ? "Student Removed" : "Deletion Failed" %></div>

    <p class="sub">
        <% if (success) { %>
            The record for <strong><%= username != null ? username : "this student" %></strong> has been permanently deleted from the system.
        <% } else { %>
            Unable to delete the record for <strong><%= username != null ? username : "this student" %></strong>. The record may no longer exist or a database error occurred.
        <% } %>
    </p>

    <div class="meta">
        <div class="meta-item">
            <div class="meta-label">Username</div>
            <div class="meta-value"><%= username != null ? username : "?" %></div>
        </div>
        <div class="meta-item">
            <div class="meta-label">Status</div>
            <div class="meta-value"><%= success ? "Deleted" : "Error" %></div>
        </div>
        <div class="meta-item">
            <div class="meta-label">Rows Affected</div>
            <div class="meta-value"><%= status %></div>
        </div>
    </div>

    <% if (success) { %>
        <a href="StudentList.jsp" class="btn-primary">Back to Student List</a>
        <div class="progress-wrap"><div class="progress-bar-fill"></div></div>
        <p class="redirect-note">Redirecting automatically in 3 seconds?</p>
    <% } else { %>
        <a href="javascript:history.back()" class="btn-primary">Try Again</a>
        <a href="StudentList.jsp" class="btn-ghost">Go to Student List</a>
    <% } %>

</div>

</body>
</html>
