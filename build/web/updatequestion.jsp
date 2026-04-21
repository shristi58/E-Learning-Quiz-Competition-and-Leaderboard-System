<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="oes.model.*"%>
<%@page import="oes.db.*"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.net.URLEncoder"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Update Question — Examily</title>
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
      --warning:  #f5a623;
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
      padding: 2.5rem 1rem 4rem;
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
      color: var(--muted); margin-bottom: 2.5rem;
      position: relative; z-index: 1;
    }
    .brand span { color: var(--accent); }

    /* ---- Edit card (shown for the selected question) ---- */
    .edit-card {
      position: relative; z-index: 1;
      background: var(--surface);
      border: 1px solid var(--border);
      border-radius: var(--radius);
      width: 100%; max-width: 860px;
      box-shadow: 0 24px 64px rgba(0,0,0,0.5), 0 0 0 1px rgba(255,255,255,0.03) inset;
      animation: slideUp 0.4s cubic-bezier(0.22,1,0.36,1) both;
      margin-bottom: 2rem;
      overflow: hidden;
    }

    @keyframes slideUp {
      from { opacity: 0; transform: translateY(24px); }
      to   { opacity: 1; transform: translateY(0); }
    }

    .edit-header {
      padding: 1.5rem 2rem;
      border-bottom: 1px solid var(--border);
      display: flex; align-items: flex-end;
      justify-content: space-between; flex-wrap: wrap; gap: 1rem;
    }
    .edit-label {
      font-size: 0.65rem; letter-spacing: 0.2em;
      text-transform: uppercase; color: var(--accent);
      font-weight: 500; margin-bottom: 0.35rem;
    }
    .edit-title {
      font-family: 'Syne', sans-serif;
      font-size: 1.25rem; font-weight: 800; color: var(--text);
    }

    .edit-body { padding: 1.75rem 2rem; }

    .field-group {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 1rem;
      margin-bottom: 1rem;
    }
    .field-group.full { grid-template-columns: 1fr; }

    .field {
      display: flex; flex-direction: column; gap: 6px;
    }
    .field label {
      font-size: 0.62rem; letter-spacing: 0.15em;
      text-transform: uppercase; color: var(--muted);
    }
    .field input[type="text"] {
      background: var(--surface2);
      border: 1px solid var(--border);
      border-radius: 8px;
      padding: 0.65rem 0.9rem;
      font-family: 'DM Mono', monospace;
      font-size: 0.82rem;
      color: var(--text);
      outline: none;
      transition: border-color 0.15s, box-shadow 0.15s;
      width: 100%;
    }
    .field input[type="text"]:focus {
      border-color: var(--accent);
      box-shadow: 0 0 0 3px rgba(79,124,255,0.15);
    }

    .edit-footer {
      padding: 1.25rem 2rem;
      border-top: 1px solid var(--border);
      background: var(--surface2);
      display: flex; gap: 10px; justify-content: flex-end;
    }

    /* ---- Main list card ---- */
    .card {
      position: relative; z-index: 1;
      background: var(--surface);
      border: 1px solid var(--border);
      border-radius: var(--radius);
      width: 100%; max-width: 1100px;
      box-shadow: 0 24px 64px rgba(0,0,0,0.5), 0 0 0 1px rgba(255,255,255,0.03) inset;
      animation: slideUp 0.45s cubic-bezier(0.22,1,0.36,1) both;
      overflow: hidden;
    }

    .card-header {
      padding: 1.75rem 2rem 1.5rem;
      border-bottom: 1px solid var(--border);
      display: flex; align-items: flex-end;
      justify-content: space-between; flex-wrap: wrap; gap: 1rem;
    }
    .card-label {
      font-size: 0.65rem; letter-spacing: 0.2em;
      text-transform: uppercase; color: var(--accent);
      font-weight: 500; margin-bottom: 0.4rem;
    }
    .card-title {
      font-family: 'Syne', sans-serif;
      font-size: 1.45rem; font-weight: 800; color: var(--text);
    }
    .count-badge {
      font-size: 0.72rem;
      background: rgba(79,124,255,0.15); color: var(--accent);
      border: 1px solid rgba(79,124,255,0.3);
      padding: 0.3rem 0.75rem; border-radius: 999px;
      letter-spacing: 0.05em; white-space: nowrap; align-self: center;
    }

    .table-wrap { overflow-x: auto; }

    table { width: 100%; border-collapse: collapse; font-size: 0.8rem; }

    thead tr { background: var(--surface2); border-bottom: 1px solid var(--border); }
    thead th {
      padding: 0.85rem 1rem;
      font-size: 0.62rem; letter-spacing: 0.15em;
      text-transform: uppercase; color: var(--muted);
      font-weight: 500; text-align: left; white-space: nowrap;
    }

    tbody tr { border-bottom: 1px solid var(--border); transition: background 0.15s; }
    tbody tr:last-child { border-bottom: none; }
    tbody tr:hover { background: rgba(79,124,255,0.04); }
    tbody tr.active-row { background: rgba(79,124,255,0.08); border-left: 3px solid var(--accent); }

    td { padding: 0.9rem 1rem; vertical-align: middle; color: var(--text); }
    .sno { color: var(--muted); font-size: 0.72rem; width: 2.5rem; }
    .q-text { max-width: 280px; word-break: break-word; line-height: 1.5; }
    .opt { color: var(--muted); max-width: 120px; word-break: break-word; }
    .ans-badge {
      display: inline-block;
      background: rgba(45,202,114,0.12); color: #6ee7a0;
      border: 1px solid rgba(45,202,114,0.25);
      padding: 0.2rem 0.6rem; border-radius: 6px;
      font-size: 0.72rem; white-space: nowrap;
    }

    .actions { display: flex; gap: 0.5rem; white-space: nowrap; }

    .action-btn {
      display: inline-flex; align-items: center; gap: 0.35rem;
      font-family: 'DM Mono', monospace;
      font-size: 0.7rem; font-weight: 500;
      padding: 0.38rem 0.8rem; border-radius: 6px;
      text-decoration: none; border: 1px solid transparent;
      transition: background 0.15s, border-color 0.15s, color 0.15s, transform 0.1s;
      cursor: pointer; background: none;
    }
    .action-btn:active { transform: scale(0.96); }

    .btn-update {
      background: rgba(79,124,255,0.1); border-color: rgba(79,124,255,0.3); color: #7fa4ff;
    }
    .btn-update:hover { background: rgba(79,124,255,0.2); border-color: var(--accent); color: #fff; }
    .btn-update.active {
      background: rgba(79,124,255,0.25); border-color: var(--accent); color: #fff;
    }

    .btn-delete {
      background: rgba(255,79,106,0.08); border-color: rgba(255,79,106,0.25); color: #ff7a8f;
    }
    .btn-delete:hover { background: rgba(255,79,106,0.18); border-color: var(--danger); color: #fff; }

    .card-footer {
      padding: 1.25rem 2rem;
      border-top: 1px solid var(--border);
      display: flex; align-items: center;
      justify-content: space-between; flex-wrap: wrap; gap: 0.75rem;
      background: var(--surface2);
    }

    /* ---- Shared buttons ---- */
    .btn {
      font-family: 'DM Mono', monospace;
      font-size: 0.78rem; font-weight: 500;
      padding: 0.6rem 1.3rem; border: none;
      border-radius: 8px; cursor: pointer;
      letter-spacing: 0.05em;
      transition: transform 0.15s, filter 0.15s;
      display: inline-flex; align-items: center; gap: 0.4rem;
      text-decoration: none;
    }
    .btn:active { transform: scale(0.97); }

    .btn-primary {
      background: linear-gradient(135deg, var(--accent), var(--accent-g));
      color: #fff; box-shadow: 0 4px 18px rgba(79,124,255,0.3);
    }
    .btn-primary:hover { filter: brightness(1.12); }

    .btn-ghost {
      background: transparent; border: 1px solid var(--border); color: var(--muted);
    }
    .btn-ghost:hover { border-color: var(--text); color: var(--text); }

    .btn-save {
      background: linear-gradient(135deg, var(--accent), var(--accent-g));
      color: #fff; box-shadow: 0 4px 14px rgba(79,124,255,0.25);
    }
    .btn-save:hover { filter: brightness(1.1); }

    .btn-cancel-edit {
      background: transparent; border: 1px solid var(--border); color: var(--muted);
    }
    .btn-cancel-edit:hover { border-color: var(--text); color: var(--text); }

    .icon { width: 13px; height: 13px; fill: none; stroke: currentColor; stroke-width: 2; stroke-linecap: round; stroke-linejoin: round; }

    footer {
      margin-top: 2rem; font-size: 0.7rem;
      color: var(--muted); letter-spacing: 0.05em;
      position: relative; z-index: 1;
    }

    @media (max-width: 600px) {
      .field-group { grid-template-columns: 1fr; }
      .edit-body { padding: 1.25rem; }
      .edit-footer { flex-direction: column; }
    }
  </style>
</head>
<body>

<%
  String ctxPath     = request.getContextPath();
  String editQues    = request.getParameter("ques");
  ArrayList<Questions> allQuestions = QuestionsDao.getAllRecords();
  int total = (allQuestions != null) ? allQuestions.size() : 0;
%>

<div class="brand">© <span>Examily</span> Admin Console</div>

<%-- ========== EDIT CARD (only shown when a question is selected) ========== --%>
<% if (editQues != null && !editQues.trim().isEmpty()) {
     for (Questions e : allQuestions) {
       if (editQues.equals(e.getQuestion())) { %>

<div class="edit-card">
  <div class="edit-header">
    <div>
      <p class="edit-label">Editing question</p>
      <h2 class="edit-title">Edit Question</h2>
    </div>
  </div>
  <form action="<%= ctxPath %>/updatequestionnow.jsp" method="post">
    <input type="hidden" name="quesoriginal" value="<%= e.getQuestion() %>">
    <div class="edit-body">

      <div class="field-group full">
        <div class="field">
          <label>Question</label>
          <input type="text" name="quesmodified" value="<%= e.getQuestion() %>">
        </div>
      </div>

      <div class="field-group">
        <div class="field">
          <label>Option A</label>
          <input type="text" name="opta" value="<%= e.getA() %>">
        </div>
        <div class="field">
          <label>Option B</label>
          <input type="text" name="optb" value="<%= e.getB() %>">
        </div>
        <div class="field">
          <label>Option C</label>
          <input type="text" name="optc" value="<%= e.getC() %>">
        </div>
        <div class="field">
          <label>Option D</label>
          <input type="text" name="optd" value="<%= e.getD() %>">
        </div>
      </div>

      <div class="field-group full">
        <div class="field">
          <label>Correct Answer</label>
          <input type="text" name="ans" value="<%= e.getAnswer() %>">
        </div>
      </div>

    </div>
    <div class="edit-footer">
      <a href="<%= ctxPath %>/updatequestion.jsp" class="btn btn-cancel-edit">
        <svg class="icon" viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
        Cancel
      </a>
      <button type="submit" class="btn btn-save">
        <svg class="icon" viewBox="0 0 24 24"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>
        Save changes
      </button>
    </div>
  </form>
</div>

<%   break; }
   }
} %>

<%-- ========== QUESTION LIST CARD ========== --%>
<div class="card">

  <div class="card-header">
    <div>
      <p class="card-label">Questions</p>
      <h1 class="card-title">All Questions</h1>
    </div>
    <span class="count-badge"><%= total %> record<%= total == 1 ? "" : "s" %></span>
  </div>

  <div class="table-wrap">
    <% if (total == 0) { %>
      <div style="padding:3rem; text-align:center; color:var(--muted); font-size:0.85rem;">
        <div style="font-size:2rem;margin-bottom:.75rem;opacity:.4;">📝</div>
        No questions found. Add one to get started.
      </div>
    <% } else { %>
    <table>
      <thead>
        <tr>
          <th>#</th>
          <th>Question</th>
          <th>Opt A</th>
          <th>Opt B</th>
          <th>Opt C</th>
          <th>Opt D</th>
          <th>Answer</th>
          <th colspan="2">Actions</th>
        </tr>
      </thead>
      <tbody>
        <%
          int idx = 1;
          for (Questions e : allQuestions) {
            boolean isEditing = editQues != null && editQues.equals(e.getQuestion());
            String encQues = URLEncoder.encode(e.getQuestion(), "UTF-8");
        %>
        <tr class="<%= isEditing ? "active-row" : "" %>">
          <td class="sno"><%= idx++ %></td>
          <td class="q-text"><%= e.getQuestion() %></td>
          <td class="opt"><%= e.getA() %></td>
          <td class="opt"><%= e.getB() %></td>
          <td class="opt"><%= e.getC() %></td>
          <td class="opt"><%= e.getD() %></td>
          <td><span class="ans-badge"><%= e.getAnswer() %></span></td>
          <td>
            <div class="actions">
              <a class="action-btn btn-update <%= isEditing ? "active" : "" %>"
                 href="<%= ctxPath %>/updatequestion.jsp?ques=<%= encQues %>">
                <svg class="icon" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                <%= isEditing ? "Editing…" : "Update" %>
              </a>
              <a class="action-btn btn-delete"
                 href="<%= ctxPath %>/deletequestion.jsp?ques=<%= encQues %>"
                 onclick="return confirm('Delete this question?')">
                <svg class="icon" viewBox="0 0 24 24"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/><path d="M10 11v6"/><path d="M14 11v6"/><path d="M9 6V4h6v2"/></svg>
                Delete
              </a>
            </div>
          </td>
        </tr>
        <% } %>
      </tbody>
    </table>
    <% } %>
  </div>

  <div class="card-footer">
    <button class="btn btn-primary" onclick="location.href='<%= ctxPath %>/AddQuestion.jsp'">
      <svg class="icon" viewBox="0 0 24 24"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
      Add Question
    </button>
    <button class="btn btn-ghost" onclick="location.href='<%= ctxPath %>/AdminPanel.jsp'">
      <svg class="icon" viewBox="0 0 24 24"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
      Back to Panel
    </button>
  </div>

</div>

<footer>© 2026 Examily, developed by Samrat.</footer>

</body>
</html>
