package oes.controller;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import oes.db.Exams;
import oes.model.ExamsDao;

@WebServlet("/StartExamServlet")
public class StartExamServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Guard: student must be logged in
        if (session.getAttribute("username") == null) {
            response.sendRedirect("StudentLogin.jsp");
            return;
        }

        // Default to examId=1 if not provided
        int examId = 1;
        try {
            examId = Integer.parseInt(request.getParameter("examId"));
        } catch (Exception ex) { /* use default */ }

        try {
            Exams exam = ExamsDao.getExamById(examId);
            if (exam != null) {
                String sessionKey = "examEndTime_" + examId;
                // Only register end-time once — preserves timer on page refresh
                if (session.getAttribute(sessionKey) == null) {
                    long endTime = System.currentTimeMillis()
                                   + ((long) exam.getDuration() * 60 * 1000);
                    session.setAttribute(sessionKey, endTime);
                }
                session.setAttribute("currentExamId",       examId);
                session.setAttribute("currentExamDuration", exam.getDuration());

                // ── ANTI-CHEAT: Reset violation counter for a fresh attempt ──
                session.setAttribute("examViolations_" + examId, 0);
                // ─────────────────────────────────────────────────────────────
            }
        } catch (Exception e) {
            System.out.println("ERROR! -> StartExamServlet");
            System.out.println(e);
        }

        response.sendRedirect("Exam.jsp?examId=" + examId);
    }

    // ── ANTI-CHEAT: Handle POST from exam form submission ────────────────────
    // Result.jsp currently receives the POST from examForm (action="Result.jsp").
    // If you ever route through this servlet instead, this method is ready.
    // For now, read the violation count inside Result.jsp or wherever the form
    // currently submits — see the note below.
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * Call this static helper from Result.jsp (or whichever page/servlet
     * receives the examForm POST) to persist the violation count.
     *
     * Usage in Result.jsp:
     *   <%
     *     int v = StartExamServlet.readViolations(request, session);
     *     // v is now available for display or DB storage
     *   %>
     */
    public static int readViolations(HttpServletRequest request, HttpSession session) {
        int violations = 0;
        String param = request.getParameter("violations");
        if (param != null && !param.trim().isEmpty()) {
            try { violations = Integer.parseInt(param.trim()); }
            catch (NumberFormatException ignored) {}
        }

        // Retrieve the examId to scope the session key
        int examId = 1;
        try {
            String eid = request.getParameter("examId");
            if (eid != null) examId = Integer.parseInt(eid);
        } catch (Exception ignored) {}

        // Store on session for Result.jsp to display
        session.setAttribute("examViolations_" + examId, violations);

        System.out.println("[AntiCheat] Exam " + examId
                + " submitted with " + violations + " violation(s).");
        return violations;
    }
}
