<%--
    Document   : StudentInstructions
    Modified   : Exam selector added ? student picks which exam before starting
--%>
<%@page import="oes.model.StudentsDao"%>
<%@page import="oes.model.ExamsDao"%>
<%@page import="oes.db.Exams"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@page import="oes.model.InstructionsDao"%>
<%@page import="oes.db.Instructions"%>
<%@page import="java.util.ArrayList"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Exam Instructions ? Examily</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --red: #C0392B; --red-dark: #96281B;
            --cream: #FAF8F4; --ink: #1A1A1A; --muted: #6B6B6B;
            --border: #E5E0D8; --white: #FFFFFF;
            --green: #1A7A4A; --shadow: 0 4px 32px rgba(0,0,0,0.07);
        }
        body { font-family: 'DM Sans', sans-serif; background: var(--cream); color: var(--ink); min-height: 100vh; display: flex; flex-direction: column; }
        nav { background: rgba(250,248,244,0.95); backdrop-filter: blur(12px); border-bottom: 1px solid var(--border); padding: 0 2rem; display: flex; align-items: center; height: 64px; gap: 1rem; position: sticky; top: 0; z-index: 50; }
        .nav-logo { display: flex; align-items: center; gap: 0.6rem; text-decoration: none; }
        .nav-logo-icon { width: 32px; height: 32px; background: var(--red); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-family: 'Playfair Display', serif; font-weight: 700; font-size: 0.85rem; }
        .nav-brand { font-family: 'Playfair Display', serif; font-size: 1.1rem; font-weight: 600; color: var(--ink); }
        .welcome-banner { background: linear-gradient(135deg, var(--red) 0%, #96281B 100%); padding: 2.5rem 2rem 2rem; position: relative; overflow: hidden; }
        .welcome-banner::before { content: ''; position: absolute; top: -50px; right: -50px; width: 220px; height: 220px; border-radius: 50%; background: rgba(255,255,255,0.06); pointer-events: none; }
        .welcome-inner { max-width: 780px; margin: 0 auto; position: relative; z-index: 1; }
        .welcome-badge { display: inline-flex; align-items: center; gap: 0.45rem; background: rgba(255,255,255,0.15); color: rgba(255,255,255,0.9); font-size: 0.72rem; font-weight: 500; letter-spacing: 0.1em; text-transform: uppercase; padding: 0.3rem 0.8rem; border-radius: 100px; margin-bottom: 0.85rem; }
        .welcome-badge::before { content: ''; width: 6px; height: 6px; border-radius: 50%; background: #7DFFB3; }
        .welcome-name { font-family: 'Playfair Display', serif; font-size: clamp(1.6rem, 3.5vw, 2.3rem); font-weight: 700; color: white; line-height: 1.2; }
        .welcome-sub { color: rgba(255,255,255,0.7); font-size: 0.9rem; font-weight: 300; margin-top: 0.4rem; }
        main { flex: 1; max-width: 780px; width: 100%; margin: 2.5rem auto; padding: 0 1.5rem; }
        .instructions-card { background: var(--white); border-radius: 16px; border: 1px solid var(--border); box-shadow: var(--shadow); overflow: hidden; animation: fadeUp 0.45s ease both; }
        .card-header { padding: 1.5rem 2rem; border-bottom: 1px solid var(--border); display: flex; align-items: center; gap: 0.85rem; }
        .card-header-icon { width: 40px; height: 40px; background: rgba(192,57,43,0.08); border-radius: 10px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
        .card-header-icon svg { color: var(--red); }
        .card-header-text h2 { font-family: 'Playfair Display', serif; font-size: 1.15rem; font-weight: 600; color: var(--ink); }
        .card-header-text p  { font-size: 0.8rem; color: var(--muted); margin-top: 0.1rem; }
        .instruction-list { padding: 0.5rem 0; }
        .instruction-item { display: flex; align-items: flex-start; gap: 1rem; padding: 1rem 2rem; border-bottom: 1px solid var(--border); transition: background 0.15s; animation: fadeUp 0.4s ease both; }
        .instruction-item:last-child { border-bottom: none; }
        .instruction-item:hover { background: var(--cream); }
        .instruction-num { min-width: 28px; height: 28px; background: rgba(192,57,43,0.08); color: var(--red); border-radius: 7px; display: flex; align-items: center; justify-content: center; font-size: 0.78rem; font-weight: 600; flex-shrink: 0; margin-top: 0.1rem; }
        .instruction-text { font-size: 0.92rem; color: var(--ink); line-height: 1.6; }

        /* EXAM SELECTOR */
        .exam-select-card { background: var(--white); border-radius: 16px; border: 1px solid var(--border); box-shadow: var(--shadow); padding: 1.4rem 2rem; margin-top: 1.25rem; animation: fadeUp 0.45s 0.05s ease both; }
        .exam-select-label { font-size: 0.75rem; font-weight: 600; letter-spacing: 0.08em; text-transform: uppercase; color: var(--muted); margin-bottom: 0.65rem; display: flex; align-items: center; gap: 0.5rem; }
        .exam-select-label::before { content: ''; display: inline-block; width: 8px; height: 8px; border-radius: 50%; background: var(--red); }
        select#examPicker { width: 100%; padding: 0.78rem 1rem; border: 1.5px solid var(--border); border-radius: 10px; background: var(--cream); color: var(--ink); font-family: 'DM Sans', sans-serif; font-size: 0.95rem; appearance: none; -webkit-appearance: none; outline: none; background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='8' viewBox='0 0 12 8'%3E%3Cpath d='M1 1l5 5 5-5' stroke='%236B6B6B' stroke-width='1.5' fill='none' stroke-linecap='round'/%3E%3C/svg%3E"); background-repeat: no-repeat; background-position: right 1rem center; cursor: pointer; transition: border-color 0.2s; }
        select#examPicker:focus { border-color: var(--red); box-shadow: 0 0 0 3px rgba(192,57,43,0.08); }

        .action-bar { background: var(--white); border-radius: 16px; border: 1px solid var(--border); box-shadow: var(--shadow); padding: 1.25rem 2rem; display: flex; align-items: center; justify-content: space-between; margin-top: 1.25rem; animation: fadeUp 0.45s 0.1s ease both; gap: 1rem; }
        .action-bar-note { font-size: 0.82rem; color: var(--muted); display: flex; align-items: center; gap: 0.5rem; }
        .action-bar-note svg { color: var(--green); flex-shrink: 0; }
        .action-btns { display: flex; gap: 0.75rem; flex-shrink: 0; }
        .btn { display: inline-flex; align-items: center; gap: 0.5rem; padding: 0.72rem 1.5rem; border-radius: 8px; font-family: 'DM Sans', sans-serif; font-size: 0.88rem; font-weight: 500; cursor: pointer; border: none; transition: all 0.2s; text-decoration: none; letter-spacing: 0.01em; }
        .btn-outline { background: transparent; border: 1.5px solid var(--border); color: var(--muted); }
        .btn-outline:hover { border-color: var(--red); color: var(--red); background: rgba(192,57,43,0.04); }
        .btn-primary { background: var(--red); color: white; }
        .btn-primary:hover { background: var(--red-dark); transform: translateY(-1px); box-shadow: 0 6px 24px rgba(192,57,43,0.25); }
        .btn-primary:active { transform: translateY(0); }
        .btn-primary svg, .btn-outline svg { transition: transform 0.2s; }
        .btn-primary:hover svg { transform: translateX(3px); }
        footer { border-top: 1px solid var(--border); padding: 1.25rem 2rem; text-align: center; font-size: 0.8rem; color: var(--muted); }
        @keyframes fadeUp { from { opacity: 0; transform: translateY(16px); } to { opacity: 1; transform: translateY(0); } }
        .welcome-inner { animation: fadeUp 0.4s ease both; }
        @media (max-width: 560px) { .action-bar { flex-direction: column; align-items: stretch; } .action-btns { justify-content: stretch; } .btn { justify-content: center; flex: 1; } .instruction-item { padding: 0.9rem 1.25rem; } .card-header { padding: 1.25rem; } }
    </style>
</head>
<body>

    <%
        String name = StudentsDao.getStudentName(session.getAttribute("username").toString());
        ArrayList<Exams> allExams = ExamsDao.getAllExams();
    %>

    <nav>
        <a href="#" class="nav-logo">
            <div class="nav-logo-icon">E</div>
            <span class="nav-brand">Examily</span>
        </a>
    </nav>

    <div class="welcome-banner">
        <div class="welcome-inner">
            <div class="welcome-badge">Logged in</div>
            <div class="welcome-name">Welcome, <%= name %>!</div>
            <div class="welcome-sub">Please read all instructions carefully before starting your exam.</div>
        </div>
    </div>

    <main>
        <!-- Instructions -->
        <div class="instructions-card">
            <div class="card-header">
                <div class="card-header-icon">
                    <svg width="18" height="18" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                    </svg>
                </div>
                <div class="card-header-text">
                    <h2>Instructions to Students</h2>
                    <p>Read each point thoroughly before proceeding</p>
                </div>
            </div>
            <div class="instruction-list">
                <%
                    int i = 1;
                    ArrayList<Instructions> allinsts = InstructionsDao.getAllRecords();
                    for (Instructions e : allinsts) {
                %>
                <div class="instruction-item" style="animation-delay: <%= (i * 0.05) %>s">
                    <div class="instruction-num"><%= i++ %></div>
                    <div class="instruction-text"><%= e.getInstruction() %></div>
                </div>
                <% } %>
            </div>
        </div>

        <!-- EXAM SELECTOR -->
        <div class="exam-select-card">
            <div class="exam-select-label">Select Your Exam</div>
            <select id="examPicker">
                <% if (allExams.isEmpty()) { %>
                    <option value="1">Default Exam</option>
                <% } else { for (Exams ex : allExams) { %>
                    <option value="<%= ex.getExamId() %>">
                        <%= ex.getExamName() %> &mdash; <%= ex.getDuration() %> min
                    </option>
                <% } } %>
            </select>
        </div>

        <!-- ACTION BAR -->
        <div class="action-bar">
            <div class="action-bar-note">
                <svg width="16" height="16" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                I have read and understood all instructions
            </div>
            <div class="action-btns">
                <button class="btn btn-outline" onclick="location.href='oes.controller.LogoutStudent'">
                    <svg width="15" height="15" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                    </svg>
                    Logout
                </button>
                <button class="btn btn-primary" onclick="startExam()">
                    Start Exam
                    <svg width="15" height="15" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M17 8l4 4m0 0l-4 4m4-4H3" />
                    </svg>
                </button>
            </div>
        </div>
    </main>

    <footer>&copy; 2026 Examily, Inc. All rights reserved.</footer>

    <script>
        function startExam() {
            var examId = document.getElementById('examPicker').value;
            location.href = 'StartExamServlet?examId=' + examId;
        }
    </script>
</body>
</html>
