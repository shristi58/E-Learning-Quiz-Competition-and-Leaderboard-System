<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Examily &mdash; Admin Panel</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:ital,wght@0,300;0,400;0,500;1,300&display=swap" rel="stylesheet">
<style>
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

  :root {
    --bg:      #0d0f14;
    --surface: #13161e;
    --border:  rgba(255,255,255,0.07);
    --accent:  #f0c040;
    --accent2: #e87c3e;
    --text:    #eef0f5;
    --muted:   #6b7280;
    --green:   #34d399;
    --blue:    #60a5fa;
    --red:     #f87171;
    --purple:  #a78bfa;
    --radius:  16px;
  }

  body {
    font-family: 'DM Sans', sans-serif;
    background: var(--bg);
    color: var(--text);
    min-height: 100vh;
    overflow-x: hidden;
  }

  body::before {
    content: '';
    position: fixed;
    top: -200px; left: -200px;
    width: 600px; height: 600px;
    background: radial-gradient(circle, rgba(240,192,64,0.07) 0%, transparent 70%);
    pointer-events: none; z-index: 0;
  }
  body::after {
    content: '';
    position: fixed;
    bottom: -200px; right: -200px;
    width: 700px; height: 700px;
    background: radial-gradient(circle, rgba(232,124,62,0.05) 0%, transparent 70%);
    pointer-events: none; z-index: 0;
  }

  /* HEADER */
  header {
    position: sticky; top: 0; z-index: 100;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 18px 40px;
    border-bottom: 1px solid var(--border);
    background: rgba(13,15,20,0.9);
    backdrop-filter: blur(14px);
  }
  .logo {
    font-family: 'Syne', sans-serif;
    font-weight: 800;
    font-size: 1.45rem;
    letter-spacing: -0.5px;
    color: var(--text);
  }
  .logo span { color: var(--accent); }
  .header-right { display: flex; align-items: center; gap: 14px; }
  .badge-admin {
    font-size: 0.68rem;
    font-weight: 600;
    letter-spacing: 1.8px;
    text-transform: uppercase;
    color: var(--accent);
    background: rgba(240,192,64,0.1);
    border: 1px solid rgba(240,192,64,0.22);
    padding: 4px 12px;
    border-radius: 999px;
  }
  .avatar {
    width: 40px; height: 40px;
    background: linear-gradient(135deg, var(--accent), var(--accent2));
    border-radius: 50%;
    display: flex; align-items: center; justify-content: center;
    font-family: 'Syne', sans-serif;
    font-weight: 800;
    font-size: 1rem;
    color: #000;
    flex-shrink: 0;
  }

  /* MAIN */
  main {
    position: relative; z-index: 1;
    max-width: 1080px;
    margin: 0 auto;
    padding: 56px 24px 80px;
  }

  /* WELCOME */
  .welcome-section {
    margin-bottom: 52px;
    animation: fadeUp 0.55s ease both;
  }
  .eyebrow {
    font-size: 0.72rem;
    font-weight: 600;
    letter-spacing: 2.5px;
    text-transform: uppercase;
    color: var(--accent);
    margin-bottom: 10px;
  }
  .welcome-section h1 {
    font-family: 'Syne', sans-serif;
    font-size: clamp(1.9rem, 4vw, 2.8rem);
    font-weight: 800;
    line-height: 1.1;
    margin-bottom: 10px;
  }
  .welcome-section h1 .username {
    background: linear-gradient(90deg, var(--accent) 0%, var(--accent2) 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
  }
  .welcome-section p {
    color: var(--muted);
    font-size: 0.95rem;
    font-weight: 300;
  }

  /* STATS */
  .stats-row {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 16px;
    margin-bottom: 52px;
    animation: fadeUp 0.55s 0.08s ease both;
  }
  .stat-card {
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    padding: 22px 24px;
    display: flex;
    flex-direction: column;
    gap: 8px;
    transition: border-color 0.2s, transform 0.2s;
  }
  .stat-card:hover { border-color: rgba(255,255,255,0.13); transform: translateY(-2px); }
  .stat-top { display: flex; align-items: center; gap: 8px; }
  .stat-dot { width: 8px; height: 8px; border-radius: 50%; flex-shrink: 0; }
  .stat-label {
    font-size: 0.72rem; font-weight: 500; letter-spacing: 1.2px;
    text-transform: uppercase; color: var(--muted);
  }
  .stat-value {
    font-family: 'Syne', sans-serif; font-size: 2rem; font-weight: 800;
    color: var(--text); line-height: 1;
  }
  .stat-sub { font-size: 0.78rem; color: var(--muted); font-weight: 300; }

  /* SECTION LABEL */
  .section-label {
    font-family: 'Syne', sans-serif; font-size: 0.72rem; font-weight: 700;
    letter-spacing: 2.5px; text-transform: uppercase; color: var(--muted); margin-bottom: 18px;
  }

  /* CARDS GRID */
  .cards-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
    gap: 18px;
    margin-bottom: 52px;
    animation: fadeUp 0.55s 0.16s ease both;
  }
  .nav-card {
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    padding: 26px;
    cursor: pointer;
    text-decoration: none;
    display: flex;
    flex-direction: column;
    gap: 14px;
    transition: transform 0.22s ease, border-color 0.22s ease, box-shadow 0.22s ease;
    position: relative;
    overflow: hidden;
  }
  .nav-card::after {
    content: ''; position: absolute; inset: 0; opacity: 0;
    transition: opacity 0.22s; border-radius: var(--radius);
  }
  .nav-card:hover { transform: translateY(-5px); box-shadow: 0 22px 44px rgba(0,0,0,0.35); }
  .nav-card:active { transform: translateY(-2px); }
  .nav-card:hover::after { opacity: 1; }

  .card-blue::after   { background: linear-gradient(135deg, rgba(96,165,250,0.06), transparent); }
  .card-green::after  { background: linear-gradient(135deg, rgba(52,211,153,0.06), transparent); }
  .card-amber::after  { background: linear-gradient(135deg, rgba(240,192,64,0.06), transparent); }
  .card-orange::after { background: linear-gradient(135deg, rgba(232,124,62,0.06), transparent); }
  .card-purple::after { background: linear-gradient(135deg, rgba(167,139,250,0.06), transparent); }

  .card-blue:hover   { border-color: rgba(96,165,250,0.35); }
  .card-green:hover  { border-color: rgba(52,211,153,0.35); }
  .card-amber:hover  { border-color: rgba(240,192,64,0.35); }
  .card-orange:hover { border-color: rgba(232,124,62,0.35); }
  .card-purple:hover { border-color: rgba(167,139,250,0.35); }

  .card-icon {
    width: 46px; height: 46px; border-radius: 12px;
    display: flex; align-items: center; justify-content: center; flex-shrink: 0;
  }
  .icon-blue   { background: rgba(96,165,250,0.12); }
  .icon-green  { background: rgba(52,211,153,0.12); }
  .icon-amber  { background: rgba(240,192,64,0.12); }
  .icon-orange { background: rgba(232,124,62,0.12); }
  .icon-purple { background: rgba(167,139,250,0.12); }

  .card-icon svg { width: 22px; height: 22px; fill: none; stroke-width: 1.8; stroke-linecap: round; stroke-linejoin: round; }
  .icon-blue   svg { stroke: var(--blue); }
  .icon-green  svg { stroke: var(--green); }
  .icon-amber  svg { stroke: var(--accent); }
  .icon-orange svg { stroke: var(--accent2); }
  .icon-purple svg { stroke: var(--purple); }

  .card-body { flex: 1; }
  .card-title { font-family: 'Syne', sans-serif; font-size: 1rem; font-weight: 700; color: var(--text); margin-bottom: 6px; }
  .card-desc  { font-size: 0.8rem; color: var(--muted); line-height: 1.55; font-weight: 300; }
  .card-footer {
    display: flex; align-items: center; justify-content: space-between;
    padding-top: 4px; border-top: 1px solid var(--border);
  }
  .card-action { font-size: 0.75rem; font-weight: 500; letter-spacing: 0.4px; }
  .card-blue .card-action   { color: var(--blue); }
  .card-green .card-action  { color: var(--green); }
  .card-amber .card-action  { color: var(--accent); }
  .card-orange .card-action { color: var(--accent2); }
  .card-purple .card-action { color: var(--purple); }
  .card-arrow { font-size: 1rem; color: var(--muted); transition: transform 0.2s; }
  .nav-card:hover .card-arrow { transform: translateX(4px); }

  /* LOGOUT */
  .bottom-row { display: flex; justify-content: center; animation: fadeUp 0.55s 0.24s ease both; }
  .logout-btn {
    display: inline-flex; align-items: center; gap: 10px;
    padding: 13px 36px;
    border: 1px solid rgba(248,113,113,0.22);
    border-radius: 12px;
    background: rgba(248,113,113,0.05);
    color: var(--red);
    font-family: 'DM Sans', sans-serif;
    font-size: 0.88rem; font-weight: 500;
    cursor: pointer; text-decoration: none;
    transition: all 0.22s ease;
  }
  .logout-btn svg { width: 16px; height: 16px; stroke: var(--red); fill: none; stroke-width: 2; stroke-linecap: round; stroke-linejoin: round; }
  .logout-btn:hover { background: rgba(248,113,113,0.1); border-color: rgba(248,113,113,0.45); transform: translateY(-2px); box-shadow: 0 8px 24px rgba(248,113,113,0.1); }

  footer {
    position: relative; z-index: 1;
    text-align: center; padding: 22px;
    border-top: 1px solid var(--border);
    color: var(--muted); font-size: 0.78rem; font-weight: 300; margin-top: 40px;
  }
  footer strong { color: var(--accent); font-weight: 600; }

  @keyframes fadeUp {
    from { opacity: 0; transform: translateY(18px); }
    to   { opacity: 1; transform: translateY(0); }
  }

  @media (max-width: 700px) {
    header { padding: 14px 18px; }
    main   { padding: 36px 16px 60px; }
    .stats-row  { grid-template-columns: 1fr; }
    .cards-grid { grid-template-columns: 1fr; }
    .welcome-section h1 { font-size: 1.8rem; }
  }
