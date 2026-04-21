<%-- 
    Document   : InstructionList
    Created on : 25 Mar 2026, 13:08:05
    Author     : Kumar Samrat Singh
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="oes.model.InstructionsDao"%>
<%@page import="oes.db.Instructions"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.net.URLEncoder"%>
<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Instruction List — Examily</title>
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Mono:wght@300;400;500&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    :root {
      --bg:        #0d0f14;
      --surface:   #161a23;
      --surface2:  #1c2130;
      --border:    #252b3b;
      --accent:    #4f7cff;
      --accent-g:  #7c5cff;
      --success:   #2dca72;
      --danger:    #ff4f6a;
      --warning:   #f5a623;
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
      padding: 2.5rem 1rem 4rem;
      position: relative;
      overflow-x: hidden;
    }

    body::before {
      content: '';
      position: fixed;
      top: -20%;
      left: 50%;
      transform: translateX(-50%);
      width: 800px;
      height: 500px;
      background: radial-gradient(ellipse, rgba(79,124,255,0.10) 0%, transparent 70%);
      pointer-events: none;
      z-index: 0;
    }

    .brand {
      font-family: 'Syne', sans-serif;
      font-size: 0.75rem;
      font-weight: 700;
      letter-spacing: 0.25em;
      text-transform: uppercase;
      color: var(--muted);
      margin-bottom: 2.5rem;
      position: relative;
      z-index: 1;
    }
    .brand span { color: var(--accent); }

    .card {
      position: relative;
      z-index: 1;
      background: var(--surface);
      border: 1px solid var(--border);
      border-radius: var(--radius);
      width: 100%;
      max-width: 780px;
      box-shadow: 0 24px 64px rgba(0,0,0,0.5), 0 0 0 1px rgba(255,255,255,0.03) inset;
      animation: slideUp 0.45s cubic-bezier(0.22,1,0.36,1) both;
      overflow: hidden;
    }

    @keyframes slideUp {
      from { opacity: 0; transform: translateY(28px); }
      to   { opacity: 1; transform: translateY(0); }
    }

    .card-header {
      padding: 1.75rem 2rem 1.5rem;
      border-bottom: 1px solid var(--border);
      display: flex;
      align-items: flex-end;
      justify-content: space-between;
      flex-wrap: wrap;
      gap: 1rem;
    }

    .card-label {
      font-size: 0.65rem;
      letter-spacing: 0.2em;
      text-transform: uppercase;
      color: var(--accent);
      font-weight: 500;
      margin-bottom: 0.4rem;
    }

    .card-title {
      font-family: 'Syne', sans-serif;
      font-size: 1.45rem;
      font-weight: 800;
      color: var(--text);
      line-height: 1.2;
    }

    .count-badge {
      font-size: 0.72rem;
      background: rgba(79,124,255,0.15);
      color: var(--accent);
      border: 1px solid rgba(79,124,255,0.3);
      padding: 0.3rem 0.75rem;
      border-radius: 999px;
      letter-spacing: 0.05em;
      white-space: nowrap;
      align-self: center;
    }

    .table-wrap { overflow-x: auto; }

    table {
      width: 100%;
      border-collapse: collapse;
      font-size: 0.83rem;
    }

    thead tr {
      background: var(--surface2);
      border-bottom: 1px solid var(--border);
    }

    thead th {
      padding: 0.85rem 1.25rem;
      font-size: 0.65rem;
      letter-spacing: 0.15em;
      text-transform: uppercase;
      color: var(--muted);
      font-weight: 500;
      text-align: left;
      white-space: nowrap;
    }

    tbody tr {
      border-bottom: 1px solid var(--border);
      transition: background 0.15s;
    }

    tbody tr:last-child { border-bottom: none; }
    tbody tr:hover { background: rgba(79,124,255,0.05); }

    td {
      padding: 1rem 1.25rem;
      color: var(--text);
      vertical-align: middle;
    }

    .sno {
      color: var(--muted);
      font-size: 0.75rem;
      width: 3rem;
    }

    .inst-text {
      max-width: 340px;
      word-break: break-word;
      line-height: 1.5;
    }

    .actions {
      display: flex;
      gap: 0.5rem;
      white-space: nowrap;
    }

    .action-btn {
      display: inline-flex;
      align-items: center;
      gap: 0.35rem;
      font-family: 'DM Mono', monospace;
      font-size: 0.72rem;
      font-weight: 500;
      padding: 0.4rem 0.85rem;
      border-radius: 6px;
      text-decoration: none;
      border: 1px solid transparent;
      transition: background 0.15s, border-color 0.15s, color 0.15s, transform 0.12s;
      letter-spacing: 0.04em;
      cursor: pointer;
      background: none;
    }
    .action-btn:active { transform: scale(0.96); }

    .btn-update {
      background: rgba(79,124,255,0.1);
      border-color: rgba(79,124,255,0.3);
      color: #7fa4ff;
    }
    .btn-update:hover {
      background: rgba(79,124,255,0.2);
      border-color: var(--accent);
      color: #fff;
    }

    .btn-delete {
      background: rgba(255,79,106,0.08);
      border-color: rgba(255,79,106,0.25);
      color: #ff7a8f;
    }
    .btn-delete:hover {
      background: rgba(255,79,106,0.18);
      border-color: var(--danger);
      color: #fff;
    }

    .empty {
      padding: 3rem 1.5rem;
      text-align: center;
      color: var(--muted);
      font-size: 0.85rem;
    }
    .empty-icon {
      font-size: 2rem;
      margin-bottom: 0.75rem;
      opacity: 0.4;
    }

    .card-footer {
      padding: 1.25rem 2rem;
      border-top: 1px solid var(--border);
      display: flex;
      align-items: center;
      justify-content: space-between;
      flex-wrap: wrap;
      gap: 0.75rem;
      background: var(--surface2);
    }

    .btn {
      font-family: 'DM Mono', monospace;
      font-size: 0.78rem;
      font-weight: 500;
      padding: 0.6rem 1.3rem;
      border: none;
      border-radius: 8px;
      cursor: pointer;
      letter-spacing: 0.05em;
      transition: transform 0.15s, box-shadow 0.15s, filter 0.15s;
      display: inline-flex;
      align-items: center;
      gap: 0.4rem;
      text-decoration: none;
    }
    .btn:active { transform: scale(0.97); }

    .btn-primary {
      background: linear-gradient(135deg, var(--accent), var(--accent-g));
      color: #fff;
      box-shadow: 0 4px 18px rgba(79,124,255,0.3);
    }
    .btn-primary:hover { filter: brightness(1.12); }

    .btn-ghost {
      background: transparent;
      border: 1px solid var(--border);
      color: var(--muted);
    }
    .btn-ghost:hover { border-color: var(--text); color: var(--text); }

    footer {
      margin-top: 2rem;
      font-size: 0.7rem;
      color: var(--muted);
      letter-spacing: 0.05em;
      position: relative;
      z-index: 1;
    }

    .icon { width: 13px; height: 13px; fill: none; stroke: currentColor; stroke-width: 2; stroke-linecap: round; stroke-linejoin: round; }

    /* Modal overlay */
    .modal-overlay {
      display: none;
      position: fixed;
      inset: 0;
      background: rgba(0,0,0,0.7);
      z-index: 100;
      align-items: center;
      justify-content: center;
    }
    .modal-overlay.show { display: flex; }

    .modal {
      background: var(--surface);
      border: 1px solid var(--border);
      border-radius: var(--radius);
      padding: 2rem;
      max-width: 400px;
      width: 90%;
      text-align: center;
      animation: slideUp 0.25s cubic-bezier(0.22,1,0.36,1) both;
    }

    .modal-icon {
      width: 52px; height: 52px;
      border-radius: 50%;
      background: rgba(255,79,106,0.12);
      display: flex; align-items: center; justify-content: center;
      margin: 0 auto 1.25rem;
    }
    .modal-icon svg { width: 24px; height: 24px; stroke: var(--danger); fill: none; stroke-width: 2; stroke-linecap: round; stroke-linejoin: round; }

    .modal h3 {
      font-family: 'Syne', sans-serif;
      font-size: 1.1rem;
      font-weight: 700;
      margin-bottom: 0.5rem;
      color: var(--text);
    }

    .modal p {
      font-size: 0.8rem;
      color: var(--muted);
      margin-bottom: 0.5rem;
      line-height: 1.5;
    }

    .modal-inst {
      background: var(--surface2);
      border: 1px solid var(--border);
      border-radius: 8px;
      padding: 0.6rem 0.9rem;
      font-size: 0.78rem;
      color: var(--text);
      margin: 0.75rem 0 1.5rem;
      word-break: break-word;
      text-align: left;
    }

    .modal-inst-label {
      font-size: 0.6rem;
      letter-spacing: 0.15em;
      text-transform: uppercase;
      color: var(--muted);
      margin-bottom: 4px;
    }

    .modal-btn-row {
      display: flex;
      gap: 10px;
    }

    .modal-btn {
      flex: 1;
      padding: 0.55rem 1rem;
      font-family: 'DM Mono', monospace;
      font-size: 0.78rem;
      font-weight: 500;
      border-radius: 8px;
      cursor: pointer;
      border: 1px solid transparent;
      transition: filter 0.15s, transform 0.1s;
      letter-spacing: 0.04em;
    }
    .modal-btn:active { transform: scale(0.97); }

    .modal-btn-cancel {
      background: transparent;
      border-color: var(--border);
      color: var(--muted);
    }
    .modal-btn-cancel:hover { border-color: var(--text); color: var(--text); }

    .modal-btn-confirm {
      background: var(--danger);
      color: #fff;
      border-color: var(--danger);
    }
    .modal-btn-confirm:hover { filter: brightness(1.1); }
  </style>
