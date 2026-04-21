<%-- 
    Document   : Exam
    Created on : 25 Mar 2026, 16:12:24
    Author     : Samrat
    Modified   : Timer now reads duration from session (set by StartExamServlet)
                 Anti-Cheat module integrated (tab switch, fullscreen, copy/paste, auto-submit)
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@page import="oes.model.QuestionsDao"%>
<%@page import="oes.db.*"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%
    // ?? TIMER: calculate remaining seconds from session ??????????????????????
    int examId = 1;
    try { examId = Integer.parseInt(request.getParameter("examId")); } catch (Exception ex) {}

    long remainingSeconds = 30 * 60L; // fallback: 30 min
    String sessionKey = "examEndTime_" + examId;
    Long endTime = (Long) session.getAttribute(sessionKey);
    if (endTime != null) {
        remainingSeconds = (endTime - System.currentTimeMillis()) / 1000;
        if (remainingSeconds < 0) remainingSeconds = 0;
    }

    // totalSeconds is used by the ring progress (full duration at start)
    int totalDuration = 30 * 60; // fallback seconds
    Integer storedDuration = (Integer) session.getAttribute("currentExamDuration");
    if (storedDuration != null) totalDuration = storedDuration * 60;
    // ?????????????????????????????????????????????????????????????????????????
%>

