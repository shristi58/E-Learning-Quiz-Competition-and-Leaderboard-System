<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="oes.model.QuestionsDao" %>
<%
    // ── Guard: admin must be logged in ────────────────────────────────────────
    if (session.getAttribute("username") == null) {
        response.sendRedirect("AdminLogin.jsp");
        return;
    }

    // ── Read questionId, delete by primary key, redirect back ─────────────────
    String quesParam = request.getParameter("ques");
    if (quesParam != null && !quesParam.trim().isEmpty()) {
        try {
            int questionId = Integer.parseInt(quesParam.trim());
            QuestionsDao.deleteRecord(questionId);
        } catch (NumberFormatException e) {
            // bad param — just redirect
        }
    }

    response.sendRedirect("QuestionList.jsp?msg1=Question+deleted.");
%>
