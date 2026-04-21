package oes.controller;

import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeTokenRequest;
import com.google.api.client.googleapis.auth.oauth2.GoogleTokenResponse;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Collections;
import oes.db.Students;
import oes.model.StudentsDao;

public class StudentGoogleCallbackServlet extends HttpServlet {

    private static final String CLIENT_ID = System.getenv("GOOGLE_CLIENT_ID");
    private static final String CLIENT_SECRET = System.getenv("GOOGLE_CLIENT_SECRET");
    private static final String REDIRECT_URI = "http://localhost:8080/Online-Quiz-System/StudentGoogleCallbackServlet";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String code = request.getParameter("code");
        if (code == null) {
            response.sendRedirect("StudentLogin.jsp?msg2=Google+login+failed");
            return;
        }

        if (CLIENT_ID == null || CLIENT_ID.isEmpty() || CLIENT_SECRET == null || CLIENT_SECRET.isEmpty()) {
            response.sendRedirect("StudentLogin.jsp?msg2=Google+OAuth+is+not+configured");
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
                String name = (String) payload.get("name");

                // Check if student already exists
                Students student = StudentsDao.getStudentByEmail(email);

                if (student == null) {
                    // Auto-create account using email as userid
                    student = new Students();
                    student.setEmail(email);
                    student.setUsername(email); // use email as userid
                    student.setPassword("google_auth"); // placeholder password
                    student.setName(name);
                    StudentsDao.insertGoogleStudent(student);
                }

                // Set session — same keys as ValidateStudent
                HttpSession session = request.getSession();
                session.setAttribute("username", student.getUsername());
                session.setAttribute("name", student.getName());
                response.sendRedirect("StudentInstructions.jsp");

            } else {
                response.sendRedirect("StudentLogin.jsp?msg2=Invalid+token");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("StudentLogin.jsp?msg2=OAuth+error");
        }
    }
}
