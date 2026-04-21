<%-- 
    Document   : AddStudent
    Created on : 25 March 2026, 14:10:08
    Author     : Samrat
--%>
<%@page import="oes.controller.*" %>
<%@page import="oes.controller.StudentInsert" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Add Student — Examily</title>
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    :root {
      --bg:        #0d0f14;
      --surface:   #13161e;
      --surface2:  #1a1e2a;
      --border:    rgba(255,255,255,0.07);
      --border-focus: rgba(91,140,255,0.5);
      --accent:    #5b8cff;
      --accent2:   #a78bfa;
      --danger:    #ff5c7a;
      --success:   #34d399;
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
      position: sticky; top: 0; z-index: 100;
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
      font-size: 1.3rem; font-weight: 800;
      letter-spacing: -0.02em;
      background: linear-gradient(90deg, var(--accent), var(--accent2));
      -webkit-background-clip: text; -webkit-text-fill-color: transparent;
    }
    .header-right { display: flex; gap: 10px; }

    /* ── Buttons ── */
    .btn {
      font-family: 'DM Sans', sans-serif;
      font-weight: 500; font-size: 0.875rem;
      padding: 9px 20px; border: none; border-radius: 8px;
      cursor: pointer; text-decoration: none;
      display: inline-flex; align-items: center; gap: 7px;
      transition: all 0.18s ease;
    }
    .btn-primary {
      background: linear-gradient(135deg, var(--accent), #3b6ee8);
      color: #fff;
      box-shadow: 0 4px 20px rgba(91,140,255,0.3);
    }
    .btn-primary:hover { transform: translateY(-1px); box-shadow: 0 6px 28px rgba(91,140,255,0.45); }
    .btn-ghost {
      background: var(--surface2); color: var(--muted);
      border: 1px solid var(--border);
    }
    .btn-ghost:hover { color: var(--text); border-color: rgba(255,255,255,0.18); }

    /* ── Page wrapper ── */
    .page {
      max-width: 560px;
      margin: 60px auto 0;
      padding: 0 24px;
    }

    /* ── Card ── */
    .card {
      background: var(--surface);
      border: 1px solid var(--border);
      border-radius: 16px;
      overflow: hidden;
      position: relative;
    }
    .card::before {
      content: '';
      position: absolute; top: 0; left: 0; right: 0; height: 3px;
      background: linear-gradient(90deg, var(--accent), var(--accent2));
    }
    .card-header {
      padding: 32px 36px 24px;
      border-bottom: 1px solid var(--border);
    }
    .card-icon {
      width: 52px; height: 52px;
      background: linear-gradient(135deg, rgba(91,140,255,0.15), rgba(167,139,250,0.15));
      border: 1px solid rgba(91,140,255,0.2);
      border-radius: 14px;
      display: grid; place-items: center;
      font-size: 24px;
      margin-bottom: 16px;
    }
    .card-title {
      font-family: 'Syne', sans-serif;
      font-size: 1.4rem; font-weight: 800;
      margin-bottom: 6px;
    }
    .card-subtitle { font-size: 0.875rem; color: var(--muted); }

    /* ── Form ── */
    .card-body { padding: 28px 36px 32px; }

    .form-group { margin-bottom: 22px; }

    label {
      display: block;
      font-size: 0.78rem;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.08em;
      color: var(--muted);
      margin-bottom: 8px;
    }

    .input-wrap { position: relative; }
    .input-icon {
      position: absolute; left: 14px; top: 50%; transform: translateY(-50%);
      font-size: 16px; pointer-events: none;
      color: var(--muted);
    }

    input[type="text"],
    input[type="password"] {
      width: 100%;
      background: var(--surface2);
      border: 1px solid var(--border);
      border-radius: 9px;
      padding: 12px 14px 12px 42px;
      font-family: 'DM Sans', sans-serif;
      font-size: 0.9rem;
      color: var(--text);
      transition: border-color 0.18s ease, box-shadow 0.18s ease;
      outline: none;
    }
    input[type="text"]:focus,
    input[type="password"]:focus {
      border-color: var(--border-focus);
      box-shadow: 0 0 0 3px rgba(91,140,255,0.12);
    }
    input::placeholder { color: var(--muted); }

    /* Password toggle */
    .toggle-pwd {
      position: absolute; right: 14px; top: 50%; transform: translateY(-50%);
      background: none; border: none; cursor: pointer;
      color: var(--muted); font-size: 16px; padding: 0;
      transition: color 0.15s;
    }
    .toggle-pwd:hover { color: var(--text); }

    /* Hint */
    .input-hint {
      font-size: 0.76rem; color: var(--muted);
      margin-top: 6px; padding-left: 2px;
    }

    /* ── Alert messages ── */
    .alert {
      display: flex; align-items: center; gap: 10px;
      padding: 12px 16px;
      border-radius: 9px;
      font-size: 0.875rem;
      font-weight: 500;
      margin-bottom: 22px;
    }
    .alert-error {
      background: rgba(255,92,122,0.1);
      border: 1px solid rgba(255,92,122,0.25);
      color: var(--danger);
    }
    .alert-success {
      background: rgba(52,211,153,0.1);
      border: 1px solid rgba(52,211,153,0.25);
      color: var(--success);
    }

    /* ── Action row ── */
    .action-row {
      display: flex; gap: 10px; margin-top: 28px;
      flex-wrap: wrap;
    }
    .btn-submit {
      flex: 1;
      background: linear-gradient(135deg, var(--accent), #3b6ee8);
      color: #fff;
      border: none;
      border-radius: 9px;
      padding: 13px 20px;
      font-family: 'DM Sans', sans-serif;
      font-size: 0.9rem; font-weight: 600;
      cursor: pointer;
      display: flex; align-items: center; justify-content: center; gap: 8px;
      transition: all 0.18s ease;
      box-shadow: 0 4px 20px rgba(91,140,255,0.3);
    }
    .btn-submit:hover { transform: translateY(-1px); box-shadow: 0 6px 28px rgba(91,140,255,0.45); }

    .btn-secondary {
      background: var(--surface2);
      color: var(--muted);
      border: 1px solid var(--border);
      border-radius: 9px;
      padding: 13px 18px;
      font-family: 'DM Sans', sans-serif;
      font-size: 0.875rem; font-weight: 500;
      cursor: pointer;
      transition: all 0.16s ease;
    }
    .btn-secondary:hover { color: var(--text); border-color: rgba(255,255,255,0.18); }

    /* ── Footer ── */
    footer {
      text-align: center;
      margin-top: 36px;
      color: var(--muted);
      font-size: 0.8rem;
      letter-spacing: 0.04em;
    }

    @media (max-width: 600px) {
      .header { padding: 18px 20px; }
      .card-header, .card-body { padding-left: 22px; padding-right: 22px; }
      .action-row { flex-direction: column; }
      .btn-submit { flex: none; }
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
      <a href="StudentList.jsp" class="btn btn-ghost">← Student List</a>
      <a href="AdminPanel.jsp" class="btn btn-ghost">⌂ Admin Panel</a>
    </div>
  </div>

  <!-- Page -->
  <div class="page">
    <div class="card">

      <!-- Card Header -->
      <div class="card-header">
        <div class="card-icon">👤</div>
        <div class="card-title">Register New Student</div>
        <div class="card-subtitle">Fill in the details below to add a student to the system.</div>
      </div>

      <!-- Card Body -->
      <div class="card-body">

        <!-- Alert messages -->
        <%
          String errMsg = request.getParameter("msg2");
          String okMsg  = request.getParameter("msg1");
          if (errMsg != null && !errMsg.trim().isEmpty()) {
        %>
        <div class="alert alert-error">⚠ <%=errMsg%></div>
        <% } %>
        <%
          if (okMsg != null && !okMsg.trim().isEmpty()) {
        %>
        <div class="alert alert-success">✓ <%=okMsg%></div>
        <% } %>

        <!-- Form -->
        <form action="oes.controller.StudentInsert" method="post">

          <div class="form-group">
            <label for="name">Full Name</label>
            <div class="input-wrap">
              <span class="input-icon">👤</span>
              <input type="text" id="name" name="name" placeholder="e.g. Samrat Singh" required>
            </div>
          </div>

          <div class="form-group">
            <label for="uname">Username / User ID</label>
            <div class="input-wrap">
              <span class="input-icon">@</span>
              <input type="text" id="uname" name="uname" placeholder="e.g. samrat01" required autocomplete="username">
            </div>
            <div class="input-hint">This will be used to log in. Must be unique.</div>
          </div>

          <div class="form-group">
            <label for="pass">Password</label>
            <div class="input-wrap">
              <span class="input-icon">🔒</span>
              <input type="password" id="pass" name="pass" placeholder="Enter a strong password" required autocomplete="new-password">
              <button type="button" class="toggle-pwd" onclick="togglePassword()" title="Show/hide password">👁</button>
            </div>
            <div class="input-hint">Minimum 6 characters recommended.</div>
          </div>

          <div class="action-row">
            <button type="submit" class="btn-submit">＋ Register Student</button>
            <button type="button" class="btn-secondary" onclick="location.href='StudentList.jsp'">← Back</button>
            <button type="reset"  class="btn-secondary">↺ Clear</button>
          </div>

        </form>
      </div>
    </div>

    <footer>© 2026 Examily, Inc. — All rights reserved.</footer>
  </div>

  <script>
    function togglePassword() {
      const input = document.getElementById('pass');
      const btn   = document.querySelector('.toggle-pwd');
      if (input.type === 'password') {
        input.type = 'text';
        btn.textContent = '🙈';
      } else {
        input.type = 'password';
        btn.textContent = '👁';
      }
    }
  </script>

</body>
</html>