</style>
</head>
<body>

<%
if(session.getAttribute("username") == null) {
    String msg2 = "Please Login as Admin to Continue";
    response.sendRedirect("AdminLogin.jsp?msg2=" + msg2);
    return;
}
String adminUser = (String) session.getAttribute("username");
String initial = (adminUser != null && adminUser.length() > 0)
    ? String.valueOf(adminUser.charAt(0)).toUpperCase() : "A";
%>

<!-- HEADER -->
<header>
  <div class="logo">Exam<span>ily</span></div>
  <div class="header-right">
    <span class="badge-admin">Admin</span>
    <div class="avatar"><%= initial %></div>
  </div>
</header>

<!-- MAIN -->
<main>

  <!-- Welcome -->
  <div class="welcome-section">
    <div class="eyebrow">Dashboard</div>
    <h1>Welcome back, <span class="username"><%= adminUser %></span></h1>
    <p>Manage your exam portal from one place.</p>
  </div>

  <!-- Stats -->
  <div class="stats-row">
    <div class="stat-card">
      <div class="stat-top">
        <span class="stat-dot" style="background:var(--blue)"></span>
        <span class="stat-label">Students</span>
      </div>
      <div class="stat-value">&#8212;</div>
      <div class="stat-sub">Total registered</div>
    </div>
    <div class="stat-card">
      <div class="stat-top">
        <span class="stat-dot" style="background:var(--accent)"></span>
        <span class="stat-label">Questions</span>
      </div>
      <div class="stat-value">&#8212;</div>
      <div class="stat-sub">In question bank</div>
    </div>
    <div class="stat-card">
      <div class="stat-top">
        <span class="stat-dot" style="background:var(--accent2)"></span>
        <span class="stat-label">Leaderboard</span>
      </div>
      <div class="stat-value">&#8212;</div>
      <div class="stat-sub">Scores recorded</div>
    </div>
  </div>

  <!-- Nav Cards -->
  <p class="section-label">Quick Actions</p>
  <div class="cards-grid">

    <!-- Students -->
    <a href="StudentList.jsp" class="nav-card card-blue">
      <div class="card-icon icon-blue">
        <svg viewBox="0 0 24 24">
          <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
          <circle cx="9" cy="7" r="4"/>
          <path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
          <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
        </svg>
      </div>
      <div class="card-body">
        <div class="card-title">Manage Students</div>
        <div class="card-desc">View, add, edit and remove registered students from the system.</div>
      </div>
      <div class="card-footer">
        <span class="card-action">Open list</span>
        <span class="card-arrow">&#8594;</span>
      </div>
    </a>

    <!-- Instructions -->
    <a href="InstructionList.jsp" class="nav-card card-green">
      <div class="card-icon icon-green">
        <svg viewBox="0 0 24 24">
          <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
          <polyline points="14 2 14 8 20 8"/>
          <line x1="16" y1="13" x2="8" y2="13"/>
          <line x1="16" y1="17" x2="8" y2="17"/>
          <polyline points="10 9 9 9 8 9"/>
        </svg>
      </div>
      <div class="card-body">
        <div class="card-title">Manage Instructions</div>
        <div class="card-desc">Edit exam rules and instructions shown to students before the test.</div>
      </div>
      <div class="card-footer">
        <span class="card-action">Edit instructions</span>
        <span class="card-arrow">&#8594;</span>
      </div>
    </a>

    <!-- Questions -->
    <a href="QuestionList.jsp" class="nav-card card-amber">
      <div class="card-icon icon-amber">
        <svg viewBox="0 0 24 24">
          <circle cx="12" cy="12" r="10"/>
          <path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"/>
          <line x1="12" y1="17" x2="12.01" y2="17"/>
        </svg>
      </div>
      <div class="card-body">
        <div class="card-title">Manage Questions</div>
        <div class="card-desc">Create, update, and organise the question bank for exams.</div>
      </div>
      <div class="card-footer">
        <span class="card-action">View questions</span>
        <span class="card-arrow">&#8594;</span>
      </div>
    </a>

    <!-- Leaderboard -->
    <a href="Leaderboard.jsp" class="nav-card card-orange">
      <div class="card-icon icon-orange">
        <svg viewBox="0 0 24 24">
          <polyline points="18 20 18 10"/>
          <polyline points="12 20 12 4"/>
          <polyline points="6 20 6 14"/>
        </svg>
      </div>
      <div class="card-body">
        <div class="card-title">View Leaderboard</div>
        <div class="card-desc">Check student rankings and exam performance at a glance.</div>
      </div>
      <div class="card-footer">
        <span class="card-action">See rankings</span>
        <span class="card-arrow">&#8594;</span>
      </div>
    </a>

    <!-- ── NEW: Manage Exams (Timer) ── -->
    <a href="ManageExam.jsp" class="nav-card card-purple">
      <div class="card-icon icon-purple">
        <svg viewBox="0 0 24 24">
          <circle cx="12" cy="12" r="10"/>
          <polyline points="12 6 12 12 16 14"/>
        </svg>
      </div>
      <div class="card-body">
        <div class="card-title">Manage Exams</div>
        <div class="card-desc">Create exams and set their timer duration in minutes.</div>
      </div>
      <div class="card-footer">
        <span class="card-action">Set timers</span>
        <span class="card-arrow">&#8594;</span>
      </div>
    </a>

  </div>

  <!-- Logout -->
  <div class="bottom-row">
    <a href="oes.controller.LogoutAdmin" class="logout-btn">
      <svg viewBox="0 0 24 24">
        <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
        <polyline points="16 17 21 12 16 7"/>
        <line x1="21" y1="12" x2="9" y2="12"/>
      </svg>
      Sign Out
    </a>
  </div>

</main>

<!-- FOOTER -->
<footer>
  &copy; 2026 <strong>Examily</strong> &nbsp;&middot;&nbsp; Developed by Samrat
</footer>

</body>
</html>
