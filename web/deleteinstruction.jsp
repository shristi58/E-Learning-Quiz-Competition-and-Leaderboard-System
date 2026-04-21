<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="oes.db.*" %>
<%@page import="oes.model.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete Instruction</title>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: #f5f5f5;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #1a1a1a;
        }

        .card {
            background: #fff;
            border-radius: 12px;
            border: 0.5px solid rgba(0,0,0,0.12);
            padding: 2rem;
            max-width: 420px;
            width: 90%;
            text-align: center;
        }

        .icon-wrap {
            width: 56px;
            height: 56px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.25rem;
        }

        .icon-wrap.danger  { background: #fef2f2; }
        .icon-wrap.success { background: #f0fdf4; }
        .icon-wrap.error   { background: #fff7ed; }

        .icon-wrap svg { width: 28px; height: 28px; }

        h2 {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .subtitle {
            font-size: 14px;
            color: #6b7280;
            margin-bottom: 1.5rem;
            line-height: 1.5;
        }

        .instruction-box {
            background: #f9fafb;
            border: 0.5px solid rgba(0,0,0,0.1);
            border-radius: 8px;
            padding: 0.75rem 1rem;
            font-size: 14px;
            color: #374151;
            margin-bottom: 1.75rem;
            word-break: break-word;
            text-align: left;
        }

        .instruction-label {
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #9ca3af;
            margin-bottom: 4px;
        }

        .btn-row {
            display: flex;
            gap: 10px;
        }

        .btn {
            flex: 1;
            padding: 0.6rem 1rem;
            font-size: 14px;
            font-weight: 500;
            border-radius: 8px;
            cursor: pointer;
            border: 0.5px solid transparent;
            transition: opacity 0.15s, transform 0.1s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .btn:active { transform: scale(0.98); }

        .btn-cancel {
            background: #fff;
            border-color: rgba(0,0,0,0.15);
            color: #374151;
        }
        .btn-cancel:hover { background: #f9fafb; }

        .btn-delete {
            background: #ef4444;
            color: #fff;
            border-color: #dc2626;
        }
        .btn-delete:hover { background: #dc2626; }

        .btn-primary {
            background: #3b82f6;
            color: #fff;
            border-color: #2563eb;
            width: 100%;
        }
        .btn-primary:hover { background: #2563eb; }

        .state { display: none; }
        .state.active { display: block; }

        .result-msg {
            font-size: 15px;
            font-weight: 500;
            margin-bottom: 0.35rem;
        }
        .result-sub {
            font-size: 13px;
            color: #6b7280;
            margin-bottom: 1.5rem;
        }
    </style>
</head>
<body>

<%
    String inst = request.getParameter("inst");
    String action = request.getParameter("action");
    boolean confirmed = "confirm".equals(action);
    int deleteStatus = 0;
    boolean hasParam = inst != null && !inst.trim().isEmpty();
%>

<div class="card">

    <%-- Step 1: Confirmation prompt --%>
    <% if (hasParam && !confirmed) { %>
    <div class="state active" id="confirm-state">
        <div class="icon-wrap danger">
            <svg viewBox="0 0 24 24" fill="none" stroke="#ef4444" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <polyline points="3 6 5 6 21 6"/>
                <path d="M19 6l-1 14H6L5 6"/>
                <path d="M10 11v6M14 11v6"/>
                <path d="M9 6V4h6v2"/>
            </svg>
        </div>
        <h2>Delete instruction?</h2>
        <p class="subtitle">This action cannot be undone. The following instruction will be permanently removed.</p>
        <div class="instruction-box">
            <div class="instruction-label">Instruction</div>
            <%= inst %>
        </div>
        <div class="btn-row">
            <a href="InstructionList.jsp" class="btn btn-cancel">Cancel</a>
            <form method="post" action="DeleteInstruction.jsp" style="flex:1; margin:0;">
                <input type="hidden" name="inst" value="<%= inst %>">
                <input type="hidden" name="action" value="confirm">
                <button type="submit" class="btn btn-delete" style="width:100%;">Delete</button>
            </form>
        </div>
    </div>
    <% } %>

    <%-- Step 2: Perform deletion and show result --%>
    <% if (confirmed && hasParam) {
        Instructions i = new Instructions();
        i.setInstruction(inst);
        deleteStatus = InstructionsDao.deleteRecord(i);
    %>

    <% if (deleteStatus > 0) { %>
    <div class="state active" id="success-state">
        <div class="icon-wrap success">
            <svg viewBox="0 0 24 24" fill="none" stroke="#22c55e" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M20 6L9 17l-5-5"/>
            </svg>
        </div>
        <p class="result-msg">Instruction deleted</p>
        <p class="result-sub">The instruction has been permanently removed.</p>
        <a href="InstructionList.jsp" class="btn btn-primary">Back to instructions</a>
    </div>
    <% } else { %>
    <div class="state active" id="error-state">
        <div class="icon-wrap error">
            <svg viewBox="0 0 24 24" fill="none" stroke="#f97316" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="12" cy="12" r="10"/>
                <line x1="12" y1="8" x2="12" y2="12"/>
                <line x1="12" y1="16" x2="12.01" y2="16"/>
            </svg>
        </div>
        <p class="result-msg">Deletion failed</p>
        <p class="result-sub">Something went wrong. The instruction could not be deleted. Please try again.</p>
        <div class="btn-row">
            <a href="InstructionList.jsp" class="btn btn-cancel">Cancel</a>
            <form method="post" action="DeleteInstruction.jsp" style="flex:1; margin:0;">
                <input type="hidden" name="inst" value="<%= inst %>">
                <input type="hidden" name="action" value="confirm">
                <button type="submit" class="btn btn-delete" style="width:100%;">Retry</button>
            </form>
        </div>
    </div>
    <% } %>
    <% } %>

    <%-- Edge case: no instruction param --%>
    <% if (!hasParam) { %>
    <div class="state active">
        <div class="icon-wrap error">
            <svg viewBox="0 0 24 24" fill="none" stroke="#f97316" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="12" cy="12" r="10"/>
                <line x1="12" y1="8" x2="12" y2="12"/>
                <line x1="12" y1="16" x2="12.01" y2="16"/>
            </svg>
        </div>
        <p class="result-msg">No instruction specified</p>
        <p class="result-sub">A valid instruction parameter is required to proceed.</p>
        <a href="InstructionList.jsp" class="btn btn-primary">Back to instructions</a>
    </div>
    <% } %>

</div>
</body>
</html>

