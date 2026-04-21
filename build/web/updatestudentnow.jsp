<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="oes.model.StudentsDao"%>
<%@page import="oes.db.Students"%>
<%@page import="java.util.ArrayList"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Update Student — Examily</title>
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Mono:wght@300;400;500&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    :root {
      --bg:       #0d0f14;
      --surface:  #161a23;
      --surface2: #1c2130;
      --border:   #252b3b;
      --accent:   #4f7cff;
      --accent-g: #7c5cff;
      --success:  #2dca72;
      --danger:   #ff4f6a;
      --text:     #e8eaf2;
      --muted:    #6b7390;
      --radius:   14px;
    }

    body {
      font-family: 'DM Mono', monospace;
      background: var(--bg);
      color: var(--text);
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      padding: 2rem 1rem;
      position: relative;
      overflow-x: hidden;
    }

    body::before {
      content: '';
      position: fixed;
      top: -20%; left: 50%;
      transform: translateX(-50%);
      width: 800px; height: 500px;
      background: radial-gradient(ellipse, rgba(79,124,255,0.10) 0%, transparent 70%);
      pointer-events: none; z-index: 0;
    }

    .brand {
      font-family: 'Syne', sans-serif;
      font-size: 0.75rem; font-weight: 700;
      letter-spacing: 0.25em; text-transform: uppercase;
      color: var(--muted); margin-bottom: 2rem;
      position: relative; z-index: 1;
    }
    .brand span { color: var(--accent); }

    .card {
      position: relative; z-index: 1;
      background: var(--surface);
      border: 1px solid var(--border);
      border-radius: var(--radius);
      width: 100%; max-width: 460px;
      box-shadow: 0 24px 64px rgba(0,0,0,0.5), 0 0 0 1px rgba(255,255,255,0.03) inset;
      animation: slideUp 0.45s cubic-bezier(0.22,1,0.36,1) both;
      overflow: hidden;
    }

    @keyframes slideUp {
      from { opacity: 0; transform: translateY(28px); }
      to   { opacity: 1; transform: translateY(0); }
    }

    .card-header {
      padding: 1.5rem 2rem;
      border-bottom: 1px solid var(--border);
    }
    .card-label {
      font-size: 0.65rem; letter-spacing: 0.2em;
      text-transform: uppercase; color: var(--accent);
      font-weight: 500; margin-bottom: 0.35rem;
    }
    .card-title {
      font-family: 'Syne', sans-serif;
      font-size: 1.3rem; font-weight: 800; color: var(--text);
    }

    .result-body {
      padding: 2rem;
      text-align: center;
    }

    .result-icon {
      width: 56px; height: 56px; border-radius: 50%;
      display: flex; align-items: center; justify-content: center;
      margin: 0 auto 1.25rem;
    }
    .result-icon.success { background: rgba(45,202,114,0.12); }
    .result-icon.danger  { background: rgba(255,79,106,0.12); }
    .result-icon svg {
      width: 26px; height: 26px;
      fill: none; stroke-width: 2;
      stroke-linecap: round; stroke-linejoin: round;
    }
    .result-icon.success svg { stroke: var(--success); }
    .result-icon.danger  svg { stroke: var(--danger); }

    .result-title {
      font-family: 'Syne', sans-serif;
      font-size: 1.1rem; font-weight: 700;
      margin-bottom: 0.4rem; color: var(--text);
    }
    .result-sub {
      font-size: 0.78rem; color: var(--muted);
      line-height: 1.6; margin-bottom: 1.75rem;
    }

    /* Diff summary box */
    .diff-box {
      background: var(--surface2);
      border: 1px solid var(--border);
      border-radius: 10px;
      padding: 1rem 1.25rem;
      text-align: left;
      margin-bottom: 1.75rem;
    }
    .diff-row {
      display: flex; align-items: baseline;
      justify-content: space-between;
      padding: 0.45rem 0;
      border-bottom: 1px solid var(--border);
      gap: 1rem;
    }
    .diff-row:last-child { border-bottom: none; }
    .diff-key {
      font-size: 0.62rem; letter-spacing: 0.12em;
      text-transform: uppercase; color: var(--muted);
      white-space: nowrap; flex-shrink: 0;
    }
    .diff-val {
      font-size: 0.78rem; color: var(--text);
      text-align: right; word-break: break-all;
    }
    .diff-val.masked { letter-spacing: 0.2em; color: var(--muted); }

    /* Buttons */
    .btn-row { display: flex; gap: 10px; }

    .btn {
      flex: 1;
      font-family: 'DM Mono', monospace;
      font-size: 0.78rem; font-weight: 500;
      padding: 0.65rem 1rem; border-radius: 8px;
      cursor: pointer; letter-spacing: 0.04em;
      border: 1px solid transparent;
      transition: filter 0.15s, transform 0.1s;
      display: inline-flex; align-items: center; justify-content: center;
      gap: 0.4rem; text-decoration: none;
    }
    .btn:active { transform: scale(0.97); }

    .btn-primary {
      background: linear-gradient(135deg, var(--accent), var(--accent-g));
      color: #fff; box-shadow: 0 4px 18px rgba(79,124,255,0.25);
    }
    .btn-primary:hover { filter: brightness(1.12); }

    .btn-ghost {
      background: transparent; border-color: var(--border); color: var(--muted);
    }
    .btn-ghost:hover { border-color: var(--text); color: var(--text); }

    .btn-danger {
      background: rgba(255,79,106,0.12);
      border-color: rgba(255,79,106,0.3); color: #ff7a8f;
    }
    .btn-danger:hover { background: rgba(255,79,106,0.22); border-color: var(--danger); color: #fff; }

    .icon { width: 13px; height: 13px; fill: none; stroke: currentColor; stroke-width: 2; stroke-linecap: round; stroke-linejoin: round; }

    footer {
      margin-top: 2rem; font-size: 0.7rem;
      color: var(--muted); letter-spacing: 0.05em;
      position: relative; z-index: 1;
    }
  </style>
</head>
<body>

<%
  String newuserid   = request.getParameter("uname");
  String newpassword = request.getParameter("pass");
  String newname     = request.getParameter("name");
  String originaluid = request.getParameter("usernameoriginal");
  String ctxPath     = request.getContextPath();

  boolean hasParams = originaluid != null && !originaluid.trim().isEmpty()
                   && newuserid   != null && !newuserid.trim().isEmpty()
                   && newpassword != null && !newpassword.trim().isEmpty()
                   && newname     != null && !newname.trim().isEmpty();

  int status = 0;
  if (hasParams) {
    status = StudentsDao.doUpdateNowRecord(originaluid, newuserid, newpassword, newname);
  }

  // Mask password for display
  String maskedPass = "";
  if (newpassword != null) {
    for (int k = 0; k < newpassword.length(); k++) maskedPass += "●";
  }
%>

<div class="brand">© <span>Examily</span> Admin Console</div>

<div class="card">
  <div class="card-header">
    <p class="card-label">Students</p>
    <h1 class="card-title">Update Student</h1>
  </div>

  <div class="result-body">

    <%-- Missing params --%>
    <% if (!hasParams) { %>
      <div class="result-icon danger">
        <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
      </div>
      <p class="result-title">Missing parameters</p>
      <p class="result-sub">All fields — username, password, and name — are required to update a student record.</p>
      <div class="btn-row">
        <a href="javascript:history.back()" class="btn btn-ghost">
          <svg class="icon" viewBox="0 0 24 24"><polyline points="15 18 9 12 15 6"/></svg>
          Go back
        </a>
      </div>

    <%-- Success --%>
    <% } else if (status > 0) { %>
      <div class="result-icon success">
        <svg viewBox="0 0 24 24"><path d="M20 6L9 17l-5-5"/></svg>
      </div>
      <p class="result-title">Student updated</p>
      <p class="result-sub">The student record has been saved successfully.</p>

      <div class="diff-box">
        <div class="diff-row">
          <span class="diff-key">Username</span>
          <span class="diff-val"><%= newuserid %></span>
        </div>
        <div class="diff-row">
          <span class="diff-key">Password</span>
          <span class="diff-val masked"><%= maskedPass %></span>
        </div>
        <div class="diff-row">
          <span class="diff-key">Name</span>
          <span class="diff-val"><%= newname %></span>
        </div>
      </div>

      <div class="btn-row">
        <a href="<%= ctxPath %>/StudentList.jsp" class="btn btn-primary">
          <svg class="icon" viewBox="0 0 24 24"><line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/><line x1="8" y1="18" x2="21" y2="18"/><line x1="3" y1="6" x2="3.01" y2="6"/><line x1="3" y1="12" x2="3.01" y2="12"/><line x1="3" y1="18" x2="3.01" y2="18"/></svg>
          View all students
        </a>
      </div>

    <%-- DB returned 0 rows --%>
    <% } else if (status == -1) { %>
      <div class="result-icon danger">
        <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
      </div>
      <p class="result-title">No record updated</p>
      <p class="result-sub">The original username <strong style="color:var(--text)"><%= originaluid %></strong> was not found. It may have already been changed or deleted.</p>
      <div class="btn-row">
        <a href="javascript:history.back()" class="btn btn-danger">
          <svg class="icon" viewBox="0 0 24 24"><polyline points="1 4 1 10 7 10"/><path d="M3.51 15a9 9 0 1 0 .49-3.5"/></svg>
          Try again
        </a>
        <a href="<%= ctxPath %>/StudentList.jsp" class="btn btn-ghost">
          <svg class="icon" viewBox="0 0 24 24"><polyline points="15 18 9 12 15 6"/></svg>
          Back to list
        </a>
      </div>

    <%-- Exception --%>
    <% } else { %>
      <div class="result-icon danger">
        <svg viewBox="0 0 24 24"><polygon points="7.86 2 16.14 2 22 7.86 22 16.14 16.14 22 7.86 22 2 16.14 2 7.86 7.86 2"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
      </div>
      <p class="result-title">Something went wrong</p>
      <p class="result-sub">A database exception occurred. Check the server logs and try again.</p>
      <div class="btn-row">
        <a href="javascript:history.back()" class="btn btn-danger">
          <svg class="icon" viewBox="0 0 24 24"><polyline points="1 4 1 10 7 10"/><path d="M3.51 15a9 9 0 1 0 .49-3.5"/></svg>
          Try again
        </a>
        <a href="<%= ctxPath %>/StudentList.jsp" class="btn btn-ghost">
          <svg class="icon" viewBox="0 0 24 24"><polyline points="15 18 9 12 15 6"/></svg>
          Back to list
        </a>
      </div>
    <% } %>

  </div>
</div>

<footer>© 2026 Examily, developed by Samrat.</footer>

</body>
</html>
