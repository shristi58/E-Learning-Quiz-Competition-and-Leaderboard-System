<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="oes.model.InstructionsDao"%>
<%@page import="oes.db.Instructions"%>
<%@page import="java.util.ArrayList"%>
<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Manage Instructions</title>
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:ital,wght@0,300;0,400;0,500;1,300&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    :root {
      --bg:        #0d0f14;
      --surface:   #13161e;
      --card:      #1a1e2a;
      --border:    #252a38;
      --accent:    #4f8ef7;
      --accent2:   #7c5cfc;
      --danger:    #f7564f;
      --success:   #3ecf8e;
      --text:      #e8eaf0;
      --muted:     #6b7280;
      --radius:    12px;
    }

    body {
      background: var(--bg);
      color: var(--text);
      font-family: 'DM Sans', sans-serif;
      min-height: 100vh;
      padding: 40px 20px;
    }

    /* ── BACKGROUND MESH ── */
    body::before {
      content: '';
      position: fixed;
      inset: 0;
      background:
        radial-gradient(ellipse 80% 60% at 20% 10%, rgba(79,142,247,.08) 0%, transparent 60%),
        radial-gradient(ellipse 60% 50% at 80% 80%, rgba(124,92,252,.07) 0%, transparent 55%);
      pointer-events: none;
      z-index: 0;
    }

    .wrapper {
      position: relative;
      z-index: 1;
      max-width: 900px;
      margin: 0 auto;
    }

    /* ── HEADER ── */
    .page-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 36px;
      flex-wrap: wrap;
      gap: 16px;
    }

    .page-title {
      font-family: 'Syne', sans-serif;
      font-size: 28px;
      font-weight: 800;
      letter-spacing: -0.5px;
      background: linear-gradient(135deg, var(--accent), var(--accent2));
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }

    .page-subtitle {
      font-size: 13px;
      color: var(--muted);
      margin-top: 4px;
      font-weight: 300;
    }

    .header-actions {
      display: flex;
      gap: 10px;
    }

    /* ── BUTTONS ── */
    .btn {
      display: inline-flex;
      align-items: center;
      gap: 7px;
      padding: 9px 18px;
      border-radius: 8px;
      font-size: 13px;
      font-weight: 500;
      cursor: pointer;
      border: none;
      text-decoration: none;
      transition: all .18s ease;
      font-family: 'DM Sans', sans-serif;
      letter-spacing: .01em;
      white-space: nowrap;
    }

    .btn-primary {
      background: linear-gradient(135deg, var(--accent), var(--accent2));
      color: #fff;
      box-shadow: 0 4px 14px rgba(79,142,247,.25);
    }
    .btn-primary:hover { transform: translateY(-1px); box-shadow: 0 6px 20px rgba(79,142,247,.35); }

    .btn-ghost {
      background: var(--card);
      color: var(--text);
      border: 1px solid var(--border);
    }
    .btn-ghost:hover { background: var(--border); transform: translateY(-1px); }

    .btn-save {
      background: linear-gradient(135deg, var(--success), #2ab872);
      color: #fff;
      padding: 7px 16px;
      font-size: 12px;
      box-shadow: 0 3px 10px rgba(62,207,142,.2);
    }
    .btn-save:hover { transform: translateY(-1px); box-shadow: 0 5px 14px rgba(62,207,142,.3); }

    .btn-delete {
      background: transparent;
      color: var(--danger);
      border: 1px solid rgba(247,86,79,.25);
      padding: 7px 14px;
      font-size: 12px;
    }
    .btn-delete:hover { background: rgba(247,86,79,.08); border-color: var(--danger); }

    /* ── CARD TABLE ── */
    .card {
      background: var(--surface);
      border: 1px solid var(--border);
      border-radius: var(--radius);
      overflow: hidden;
      box-shadow: 0 8px 40px rgba(0,0,0,.4);
    }

    .table-header {
      display: grid;
      grid-template-columns: 52px 1fr 140px 100px;
      gap: 0;
      background: var(--card);
      border-bottom: 1px solid var(--border);
      padding: 12px 20px;
    }

    .col-head {
      font-family: 'Syne', sans-serif;
      font-size: 11px;
      font-weight: 700;
      letter-spacing: 1.2px;
      text-transform: uppercase;
      color: var(--muted);
    }

    /* ── ROWS ── */
    .instruction-row {
      display: grid;
      grid-template-columns: 52px 1fr 140px 100px;
      align-items: center;
      gap: 0;
      padding: 14px 20px;
      border-bottom: 1px solid var(--border);
      transition: background .15s ease;
      animation: fadeSlide .3s ease both;
    }

    .instruction-row:last-of-type { border-bottom: none; }
    .instruction-row:hover { background: rgba(255,255,255,.02); }
    .instruction-row.editing { background: rgba(79,142,247,.05); }

    @keyframes fadeSlide {
      from { opacity: 0; transform: translateY(6px); }
      to   { opacity: 1; transform: translateY(0); }
    }

    .row-index {
      font-size: 12px;
      color: var(--muted);
      font-weight: 500;
      font-family: 'Syne', sans-serif;
    }

    .row-text {
      font-size: 14px;
      color: var(--text);
      padding-right: 16px;
      line-height: 1.5;
    }

    /* editable input */
    .edit-input {
      width: 100%;
      background: var(--bg);
      border: 1px solid var(--accent);
      border-radius: 7px;
      color: var(--text);
      font-family: 'DM Sans', sans-serif;
      font-size: 13.5px;
      padding: 7px 12px;
      outline: none;
      box-shadow: 0 0 0 3px rgba(79,142,247,.12);
      margin-right: 16px;
      transition: box-shadow .15s;
    }
    .edit-input:focus { box-shadow: 0 0 0 4px rgba(79,142,247,.2); }

    .row-actions { display: flex; gap: 8px; align-items: center; }
    .row-ops     { display: flex; gap: 8px; align-items: center; }

    /* ── FOOTER BAR ── */
    .footer-bar {
      padding: 16px 20px;
      background: var(--card);
      border-top: 1px solid var(--border);
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 12px;
    }

    .count-pill {
      font-size: 12px;
      color: var(--muted);
      background: var(--bg);
      border: 1px solid var(--border);
      border-radius: 20px;
      padding: 4px 12px;
    }

    /* ── ICON SVGs ── */
    .icon { width: 14px; height: 14px; stroke-width: 2; fill: none; stroke: currentColor; flex-shrink: 0; }

    /* ── EMPTY STATE ── */
    .empty {
      text-align: center;
      padding: 60px 20px;
      color: var(--muted);
    }
    .empty-icon { font-size: 40px; margin-bottom: 12px; opacity: .5; }
    .empty p { font-size: 14px; }

    /* ── RESPONSIVE ── */
    @media (max-width: 600px) {
      .table-header,
      .instruction-row {
        grid-template-columns: 40px 1fr;
      }
      .col-head:nth-child(3), .col-head:nth-child(4),
      .row-ops, .row-actions { display: none; }
      .instruction-row { gap: 0; }
    }
  </style>
</head>
<body>
<div class="wrapper">

  <!-- HEADER -->
  <div class="page-header">
    <div>
      <div class="page-title">Instructions Manager</div>
      <div class="page-subtitle">Manage exam instructions — edit inline or delete in one click</div>
    </div>
    <div class="header-actions">
      <a href="AdminPanel.jsp" class="btn btn-ghost">
        <svg class="icon" viewBox="0 0 24 24"><path d="M19 12H5M12 5l-7 7 7 7"/></svg>
        Back
      </a>
      <a href="AddInstruction.jsp" class="btn btn-primary">
        <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
        Add Instruction
      </a>
    </div>
  </div>

  <!-- TABLE CARD -->
  <div class="card">
    <div class="table-header">
      <span class="col-head">#</span>
      <span class="col-head">Instruction</span>
      <span class="col-head">Edit</span>
      <span class="col-head">Delete</span>
    </div>

    <%
      int i = 1;
      ArrayList<Instructions> allinsts = InstructionsDao.getAllRecords();
      String selectedInst = request.getParameter("inst");
      if (allinsts == null || allinsts.isEmpty()) {
    %>
      <div class="empty">
        <div class="empty-icon">📋</div>
        <p>No instructions found. Add one to get started.</p>
      </div>
    <%
      } else {
        for (Instructions e : allinsts) {
          boolean isEditing = (selectedInst != null && selectedInst.equals(e.getInstruction()));
    %>
      <div class="instruction-row <%= isEditing ? "editing" : "" %>">
        <span class="row-index"><%= i++ %></span>

        <% if (isEditing) { %>
          <form action="updateinstructionnow.jsp" method="post" style="display:contents;">
            <input type="hidden" name="instoriginal" value="<%= e.getInstruction() %>">
            <div style="padding-right:16px;">
              <input class="edit-input" type="text" name="instmodified" value="<%= e.getInstruction() %>" autofocus>
            </div>
            <div class="row-ops">
              <button type="submit" class="btn btn-save">
                <svg class="icon" viewBox="0 0 24 24"><path d="M20 6L9 17l-5-5"/></svg>
                Save
              </button>
            </div>
            <div class="row-actions">
              <a href="deleteinstruction.jsp?inst=<%= java.net.URLEncoder.encode(e.getInstruction(),"UTF-8") %>"
                 class="btn btn-delete"
                 onclick="return confirm('Delete this instruction?')">
                <svg class="icon" viewBox="0 0 24 24"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14H6L5 6M10 11v6M14 11v6M9 6V4h6v2"/></svg>
              </a>
            </div>
          </form>
        <% } else { %>
          <span class="row-text"><%= e.getInstruction() %></span>
          <div class="row-ops">
            <a href="updateinstruction.jsp?inst=<%= java.net.URLEncoder.encode(e.getInstruction(),"UTF-8") %>" class="btn btn-ghost" style="padding:7px 14px;font-size:12px;">
              <svg class="icon" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
              Edit
            </a>
          </div>
          <div class="row-actions">
            <a href="deleteinstruction.jsp?inst=<%= java.net.URLEncoder.encode(e.getInstruction(),"UTF-8") %>"
               class="btn btn-delete"
               onclick="return confirm('Delete this instruction?')">
              <svg class="icon" viewBox="0 0 24 24"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14H6L5 6M10 11v6M14 11v6M9 6V4h6v2"/></svg>
            </a>
          </div>
        <% } %>
      </div>
    <%
        }
      }
    %>

    <!-- FOOTER BAR -->
    <div class="footer-bar">
      <span class="count-pill">
        <%= allinsts != null ? allinsts.size() : 0 %> instruction<%= (allinsts == null || allinsts.size() != 1) ? "s" : "" %>
      </span>
      <div style="display:flex;gap:10px;">
        <a href="AddInstruction.jsp" class="btn btn-primary" style="font-size:12px;padding:8px 16px;">
          <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
          Add New
        </a>
        <a href="AdminPanel.jsp" class="btn btn-ghost" style="font-size:12px;padding:8px 16px;">
          Admin Panel
        </a>
      </div>
    </div>
  </div>

</div>
</body>
</html>