<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Examination ? Examily</title>
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Mono:wght@300;400;500&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    :root {
      --bg:        #0b0e14;
      --surface:   #13171f;
      --surface2:  #1a1f2b;
      --surface3:  #1e2330;
      --border:    rgba(255,255,255,0.07);
      --border-hover: rgba(255,255,255,0.14);
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

    body::before {
      content: '';
      position: fixed; inset: 0; z-index: 0; pointer-events: none;
      background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.04'/%3E%3C/svg%3E");
      background-size: 200px; opacity: 0.6;
    }

    .blob { position: fixed; border-radius: 50%; filter: blur(110px); pointer-events: none; z-index: 0; }
    .blob-green { width: 500px; height: 500px; background: rgba(0,229,160,0.07); top: -150px; right: -100px; }
    .blob-pink  { width: 400px; height: 400px; background: rgba(255,77,109,0.05); bottom: -100px; left: -80px; }

    /* STICKY TOPBAR */
    .topbar {
      position: sticky; top: 0; z-index: 100;
      background: rgba(11,14,20,0.85);
      backdrop-filter: blur(16px);
      border-bottom: 1px solid var(--border);
      padding: 0 24px;
      display: flex; align-items: center; justify-content: space-between;
      height: 60px;
    }
    .logo {
      font-family: 'Syne', sans-serif;
      font-size: 1.15rem; font-weight: 800;
      letter-spacing: -0.02em;
      color: var(--accent);
    }
    .logo span { color: var(--text); }

    /* TIMER WIDGET */
    .timer-wrap {
      display: flex; align-items: center; gap: 10px;
    }
    .timer-label {
      font-size: 0.62rem; letter-spacing: 0.14em; text-transform: uppercase; color: var(--muted);
    }
    .timer-display {
      font-family: 'Syne', sans-serif;
      font-size: 1.3rem; font-weight: 800;
      color: var(--accent);
      min-width: 64px; text-align: right;
      transition: color 0.4s;
    }
    .timer-display.warning { color: var(--accent3); }
    .timer-display.danger  { color: var(--accent2); animation: pulse 0.8s infinite; }

    .timer-ring {
      width: 38px; height: 38px;
      transform: rotate(-90deg);
    }
    .timer-ring circle {
      fill: none; stroke-width: 3;
    }
    .ring-bg    { stroke: var(--surface2); }
    .ring-track { stroke: var(--accent); stroke-linecap: round;
                  stroke-dasharray: 100.5; stroke-dashoffset: 0;
                  transition: stroke-dashoffset 1s linear, stroke 0.4s; }

    /* QUESTIONS LEFT BADGE */
    .q-badge {
      font-size: 0.62rem; letter-spacing: 0.1em; text-transform: uppercase;
      padding: 5px 12px; border-radius: 20px;
      border: 1px solid var(--border);
      color: var(--muted);
      background: var(--surface);
    }
    .q-badge span { color: var(--accent3); font-weight: 600; font-family: 'Syne', sans-serif; }

    /* PAGE LAYOUT */
    .page {
      position: relative; z-index: 1;
      max-width: 760px; margin: 0 auto;
      padding: 40px 20px 100px;
    }

    /* EXAM HEADER */
    .exam-header {
      margin-bottom: 36px;
      opacity: 0; animation: fadeUp 0.5s 0.1s ease forwards;
    }
    .exam-title {
      font-family: 'Syne', sans-serif;
      font-size: clamp(1.6rem, 4vw, 2.4rem);
      font-weight: 800; letter-spacing: -0.03em;
      line-height: 1.1; margin-bottom: 8px;
    }
    .exam-title .highlight { color: var(--accent); }
    .exam-meta {
      font-size: 0.68rem; color: var(--muted); letter-spacing: 0.06em;
    }

    /* PROGRESS STRIP */
    .progress-strip {
      height: 4px; background: var(--surface2); border-radius: 99px;
      margin-bottom: 40px; overflow: hidden;
      opacity: 0; animation: fadeUp 0.5s 0.2s ease forwards;
    }
    .progress-fill {
      height: 100%; width: 0;
      background: linear-gradient(90deg, var(--accent), #00b4d8);
      border-radius: 99px;
      transition: width 0.4s ease;
    }

    /* QUESTION CARD */
    .question-card {
      background: var(--surface);
      border: 1px solid var(--border);
      border-radius: var(--radius);
      padding: 28px;
      margin-bottom: 20px;
      transition: border-color 0.2s;
      opacity: 0;
      animation: fadeUp 0.5s ease forwards;
    }
    .question-card.answered { border-color: rgba(0,229,160,0.25); }

    .q-header {
      display: flex; align-items: flex-start; gap: 16px;
      margin-bottom: 22px;
    }
    .q-number {
      font-family: 'Syne', sans-serif;
      font-size: 0.7rem; font-weight: 800;
      letter-spacing: 0.1em; text-transform: uppercase;
      color: var(--muted);
      background: var(--surface2);
      border: 1px solid var(--border);
      border-radius: 8px;
      padding: 5px 10px;
      white-space: nowrap; flex-shrink: 0;
      margin-top: 2px;
    }
    .q-text {
      font-size: 0.95rem; line-height: 1.65; color: var(--text);
      font-family: 'DM Mono', monospace;
    }

    /* OPTIONS */
    .options {
      display: grid; grid-template-columns: 1fr 1fr; gap: 10px;
    }
    @media (max-width: 520px) { .options { grid-template-columns: 1fr; } }

    .option-label {
      display: flex; align-items: center; gap: 12px;
      padding: 12px 16px;
      border-radius: 10px;
      border: 1px solid var(--border);
      background: var(--surface2);
      cursor: pointer;
      transition: border-color 0.15s, background 0.15s, transform 0.15s;
      user-select: none;
    }
    .option-label:hover {
      border-color: var(--border-hover);
      background: var(--surface3);
      transform: translateY(-1px);
    }
    .option-label input[type="radio"] { display: none; }
    .option-label.selected {
      border-color: var(--accent);
      background: rgba(0,229,160,0.08);
    }

    .opt-key {
      font-family: 'Syne', sans-serif;
      font-size: 0.7rem; font-weight: 800;
      width: 26px; height: 26px;
      border-radius: 6px;
      background: var(--surface);
      border: 1px solid var(--border);
      display: flex; align-items: center; justify-content: center;
      flex-shrink: 0;
      color: var(--muted);
      transition: background 0.15s, color 0.15s, border-color 0.15s;
    }
    .option-label.selected .opt-key {
      background: var(--accent);
      color: var(--bg);
      border-color: var(--accent);
    }
    .opt-text { font-size: 0.85rem; color: var(--text); line-height: 1.4; }

    /* SUBMIT AREA */
    .submit-wrap {
      display: flex; flex-direction: column; align-items: center; gap: 14px;
      margin-top: 44px;
      opacity: 0; animation: fadeUp 0.5s 0.4s ease forwards;
    }
    .submit-note { font-size: 0.65rem; color: var(--muted); letter-spacing: 0.06em; }
    .btn-submit {
      font-family: 'Syne', sans-serif;
      font-size: 0.9rem; font-weight: 800;
      letter-spacing: 0.06em; text-transform: uppercase;
      color: var(--bg);
      background: var(--accent);
      border: none; border-radius: 12px;
      padding: 16px 56px;
      cursor: pointer;
      transition: transform 0.2s ease, box-shadow 0.2s ease, background 0.2s;
      box-shadow: 0 0 0 0 rgba(0,229,160,0.4);
    }
    .btn-submit:hover {
      background: #1df5b0;
      transform: translateY(-2px);
      box-shadow: 0 8px 30px rgba(0,229,160,0.3);
    }
    .btn-submit:active { transform: translateY(0); }

    /* 1-MINUTE WARNING TOAST */
    #toastWarning {
      display: none;
      position: fixed; top: 70px; left: 50%; transform: translateX(-50%);
      background: var(--accent3); color: #000;
      padding: 10px 28px; border-radius: 8px;
      font-weight: bold; font-size: 0.85rem;
      z-index: 9999; white-space: nowrap;
      box-shadow: 0 4px 20px rgba(255,209,102,0.4);
    }

    footer {
      text-align: center;
      margin-top: 60px;
      font-size: 0.62rem; color: var(--muted); letter-spacing: 0.08em;
    }

    @keyframes fadeUp {
      from { opacity: 0; transform: translateY(18px); }
      to   { opacity: 1; transform: translateY(0); }
    }
    @keyframes pulse {
      0%, 100% { opacity: 1; } 50% { opacity: 0.5; }
    }

    /* ???????????????????????????????????????????????????????????
       ANTI-CHEAT STYLES
    ??????????????????????????????????????????????????????????? */

    /* Disable text selection globally during exam */
    body.ac-active {
      -webkit-user-select: none;
      -moz-user-select: none;
      user-select: none;
    }

    /* ?? Violation counter badge in topbar ?? */
    .ac-vbadge {
      display: flex; align-items: center; gap: 6px;
      font-size: 0.62rem; letter-spacing: 0.1em; text-transform: uppercase;
      padding: 5px 12px; border-radius: 20px;
      border: 1px solid rgba(255,77,109,0.25);
      color: var(--accent2);
      background: rgba(255,77,109,0.08);
      transition: border-color 0.3s, background 0.3s;
    }
    .ac-vbadge.ac-hit {
      border-color: rgba(255,77,109,0.6);
      background: rgba(255,77,109,0.18);
      animation: acPulse 0.5s ease;
    }
    .ac-vbadge-dot {
      width: 6px; height: 6px; border-radius: 50%;
      background: var(--accent2);
    }
    .ac-vbadge span { font-family: 'Syne', sans-serif; font-weight: 800; }

    /* ?? Modal overlay ?? */
    #ac-overlay {
      display: none;
      position: fixed; inset: 0; z-index: 99999;
      background: rgba(7, 9, 14, 0.80);
      backdrop-filter: blur(6px);
      align-items: center; justify-content: center;
    }
    #ac-overlay.ac-show { display: flex; animation: acFadeIn 0.25s ease; }

    #ac-card {
      background: var(--surface);
      border: 1px solid rgba(255,77,109,0.3);
      border-radius: 20px;
      padding: 40px 44px 32px;
      max-width: 460px; width: 92%;
      box-shadow: 0 32px 80px rgba(0,0,0,0.6), 0 0 0 1px rgba(255,77,109,0.1);
      text-align: center; position: relative; overflow: hidden;
    }
    #ac-card::before {
      content: '';
      position: absolute; top: 0; left: 0; right: 0; height: 4px;
      background: linear-gradient(90deg, var(--accent2), #ff8c42);
    }

    .ac-icon-wrap {
      width: 68px; height: 68px; border-radius: 50%;
      background: rgba(255,77,109,0.1);
      border: 1px solid rgba(255,77,109,0.25);
      display: flex; align-items: center; justify-content: center;
      margin: 0 auto 20px; font-size: 32px;
    }

    #ac-title {
      font-family: 'Syne', sans-serif;
      font-size: 1.2rem; font-weight: 800; letter-spacing: -0.02em;
      color: var(--accent2); margin-bottom: 10px;
    }
    #ac-msg {
      font-size: 0.85rem; color: var(--muted);
      line-height: 1.7; margin-bottom: 24px;
    }

    /* Violation progress bar */
    .ac-bar-wrap {
      background: var(--surface2);
      border-radius: 99px; height: 6px;
      margin-bottom: 6px; overflow: hidden;
    }
    .ac-bar-fill {
      height: 100%; border-radius: 99px;
      background: linear-gradient(90deg, var(--accent3), var(--accent2));
      transition: width 0.5s ease;
    }
    .ac-bar-label {
      font-size: 0.65rem; color: var(--muted);
      text-align: right; margin-bottom: 24px;
      letter-spacing: 0.06em;
    }

    /* Buttons */
    .ac-btn-row { display: flex; gap: 10px; justify-content: center; }
    .ac-btn {
      font-family: 'Syne', sans-serif;
      font-size: 0.78rem; font-weight: 800;
      letter-spacing: 0.06em; text-transform: uppercase;
      padding: 11px 24px; border-radius: 10px;
      border: none; cursor: pointer;
      transition: transform 0.15s, box-shadow 0.15s;
    }
    .ac-btn:hover { transform: translateY(-1px); }
    .ac-btn-primary {
      background: var(--accent2); color: #fff;
      box-shadow: 0 4px 16px rgba(255,77,109,0.3);
    }
    .ac-btn-primary:hover { box-shadow: 0 6px 22px rgba(255,77,109,0.45); }
    .ac-btn-secondary {
      background: var(--surface2);
      border: 1px solid var(--border);
      color: var(--muted);
    }

    /* ?? Auto-submit banner (top of screen) ?? */
    #ac-banner {
      display: none;
      position: fixed; top: 0; left: 0; right: 0; z-index: 100001;
      background: linear-gradient(90deg, #b71c1c, var(--accent2));
      color: #fff; text-align: center;
      padding: 14px 20px;
      font-family: 'Syne', sans-serif;
      font-size: 0.9rem; font-weight: 700; letter-spacing: 0.02em;
      box-shadow: 0 4px 24px rgba(0,0,0,0.5);
    }
    #ac-banner.ac-show { display: block; animation: acFadeIn 0.3s ease; }

    /* ?? Small toast (bottom centre) ?? */
    #ac-toast {
      display: none;
      position: fixed; bottom: 28px; left: 50%; transform: translateX(-50%);
      z-index: 99998;
      background: var(--surface3);
      border: 1px solid var(--border);
      color: var(--text);
      padding: 10px 20px; border-radius: 10px;
      font-size: 0.78rem; white-space: nowrap;
      box-shadow: 0 6px 24px rgba(0,0,0,0.4);
    }
    #ac-toast.ac-show { display: block; animation: acFadeIn 0.2s ease; }

    @keyframes acFadeIn {
      from { opacity: 0; transform: scale(0.96) translateX(var(--tx, 0)); }
      to   { opacity: 1; transform: scale(1)    translateX(var(--tx, 0)); }
    }
    @keyframes acPulse {
      0%, 100% { transform: scale(1); }
      50%       { transform: scale(1.06); }
    }
    @keyframes acShake {
      0%,100% { transform: translateX(0); }
      20%     { transform: translateX(-9px); }
      40%     { transform: translateX(9px); }
      60%     { transform: translateX(-6px); }
      80%     { transform: translateX(6px); }
    }
    /* ??????????????????????????????????????????????????????????? */
  </style>

  <script>
    // ?? TIMER VARIABLES (injected from session by JSP) ????????????????????????
    var timeLeft   = <%= remainingSeconds %>;
    var totalTime  = <%= totalDuration %>;
    var warned     = false;
    var autoSubmitted = false;
    // ?????????????????????????????????????????????????????????????????????????

    function pad(n) { return n < 10 ? '0' + n : n; }

    function updateTimerUI() {
      var el   = document.getElementById('timerDisplay');
      var mins = Math.floor(timeLeft / 60);
      var secs = timeLeft % 60;
      el.textContent = pad(mins) + ':' + pad(secs);

      var pct = (totalTime > 0) ? timeLeft / totalTime : 0;

      if (pct > 0.4) {
        el.className = 'timer-display';
        document.querySelector('.ring-track').style.stroke = 'var(--accent)';
      } else if (pct > 0.2) {
        el.className = 'timer-display warning';
        document.querySelector('.ring-track').style.stroke = 'var(--accent3)';
      } else {
        el.className = 'timer-display danger';
        document.querySelector('.ring-track').style.stroke = 'var(--accent2)';
      }

      // Ring progress
      var circumference = 100.5;
      var offset = circumference * (1 - pct);
      document.querySelector('.ring-track').style.strokeDashoffset = offset;
    }

    function timer() {
      if (autoSubmitted) return;   // ? anti-cheat sets this flag too

      if (timeLeft <= 0) {
        autoSubmitted = true;
        document.getElementById('timerDisplay').textContent = '00:00';
        document.getElementById('timerDisplay').className = 'timer-display danger';
        alert('Time is up! Your exam will now be submitted automatically.');
        document.getElementById('examForm').submit();
        return;
      }

      updateTimerUI();

      // Show warning toast at 60 seconds remaining
      if (timeLeft <= 60 && !warned) {
        document.getElementById('toastWarning').style.display = 'block';
        warned = true;
      }

      timeLeft--;
      setTimeout(timer, 1000);
    }

    // Track answered questions & update progress bar
    function trackAnswers() {
      var total    = <%=QuestionsDao.getAllRecords().size()%>;
      var answered = 0;
      for (var i = 0; i < total; i++) {
        var radios = document.getElementsByName(String(i));
        for (var r = 0; r < radios.length; r++) {
          if (radios[r].checked && radios[r].value !== 'e') { answered++; break; }
        }
      }
      var left = total - answered;
      var badge = document.getElementById('qLeft');
      if (badge) badge.textContent = left;

      var pct = (answered / total) * 100;
      document.querySelector('.progress-fill').style.width = pct + '%';
      updateCardStates();
    }

    function updateCardStates() {
      var total = <%=QuestionsDao.getAllRecords().size()%>;
      for (var i = 0; i < total; i++) {
        var radios = document.getElementsByName(String(i));
        var card   = document.getElementById('card-' + i);
        var answered = false;
        for (var r = 0; r < radios.length; r++) {
          if (radios[r].checked && radios[r].value !== 'e') { answered = true; break; }
        }
        if (card) {
          if (answered) card.classList.add('answered');
          else          card.classList.remove('answered');
        }
        var opts = document.querySelectorAll('#card-' + i + ' .option-label');
        opts.forEach(function(lbl) {
          var input = lbl.querySelector('input[type=radio]');
          if (input && input.checked && input.value !== 'e') lbl.classList.add('selected');
          else lbl.classList.remove('selected');
        });
      }
    }

    window.addEventListener('DOMContentLoaded', function() {
      updateTimerUI();

      // Stagger card appearances
      var cards = document.querySelectorAll('.question-card');
      cards.forEach(function(c, idx) {
        c.style.animationDelay = (0.05 * idx + 0.3) + 's';
      });

      // Click handlers for option labels
      document.querySelectorAll('.option-label').forEach(function(lbl) {
        lbl.addEventListener('click', function() {
          var input = this.querySelector('input[type=radio]');
          if (input) input.checked = true;
          setTimeout(trackAnswers, 50);
        });
      });

      trackAnswers();
    });
  </script>
