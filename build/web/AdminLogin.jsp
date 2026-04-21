<%-- 
    Document   : AdminLogin
    Redesigned : March 2026
    Author     : Improved Version
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Examiner Login — Examily</title>
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    :root {
      --ink:       #0d0d0f;
      --ink-soft:  #5a5a6e;
      --surface:   #f5f4f0;
      --card:      #ffffff;
      --accent:    #c0392b;
      --accent-2:  #e8533f;
      --gold:      #d4a843;
      --border:    #e2e1dd;
      --input-bg:  #fafaf8;
      --shadow:    0 20px 60px rgba(0,0,0,.10), 0 4px 16px rgba(0,0,0,.06);
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

    /* ── LEFT PANEL (decorative) ── */
    .left-panel {
      background: var(--ink);
      display: flex;
      flex-direction: column;
      justify-content: flex-end;
      padding: 64px;
      position: relative;
      overflow: hidden;
    }
    .left-panel::before {
      content: '';
      position: absolute;
      inset: 0;
      background:
        radial-gradient(ellipse 60% 50% at 20% 30%, rgba(192,57,43,.35) 0%, transparent 70%),
        radial-gradient(ellipse 40% 40% at 80% 70%, rgba(212,168,67,.20) 0%, transparent 60%);
    }
    .left-noise {
      position: absolute;
      inset: 0;
      opacity: .04;
      background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)'/%3E%3C/svg%3E");
    }
    .left-big-letter {
      position: absolute;
      top: -30px; left: -20px;
      font-family: 'Playfair Display', serif;
      font-size: clamp(200px, 22vw, 320px);
      font-weight: 900;
      color: rgba(255,255,255,.035);
      line-height: 1;
      user-select: none;
      pointer-events: none;
    }
    .left-content { position: relative; z-index: 2; }
    .left-tag {
      display: inline-block;
      background: rgba(192,57,43,.25);
      border: 1px solid rgba(192,57,43,.5);
      color: #f4988e;
      font-size: .72rem;
      font-weight: 600;
      letter-spacing: 2px;
      text-transform: uppercase;
      padding: 6px 14px;
      border-radius: 100px;
      margin-bottom: 28px;
    }
    .left-headline {
      font-family: 'Playfair Display', serif;
      font-size: clamp(2rem, 3.5vw, 3.2rem);
      font-weight: 900;
      color: #fff;
      line-height: 1.15;
      margin-bottom: 20px;
      letter-spacing: -.5px;
    }
    .left-headline em {
      font-style: normal;
      color: var(--gold);
    }
    .left-desc {
      color: rgba(255,255,255,.55);
      font-size: .95rem;
      line-height: 1.7;
      max-width: 340px;
      margin-bottom: 40px;
    }
    .left-stats {
      display: flex;
      gap: 32px;
    }
    .stat-item .stat-num {
      font-family: 'Playfair Display', serif;
      font-size: 1.8rem;
      font-weight: 700;
      color: #fff;
      line-height: 1;
    }
    .stat-item .stat-label {
      font-size: .75rem;
      color: rgba(255,255,255,.45);
      margin-top: 4px;
      letter-spacing: .5px;
    }

    /* ── RIGHT PANEL (form) ── */
    .right-panel {
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
    .alert-error  { background: #fef2f2; color: #991b1b; border: 1px solid #fecaca; }
    .alert-success{ background: #f0fdf4; color: #166534; border: 1px solid #bbf7d0; }
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
      border-color: #aaa;
      background: #fff;
      box-shadow: 0 2px 12px rgba(0,0,0,.08);
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
    .input-wrap {
      position: relative;
    }
    .input-wrap svg {
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
      box-shadow: 0 0 0 3px rgba(192,57,43,.12);
      background: #fff;
    }
    .field input:focus + svg,
    .input-wrap:focus-within svg { color: var(--accent); }

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
      box-shadow: 0 8px 24px rgba(192,57,43,.35);
    }
    .btn-login:active { transform: translateY(0); }
    .btn-login svg { width: 18px; height: 18px; }

    /* Sign up link */
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
      .left-panel { display: none; }
      .right-panel { padding: 32px 24px; }
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

  <!-- LEFT DECORATIVE PANEL -->
  <div class="left-panel">
    <div class="left-noise"></div>
    <div class="left-big-letter">E</div>
    <div class="left-content">
      <span class="left-tag">Examiner Portal</span>
      <h1 class="left-headline">
        Conduct exams<br>with <em>confidence.</em>
      </h1>
      <p class="left-desc">
        Examily gives educators powerful tools to create, manage, and evaluate
        assessments — all in one seamless platform.
      </p>
      <div class="left-stats">
        <div class="stat-item">
          <div class="stat-num">12k+</div>
          <div class="stat-label">Examiners</div>
        </div>
        <div class="stat-item">
          <div class="stat-num">4.8★</div>
          <div class="stat-label">Avg Rating</div>
        </div>
        <div class="stat-item">
          <div class="stat-num">99%</div>
          <div class="stat-label">Uptime</div>
        </div>
      </div>
    </div>
  </div>

  <!-- RIGHT FORM PANEL -->
  <div class="right-panel">
    <div class="form-card">

      <div class="form-eyebrow">
        <span class="form-eyebrow-line"></span>
        <span class="form-eyebrow-text">Examiner Access</span>
      </div>

      <h1 class="form-title">Welcome back</h1>
      <p class="form-subtitle">Sign in to manage your exams and students.</p>

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
      <!-- Google -->
<%
    String clientId = "485767533625-iph2nvm01nj664t5lin7ggb40l9altqf.apps.googleusercontent.com";
    String redirectUri = "http://localhost:8080/Online-Quiz-System/GoogleCallbackServlet";
    String scope = "openid email profile";
    String googleAuthUrl = "https://accounts.google.com/o/oauth2/v2/auth"
        + "?client_id=" + clientId
        + "&redirect_uri=" + java.net.URLEncoder.encode(redirectUri, "UTF-8")
        + "&response_type=code"
        + "&scope=" + java.net.URLEncoder.encode(scope, "UTF-8");
%>
<a href="<%= googleAuthUrl %>" class="btn-google">
    <img src="https://img.icons8.com/fluency/48/000000/google-logo.png" alt="Google"/>
    Continue with Google
</a>

      <div class="divider">
        <span class="divider-line"></span>
        <span class="divider-text">or sign in with credentials</span>
        <span class="divider-line"></span>
      </div>

      <!-- Form -->
      <form action="oes.controller.ValidateAdmin" method="post" autocomplete="on">

        <div class="field">
          <label for="uname">Username</label>
          <div class="input-wrap">
            <input type="text" id="uname" name="uname" placeholder="Enter your username" autocomplete="username" required>
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="position:absolute;left:14px;top:50%;transform:translateY(-50%);width:16px;height:16px;color:var(--ink-soft);pointer-events:none">
              <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>
            </svg>
          </div>
        </div>

        <div class="field">
          <label for="password">Password</label>
          <div class="input-wrap">
            <input type="password" id="password" name="pass" placeholder="Enter your password" autocomplete="current-password" required>
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="position:absolute;left:14px;top:50%;transform:translateY(-50%);width:16px;height:16px;color:var(--ink-soft);pointer-events:none">
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
