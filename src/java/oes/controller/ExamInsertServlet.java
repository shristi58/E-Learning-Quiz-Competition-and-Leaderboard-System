package oes.controller;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import oes.db.Exams;
import oes.model.ExamsDao;

@WebServlet("/ExamInsertServlet")
public class ExamInsertServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Guard: admin must be logged in
        if (request.getSession().getAttribute("username") == null) {
            response.sendRedirect("AdminLogin.jsp");
            return;
        }

        String examName = request.getParameter("examName");
        String durationParam = request.getParameter("duration");

        if (examName == null || examName.trim().isEmpty()
                || durationParam == null || durationParam.trim().isEmpty()) {
            response.sendRedirect("ManageExam.jsp?msg2=Please fill all fields");
            return;
        }

        int duration = 30; // fallback default
        try {
            duration = Integer.parseInt(durationParam);
        } catch (NumberFormatException e) {
            response.sendRedirect("ManageExam.jsp?msg2=Invalid duration value");
            return;
        }

        Exams exam = new Exams();
        exam.setExamName(examName.trim());
        exam.setDuration(duration);

        boolean status = ExamsDao.insertExam(exam);
        if (status) {
            response.sendRedirect("ManageExam.jsp?msg1=Exam created successfully!");
        } else {
            response.sendRedirect("ManageExam.jsp?msg2=Failed to create exam. Try again.");
        }
    }
}