</head>

<%-- Start timer on page load --%>
<body onload="timer(); AC.init();" class="ac-active">

<%
  ArrayList<Questions> allQuestions = QuestionsDao.getAllRecords();
  int totalQ = allQuestions.size();
%>

<div class="blob blob-green"></div>
<div class="blob blob-pink"></div>

<!-- 1-MINUTE WARNING TOAST (existing) -->
<div id="toastWarning">?? Only 1 minute remaining! Submit soon.</div>

<!-- ???????????????????????????????????????????????????
     ANTI-CHEAT: Modal overlay
     ??????????????????????????????????????????????????? -->
<div id="ac-overlay">
  <div id="ac-card">
    <div class="ac-icon-wrap">??</div>
    <div id="ac-title">Warning Detected</div>
    <p   id="ac-msg">Suspicious activity has been detected.</p>
    <div class="ac-bar-wrap">
      <div class="ac-bar-fill" id="ac-bar" style="width:0%"></div>
    </div>
    <div class="ac-bar-label" id="ac-bar-label">Violations: 0 / 3</div>
    <div class="ac-btn-row">
      <button class="ac-btn ac-btn-secondary" id="ac-btn-fs">Go Fullscreen</button>
      <button class="ac-btn ac-btn-primary"   id="ac-btn-ok">I Understand</button>
    </div>
  </div>
