<%-- 
    Document   : updatequestionnow
    Created on : 4 Jul 2022, 13:23:18
    Author     : adrianadewunmi
--%>
<%@page import="oes.model.QuestionsDao"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Update Question</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --bg:           #080b12;
            --surface:      #0f1320;
            --surface2:     #141826;
            --border:       #1e2436;
            --border2:      #252d42;
            --accent:       #4f7cff;
            --accent-glow:  rgba(79, 124, 255, 0.20);
            --accent-soft:  rgba(79, 124, 255, 0.08);
            --amber:        #f5a623;
            --amber-glow:   rgba(245, 166, 35, 0.18);
            --amber-soft:   rgba(245, 166, 35, 0.07);
            --red:          #e8423a;
            --red-glow:     rgba(232, 66, 58, 0.18);
            --red-soft:     rgba(232, 66, 58, 0.07);
            --green:        #2ecc8f;
            --green-glow:   rgba(46, 204, 143, 0.18);
            --text:         #dde2f0;
            --muted:        #5a6380;
            --muted2:       #8892a8;
        }

        body {
            background: var(--bg);
            color: var(--text);
            font-family: 'Plus Jakarta Sans', sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 32px 16px;
            overflow-x: hidden;
        }

        /* Background grid */
        body::before {
            content: '';
            position: fixed; inset: 0;
            background-image:
                linear-gradient(rgba(79,124,255,0.03) 1px, transparent 1px),
                linear-gradient(90deg, rgba(79,124,255,0.03) 1px, transparent 1px);
            background-size: 48px 48px;
            pointer-events: none; z-index: 0;
        }

        /* Ambient blobs */
        .blob {
            position: fixed; border-radius: 50%;
            filter: blur(100px); pointer-events: none; z-index: 0;
        }
        .blob-1 { width: 500px; height: 500px; top: -180px; left: -180px;
                  background: radial-gradient(circle, rgba(79,124,255,0.09) 0%, transparent 70%); }
        .blob-2 { width: 400px; height: 400px; bottom: -140px; right: -140px;
                  background: radial-gradient(circle, rgba(245,166,35,0.07) 0%, transparent 70%); }

        /* ??? CARD ??? */
        .card {
            position: relative; z-index: 1;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 24px;
            width: 560px; max-width: 100%;
            box-shadow: 0 32px 80px rgba(0,0,0,0.55);
            overflow: hidden;
            animation: fadeUp 0.55s cubic-bezier(0.22,1,0.36,1) both;
        }
        @keyframes fadeUp {
            from { opacity:0; transform: translateY(28px) scale(0.97); }
            to   { opacity:1; transform: translateY(0)    scale(1);    }
        }

        /* Top accent stripe */
        .card-stripe {
            height: 4px;
            background: linear-gradient(90deg, var(--accent) 0%, #7c56ff 50%, var(--amber) 100%);
        }

        .card-body { padding: 36px 40px 40px; }

        /* ??? HEADER ??? */
        .header { display: flex; align-items: flex-start; gap: 16px; margin-bottom: 28px; }
        .icon-box {
            width: 52px; height: 52px; flex-shrink: 0;
            border-radius: 14px;
            display: flex; align-items: center; justify-content: center;
        }
        .icon-box svg { width: 24px; height: 24px; fill: none; stroke-width: 2.2; }

        /* success */
        .state-success .icon-box { background: rgba(46,204,143,0.1); border: 1px solid rgba(46,204,143,0.25); }
        .state-success .icon-box svg { stroke: var(--green); }
        .state-success .badge { background: rgba(46,204,143,0.1); color: var(--green); border-color: rgba(46,204,143,0.25); }
        .state-success .card-stripe { background: linear-gradient(90deg, var(--green), #0fa86a); }
        .state-success .btn-primary { background: var(--green); box-shadow: 0 0 28px var(--green-glow); }
        .state-success .btn-primary:hover { box-shadow: 0 0 44px rgba(46,204,143,0.32); }
        .state-success .progress-fill { background: var(--green); }

        /* db error */
        .state-dberror .icon-box { background: var(--red-soft); border: 1px solid rgba(232,66,58,0.25); }
        .state-dberror .icon-box svg { stroke: var(--red); }
        .state-dberror .badge { background: var(--red-soft); color: var(--red); border-color: rgba(232,66,58,0.25); }
        .state-dberror .card-stripe { background: linear-gradient(90deg, var(--red), #c0392b); }
        .state-dberror .btn-primary { background: var(--red); box-shadow: 0 0 28px var(--red-glow); }
        .state-dberror .btn-primary:hover { box-shadow: 0 0 44px rgba(232,66,58,0.32); }

        /* exception */
        .state-exception .icon-box { background: var(--amber-soft); border: 1px solid rgba(245,166,35,0.25); }
        .state-exception .icon-box svg { stroke: var(--amber); }
        .state-exception .badge { background: var(--amber-soft); color: var(--amber); border-color: rgba(245,166,35,0.25); }
        .state-exception .card-stripe { background: linear-gradient(90deg, var(--amber), #e67e22); }
        .state-exception .btn-primary { background: var(--amber); color: #0d1016; box-shadow: 0 0 28px var(--amber-glow); }
        .state-exception .btn-primary:hover { box-shadow: 0 0 44px rgba(245,166,35,0.32); }

        .header-text { flex: 1; }
        .badge {
            display: inline-flex; align-items: center; gap: 6px;
            font-size: 10px; font-weight: 700; letter-spacing: 0.09em; text-transform: uppercase;
            padding: 3px 11px; border-radius: 99px; border: 1px solid transparent;
            margin-bottom: 8px;
        }
        .badge::before {
            content: ''; width: 5px; height: 5px; border-radius: 50%;
            background: currentColor;
            animation: blink 1.8s ease-in-out infinite;
        }
        @keyframes blink { 0%,100%{opacity:1} 50%{opacity:0.35} }

        .headline {
            font-size: 22px; font-weight: 800;
            letter-spacing: -0.02em; line-height: 1.2;
        }
        .state-success   .headline { color: var(--green); }
        .state-dberror   .headline { color: var(--red); }
        .state-exception .headline { color: var(--amber); }

        /* ??? DESCRIPTION ??? */
        .desc {
            font-size: 13.5px; color: var(--muted2); line-height: 1.65;
            margin-bottom: 24px;
        }
        .desc strong { color: var(--text); font-weight: 600; }

        /* ??? DIFF PANEL ??? */
        .diff-panel {
            background: var(--surface2);
            border: 1px solid var(--border);
            border-radius: 14px;
            overflow: hidden;
            margin-bottom: 24px;
        }
        .diff-header {
            padding: 10px 16px;
            border-bottom: 1px solid var(--border);
            font-size: 10px; font-weight: 700; letter-spacing: 0.08em;
            text-transform: uppercase; color: var(--muted);
            display: flex; align-items: center; gap: 8px;
        }
        .diff-header::before {
            content: ''; width: 8px; height: 8px; border-radius: 2px;
            background: var(--accent); flex-shrink: 0;
        }
        .diff-row {
            display: grid; grid-template-columns: 80px 1fr;
            border-bottom: 1px solid var(--border);
        }
        .diff-row:last-child { border-bottom: none; }
        .diff-label {
            padding: 10px 14px;
            font-size: 10px; font-weight: 700; letter-spacing: 0.07em;
            text-transform: uppercase; color: var(--muted);
            border-right: 1px solid var(--border);
            display: flex; align-items: center;
            background: rgba(255,255,255,0.015);
        }
        .diff-value {
            padding: 10px 14px;
            font-family: 'JetBrains Mono', monospace;
            font-size: 12px; color: var(--text);
            word-break: break-word; line-height: 1.5;
        }
        .diff-row.was .diff-value  { color: #e05555; background: rgba(232,66,58,0.04); }
        .diff-row.now .diff-value  { color: var(--green); background: rgba(46,204,143,0.04); }

        /* ??? META CHIPS ??? */
        .chips { display: flex; flex-wrap: wrap; gap: 8px; margin-bottom: 24px; }
        .chip {
            background: rgba(255,255,255,0.03);
            border: 1px solid var(--border2);
            border-radius: 8px; padding: 7px 12px;
            font-size: 11px; color: var(--muted2); line-height: 1;
        }
        .chip span { font-weight: 700; color: var(--text); margin-left: 5px; }

        /* ??? DIVIDER ??? */
        .divider { height: 1px; background: var(--border); margin: 6px 0 24px; }

        /* ??? BUTTONS ??? */
        .btn-primary {
            display: block; width: 100%; padding: 14px;
            border: none; border-radius: 11px;
            font-family: 'Plus Jakarta Sans', sans-serif;
            font-size: 14px; font-weight: 700; letter-spacing: 0.02em;
            color: #fff; cursor: pointer; text-decoration: none; text-align: center;
            transition: transform 0.15s, box-shadow 0.25s;
        }
        .btn-primary:hover  { transform: translateY(-1px); }
        .btn-primary:active { transform: translateY(0); }

        .btn-ghost {
            display: block; width: 100%; padding: 13px;
            border: 1px solid var(--border2); border-radius: 11px;
            background: transparent;
            font-family: 'Plus Jakarta Sans', sans-serif;
            font-size: 14px; font-weight: 600; letter-spacing: 0.01em;
            color: var(--muted2); cursor: pointer; text-decoration: none; text-align: center;
            margin-top: 10px;
            transition: border-color 0.2s, color 0.2s, background 0.2s;
        }
        .btn-ghost:hover { border-color: #3a3d4a; color: var(--text); background: rgba(255,255,255,0.03); }

        /* ??? PROGRESS BAR ??? */
        .progress-wrap {
            height: 3px; background: rgba(255,255,255,0.05);
            border-radius: 99px; overflow: hidden; margin-top: 18px;
        }
        .progress-fill {
            height: 100%; border-radius: 99px;
            animation: shrink 3s linear forwards;
            transform-origin: left;
        }
        @keyframes shrink { from { transform: scaleX(1); } to { transform: scaleX(0); } }
        .redirect-note { font-size: 12px; color: var(--muted); text-align: center; margin-top: 8px; }
    </style>
</head>
<body>
<div class="blob blob-1"></div>
<div class="blob blob-2"></div>

<%
    String originalQuestion = request.getParameter("quesoriginal");
    String newQuestion      = request.getParameter("quesmodified");
    String opta = request.getParameter("opta");
    String optb = request.getParameter("optb");
    String optc = request.getParameter("optc");
    String optd = request.getParameter("optd");
    String ans  = request.getParameter("ans");

    int status = QuestionsDao.doUpdateNowRecord(originalQuestion, newQuestion, opta, optb, optc, optd, ans);

    String stateClass, badgeText, headline, descText, btnLabel, btnHref;
    boolean isSuccess = false;

    if (status > 0) {
        isSuccess  = true;
        stateClass = "state-success";
        badgeText  = "Updated Successfully";
        headline   = "Question Updated";
        descText   = "The question has been saved to the database. You will be redirected to the question list shortly.";
        btnLabel   = "Go to Question List";
        btnHref    = "QuestionList.jsp";
        response.setHeader("Refresh", "3;url=QuestionList.jsp");
    } else if (status == -1) {
        stateClass = "state-dberror";
        badgeText  = "Database Error";
        headline   = "Database Error";
        descText   = "The update query ran but no records were affected. The question may not exist, or a constraint was violated.";
        btnLabel   = "Try Again";
        btnHref    = "javascript:history.back()";
    } else {
        stateClass = "state-exception";
        badgeText  = "Exception";
        headline   = "Unexpected Exception";
        descText   = "An unexpected server-side exception occurred while processing the update. Please check the server logs for details.";
        btnLabel   = "Try Again";
        btnHref    = "javascript:history.back()";
    }
%>

<div class="card <%= stateClass %>">
    <div class="card-stripe"></div>
    <div class="card-body">

        <!-- Header -->
        <div class="header">
            <div class="icon-box">
                <% if (isSuccess) { %>
                <svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
                <% } else if (status == -1) { %>
                <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                <% } else { %>
                <svg viewBox="0 0 24 24"><polygon points="10.29 3.86 1.82 18 22.18 18 13.71 3.86 10.29 3.86"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                <% } %>
            </div>
            <div class="header-text">
                <div class="badge"><%= badgeText %></div>
                <div class="headline"><%= headline %></div>
            </div>
        </div>

        <!-- Description -->
        <p class="desc"><%= descText %></p>

        <!-- Diff panel ? only on success -->
        <% if (isSuccess && originalQuestion != null && newQuestion != null) { %>
        <div class="diff-panel">
            <div class="diff-header">Question Change</div>
            <div class="diff-row was">
                <div class="diff-label">Before</div>
                <div class="diff-value"><%= originalQuestion %></div>
            </div>
            <div class="diff-row now">
                <div class="diff-label">After</div>
                <div class="diff-value"><%= newQuestion %></div>
            </div>
        </div>
        <% } %>

        <!-- Meta chips -->
        <div class="chips">
            <div class="chip">Option A <span><%= opta != null ? opta : "?" %></span></div>
            <div class="chip">Option B <span><%= optb != null ? optb : "?" %></span></div>
            <div class="chip">Option C <span><%= optc != null ? optc : "?" %></span></div>
            <div class="chip">Option D <span><%= optd != null ? optd : "?" %></span></div>
            <div class="chip">Answer <span><%= ans  != null ? ans  : "?" %></span></div>
            <div class="chip">Rows Affected <span><%= status %></span></div>
        </div>

        <div class="divider"></div>

        <!-- CTA -->
        <a href="<%= btnHref %>" class="btn-primary"><%= btnLabel %></a>

        <% if (!isSuccess) { %>
        <a href="QuestionList.jsp" class="btn-ghost">Back to Question List</a>
        <% } else { %>
        <div class="progress-wrap"><div class="progress-fill"></div></div>
        <p class="redirect-note">Redirecting in 3 seconds?</p>
        <% } %>

    </div>
</div>
</body>
</html>
