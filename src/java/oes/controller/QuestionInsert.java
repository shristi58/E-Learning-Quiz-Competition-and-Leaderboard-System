package oes.controller;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import oes.db.Questions;
import oes.model.QuestionsDao;

@WebServlet("/oes.controller.QuestionInsert")
public class QuestionInsert extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public QuestionInsert() { super(); }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── TIMER: clear session timer key after exam submit ──────────────────
        HttpSession session = request.getSession(false);
        if (session != null) {
            String ep = request.getParameter("examId");
            if (ep != null && !ep.trim().isEmpty()) {
                session.removeAttribute("examEndTime_" + ep);
                session.removeAttribute("currentExamId");
                session.removeAttribute("currentExamDuration");
            }
        }
        // ──────────────────────────────────────────────────────────────────────

        response.setContentType("text/html");

        String question = request.getParameter("Question");
        String a        = request.getParameter("option1");
        String b        = request.getParameter("option2");
        String c        = request.getParameter("option3");
        String d        = request.getParameter("option4");
        String answer   = request.getParameter("answer");

        // ── Which exam does this question belong to? ──────────────────────────
        int examId = 1; // fallback default
        try {
            String examIdStr = request.getParameter("examId");
            if (examIdStr != null && !examIdStr.trim().isEmpty()) {
                examId = Integer.parseInt(examIdStr);
            }
        } catch (NumberFormatException e) { /* keep default */ }
        // ──────────────────────────────────────────────────────────────────────

        Questions q = new Questions();
        q.setQuestion(question);
        q.setA(a);
        q.setB(b);
        q.setC(c);
        q.setD(d);
        q.setAnswer(answer);
        q.setExamId(examId);  // ← NEW: links question to the chosen exam

        boolean status = QuestionsDao.insertQuestion(q);
        if (status) {
            response.sendRedirect("AddQuestion.jsp?msg1=Question Added!");
        } else {
            response.sendRedirect("AddQuestion.jsp?msg2=Question Not Added!");
        }
    }
}