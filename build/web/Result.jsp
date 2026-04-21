<%-- 
    Document   : Result
    Created on : 8 april 2026, 15:42:48
    Author     : Samrat
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page import="oes.model.QuestionsDao"%>
<%@page import="oes.db.*"%>
<%@page import="java.util.ArrayList"%>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Results ? Examily</title>
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Mono:wght@300;400;500&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    :root {
      --bg:        #0b0e14;
      --surface:   #13171f;
      --surface2:  #1a1f2b;
      --border:    rgba(255,255,255,0.07);
      --accent:    #00e5a0;
      --accent2:   #ff4d6d;
      --accent3:   #ffd166;
      --text:      #e8eaf0;
      --muted:     #6b7385;
      --radius:    16px;
    }

    html, body {
      min-height: 100%;
      background: var(--bg);
      color: var(--text);
      font-family: 'DM Mono', monospace;
    }

    /* ?? NOISE OVERLAY ??????????????????????????????? */
    body::before {
      content: '';
      position: fixed; inset: 0; z-index: 0; pointer-events: none;
      background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.04'/%3E%3C/svg%3E");
      background-size: 200px;
      opacity: 0.6;
    }

    /* ?? GLOW BLOBS ??????????????????????????????????? */
    .blob {
      position: fixed; border-radius: 50%; filter: blur(100px);
      pointer-events: none; z-index: 0;
    }
    .blob-green  { width: 500px; height: 500px; background: rgba(0,229,160,0.08); top: -150px; right: -100px; }
    .blob-pink   { width: 400px; height: 400px; background: rgba(255,77,109,0.06); bottom: -100px; left: -80px; }

    /* ?? LAYOUT ??????????????????????????????????????? */
    .page {
      position: relative; z-index: 1;
      min-height: 100vh;
      display: flex; flex-direction: column; align-items: center;
      padding: 48px 20px 80px;
    }

    /* ?? HEADER ??????????????????????????????????????? */
    .header {
      width: 100%; max-width: 700px;
      display: flex; align-items: center; justify-content: space-between;
      margin-bottom: 52px;
      opacity: 0; animation: fadeUp 0.6s 0.1s ease forwards;
    }
    .logo {
      font-family: 'Syne', sans-serif;
      font-size: 1.25rem; font-weight: 800;
      letter-spacing: -0.02em;
      color: var(--accent);
    }
    .logo span { color: var(--text); }
    .badge {
      font-size: 0.68rem; font-weight: 500;
      letter-spacing: 0.12em; text-transform: uppercase;
      padding: 5px 12px; border-radius: 20px;
      border: 1px solid var(--border);
      color: var(--muted);
      background: var(--surface);
    }

    /* ?? HERO SCORE ??????????????????????????????????? */
    .hero {
      width: 100%; max-width: 700px;
      text-align: center;
      margin-bottom: 48px;
      opacity: 0; animation: fadeUp 0.6s 0.25s ease forwards;
    }
    .hero-label {
      font-size: 0.7rem; letter-spacing: 0.18em; text-transform: uppercase;
      color: var(--muted); margin-bottom: 16px;
    }
    .hero-score {
      font-family: 'Syne', sans-serif;
      font-size: clamp(5rem, 15vw, 9rem);
      font-weight: 800; line-height: 1;
      letter-spacing: -0.04em;
      background: linear-gradient(135deg, var(--accent), #00b4d8);
      -webkit-background-clip: text; -webkit-text-fill-color: transparent;
      background-clip: text;
    }
    .hero-sub {
      font-size: 0.78rem; color: var(--muted); margin-top: 10px; letter-spacing: 0.05em;
    }

    /* ?? IDENTITY CARD ???????????????????????????????? */
    .id-card {
      width: 100%; max-width: 700px;
      background: var(--surface);
      border: 1px solid var(--border);
      border-radius: var(--radius);
      padding: 20px 28px;
      display: flex; gap: 32px; flex-wrap: wrap;
      margin-bottom: 28px;
      opacity: 0; animation: fadeUp 0.6s 0.4s ease forwards;
    }
    .id-field { display: flex; flex-direction: column; gap: 4px; }
    .id-key   { font-size: 0.62rem; letter-spacing: 0.14em; text-transform: uppercase; color: var(--muted); }
    .id-val   { font-size: 0.95rem; font-weight: 500; color: var(--text); }

    /* ?? STAT GRID ???????????????????????????????????? */
    .stats {
      width: 100%; max-width: 700px;
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 16px;
      margin-bottom: 28px;
    }
    .stat-card {
      background: var(--surface);
      border: 1px solid var(--border);
      border-radius: var(--radius);
      padding: 24px;
      position: relative; overflow: hidden;
      opacity: 0; animation: fadeUp 0.6s ease forwards;
    }
    .stat-card:nth-child(1) { animation-delay: 0.5s; }
    .stat-card:nth-child(2) { animation-delay: 0.6s; }
    .stat-card:nth-child(3) { animation-delay: 0.7s; }
    .stat-card:nth-child(4) { animation-delay: 0.8s; }

    .stat-card::before {
      content: '';
      position: absolute; top: 0; left: 0; right: 0; height: 2px;
      border-radius: var(--radius) var(--radius) 0 0;
    }
    .stat-card.total::before   { background: linear-gradient(90deg, #4361ee, #7209b7); }
    .stat-card.attempted::before { background: linear-gradient(90deg, var(--accent3), #f77f00); }
    .stat-card.correct::before { background: linear-gradient(90deg, var(--accent), #06d6a0); }
    .stat-card.wrong::before   { background: linear-gradient(90deg, var(--accent2), #f72585); }

    .stat-icon {
      font-size: 1.3rem; margin-bottom: 14px; display: block;
    }
    .stat-label {
      font-size: 0.65rem; letter-spacing: 0.14em; text-transform: uppercase;
      color: var(--muted); margin-bottom: 10px;
    }
    .stat-value {
      font-family: 'Syne', sans-serif;
      font-size: 2.6rem; font-weight: 800;
      line-height: 1; letter-spacing: -0.03em;
    }
    .stat-card.total   .stat-value { color: #7b8cde; }
    .stat-card.attempted .stat-value { color: var(--accent3); }
    .stat-card.correct .stat-value { color: var(--accent); }
    .stat-card.wrong   .stat-value { color: var(--accent2); }

    /* ?? PROGRESS BAR ????????????????????????????????? */
    .progress-section {
      width: 100%; max-width: 700px;
      background: var(--surface);
      border: 1px solid var(--border);
      border-radius: var(--radius);
      padding: 24px 28px;
      margin-bottom: 36px;
      opacity: 0; animation: fadeUp 0.6s 0.9s ease forwards;
    }
    .progress-header {
      display: flex; justify-content: space-between; align-items: center;
      margin-bottom: 16px;
    }
    .progress-title {
      font-size: 0.65rem; letter-spacing: 0.14em; text-transform: uppercase; color: var(--muted);
    }
    .progress-pct {
      font-family: 'Syne', sans-serif; font-size: 0.9rem; font-weight: 700; color: var(--accent);
    }
    .track {
      height: 8px; background: var(--surface2); border-radius: 99px; overflow: hidden;
      margin-bottom: 14px;
    }
    .fill {
      height: 100%; border-radius: 99px;
      background: linear-gradient(90deg, var(--accent), #00b4d8);
      width: 0; transition: width 1.4s cubic-bezier(.16,1,.3,1);
    }
    .fill.wrong-fill {
      background: linear-gradient(90deg, var(--accent2), #f72585);
    }
    .legend {
      display: flex; gap: 20px;
    }
    .legend-item {
      display: flex; align-items: center; gap: 7px;
      font-size: 0.68rem; color: var(--muted);
    }
    .dot {
      width: 8px; height: 8px; border-radius: 50%;
    }
    .dot.green  { background: var(--accent); }
    .dot.red    { background: var(--accent2); }
    .dot.yellow { background: var(--accent3); }

    /* ?? EXIT BUTTON ??????????????????????????????????? */
    .cta-wrap {
      opacity: 0; animation: fadeUp 0.6s 1s ease forwards;
    }
    .btn-exit {
      font-family: 'Syne', sans-serif;
      font-size: 0.85rem; font-weight: 700;
      letter-spacing: 0.06em; text-transform: uppercase;
      color: var(--bg);
      background: var(--accent2);
      border: none; border-radius: 10px;
      padding: 14px 44px;
      cursor: pointer;
      transition: transform 0.2s ease, box-shadow 0.2s ease, background 0.2s;
      box-shadow: 0 0 0 0 rgba(255,77,109,0.5);
    }
    .btn-exit:hover {
      background: #ff6b86;
      transform: translateY(-2px);
      box-shadow: 0 8px 30px rgba(255,77,109,0.35);
    }
    .btn-exit:active { transform: translateY(0); }

    /* ?? FOOTER ??????????????????????????????????????? */
    footer {
      position: absolute; bottom: 24px;
      font-size: 0.65rem; color: var(--muted); letter-spacing: 0.08em;
    }

    /* ?? ANIMATIONS ??????????????????????????????????? */
    @keyframes fadeUp {
      from { opacity: 0; transform: translateY(22px); }
      to   { opacity: 1; transform: translateY(0); }
    }
  </style>
</head>
<body>

<%
  String[] dbans = new String[100];
  ArrayList<Questions> allQuestions = QuestionsDao.getAllRecords();
  int i = 0;
  int size = allQuestions.size();
  for (Questions e : allQuestions) {
    dbans[i] = e.getAnswer();
    i++;
  }
  String[] userans = new String[100];
  for (int j = 0; j < size; j++) {
    userans[j] = request.getParameter(Integer.toString(j));
  }
  int correctanswer = 0;
  int unattempted   = 0;
  int wronganswer   = 0;
  for (int k = 0; k < size; k++) {
    if (userans[k].equalsIgnoreCase(dbans[k])) {
      correctanswer++;
    } else if (userans[k].equals("e")) {
      unattempted++;
    } else {
      wronganswer++;
    }
  }
  int attempted = size - unattempted;
  int scorePct  = (size > 0) ? Math.round((float) correctanswer / size * 100) : 0;
  int correctPct = (attempted > 0) ? Math.round((float) correctanswer / attempted * 100) : 0;
  int wrongPct   = (attempted > 0) ? Math.round((float) (attempted - correctanswer) / attempted * 100) : 0;
%>

<div class="blob blob-green"></div>
<div class="blob blob-pink"></div>

<div class="page">

  <!-- Header -->
  <header class="header">
    <div class="logo">exam<span>ily</span></div>
    <div class="badge">Score Report</div>
  </header>

  <!-- Hero score -->
  <section class="hero">
    <p class="hero-label">Overall Score</p>
    <div class="hero-score" id="scoreDisplay">0%</div>
    <p class="hero-sub">Based on <%=size%> questions</p>
  </section>

  <!-- Identity -->
  <div class="id-card">
    <div class="id-field">
      <span class="id-key">Name</span>
      <span class="id-val"><%=session.getAttribute("name")%></span>
    </div>
    <div class="id-field">
      <span class="id-key">User ID</span>
      <span class="id-val"><%=session.getAttribute("username")%></span>
    </div>
    <div class="id-field">
      <span class="id-key">Status</span>
      <span class="id-val" style="color:<%=scorePct >= 50 ? "var(--accent)" : "var(--accent2)"%>">
        <%=scorePct >= 50 ? "? Passed" : "? Failed"%>
      </span>
    </div>
  </div>

  <!-- Stat cards -->
  <div class="stats">
    <div class="stat-card total">
      <span class="stat-icon">?</span>
      <div class="stat-label">Total Questions</div>
      <div class="stat-value"><%=size%></div>
    </div>
    <div class="stat-card attempted">
      <span class="stat-icon">??</span>
      <div class="stat-label">Attempted</div>
      <div class="stat-value"><%=attempted%></div>
    </div>
    <div class="stat-card correct">
      <span class="stat-icon">?</span>
      <div class="stat-label">Correct</div>
      <div class="stat-value"><%=correctanswer%></div>
    </div>
    <div class="stat-card wrong">
      <span class="stat-icon">?</span>
      <div class="stat-label">Wrong</div>
      <div class="stat-value"><%=attempted - correctanswer%></div>
    </div>
  </div>

  <!-- Progress bars -->
  <div class="progress-section">
    <div class="progress-header">
      <span class="progress-title">Correct Answers</span>
      <span class="progress-pct"><%=correctPct%>%</span>
    </div>
    <div class="track">
      <div class="fill" id="correctBar" data-width="<%=correctPct%>"></div>
    </div>

    <div class="progress-header" style="margin-top:16px;">
      <span class="progress-title">Wrong Answers</span>
      <span class="progress-pct" style="color:var(--accent2)"><%=wrongPct%>%</span>
    </div>
    <div class="track">
      <div class="fill wrong-fill" id="wrongBar" data-width="<%=wrongPct%>"></div>
    </div>

    <div class="legend" style="margin-top:18px;">
      <div class="legend-item"><div class="dot green"></div> Correct</div>
      <div class="legend-item"><div class="dot red"></div> Wrong</div>
      <div class="legend-item"><div class="dot yellow"></div> Unattempted (<%=unattempted%>)</div>
    </div>
  </div>

  <!-- Exit -->
  <div class="cta-wrap">
    <button class="btn-exit" onclick="location.href='oes.controller.LogoutStudent'">
      Exit Exam
    </button>
  </div>

  <footer>© 2022 Examily, Inc.</footer>
</div>

<script>
  /* ?? Animate score counter ?? */
  const target = <%=scorePct%>;
  const el = document.getElementById('scoreDisplay');
  let current = 0;
  const step = () => {
    current = Math.min(current + Math.ceil((target - current) / 8 + 0.5), target);
    el.textContent = current + '%';
    if (current < target) requestAnimationFrame(step);
  };
  setTimeout(() => requestAnimationFrame(step), 600);

  /* ?? Animate progress bars ?? */
  window.addEventListener('load', () => {
    setTimeout(() => {
      document.getElementById('correctBar').style.width = <%=correctPct%> + '%';
      document.getElementById('wrongBar').style.width   = <%=wrongPct%>   + '%';
    }, 1000);
  });
</script>
</body>
</html>
