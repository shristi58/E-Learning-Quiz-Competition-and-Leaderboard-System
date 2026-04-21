<%-- 
    Document   : StudentLogin
    Redesigned : March 2026
    Author     : Improved Version
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Student Login — Examily</title>
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    :root {
      --ink:        #0d0d0f;
      --ink-soft:   #5a5a6e;
      --surface:    #f0f4ff;
      --card:       #ffffff;
      --accent:     #2563eb;
      --accent-2:   #3b82f6;
      --accent-glow:#1d4ed8;
      --teal:       #0ea5e9;
      --border:     #dde3f0;
      --input-bg:   #f8f9fd;
      --shadow:     0 20px 60px rgba(37,99,235,.10), 0 4px 16px rgba(0,0,0,.06);
    }

    html, body { height: 100%; }

    body {
      font-family: 'DM Sans', sans-serif;
      background: var(--surface);
      color: var(--ink);
      min-height: 100vh;
      display: flex;
      flex-direction: column;
    }

    /* ── NAV ── */
    nav {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 18px 48px;
      background: var(--card);
      border-bottom: 1px solid var(--border);
      position: sticky;
      top: 0;
      z-index: 100;
    }
    .nav-brand {
      display: flex;
      align-items: center;
      gap: 10px;
      text-decoration: none;
      color: var(--ink);
    }
    .nav-brand-dot {
      width: 28px; height: 28px;
      background: var(--accent);
      border-radius: 50%;
      display: flex; align-items: center; justify-content: center;
    }
    .nav-brand-dot svg { width: 14px; height: 14px; fill: #fff; }
    .nav-brand-name {
      font-family: 'Playfair Display', serif;
      font-size: 1.2rem;
      font-weight: 700;
      letter-spacing: -.3px;
    }
    .nav-links { display: flex; gap: 28px; list-style: none; }
    .nav-links a {
      text-decoration: none;
      color: var(--ink-soft);
      font-size: .9rem;
      font-weight: 500;
      letter-spacing: .3px;
      transition: color .2s;
    }
    .nav-links a:hover { color: var(--accent); }

    /* ── LAYOUT ── */
    .page-wrapper {
      flex: 1;
      display: grid;
      grid-template-columns: 1fr 1fr;
      min-height: calc(100vh - 64px);
    }

    /* ── LEFT PANEL (form side for students) ── */
    .left-panel {
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 48px;
      background: var(--surface);
    }

    .form-card {
      width: 100%;
      max-width: 420px;
      background: var(--card);
      border-radius: 20px;
      padding: 48px 44px;
      box-shadow: var(--shadow);
      border: 1px solid var(--border);
      animation: slideUp .5s cubic-bezier(.22,1,.36,1) both;
    }
    @keyframes slideUp {
      from { opacity: 0; transform: translateY(24px); }
      to   { opacity: 1; transform: translateY(0); }
    }

    .form-eyebrow {
      display: flex;
      align-items: center;
      gap: 8px;
      margin-bottom: 28px;
    }
    .form-eyebrow-line {
      width: 28px; height: 2px;
      background: var(--accent);
      border-radius: 2px;
    }
    .form-eyebrow-text {
      font-size: .72rem;
      font-weight: 600;
      letter-spacing: 2px;
      text-transform: uppercase;
      color: var(--accent);
    }

    .form-title {
      font-family: 'Playfair Display', serif;
      font-size: 2rem;
      font-weight: 700;
      color: var(--ink);
      line-height: 1.2;
      margin-bottom: 6px;
      letter-spacing: -.4px;
    }
    .form-subtitle {
      font-size: .88rem;
      color: var(--ink-soft);
      margin-bottom: 32px;
      line-height: 1.6;
    }

    /* Alert messages */
    .alert-msg {
      display: flex;
      align-items: flex-start;
      gap: 10px;
      padding: 12px 14px;
      border-radius: 10px;
      font-size: .85rem;
      font-weight: 500;
      margin-bottom: 20px;
      animation: fadeIn .3s ease;
    }
    @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
    .alert-error   { background: #fef2f2; color: #991b1b; border: 1px solid #fecaca; }
    .alert-success { background: #f0fdf4; color: #166534; border: 1px solid #bbf7d0; }
    .alert-icon { font-size: 1rem; flex-shrink: 0; margin-top: 1px; }

    /* Google button */
    .btn-google {
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 10px;
      width: 100%;
      padding: 12px;
      background: var(--input-bg);
      border: 1.5px solid var(--border);
      border-radius: 12px;
      font-size: .9rem;
      font-weight: 500;
      color: var(--ink);
      text-decoration: none;
      transition: border-color .2s, box-shadow .2s, background .2s;
      cursor: pointer;
      margin-bottom: 24px;
    }
    .btn-google:hover {
      border-color: #aac4ff;
      background: #fff;
      box-shadow: 0 2px 12px rgba(37,99,235,.10);
    }
    .btn-google img { width: 20px; height: 20px; }

    /* Divider */
    .divider {
      display: flex;
      align-items: center;
      gap: 14px;
      margin-bottom: 24px;
    }
    .divider-line { flex: 1; height: 1px; background: var(--border); }
    .divider-text { font-size: .8rem; color: var(--ink-soft); font-weight: 500; }

    /* Inputs */
    .field { margin-bottom: 16px; }
    .field label {
      display: block;
      font-size: .82rem;
      font-weight: 600;
      color: var(--ink);
      margin-bottom: 7px;
      letter-spacing: .2px;
    }
    .input-wrap { position: relative; }
    .input-icon {
      position: absolute;
      left: 14px;
      top: 50%;
      transform: translateY(-50%);
      width: 16px; height: 16px;
      color: var(--ink-soft);
      pointer-events: none;
      transition: color .2s;
    }
    .field input {
      width: 100%;
      padding: 12px 14px 12px 42px;
      background: var(--input-bg);
      border: 1.5px solid var(--border);
      border-radius: 10px;
      font-size: .92rem;
      font-family: 'DM Sans', sans-serif;
      color: var(--ink);
      outline: none;
      transition: border-color .2s, box-shadow .2s;
    }
    .field input:focus {
      border-color: var(--accent);
      box-shadow: 0 0 0 3px rgba(37,99,235,.12);
      background: #fff;
    }
    .input-wrap:focus-within .input-icon { color: var(--accent); }

    /* Password toggle */
    .pw-toggle {
      position: absolute;
      right: 13px;
      top: 50%;
      transform: translateY(-50%);
      background: none;
      border: none;
      cursor: pointer;
      padding: 4px;
      color: var(--ink-soft);
      display: flex;
      transition: color .2s;
    }
    .pw-toggle:hover { color: var(--ink); }
    .pw-toggle svg { width: 17px; height: 17px; }

    /* Forgot */
    .forgot-row {
      display: flex;
      justify-content: flex-end;
      margin-top: -8px;
      margin-bottom: 22px;
    }
    .forgot-row a {
      font-size: .8rem;
      color: var(--ink-soft);
      text-decoration: none;
      font-weight: 500;
      transition: color .2s;
    }
    .forgot-row a:hover { color: var(--accent); }

    /* Submit */
    .btn-login {
      width: 100%;
      padding: 13px;
      background: var(--accent);
      color: #fff;
      border: none;
      border-radius: 12px;
      font-size: .95rem;
      font-weight: 600;
      font-family: 'DM Sans', sans-serif;
      cursor: pointer;
      letter-spacing: .3px;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      transition: background .2s, transform .15s, box-shadow .2s;
      position: relative;
      overflow: hidden;
    }
    .btn-login::after {
      content: '';
      position: absolute;
      inset: 0;
      background: linear-gradient(135deg, rgba(255,255,255,.15) 0%, transparent 60%);
    }
    .btn-login:hover {
      background: var(--accent-2);
      transform: translateY(-1px);
      box-shadow: 0 8px 24px rgba(37,99,235,.35);
    }
    .btn-login:active { transform: translateY(0); }
    .btn-login svg { width: 18px; height: 18px; }

    /* signup hint */
    .signup-hint {
      text-align: center;
      margin-top: 22px;
      font-size: .85rem;
      color: var(--ink-soft);
    }
    .signup-hint a {
      color: var(--accent);
      font-weight: 600;
      text-decoration: none;
      transition: opacity .2s;
    }
    .signup-hint a:hover { opacity: .75; }

    /* ── RIGHT DECORATIVE PANEL ── */
    .right-panel {
      background: #0f172a;
      display: flex;
      flex-direction: column;
      justify-content: flex-end;
      padding: 64px;
      position: relative;
      overflow: hidden;
    }
    .right-panel::before {
      content: '';
      position: absolute;
      inset: 0;
      background:
        radial-gradient(ellipse 55% 50% at 75% 25%, rgba(37,99,235,.40) 0%, transparent 70%),
        radial-gradient(ellipse 40% 40% at 20% 75%, rgba(14,165,233,.22) 0%, transparent 60%);
    }
    .right-noise {
      position: absolute;
      inset: 0;
      opacity: .04;
      background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)'/%3E%3C/svg%3E");
    }

    /* Floating orbs */
    .orb {
      position: absolute;
      border-radius: 50%;
      filter: blur(60px);
      pointer-events: none;
    }
    .orb-1 { width: 260px; height: 260px; top: 8%; right: 5%;  background: rgba(37,99,235,.3); }
    .orb-2 { width: 180px; height: 180px; top: 40%; left: 10%; background: rgba(14,165,233,.25); }
    .orb-3 { width: 140px; height: 140px; bottom: 20%; right: 20%; background: rgba(99,102,241,.2); }

    .right-big-letter {
      position: absolute;
      bottom: -40px; right: -20px;
      font-family: 'Playfair Display', serif;
      font-size: clamp(200px, 22vw, 320px);
      font-weight: 900;
      color: rgba(255,255,255,.03);
      line-height: 1;
      user-select: none;
      pointer-events: none;
    }

    /* Floating card preview */
    .preview-card {
      position: absolute;
      top: 52px;
      left: 50%;
      transform: translateX(-50%);
      width: 220px;
      background: rgba(255,255,255,.07);
      backdrop-filter: blur(16px);
      border: 1px solid rgba(255,255,255,.12);
      border-radius: 16px;
      padding: 18px 20px;
    }
    .preview-label {
      font-size: .68rem;
      font-weight: 600;
      letter-spacing: 1.5px;
      text-transform: uppercase;
      color: rgba(255,255,255,.4);
      margin-bottom: 12px;
    }
    .preview-row {
      display: flex;
      align-items: center;
      gap: 10px;
      margin-bottom: 10px;
    }
    .preview-row:last-child { margin-bottom: 0; }
    .preview-avatar {
      width: 28px; height: 28px;
      border-radius: 50%;
      background: linear-gradient(135deg, var(--accent) 0%, var(--teal) 100%);
      display: flex; align-items: center; justify-content: center;
      font-size: .7rem; font-weight: 700; color: #fff; flex-shrink: 0;
    }
    .preview-info { flex: 1; }
    .preview-name { font-size: .78rem; font-weight: 600; color: rgba(255,255,255,.85); }
    .preview-sub  { font-size: .68rem; color: rgba(255,255,255,.4); margin-top: 1px; }
    .preview-score {
      font-size: .75rem; font-weight: 700;
      color: #4ade80;
      background: rgba(74,222,128,.12);
      padding: 2px 8px; border-radius: 20px;
    }

    .right-content { position: relative; z-index: 2; }
    .right-tag {
      display: inline-block;
      background: rgba(37,99,235,.25);
      border: 1px solid rgba(37,99,235,.45);
      color: #93c5fd;
      font-size: .72rem;
      font-weight: 600;
      letter-spacing: 2px;
      text-transform: uppercase;
      padding: 6px 14px;
      border-radius: 100px;
      margin-bottom: 28px;
    }
    .right-headline {
      font-family: 'Playfair Display', serif;
      font-size: clamp(2rem, 3.2vw, 3rem);
      font-weight: 900;
      color: #fff;
      line-height: 1.15;
      margin-bottom: 20px;
      letter-spacing: -.5px;
    }
    .right-headline em {
      font-style: normal;
      background: linear-gradient(90deg, #60a5fa, #38bdf8);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }
    .right-desc {
      color: rgba(255,255,255,.5);
      font-size: .95rem;
      line-height: 1.7;
      max-width: 340px;
      margin-bottom: 40px;
    }
    .right-features {
      display: flex;
      flex-direction: column;
      gap: 14px;
    }
    .feature-item {
      display: flex;
      align-items: center;
      gap: 12px;
    }
    .feature-dot {
      width: 32px; height: 32px;
      background: rgba(37,99,235,.2);
      border: 1px solid rgba(37,99,235,.35);
      border-radius: 8px;
      display: flex; align-items: center; justify-content: center;
      flex-shrink: 0;
    }
    .feature-dot svg { width: 15px; height: 15px; color: #93c5fd; }
    .feature-text {
      font-size: .88rem;
      color: rgba(255,255,255,.65);
      font-weight: 400;
    }

    /* ── FOOTER ── */
    footer {
      text-align: center;
      padding: 18px;
      font-size: .8rem;
      color: var(--ink-soft);
      border-top: 1px solid var(--border);
      background: var(--card);
    }

    /* ── RESPONSIVE ── */
    @media (max-width: 860px) {
      .page-wrapper { grid-template-columns: 1fr; }
      .right-panel { display: none; }
      .left-panel { padding: 32px 24px; }
      nav { padding: 16px 24px; }
    }
  </style>
</head>
<body>

<!-- NAV -->
<nav>
  <a href="index.html" class="nav-brand">
    <span class="nav-brand-dot">
      <svg viewBox="0 0 16 16"><path d="M8 2a6 6 0 100 12A6 6 0 008 2zm0 1.5a4.5 4.5 0 110 9 4.5 4.5 0 010-9zM7 6h2v5H7zm0-2h2v1.5H7z"/></svg>
    </span>
    <span class="nav-brand-name">Examily</span>
  </a>
  <ul class="nav-links">
    <li><a href="index.html">Home</a></li>
    <li><a href="ContactUs.jsp">Contact Us</a></li>
  </ul>
</nav>

<!-- MAIN -->
<div class="page-wrapper">

  <!-- LEFT FORM PANEL -->
  <div class="left-panel">
    <div class="form-card">

      <div class="form-eyebrow">
        <span class="form-eyebrow-line"></span>
        <span class="form-eyebrow-text">Student Portal</span>
      </div>

      <h1 class="form-title">Welcome back</h1>
      <p class="form-subtitle">Sign in to access your exams and results.</p>

      <!-- Server messages -->
      <%
        String errorMsg   = request.getParameter("msg2");
        String successMsg = request.getParameter("msg1");
        if (errorMsg != null && !errorMsg.isEmpty()) {
      %>
      <div class="alert-msg alert-error">
        <span class="alert-icon">⚠</span>
        <span><%= errorMsg %></span>
      </div>
      <% } %>
      <%
        if (successMsg != null && !successMsg.isEmpty()) {
      %>
      <div class="alert-msg alert-success">
        <span class="alert-icon">✓</span>
        <span><%= successMsg %></span>
      </div>
      <% } %>

      <!-- Google -->
    <%
    String studentClientId = "485767533625-iph2nvm01nj664t5lin7ggb40l9altqf.apps.googleusercontent.com";
    String studentRedirectUri = "http://localhost:8080/Online-Quiz-System/StudentGoogleCallbackServlet";
    String studentGoogleUrl = "https://accounts.google.com/o/oauth2/v2/auth"
        + "?client_id=" + studentClientId
        + "&redirect_uri=" + java.net.URLEncoder.encode(studentRedirectUri, "UTF-8")
        + "&response_type=code"
        + "&scope=" + java.net.URLEncoder.encode("openid email profile", "UTF-8");
%>
<a href="<%= studentGoogleUrl %>" class="btn-google">
    <img src="https://img.icons8.com/fluency/48/000000/google-logo.png" alt="Google">
    Continue with Google
</a>

      <div class="divider">
        <span class="divider-line"></span>
        <span class="divider-text">or sign in with credentials</span>
        <span class="divider-line"></span>
      </div>

      <!-- Form -->
      <form action="oes.controller.ValidateStudent" method="post" autocomplete="on">

        <div class="field">
          <label for="uname">Student ID</label>
          <div class="input-wrap">
            <input type="text" id="uname" name="uname" placeholder="Enter your student ID" autocomplete="username" required>
            <svg class="input-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 7V5a2 2 0 0 0-4 0v2"/><line x1="12" y1="12" x2="12" y2="16"/><circle cx="12" cy="12" r="1"/>
            </svg>
          </div>
        </div>

        <div class="field">
          <label for="password">Password</label>
          <div class="input-wrap">
            <input type="password" id="password" name="pass" placeholder="Enter your password" autocomplete="current-password" required>
            <svg class="input-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/>
            </svg>
            <button type="button" class="pw-toggle" id="pwToggle" aria-label="Toggle password visibility">
              <svg id="eyeIcon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>
              </svg>
            </button>
          </div>
        </div>

        <div class="forgot-row">
          <a href="#">Forgot password?</a>
        </div>

        <button type="submit" class="btn-login">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/><polyline points="10 17 15 12 10 7"/><line x1="15" y1="12" x2="3" y2="12"/>
          </svg>
          Sign In
        </button>
      </form>

      <p class="signup-hint">Don't have an account? <a href="SignUp.jsp">Create one</a></p>

    </div>
  </div>

  <!-- RIGHT DECORATIVE PANEL -->
  <div class="right-panel">
    <div class="right-noise"></div>
    <div class="orb orb-1"></div>
    <div class="orb orb-2"></div>
    <div class="orb orb-3"></div>
    <div class="right-big-letter">S</div>

    <!-- Floating leaderboard preview card -->
    <div class="preview-card">
      <div class="preview-label">Top Scorers Today</div>
      <div class="preview-row">
        <div class="preview-avatar">AK</div>
        <div class="preview-info">
          <div class="preview-name">Arjun K.</div>
          <div class="preview-sub">Physics • Batch B</div>
        </div>
        <span class="preview-score">98%</span>
      </div>
      <div class="preview-row">
        <div class="preview-avatar" style="background:linear-gradient(135deg,#0ea5e9,#6366f1)">PR</div>
        <div class="preview-info">
          <div class="preview-name">Priya R.</div>
          <div class="preview-sub">Math • Batch A</div>
        </div>
        <span class="preview-score">95%</span>
      </div>
      <div class="preview-row">
        <div class="preview-avatar" style="background:linear-gradient(135deg,#8b5cf6,#ec4899)">SM</div>
        <div class="preview-info">
          <div class="preview-name">Sameer M.</div>
          <div class="preview-sub">Chemistry • Batch C</div>
        </div>
        <span class="preview-score">92%</span>
      </div>
    </div>

    <div class="right-content">
      <span class="right-tag">Student Access</span>
      <h1 class="right-headline">
        Learn, attempt,<br><em>excel.</em>
      </h1>
      <p class="right-desc">
        Take timed assessments, track your scores, and review performance
        analytics — all in one place built for students.
      </p>
      <div class="right-features">
        <div class="feature-item">
          <div class="feature-dot">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <polyline points="9 11 12 14 22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/>
            </svg>
          </div>
          <span class="feature-text">Instant results and detailed feedback after every test</span>
        </div>
        <div class="feature-item">
          <div class="feature-dot">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/>
            </svg>
          </div>
          <span class="feature-text">Track your progress with personal score analytics</span>
        </div>
        <div class="feature-item">
          <div class="feature-dot">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/>
            </svg>
          </div>
          <span class="feature-text">Timed exams that mirror real test conditions</span>
        </div>
      </div>
    </div>
  </div>

</div>

<footer>© 2026 Examily, Inc. All rights reserved.</footer>

<script>
  const toggle = document.getElementById('pwToggle');
  const pwInput = document.getElementById('password');
  const eyeIcon = document.getElementById('eyeIcon');
  const eyeOpen  = `<path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>`;
  const eyeClose = `<line x1="1" y1="1" x2="23" y2="23"/><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/>`;
  toggle.addEventListener('click', () => {
    const hidden = pwInput.type === 'password';
    pwInput.type = hidden ? 'text' : 'password';
    eyeIcon.innerHTML = hidden ? eyeClose : eyeOpen;
  });
</script>

</body>
</html>