</div>

<!-- ANTI-CHEAT: Auto-submit banner -->
<div id="ac-banner">? Maximum violations reached ? submitting your exam automatically?</div>

<!-- ANTI-CHEAT: Small toast -->
<div id="ac-toast"></div>

<!-- STICKY TOPBAR -->
<div class="topbar">
  <div class="logo">exam<span>ily</span></div>

  <div style="display:flex;align-items:center;gap:12px;">
    <!-- ANTI-CHEAT: Violation counter badge -->
    <div class="ac-vbadge" id="ac-vbadge">
      <div class="ac-vbadge-dot"></div>
      Violations: <span id="ac-vcount">0</span>/3
    </div>

    <div class="q-badge">Unanswered: <span id="qLeft"><%=totalQ%></span></div>

    <div class="timer-wrap">
      <svg class="timer-ring" viewBox="0 0 38 38">
        <circle class="ring-bg"    cx="19" cy="19" r="16"/>
        <circle class="ring-track" cx="19" cy="19" r="16"/>
      </svg>
      <div>
        <div class="timer-label">Time Left</div>
        <div class="timer-display" id="timerDisplay">--:--</div>
      </div>
    </div>
  </div>
</div>

<!-- MAIN PAGE -->
<div class="page">

  <div class="exam-header">
    <h1 class="exam-title">Online <span class="highlight">Examination</span></h1>
    <p class="exam-meta">
      <%=totalQ%> Questions &nbsp;&middot;&nbsp;
      Logged in as: <%=session.getAttribute("name") != null ? session.getAttribute("name") : "Student"%>
    </p>
  </div>

  <!-- Progress strip -->
  <div class="progress-strip">
    <div class="progress-fill"></div>
  </div>

  <%-- Exam form ? id="examForm" is required for auto-submit on timeout / anti-cheat --%>
  <form action="Result.jsp" name="formb" id="examForm">
    <%-- Pass examId so SubmitServlet / Result.jsp can clear the session timer --%>
    <input type="hidden" name="examId"     value="<%= examId %>">
    <%-- ANTI-CHEAT: violation count kept in sync by JS --%>
    <input type="hidden" name="violations" value="0" id="ac-violations-field">

    <%
    int i = 0;
    int radioname = 0;
    for (Questions e : allQuestions) {
    %>
    <div class="question-card" id="card-<%=radioname%>">
      <div class="q-header">
        <div class="q-number">Q<%=i + 1%></div>
        <div class="q-text"><%=e.getQuestion()%></div>
      </div>
      <div class="options">
        <label class="option-label">
          <input type="radio" value="a" name="<%=radioname%>">
          <div class="opt-key">A</div>
          <div class="opt-text"><%=e.getA()%></div>
        </label>
        <label class="option-label">
          <input type="radio" value="b" name="<%=radioname%>">
          <div class="opt-key">B</div>
          <div class="opt-text"><%=e.getB()%></div>
        </label>
        <label class="option-label">
          <input type="radio" value="c" name="<%=radioname%>">
          <div class="opt-key">C</div>
          <div class="opt-text"><%=e.getC()%></div>
        </label>
        <label class="option-label">
          <input type="radio" value="d" name="<%=radioname%>">
          <div class="opt-key">D</div>
          <div class="opt-text"><%=e.getD()%></div>
        </label>
      </div>
      <!-- Hidden "unattempted" default -->
      <input type="radio" value="e" name="<%=radioname%>" checked style="display:none;">
    </div>
    <%
      i++;
      radioname++;
    }
    %>

    <div class="submit-wrap">
      <p class="submit-note">Review all questions before submitting.</p>
      <button class="btn-submit" type="submit">Submit Exam</button>
    </div>
  </form>

  <footer>&copy; 2026 Examily, Inc.</footer>
