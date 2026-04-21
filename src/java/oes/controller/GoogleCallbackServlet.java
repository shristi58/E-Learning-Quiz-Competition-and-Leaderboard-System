package oes.controller;

import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeTokenRequest;
import com.google.api.client.googleapis.auth.oauth2.GoogleTokenResponse;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.Collections;
import oes.db.Admins;
import oes.model.AdminsDao;

@WebServlet("/GoogleCallbackServlet")
public class GoogleCallbackServlet extends HttpServlet {

    private static final String CLIENT_ID = System.getenv("GOOGLE_CLIENT_ID");
    private static final String CLIENT_SECRET = System.getenv("GOOGLE_CLIENT_SECRET");
    private static final String REDIRECT_URI = "http://localhost:8080/Online-Quiz-System/GoogleCallbackServlet";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String code = request.getParameter("code");

        if (code == null) {
            response.sendRedirect("AdminLogin.jsp?msg2=Google+login+failed");
            return;
        }

        if (CLIENT_ID == null || CLIENT_ID.isEmpty() || CLIENT_SECRET == null || CLIENT_SECRET.isEmpty()) {
            response.sendRedirect("AdminLogin.jsp?msg2=Google+OAuth+is+not+configured");
            return;
        }

        try {
            GoogleTokenResponse tokenResponse = new GoogleAuthorizationCodeTokenRequest(
                new NetHttpTransport(),
                GsonFactory.getDefaultInstance(),
                "https://oauth2.googleapis.com/token",
                CLIENT_ID,
                CLIENT_SECRET,
                code,
                REDIRECT_URI
            ).execute();

            GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(
                new NetHttpTransport(), GsonFactory.getDefaultInstance())
                .setAudience(Collections.singletonList(CLIENT_ID))
                .build();

            GoogleIdToken idToken = verifier.verify(tokenResponse.getIdToken());

            if (idToken != null) {
                GoogleIdToken.Payload payload = idToken.getPayload();
                String email = payload.getEmail();

                // Check if email exists in DB
                Admins admin = AdminsDao.getAdminByEmail(email);

                if (admin != null) {
                    HttpSession session = request.getSession();
                    session.setAttribute("username", admin.getUsername()); // ← AdminPanel.jsp needs this
                    session.setAttribute("adminEmail", email);
                    response.sendRedirect("AdminPanel.jsp");
                } else {
                    response.sendRedirect("AdminLogin.jsp?msg2=Google+account+not+registered+as+Admin");
                }

            } else {
                response.sendRedirect("AdminLogin.jsp?msg2=Invalid+token");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("AdminLogin.jsp?msg2=OAuth+error");
        }
    }
}
