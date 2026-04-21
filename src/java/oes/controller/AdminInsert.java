package oes.controller;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import oes.db.Admins;
import oes.model.AdminsDao;

@WebServlet("/AdminInsert")
public class AdminInsert extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String firstName = request.getParameter("firstName");
        String lastName  = request.getParameter("lastName");
        String email     = request.getParameter("email");
        String password  = request.getParameter("password");

        String userid = (firstName + lastName).toLowerCase().replaceAll("\\s+", "");

        Admins ad = new Admins();
        ad.setUsername(userid);
        ad.setPassword(password);
        ad.setEmail(email);

        boolean status = AdminsDao.insertAdmin(ad);

        if (status) {
            response.sendRedirect("AdminLogin.jsp?msg1=Account+created!+Login+with+username:+" + userid);
        } else {
            response.sendRedirect("SignUp.jsp?error=Account+creation+failed");
        }
    }
}