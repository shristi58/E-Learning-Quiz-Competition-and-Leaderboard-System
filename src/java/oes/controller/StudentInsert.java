/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package oes.controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import oes.db.Students;
import oes.model.StudentsDao;

/**
 * @author adrianadewunmi
 */
@WebServlet("/oes.controller.StudentInsert")
public class StudentInsert extends HttpServlet {

    public StudentInsert() {
        super();
    }

    /**
     * Handles the HTTP GET method.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");

        String username = request.getParameter("uname");
        String password = request.getParameter("pass");
        String name     = request.getParameter("name");

        Students st = new Students();
        st.setName(name);
        st.setPassword(password);
        st.setUsername(username);

        boolean status = StudentsDao.insertStudent(st);

        if (status) {
            String msg1 = "Student Added Successfully!";
            response.sendRedirect("AddStudent.jsp?msg1=" + msg1);
        } else {
            String msg2 = "Student Not Added. Please try again.";
            response.sendRedirect("AddStudent.jsp?msg2=" + msg2);
        }
    }

    /**
     * Handles the HTTP POST method — delegates to doGet.
     * This fixes the 405 Method Not Allowed error.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}