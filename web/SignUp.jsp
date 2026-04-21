<%-- 
    Document   : SignUp Page
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Examily — Create Account</title>
  <link href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">

  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    :root {
      --bg: #0d0f14;
      --surface: #151820;
      --surface2: #1c2030;
      --border: #252a3a;
      --accent: #4f8ef7;
      --accent2: #7c5cfc;
      --text: #e8eaf2;
      --muted: #7880a0;
      --success: #34d399;
      --danger: #f87171;
      --radius: 14px;
      --font: 'Sora', sans-serif;
      --mono: 'JetBrains Mono', monospace;
    }

    body {
      font-family: var(--font);
      background: var(--bg);
      color: var(--text);
      min-height: 100vh;
      display: flex;
      flex-direction: column;
    }

    /* ── NAVBAR ── */
    nav {
      position: sticky;
      top: 0;
      z-index: 100;
      height: 64px;
      background: rgba(13,15,20,0.88);
      backdrop-filter: blur(16px);
      border-bottom: 1px solid var(--border);
      display: flex;
      align-items: center;
      padding: 0 32px;
      justify-content: space-between;
    }

    .nav-brand {
      display: flex;
      align-items: center;
      gap: 10px;
      font-weight: 700;
      font-size: 1.1rem;
      letter-spacing: -0.02em;
      color: var(--text);
      text-decoration: none;
    }

    .brand-dot {
      width: 10px; height: 10px;
      border-radius: 50%;
      background: linear-gradient(135deg, var(--accent), var(--accent2));
      box-shadow: 0 0 10px var(--accent);
    }

    .nav-links {
      display: flex;
      align-items: center;
      gap: 8px;
      list-style: none;
    }

    .nav-links a {
      text-decoration: none;
      color: var(--muted);
      font-size: 0.87rem;
      font-weight: 500;
      padding: 7px 14px;
      border-radius: 8px;
      transition: color 0.2s, background 0.2s;
    }

    .nav-links a:hover, .nav-links a.active {
      color: var(--text);
      background: var(--surface2);
    }

    /* ── MAIN LAYOUT ── */
    .page-body {
      flex: 1;
      display: grid;
      grid-template-columns: 1fr 1fr;
      min-height: calc(100vh - 64px - 56px);
    }

    @media (max-width: 768px) {
      .page-body { grid-template-columns: 1fr; }
      .hero-panel { display: none; }
    }

    /* ── FORM PANEL ── */
    .form-panel {
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 60px 48px;
    }

    .form-inner {
      width: 100%;
      max-width: 400px;
    }

    .eyebrow {
      font-family: var(--mono);
      font-size: 0.72rem;
      font-weight: 500;
      letter-spacing: 0.12em;
      text-transform: uppercase;
      color: var(--accent);
      margin-bottom: 14px;
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .eyebrow::before {
      content: '';
      display: block;
      width: 20px; height: 2px;
      background: var(--accent);
      border-radius: 2px;
    }

    .form-heading {
      font-size: 2rem;
      font-weight: 700;
      letter-spacing: -0.04em;
      line-height: 1.15;
      margin-bottom: 8px;
    }

    .form-heading span { color: var(--accent); }

    .form-subtext {
      font-size: 0.83rem;
      color: var(--muted);
      margin-bottom: 36px;
    }

    .form-subtext a {
      color: var(--accent);
      text-decoration: none;
      font-weight: 500;
    }

    .form-subtext a:hover { text-decoration: underline; }

    /* ── INPUT FIELDS ── */
    .field-row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 12px;
      margin-bottom: 14px;
    }

    .field {
      position: relative;
      margin-bottom: 14px;
    }

    .field-row .field { margin-bottom: 0; }

    .field label {
      display: block;
      font-size: 0.75rem;
      font-weight: 600;
      color: var(--muted);
      letter-spacing: 0.04em;
      text-transform: uppercase;
      margin-bottom: 7px;
    }

    .field-wrap {
      position: relative;
    }

    .field input {
      width: 100%;
      background: var(--surface2);
      border: 1.5px solid var(--border);
      border-radius: 10px;
      padding: 12px 42px 12px 14px;
      color: var(--text);
      font-family: var(--font);
      font-size: 0.9rem;
      outline: none;
      transition: border-color 0.2s, box-shadow 0.2s, background 0.2s;
    }

    .field input::placeholder { color: var(--muted); }

    .field input:focus {
      border-color: var(--accent);
      background: rgba(79,142,247,0.05);
      box-shadow: 0 0 0 3px rgba(79,142,247,0.12);
    }

    .field-icon {
      position: absolute;
      right: 13px;
      top: 50%;
      transform: translateY(-50%);
      color: var(--muted);
      pointer-events: none;
      transition: color 0.2s;
    }

    .field input:focus ~ .field-icon { color: var(--accent); }

    .toggle-pw {
      pointer-events: all;
      cursor: pointer;
    }

    /* Password strength bar */
    .pw-strength {
      margin-top: 7px;
      display: flex;
      gap: 4px;
    }

    .pw-bar {
      flex: 1;
      height: 3px;
      border-radius: 99px;
      background: var(--border);
      transition: background 0.3s;
    }

    /* ── SUBMIT BUTTON ── */
    .btn-signup {
      width: 100%;
      background: linear-gradient(135deg, var(--accent), var(--accent2));
      color: #fff;
      font-family: var(--font);
      font-size: 0.95rem;
      font-weight: 600;
      border: none;
      border-radius: 10px;
      padding: 13px;
      margin-top: 8px;
      cursor: pointer;
      transition: opacity 0.2s, transform 0.15s, box-shadow 0.2s;
      box-shadow: 0 4px 20px rgba(79,142,247,0.35);
      letter-spacing: -0.01em;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
    }

    .btn-signup:hover {
      opacity: 0.92;
      transform: translateY(-2px);
      box-shadow: 0 8px 28px rgba(79,142,247,0.45);
    }

    .btn-signup:active { transform: translateY(0); }

    /* ── DIVIDER ── */
    .divider {
      display: flex;
      align-items: center;
      gap: 12px;
      margin: 20px 0;
      color: var(--muted);
      font-size: 0.75rem;
      font-family: var(--mono);
    }

    .divider::before, .divider::after {
      content: '';
      flex: 1;
      height: 1px;
      background: var(--border);
    }

    /* ── HERO PANEL ── */
    .hero-panel {
      position: relative;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      overflow: hidden;
      background: var(--surface);
      border-left: 1px solid var(--border);
      padding: 60px 40px;
    }

    .hero-grid {
      position: absolute;
      inset: 0;
      background-image:
        linear-gradient(var(--border) 1px, transparent 1px),
        linear-gradient(90deg, var(--border) 1px, transparent 1px);
      background-size: 40px 40px;
      opacity: 0.4;
      mask-image: radial-gradient(ellipse at center, black 30%, transparent 75%);
    }

    .hero-glow {
      position: absolute;
      width: 400px; height: 400px;
      border-radius: 50%;
      background: radial-gradient(circle, rgba(79,142,247,0.18) 0%, transparent 70%);
      pointer-events: none;
    }

    .hero-content {
      position: relative;
      text-align: center;
      z-index: 1;
    }

    .hero-badge {
      display: inline-flex;
      align-items: center;
      gap: 7px;
      background: rgba(79,142,247,0.1);
      border: 1px solid rgba(79,142,247,0.25);
      border-radius: 99px;
      padding: 6px 14px;
      font-size: 0.75rem;
      font-family: var(--mono);
      color: var(--accent);
      margin-bottom: 28px;
    }

    .hero-badge-dot {
      width: 6px; height: 6px;
      border-radius: 50%;
      background: var(--accent);
      animation: blink 1.6s infinite;
    }

    @keyframes blink {
      0%, 100% { opacity: 1; }
      50% { opacity: 0.2; }
    }

    .hero-title {
      font-size: 2.6rem;
      font-weight: 700;
      letter-spacing: -0.05em;
      line-height: 1.1;
      margin-bottom: 16px;
    }

    .hero-title .grad {
      background: linear-gradient(135deg, var(--accent), var(--accent2));
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }

    .hero-desc {
      font-size: 0.88rem;
      color: var(--muted);
      line-height: 1.6;
      max-width: 300px;
      margin: 0 auto 36px;
    }

    /* Stat pills */
    .hero-stats {
      display: flex;
      gap: 12px;
      justify-content: center;
      flex-wrap: wrap;
    }

    .stat-pill {
      background: var(--surface2);
      border: 1px solid var(--border);
      border-radius: 10px;
      padding: 12px 20px;
      text-align: center;
      transition: border-color 0.3s;
    }

    .stat-pill:hover { border-color: rgba(79,142,247,0.4); }

    .stat-val {
      font-family: var(--mono);
      font-size: 1.35rem;
      font-weight: 600;
      background: linear-gradient(135deg, var(--accent), var(--accent2));
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }

    .stat-label {
      font-size: 0.72rem;
      color: var(--muted);
      margin-top: 2px;
    }

    /* ── FOOTER ── */
    footer {
      text-align: center;
      padding: 18px;
      font-size: 0.75rem;
      color: var(--muted);
      font-family: var(--mono);
      border-top: 1px solid var(--border);
    }
  </style>
