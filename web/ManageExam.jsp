<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="oes.model.ExamsDao" %>
<%@ page import="oes.db.Exams" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Manage Exams — Examily</title>
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Mono:wght@300;400;500&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    :root {
      --bg: #0d0f14; --surface: #161a23; --surface2: #1c2130;
      --border: #252b3b; --accent: #4f7cff; --accent-g: #7c5cff;
      --success: #2dca72; --danger: #ff4f6a; --text: #e8eaf2; --muted: #6b7390; --radius: 14px;
    }
    body {
      font-family: 'DM Mono', monospace; background: var(--bg); color: var(--text);
      min-height: 100vh; padding: 2.5rem 1rem;
    }
    .brand {
      font-family: 'Syne', sans-serif; font-size: 0.75rem; font-weight: 700;
      letter-spacing: 0.25em; text-transform: uppercase; color: var(--muted);
      margin-bottom: 2rem; text-align: center;
    }
    .brand span { color: var(--accent); }
    .container { max-width: 620px; margin: 0 auto; }

    /* Card */
    .card {
      background: var(--surface); border: 1px solid var(--border);
      border-radius: var(--radius); overflow: hidden;
      box-shadow: 0 24px 64px rgba(0,0,0,0.5);
      margin-bottom: 1.5rem;
      animation: slideUp 0.4s cubic-bezier(0.22,1,0.36,1) both;
    }
    @keyframes slideUp { from { opacity:0; transform:translateY(20px); } to { opacity:1; transform:translateY(0); } }
    .card-header { padding: 1.5rem 2rem; border-bottom: 1px solid var(--border); }
    .card-label { font-size: 0.65rem; letter-spacing: 0.2em; text-transform: uppercase; color: var(--accent); margin-bottom: 0.3rem; }
    .card-title { font-family: 'Syne', sans-serif; font-size: 1.4rem; font-weight: 800; }
    .card-body { padding: 1.75rem 2rem; }
    .card-footer {
      padding: 1.25rem 2rem; border-top: 1px solid var(--border);
      background: var(--surface2); display: flex; gap: 0.75rem; flex-wrap: wrap;
    }

    /* Fields */
    .field { margin-bottom: 1.25rem; }
    label { display: block; font-size: 0.68rem; letter-spacing: 0.12em; text-transform: uppercase; color: var(--muted); margin-bottom: 0.45rem; }
    input[type="text"], input[type="number"] {
      width: 100%; background: var(--bg); border: 1px solid var(--border);
      border-radius: 8px; padding: 0.8rem 1rem; color: var(--text);
      font-family: 'DM Mono', monospace; font-size: 0.88rem; outline: none;
      transition: border-color 0.2s, box-shadow 0.2s;
    }
    input:focus { border-color: var(--accent); box-shadow: 0 0 0 3px rgba(79,124,255,0.18); }
    input::placeholder { color: var(--muted); }

    /* Buttons */
    .btn {
      font-family: 'DM Mono', monospace; font-size: 0.78rem; font-weight: 500;
      padding: 0.62rem 1.3rem; border: none; border-radius: 8px; cursor: pointer;
      letter-spacing: 0.05em; transition: transform 0.15s, filter 0.15s, border-color 0.15s, color 0.15s;
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
    .msg { margin-bottom: 1.25rem; padding: 0.75rem 1rem; border-radius: 8px; font-size: 0.82rem; }
    .msg.error   { background: rgba(255,79,106,0.1); border: 1px solid rgba(255,79,106,0.3); color: #ff7a8f; }
    .msg.success { background: rgba(45,202,114,0.1); border: 1px solid rgba(45,202,114,0.25); color: #5de89b; }

    /* Exam table */
    .exam-table { width: 100%; border-collapse: collapse; font-size: 0.82rem; }
    .exam-table th {
      text-align: left; padding: 0.75rem 1rem; font-size: 0.65rem;
      letter-spacing: 0.15em; text-transform: uppercase; color: var(--muted);
      border-bottom: 1px solid var(--border);
    }
    .exam-table td { padding: 0.85rem 1rem; border-bottom: 1px solid var(--border); color: var(--text); }
    .exam-table tr:last-child td { border-bottom: none; }
    .exam-table tr:hover td { background: var(--surface2); }
    .duration-badge {
      display: inline-block; padding: 3px 10px; border-radius: 20px;
      font-size: 0.72rem; font-weight: 600;
      background: rgba(79,124,255,0.12); border: 1px solid rgba(79,124,255,0.25); color: var(--accent);
    }
  </style>
</head>
<body>
<%
  if (session.getAttribute("username") == null) {
      response.sendRedirect("AdminLogin.jsp");
      return;
  }
  String msg1 = request.getParameter("msg1");
  String msg2 = request.getParameter("msg2");
  ArrayList<Exams> allExams = ExamsDao.getAllExams();
%>

<div class="brand">© <span>Examily</span> Admin Console</div>

<div class="container">

  <% if (msg2 != null && !msg2.isEmpty()) { %>
    <div class="msg error">⚠ <%= msg2 %></div>
  <% } %>
  <% if (msg1 != null && !msg1.isEmpty()) { %>
    <div class="msg success">✓ <%= msg1 %></div>
  <% } %>

  <!-- CREATE EXAM CARD -->
  <div class="card">
    <div class="card-header">
      <p class="card-label">Exams</p>
      <h1 class="card-title">Create New Exam</h1>
    </div>
    <form action="ExamInsertServlet" method="post">
      <div class="card-body">
        <div class="field">
          <label for="examName">Exam Name</label>
          <input type="text" id="examName" name="examName" placeholder="e.g. Unit Test 1 — Java" required autocomplete="off">
        </div>
        <div class="field">
          <label for="duration">Duration (minutes)</label>
          <input type="number" id="duration" name="duration" placeholder="e.g. 30" min="1" max="300" required>
        </div>
      </div>
      <div class="card-footer">
        <button type="submit" class="btn btn-primary">+ Create Exam</button>
        <button type="button" class="btn btn-ghost" onclick="location.href='AdminPanel.jsp'">← Back</button>
      </div>
    </form>
  </div>

  <!-- EXISTING EXAMS LIST -->
  <% if (!allExams.isEmpty()) { %>
  <div class="card">
    <div class="card-header">
      <p class="card-label">Existing</p>
      <h1 class="card-title">All Exams</h1>
    </div>
    <div style="padding: 0 1rem;">
      <table class="exam-table">
        <thead>
          <tr>
            <th>#</th>
            <th>Exam Name</th>
            <th>Duration</th>
            <th>Start Link</th>
          </tr>
        </thead>
        <tbody>
          <% for (Exams ex : allExams) { %>
          <tr>
            <td><%= ex.getExamId() %></td>
            <td><%= ex.getExamName() %></td>
            <td><span class="duration-badge"><%= ex.getDuration() %> min</span></td>
            <td>
              <a href="StartExamServlet?examId=<%= ex.getExamId() %>"
                 style="color: var(--accent); text-decoration: none; font-size: 0.78rem;">
                Start →
              </a>
            </td>
          </tr>
          <% } %>
        </tbody>
      </table>
    </div>
  </div>
  <% } %>

</div>
</body>
</html>
