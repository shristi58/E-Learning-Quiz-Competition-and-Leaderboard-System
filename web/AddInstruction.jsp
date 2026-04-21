<%-- 
    Document   : AddInstruction
    Created on : 5 April 2026, 14:28:24
    Author     : Samrat
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Add Instruction — Examily</title>
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Mono:wght@300;400;500&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    :root {
      --bg:        #0d0f14;
      --surface:   #161a23;
      --border:    #252b3b;
      --accent:    #4f7cff;
      --accent-g:  #7c5cff;
      --success:   #2dca72;
      --danger:    #ff4f6a;
      --text:      #e8eaf2;
      --muted:     #6b7390;
      --radius:    14px;
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

    /* Ambient glow background */
    body::before {
      content: '';
      position: fixed;
      top: -30%;
      left: 50%;
      transform: translateX(-50%);
      width: 700px;
      height: 500px;
      background: radial-gradient(ellipse, rgba(79,124,255,0.12) 0%, transparent 70%);
      pointer-events: none;
      z-index: 0;
    }

    /* ---- Logo / Brand ---- */
    .brand {
      font-family: 'Syne', sans-serif;
      font-size: 0.75rem;
      font-weight: 700;
      letter-spacing: 0.25em;
      text-transform: uppercase;
      color: var(--muted);
      margin-bottom: 3rem;
      position: relative;
      z-index: 1;
    }

    .brand span {
      color: var(--accent);
    }

    /* ---- Card ---- */
    .card {
      position: relative;
      z-index: 1;
      background: var(--surface);
      border: 1px solid var(--border);
      border-radius: var(--radius);
      width: 100%;
      max-width: 520px;
      padding: 2.5rem 2.5rem 2rem;
      box-shadow: 0 24px 64px rgba(0,0,0,0.5), 0 0 0 1px rgba(255,255,255,0.03) inset;
      animation: slideUp 0.45s cubic-bezier(0.22,1,0.36,1) both;
    }

    @keyframes slideUp {
      from { opacity: 0; transform: translateY(28px); }
      to   { opacity: 1; transform: translateY(0); }
    }

    .card-header {
      margin-bottom: 2rem;
    }

    .card-label {
      font-size: 0.65rem;
      letter-spacing: 0.2em;
      text-transform: uppercase;
      color: var(--accent);
      font-weight: 500;
      margin-bottom: 0.5rem;
    }

    .card-title {
      font-family: 'Syne', sans-serif;
      font-size: 1.6rem;
      font-weight: 800;
      color: var(--text);
      line-height: 1.2;
    }

    /* ---- Form elements ---- */
    .field {
      margin-bottom: 1.5rem;
    }

    label {
      display: block;
      font-size: 0.72rem;
      letter-spacing: 0.1em;
      text-transform: uppercase;
      color: var(--muted);
      margin-bottom: 0.5rem;
    }

    input[type="text"] {
      width: 100%;
      background: var(--bg);
      border: 1px solid var(--border);
      border-radius: 8px;
      padding: 0.85rem 1rem;
      color: var(--text);
      font-family: 'DM Mono', monospace;
      font-size: 0.9rem;
      outline: none;
      transition: border-color 0.2s, box-shadow 0.2s;
    }

    input[type="text"]:focus {
      border-color: var(--accent);
      box-shadow: 0 0 0 3px rgba(79,124,255,0.18);
    }

    input[type="text"]::placeholder {
      color: var(--muted);
    }

    /* ---- Buttons ---- */
    .btn-row {
      display: flex;
      gap: 0.75rem;
      margin-top: 1.75rem;
      flex-wrap: wrap;
    }

    .btn {
      font-family: 'DM Mono', monospace;
      font-size: 0.8rem;
      font-weight: 500;
      padding: 0.65rem 1.4rem;
      border: none;
      border-radius: 8px;
      cursor: pointer;
      letter-spacing: 0.05em;
      transition: transform 0.15s, box-shadow 0.15s, filter 0.15s;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      gap: 0.45rem;
    }

    .btn:active { transform: scale(0.97); }

    .btn-primary {
      background: linear-gradient(135deg, var(--accent), var(--accent-g));
      color: #fff;
      box-shadow: 0 4px 20px rgba(79,124,255,0.35);
      flex: 1;
    }
    .btn-primary:hover { filter: brightness(1.12); box-shadow: 0 6px 24px rgba(79,124,255,0.5); }

    .btn-ghost {
      background: transparent;
      border: 1px solid var(--border);
      color: var(--muted);
    }
    .btn-ghost:hover { border-color: var(--text); color: var(--text); }

    /* ---- Messages ---- */
    .msg {
      margin-top: 1.25rem;
      padding: 0.75rem 1rem;
      border-radius: 8px;
      font-size: 0.82rem;
      display: none;
    }

    .msg.error {
      background: rgba(255,79,106,0.1);
      border: 1px solid rgba(255,79,106,0.3);
      color: #ff7a8f;
      display: block;
    }

    .msg.success {
      background: rgba(45,202,114,0.1);
      border: 1px solid rgba(45,202,114,0.25);
      color: #5de89b;
      display: block;
    }

    /* ---- Divider ---- */
    .divider {
      height: 1px;
      background: var(--border);
      margin: 1.75rem 0 1.5rem;
    }

    /* ---- Footer ---- */
    footer {
      margin-top: 2.5rem;
      font-size: 0.72rem;
      color: var(--muted);
      letter-spacing: 0.05em;
      position: relative;
      z-index: 1;
    }

    /* Icon SVGs */
    .icon { width: 14px; height: 14px; fill: none; stroke: currentColor; stroke-width: 2; stroke-linecap: round; stroke-linejoin: round; }
  </style>
</head>
<body>

  <div class="brand">© <span>Examily</span> Admin Console</div>

  <div class="card">
    <div class="card-header">
      <p class="card-label">Instructions</p>
      <h1 class="card-title">Add New Instruction</h1>
    </div>

    <form action="oes.controller.InstructionInsert" method="get">
      <div class="field">
        <label for="inst">Instruction Text</label>
        <input type="text" id="inst" name="inst" placeholder="Type your instruction here…" autocomplete="off" autofocus>
      </div>

      <div class="btn-row">
        <button type="submit" class="btn btn-primary">
          <svg class="icon" viewBox="0 0 24 24"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
          Add Instruction
        </button>
        <button type="button" class="btn btn-ghost" onclick="location.href='InstructionList.jsp'">
          <svg class="icon" viewBox="0 0 24 24"><polyline points="15 18 9 12 15 6"/></svg>
          Back
        </button>
        <button type="button" class="btn btn-ghost" onclick="location.href='AdminPanel.jsp'">
          <svg class="icon" viewBox="0 0 24 24"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
          Home
        </button>
      </div>
    </form>

    <%
      String msg2 = request.getParameter("msg2");
      String msg1 = request.getParameter("msg1");
    %>

    <% if (msg2 != null && !msg2.isEmpty()) { %>
      <div class="msg error">⚠ <%= msg2 %></div>
    <% } %>

    <% if (msg1 != null && !msg1.isEmpty()) { %>
      <div class="msg success">✓ <%= msg1 %></div>
    <% } %>
  </div>

  <footer>© 2026 Examily, Inc. All rights reserved.</footer>

</body>
</html>
