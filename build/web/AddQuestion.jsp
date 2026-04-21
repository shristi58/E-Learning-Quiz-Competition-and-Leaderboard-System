<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="oes.model.ExamsDao" %>
<%@ page import="oes.db.Exams" %>
<%@ page import="java.util.ArrayList" %>
<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Add Question — Examily</title>
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
      padding: 2.5rem 1rem;
      position: relative;
      overflow-x: hidden;
    }

    body::before {
      content: '';
      position: fixed; top: -25%; left: 50%; transform: translateX(-50%);
      width: 800px; height: 550px;
      background: radial-gradient(ellipse, rgba(79,124,255,0.11) 0%, transparent 70%);
      pointer-events: none; z-index: 0;
    }

    .brand {
      font-family: 'Syne', sans-serif; font-size: 0.75rem; font-weight: 700;
      letter-spacing: 0.25em; text-transform: uppercase; color: var(--muted);
      margin-bottom: 2.5rem; position: relative; z-index: 1;
    }
    .brand span { color: var(--accent); }

    /* Card */
    .card {
      position: relative; z-index: 1;
      background: var(--surface); border: 1px solid var(--border);
      border-radius: var(--radius); width: 100%; max-width: 580px;
      box-shadow: 0 24px 64px rgba(0,0,0,0.5), 0 0 0 1px rgba(255,255,255,0.03) inset;
      animation: slideUp 0.45s cubic-bezier(0.22,1,0.36,1) both;
      overflow: hidden; margin-bottom: 1.25rem;
    }

    @keyframes slideUp {
      from { opacity: 0; transform: translateY(28px); }
      to   { opacity: 1; transform: translateY(0); }
    }

    .card-header {
      padding: 1.75rem 2rem 1.5rem;
      border-bottom: 1px solid var(--border);
    }
    .card-label {
      font-size: 0.65rem; letter-spacing: 0.2em; text-transform: uppercase;
      color: var(--accent); font-weight: 500; margin-bottom: 0.4rem;
    }
    .card-title {
      font-family: 'Syne', sans-serif; font-size: 1.5rem; font-weight: 800; color: var(--text);
    }

    .card-body { padding: 2rem 2rem 1.5rem; }

    .field { margin-bottom: 1.25rem; }

    label {
      display: block; font-size: 0.68rem; letter-spacing: 0.12em;
      text-transform: uppercase; color: var(--muted); margin-bottom: 0.45rem;
    }

    input[type="text"], select {
      width: 100%; background: var(--bg); border: 1px solid var(--border);
      border-radius: 8px; padding: 0.8rem 1rem; color: var(--text);
      font-family: 'DM Mono', monospace; font-size: 0.88rem; outline: none;
      transition: border-color 0.2s, box-shadow 0.2s;
      appearance: none; -webkit-appearance: none;
    }
    input[type="text"]:focus, select:focus {
      border-color: var(--accent); box-shadow: 0 0 0 3px rgba(79,124,255,0.18);
    }
    input[type="text"]::placeholder { color: var(--muted); }

    /* Exam selector highlight */
    .exam-select-wrap {
      position: relative;
    }
    .exam-select-wrap::after {
      content: ''; position: absolute; right: 1rem; top: 50%;
      transform: translateY(-50%); width: 0; height: 0;
      border-left: 5px solid transparent; border-right: 5px solid transparent;
      border-top: 6px solid var(--muted); pointer-events: none;
    }
    .exam-select-wrap select {
      border-color: rgba(79,124,255,0.4);
      background: rgba(79,124,255,0.05);
    }
    .exam-select-wrap select:focus {
      border-color: var(--accent); box-shadow: 0 0 0 3px rgba(79,124,255,0.18);
    }
    select option { background: var(--surface2); color: var(--text); }

    /* Options grid */
    .options-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }

    /* Answer select */
    .select-wrap { position: relative; }
    .select-wrap::after {
      content: ''; position: absolute; right: 1rem; top: 50%;
      transform: translateY(-50%); width: 0; height: 0;
      border-left: 5px solid transparent; border-right: 5px solid transparent;
      border-top: 6px solid var(--muted); pointer-events: none;
    }

    .option-label-badge {
      display: inline-block; width: 22px; height: 22px; border-radius: 50%;
      background: rgba(79,124,255,0.15); border: 1px solid rgba(79,124,255,0.3);
      color: var(--accent); font-size: 0.65rem; font-weight: 600;
      text-align: center; line-height: 22px; margin-right: 0.4rem; flex-shrink: 0;
    }
    .label-row { display: flex; align-items: center; margin-bottom: 0.45rem; }
    .label-row label { margin-bottom: 0; }

    .divider { height: 1px; background: var(--border); margin: 1.5rem 0; }

    /* Buttons */
    .card-footer {
      padding: 1.25rem 2rem; border-top: 1px solid var(--border);
      background: var(--surface2); display: flex; gap: 0.75rem; flex-wrap: wrap;
    }
    .btn {
      font-family: 'DM Mono', monospace; font-size: 0.78rem; font-weight: 500;
      padding: 0.62rem 1.3rem; border: none; border-radius: 8px; cursor: pointer;
      letter-spacing: 0.05em;
      transition: transform 0.15s, filter 0.15s, border-color 0.15s, color 0.15s;
      display: inline-flex; align-items: center; gap: 0.4rem;
    }
    .btn:active { transform: scale(0.97); }
    .btn-primary {
      background: linear-gradient(135deg, var(--accent), var(--accent-g));
      color: #fff; box-shadow: 0 4px 18px rgba(79,124,255,0.3); flex: 1;
    }
    .btn-primary:hover { filter: brightness(1.12); }
    .btn-ghost { background: transparent; border: 1px solid var(--border); color: var(--muted); }
    .btn-ghost:hover { border-color: var(--text); color: var(--text); }

    /* Messages */
    .msg { margin: 0 2rem 1.5rem; padding: 0.75rem 1rem; border-radius: 8px; font-size: 0.82rem; }
    .msg.error   { background: rgba(255,79,106,0.1); border: 1px solid rgba(255,79,106,0.3); color: #ff7a8f; }
    .msg.success { background: rgba(45,202,114,0.1); border: 1px solid rgba(45,202,114,0.25); color: #5de89b; }

    footer { margin-top: 2rem; font-size: 0.7rem; color: var(--muted); letter-spacing: 0.05em; position: relative; z-index: 1; }
    .icon { width: 13px; height: 13px; fill: none; stroke: currentColor; stroke-width: 2; stroke-linecap: round; stroke-linejoin: round; }

    @media (max-width: 480px) {
      .options-grid { grid-template-columns: 1fr; }
      .card-header, .card-body, .card-footer { padding-left: 1.25rem; padding-right: 1.25rem; }
    }
  </style>
</head>
<body>

  <div class="brand">© <span>Examily</span> Admin Console</div>

  <%
    String msg2 = request.getParameter("msg2");
    String msg1 = request.getParameter("msg1");
    ArrayList<Exams> allExams = ExamsDao.getAllExams();
  %>

  <!-- AI Question Generator -->
  <div class="card">
    <div class="card-header">
      <p class="card-label">AI</p>
      <h1 class="card-title">AI Question Generator</h1>
    </div>
    <form action="UploadPDFServlet" method="post" enctype="multipart/form-data">
      <div class="card-body">
        <div class="field">
          <label for="pdfFile">Upload PDF (Admin)</label>
          <input type="file" id="pdfFile" name="pdfFile" accept="application/pdf" required
            style="width:100%;background:var(--bg);border:1px solid var(--border);border-radius:8px;padding:0.8rem 1rem;color:var(--text);">
        </div>
        <div class="divider"></div>
        <button type="submit" class="btn btn-primary" style="width:100%;justify-content:center;">
          Generate Questions
        </button>
      </div>
    </form>
  </div>

  <!-- Add Question -->
  <div class="card">
    <div class="card-header">
      <p class="card-label">Questions</p>
      <h1 class="card-title">Add New Question</h1>
    </div>

    <form action="oes.controller.QuestionInsert" method="get">
      <div class="card-body">

        <%-- ── EXAM SELECTOR (NEW) ─────────────────────────────────────── --%>
        <div class="field">
          <label for="examId">Add to Exam</label>
          <div class="exam-select-wrap">
            <select id="examId" name="examId" required>
              <% if (allExams.isEmpty()) { %>
                <option value="1">No exams found — using Default (1)</option>
              <% } else {
                   for (Exams ex : allExams) { %>
                <option value="<%= ex.getExamId() %>">
                  <%= ex.getExamName() %> (<%= ex.getDuration() %> min)
                </option>
              <% } } %>
            </select>
          </div>
        </div>
        <%-- ──────────────────────────────────────────────────────────────── --%>

        <div class="divider"></div>

        <!-- Question text -->
        <div class="field">
          <label for="Question">Question</label>
          <input type="text" id="Question" name="Question" placeholder="Type your question here…" autocomplete="off" autofocus>
        </div>

        <div class="divider"></div>

        <!-- Options A–D -->
        <div class="options-grid">
          <div class="field">
            <div class="label-row">
              <span class="option-label-badge">A</span>
              <label for="option1">Option A</label>
            </div>
            <input type="text" id="option1" name="option1" placeholder="Enter option A">
          </div>
          <div class="field">
            <div class="label-row">
              <span class="option-label-badge">B</span>
              <label for="option2">Option B</label>
            </div>
            <input type="text" id="option2" name="option2" placeholder="Enter option B">
          </div>
          <div class="field">
            <div class="label-row">
              <span class="option-label-badge">C</span>
              <label for="option3">Option C</label>
            </div>
            <input type="text" id="option3" name="option3" placeholder="Enter option C">
          </div>
          <div class="field">
            <div class="label-row">
              <span class="option-label-badge">D</span>
              <label for="option4">Option D</label>
            </div>
            <input type="text" id="option4" name="option4" placeholder="Enter option D">
          </div>
        </div>

        <div class="divider"></div>

        <!-- Correct Answer -->
        <div class="field">
          <label for="answer">Correct Answer</label>
          <div class="select-wrap">
            <select id="answer" name="answer">
              <option value="a">A — Option A</option>
              <option value="b">B — Option B</option>
              <option value="c">C — Option C</option>
              <option value="d">D — Option D</option>
            </select>
          </div>
        </div>

      </div>

      <% if (msg2 != null && !msg2.isEmpty()) { %>
        <div class="msg error">⚠ <%= msg2 %></div>
      <% } %>
      <% if (msg1 != null && !msg1.isEmpty()) { %>
        <div class="msg success">✓ <%= msg1 %></div>
      <% } %>

      <div class="card-footer">
        <button type="submit" class="btn btn-primary">
          <svg class="icon" viewBox="0 0 24 24"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
          Add Question
        </button>
        <button type="button" class="btn btn-ghost" onclick="location.href='QuestionList.jsp'">
          <svg class="icon" viewBox="0 0 24 24"><polyline points="15 18 9 12 15 6"/></svg>
          Back
        </button>
        <button type="button" class="btn btn-ghost" onclick="location.href='AdminPanel.jsp'">
          <svg class="icon" viewBox="0 0 24 24"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
          Home
        </button>
      </div>
    </form>
  </div>

  <footer>© 2026 Examily, Inc. All rights reserved.</footer>

</body>
</html>