</head>
<body>

  <div class="brand">© <span>Examily</span> Admin Console</div>

  <%
    ArrayList<Instructions> allinsts = InstructionsDao.getAllRecords();
    int total = (allinsts != null) ? allinsts.size() : 0;
    String ctxPath = request.getContextPath();
  %>

  <!-- Delete confirmation modal -->
  <div class="modal-overlay" id="deleteModal">
    <div class="modal">
      <div class="modal-icon">
        <svg viewBox="0 0 24 24"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/><path d="M10 11v6"/><path d="M14 11v6"/><path d="M9 6V4h6v2"/></svg>
      </div>
      <h3>Delete instruction?</h3>
      <p>This action cannot be undone.</p>
      <div class="modal-inst">
        <div class="modal-inst-label">Instruction</div>
        <span id="modalInstText"></span>
      </div>
      <div class="modal-btn-row">
        <button class="modal-btn modal-btn-cancel" onclick="closeModal()">Cancel</button>
        <form id="deleteForm" method="post" style="flex:1; margin:0;">
          <input type="hidden" name="action" value="confirm">
          <input type="hidden" name="inst" id="modalInstInput">
          <button type="submit" class="modal-btn modal-btn-confirm" style="width:100%;">Delete</button>
        </form>
      </div>
    </div>
  </div>

  <div class="card">

    <div class="card-header">
      <div>
        <p class="card-label">Instructions</p>
        <h1 class="card-title">All Instructions</h1>
      </div>
      <span class="count-badge"><%= total %> record<%= total == 1 ? "" : "s" %></span>
    </div>

    <div class="table-wrap">
      <% if (total == 0) { %>
        <div class="empty">
          <div class="empty-icon">📋</div>
          No instructions found. Add one to get started.
        </div>
      <% } else { %>
      <table>
        <thead>
          <tr>
            <th>#</th>
            <th>Instruction</th>
            <th colspan="2">Actions</th>
          </tr>
        </thead>
        <tbody>
          <%
            int idx = 1;
            for (Instructions e : allinsts) {
              String instEncoded = URLEncoder.encode(e.getInstruction(), "UTF-8");
              String instEscaped = e.getInstruction().replace("'", "\\'").replace("\"", "&quot;");
          %>
          <tr>
            <td class="sno"><%= idx++ %></td>
            <td class="inst-text"><%= e.getInstruction() %></td>
            <td>
              <div class="actions">
                <a class="action-btn btn-update"
                   href="<%= ctxPath %>/updateinstruction.jsp?inst=<%= instEncoded %>">
                  <svg class="icon" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                  Update
                </a>
                <button class="action-btn btn-delete"
                        onclick="openModal('<%= instEscaped %>', '<%= ctxPath %>/DeleteInstruction.jsp')">
                  <svg class="icon" viewBox="0 0 24 24"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/><path d="M10 11v6"/><path d="M14 11v6"/><path d="M9 6V4h6v2"/></svg>
                  Delete
                </button>
              </div>
            </td>
          </tr>
          <% } %>
        </tbody>
      </table>
      <% } %>
    </div>

    <div class="card-footer">
      <button class="btn btn-primary" onclick="location.href='<%= ctxPath %>/AddInstruction.jsp'">
        <svg class="icon" viewBox="0 0 24 24"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
        Add Instruction
      </button>
      <button class="btn btn-ghost" onclick="location.href='<%= ctxPath %>/AdminPanel.jsp'">
        <svg class="icon" viewBox="0 0 24 24"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
        Back to Panel
      </button>
    </div>

  </div>

  <footer>© 2026 Examily, developed by Samrat.</footer>

  <script>
    function openModal(instText, formAction) {
      document.getElementById('modalInstText').textContent = instText;
      document.getElementById('modalInstInput').value = instText;
      document.getElementById('deleteForm').action = formAction;
      document.getElementById('deleteModal').classList.add('show');
    }

    function closeModal() {
      document.getElementById('deleteModal').classList.remove('show');
    }

    document.getElementById('deleteModal').addEventListener('click', function(e) {
      if (e.target === this) closeModal();
    });
  </script>

</body>
</html>