</div>


<!-- ???????????????????????????????????????????????????????????????
     ANTI-CHEAT SCRIPT
     Placed at end of <body> so DOM is ready.
     Uses a namespaced object (AC) ? zero interference with timer.
???????????????????????????????????????????????????????????????? -->
<script>
var AC = (function () {
  'use strict';

  /* ?? Config ??????????????????????????????? */
  var MAX_VIOLATIONS = 3;
  /* ????????????????????????????????????????? */

  var violations    = 0;
  var modalOpen     = false;
  var fsTriggered   = false; // guard: don't fire on intentional close

  /* ?? DOM refs (resolved after DOMContentLoaded / body onload) ?? */
  function el(id) { return document.getElementById(id); }

  /* ?? VIOLATION ENGINE ?????????????????????????????????????????? */
  function record(reason) {
    violations++;
    syncField();
    syncBadge();

    if (violations >= MAX_VIOLATIONS) {
      triggerAutoSubmit();
      return;
    }
    showModal(reason);
  }

  function syncField() {
    var f = el('ac-violations-field');
    if (f) f.value = violations;
  }

  function syncBadge() {
    var cnt   = el('ac-vcount');
    var badge = el('ac-vbadge');
    if (cnt)   cnt.textContent = violations;
    if (badge) {
      badge.classList.add('ac-hit');
      setTimeout(function () { badge.classList.remove('ac-hit'); }, 600);
    }
    // update modal bar
    var pct = Math.min((violations / MAX_VIOLATIONS) * 100, 100);
    var bar = el('ac-bar');
    var lbl = el('ac-bar-label');
    if (bar) bar.style.width = pct + '%';
    if (lbl) lbl.textContent = 'Violations: ' + violations + ' / ' + MAX_VIOLATIONS;
  }

  /* ?? AUTO-SUBMIT ??????????????????????????????????????????????? */
  function triggerAutoSubmit() {
    var banner = el('ac-banner');
    if (banner) banner.classList.add('ac-show');
    hideModal();

    // Reuse the timer's autoSubmitted flag so the timer loop exits cleanly
    autoSubmitted = true;

    setTimeout(function () {
      var form = el('examForm');
      if (form) form.submit();
    }, 2500);
  }

  /* ?? MODAL ????????????????????????????????????????????????????? */
  function showModal(msg) {
    if (modalOpen) return;
    modalOpen = true;

    var overlay = el('ac-overlay');
    var msgEl   = el('ac-msg');
    var card    = el('ac-card');

    if (msgEl)   msgEl.textContent = msg;
    if (overlay) overlay.classList.add('ac-show');

    // shake
    if (card) {
      card.style.animation = 'none';
      void card.offsetWidth;
      card.style.animation = 'acShake 0.4s ease';
    }
    syncBadge();
  }

  function hideModal() {
    modalOpen = false;
    var overlay = el('ac-overlay');
    if (overlay) overlay.classList.remove('ac-show');
  }

  /* ?? TOAST ????????????????????????????????????????????????????? */
  function toast(msg, ms) {
    var t = el('ac-toast');
    if (!t) return;
    t.textContent = msg;
    t.classList.add('ac-show');
    setTimeout(function () { t.classList.remove('ac-show'); }, ms || 3000);
  }

  /* ?? 1. TAB-SWITCH / VISIBILITY ???????????????????????????????? */
  function initVisibility() {
    document.addEventListener('visibilitychange', function () {
      if (document.hidden) {
        record('Tab switching detected. This may be considered cheating.');
      }
    });
    window.addEventListener('blur', function () {
      if (document.visibilityState === 'visible') {
        record('Browser window lost focus. Please stay on the exam tab.');
      }
    });
  }

  /* ?? 2. FULLSCREEN ????????????????????????????????????????????? */
  function requestFS() {
    var d = document.documentElement;
    var fn = d.requestFullscreen || d.webkitRequestFullscreen
           || d.mozRequestFullScreen || d.msRequestFullscreen;
    if (fn) {
      fn.call(d).catch(function () {
        toast('Fullscreen request denied. Please allow fullscreen for this exam.');
      });
    }
  }

  function initFullscreen() {
    requestFS();

    function onChange() {
      var active = document.fullscreenElement || document.webkitFullscreenElement
                 || document.mozFullScreenElement || document.msFullscreenElement;
      if (!active) {
        record('Fullscreen mode was exited. Please remain in fullscreen during the exam.');
      }
    }

    document.addEventListener('fullscreenchange',       onChange);
    document.addEventListener('webkitfullscreenchange', onChange);
    document.addEventListener('mozfullscreenchange',    onChange);
    document.addEventListener('MSFullscreenChange',     onChange);
  }

  /* ?? 3. COPY / PASTE / RIGHT-CLICK ???????????????????????????? */
  function initInputLock() {
    document.addEventListener('contextmenu', function (e) {
      e.preventDefault();
      toast('Right-click is disabled during the exam.');
    });
    document.addEventListener('copy',  function (e) { e.preventDefault(); toast('Copying is not allowed.'); });
    document.addEventListener('paste', function (e) { e.preventDefault(); toast('Pasting is not allowed.'); });
    document.addEventListener('cut',   function (e) { e.preventDefault(); toast('Cutting is not allowed.'); });

    document.addEventListener('keydown', function (e) {
      var ctrl = e.ctrlKey || e.metaKey;
      if (ctrl && ['c','v','x','a','u','s','p'].indexOf(e.key.toLowerCase()) !== -1) {
        e.preventDefault();
        toast('Keyboard shortcut disabled during exam.');
      }
      if (e.key === 'F12') {
        e.preventDefault();
        toast('Developer tools are disabled during the exam.');
      }
    });
  }

  /* ?? BUTTON WIRING ????????????????????????????????????????????? */
  function wireButtons() {
    var btnOk = el('ac-btn-ok');
    var btnFs = el('ac-btn-fs');
    if (btnOk) btnOk.addEventListener('click', hideModal);
    if (btnFs) btnFs.addEventListener('click', function () { requestFS(); hideModal(); });
  }

  /* ?? PUBLIC INIT ??????????????????????????????????????????????? */
  function init() {
    wireButtons();
    initVisibility();
    initFullscreen();
    initInputLock();
  }

  return { init: init };
})();
</script>

</body>
</html>