</head>

<body>

  <!-- NAVBAR -->
  <nav>
    <a href="index.html" class="nav-brand">
      <div class="brand-dot"></div>
      Examily
    </a>
    <ul class="nav-links">
      <li><a href="index.html" class="active">Home</a></li>
      <li><a href="ContactUs.jsp">Contact Us</a></li>
    </ul>
  </nav>

  <!-- PAGE BODY -->
  <div class="page-body">

    <!-- FORM PANEL -->
    <div class="form-panel">
      <div class="form-inner">
        <div class="eyebrow">Start for free</div>
        <h1 class="form-heading">Create your<br>account<span style="color:var(--accent)">.</span></h1>
        <p class="form-subtext">Already a member? <a href="AdminLogin.jsp">Log in</a></p>

<form action="AdminInsert" method="post">
        <div class="field-row">
            <div class="field">
              <label for="fname">First Name</label>
              <div class="field-wrap">
                <input type="text" id="fname" name="firstName" placeholder="Kumari" required>
                <span class="field-icon">
                  <svg width="15" height="15" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                </span>
              </div>
            </div>
            <div class="field">
              <label for="lname">Last Name</label>
              <div class="field-wrap">
                <input type="text" id="lname" name="lastName" placeholder="Shristi" required>
                <span class="field-icon">
                  <svg width="15" height="15" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                </span>
              </div>
            </div>
          </div>

          <div class="field">
            <label for="email">Email Address</label>
            <div class="field-wrap">
              <input type="email" id="email" name="email" placeholder="kumarishristi@gmail.com" required>
              <span class="field-icon">
                <svg width="15" height="15" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24"><rect x="2" y="4" width="20" height="16" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/></svg>
              </span>
            </div>
          </div>

          <div class="field">
            <label for="password">Password</label>
            <div class="field-wrap">
              <input type="password" id="password" name="password" placeholder="Min. 8 characters" required oninput="checkStrength(this.value)">
              <span class="field-icon toggle-pw" onclick="togglePw()" id="eyeIcon">
                <svg width="15" height="15" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24" id="eyeSvg"><path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z"/><circle cx="12" cy="12" r="3"/></svg>
              </span>
            </div>
            <div class="pw-strength">
              <div class="pw-bar" id="bar1"></div>
              <div class="pw-bar" id="bar2"></div>
              <div class="pw-bar" id="bar3"></div>
              <div class="pw-bar" id="bar4"></div>
            </div>
          </div>

          <button type="submit" class="btn-signup">
            Create Account
            <svg width="15" height="15" fill="none" stroke="currentColor" stroke-width="2.2" viewBox="0 0 24 24"><path d="M5 12h14M13 6l6 6-6 6"/></svg>
          </button>
        </form>
      </div>
    </div>

    <!-- HERO PANEL -->
    <div class="hero-panel">
      <div class="hero-grid"></div>
      <div class="hero-glow"></div>
      <div class="hero-content">
        <div class="hero-badge">
          <div class="hero-badge-dot"></div>
          Now Live — Examily 2.0
        </div>
        <h2 class="hero-title">Test smarter.<br><span class="grad">Learn faster.</span></h2>
        <p class="hero-desc">
          A powerful online examination platform built for students and educators who take learning seriously.
        </p>
        <div class="hero-stats">
          <div class="stat-pill">
            <div class="stat-val">10k+</div>
            <div class="stat-label">Students</div>
          </div>
          <div class="stat-pill">
            <div class="stat-val">500+</div>
            <div class="stat-label">Exams</div>
          </div>
          <div class="stat-pill">
            <div class="stat-val">99%</div>
            <div class="stat-label">Uptime</div>
          </div>
        </div>
      </div>
    </div>

  </div>

  <footer>© 2026 Examily, Inc. All rights reserved.</footer>

  <script>
    function togglePw() {
      var inp = document.getElementById("password");
      inp.type = inp.type === "password" ? "text" : "password";
    }

    function checkStrength(val) {
      var score = 0;
      if (val.length >= 8) score++;
      if (/[A-Z]/.test(val)) score++;
      if (/[0-9]/.test(val)) score++;
      if (/[^A-Za-z0-9]/.test(val)) score++;

      var colors = ["#f87171","#fbbf24","#fbbf24","#34d399","#34d399"];
      for (var i = 1; i <= 4; i++) {
        var bar = document.getElementById("bar" + i);
        bar.style.background = i <= score ? colors[score] : "var(--border)";
      }
    }
  </script>

</body>
</html>
