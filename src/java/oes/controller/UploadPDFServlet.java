package oes.controller;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import oes.db.Questions;
import oes.model.QuestionsDao;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;

@WebServlet("/UploadPDFServlet")
@MultipartConfig
public class UploadPDFServlet extends HttpServlet {

    // -------------------------------------------------------------------------
    // IMPORTANT: Set your OpenRouter API key here directly.
    // Replace the value below with your actual key.
    // -------------------------------------------------------------------------
    private static final String OPENROUTER_API_KEY = "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";

    /**
     * Simple OpenRouter connection test (for debugging only).
     * Open in browser: /UploadPDFServlet
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain; charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            String apiResponse = testOpenRouterConnection(request);
            out.println(apiResponse);
        } catch (IOException e) {
            out.println("ERROR: " + e.getMessage());
        } finally {
            out.flush();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");

        try {
            Part pdfPart = request.getPart("pdfFile");
            if (pdfPart == null || pdfPart.getSize() == 0) {
                response.sendRedirect("AddQuestion.jsp?msg2=" + encodeMessage("Please choose a PDF file."));
                return;
            }

            String fileName = getSubmittedFileName(pdfPart);
            if (fileName == null || !fileName.toLowerCase().endsWith(".pdf")) {
                response.sendRedirect("AddQuestion.jsp?msg2=" + encodeMessage("Only PDF files are allowed."));
                return;
            }

            // Step 1: Extract plain text from the uploaded PDF.
            String extractedText = extractTextFromPdf(pdfPart);
            if (extractedText == null || extractedText.trim().isEmpty()) {
                response.sendRedirect("AddQuestion.jsp?msg2=" + encodeMessage("No readable text found in the PDF."));
                return;
            }

            // Step 2: Send the PDF text to OpenRouter and ask for 10 MCQs.
            String aiResponse = sendTextToOpenRouter(extractedText, request);

            // Step 3: Convert the AI response into Question objects.
            List<Questions> questions = parseQuestions(aiResponse);
            if (questions.isEmpty()) {
                response.sendRedirect("AddQuestion.jsp?msg2=" + encodeMessage("Could not parse questions from AI response."));
                return;
            }

            // Step 4: Save the generated questions using the existing DAO.
            int savedCount = saveQuestions(questions);

            if (savedCount > 0) {
                String message = savedCount + " questions saved successfully.";
                response.sendRedirect("AddQuestion.jsp?msg1=" + encodeMessage(message));
            } else {
                response.sendRedirect("AddQuestion.jsp?msg2=" + encodeMessage("Questions were generated but not saved."));
            }

        } catch (IOException | ServletException e) {
            response.sendRedirect("AddQuestion.jsp?msg2=" + encodeMessage("Upload failed: " + e.getMessage()));
        }
    }

    /**
     * Sends a fixed prompt to OpenRouter and returns the raw JSON response.
     * For debugging only — visit /UploadPDFServlet in browser to test.
     */
    private String testOpenRouterConnection(HttpServletRequest request) throws IOException {

        if (OPENROUTER_API_KEY == null || OPENROUTER_API_KEY.trim().isEmpty()) {
            throw new IOException("OPENROUTER_API_KEY is not set in the code.");
        }

        URL url = new URL("https://openrouter.ai/api/v1/chat/completions");
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();

        try {
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Content-Type", "application/json");
            connection.setRequestProperty("Authorization", "Bearer " + OPENROUTER_API_KEY);
            connection.setRequestProperty("HTTP-Referer", request.getRequestURL().toString());
            connection.setRequestProperty("X-Title", "Online Exam System - OpenRouter Test");
            connection.setDoOutput(true);

            JsonObject body = new JsonObject();
body.addProperty("model", "nvidia/nemotron-3-super-120b-a12b:free");
            JsonArray messages = new JsonArray();
            JsonObject userMessage = new JsonObject();
            userMessage.addProperty("role", "user");
            userMessage.addProperty("content", "Generate 2 MCQ questions about Java");
            messages.add(userMessage);
            body.add("messages", messages);

            try (OutputStream outputStream = connection.getOutputStream()) {
                outputStream.write(body.toString().getBytes("UTF-8"));
                outputStream.flush();
            }

            int code = connection.getResponseCode();
            InputStream stream = (code >= 200 && code < 300)
                    ? connection.getInputStream()
                    : connection.getErrorStream();

            String raw = stream != null ? readStream(stream) : "";
            return "HTTP " + code + "\n\n" + raw;

        } finally {
            connection.disconnect();
        }
    }

    // Reads the uploaded PDF and converts it into plain text using PDFBox.
    private String extractTextFromPdf(Part pdfPart) throws IOException {
        InputStream inputStream = null;
        PDDocument document = null;

        try {
            inputStream = pdfPart.getInputStream();
            document = PDDocument.load(inputStream);
            PDFTextStripper stripper = new PDFTextStripper();
            return stripper.getText(document);
        } finally {
            if (document != null) document.close();
            if (inputStream != null) inputStream.close();
        }
    }

    // Sends extracted PDF text to OpenRouter and asks for 10 MCQs in a fixed format.
    private String sendTextToOpenRouter(String extractedText, HttpServletRequest request) throws IOException {

        if (OPENROUTER_API_KEY == null || OPENROUTER_API_KEY.trim().isEmpty()) {
            throw new IOException("OPENROUTER_API_KEY is not set in the code.");
        }

        URL url = new URL("https://openrouter.ai/api/v1/chat/completions"); // OpenRouter URL
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();

        try {
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Content-Type", "application/json");
            connection.setRequestProperty("Authorization", "Bearer " + OPENROUTER_API_KEY);
            connection.setRequestProperty("HTTP-Referer", request.getRequestURL().toString());
            connection.setRequestProperty("X-Title", "Online Exam System");
            connection.setDoOutput(true);

            String prompt =
                    "Read the following study material and create exactly 10 multiple choice questions.\n"
                    + "Use only this format:\n\n"
                    + "Q1: Question?\n"
                    + "A) Option1\n"
                    + "B) Option2\n"
                    + "C) Option3\n"
                    + "D) Option4\n"
                    + "Answer: A\n\n"
                    + "Rules:\n"
                    + "1. Create exactly 10 questions.\n"
                    + "2. Keep answers as only A, B, C, or D.\n"
                    + "3. Do not add explanation.\n"
                    + "4. Keep the questions simple and clear.\n\n"
                    + "Study material:\n"
                    + extractedText;

            JsonObject requestBody = new JsonObject();
requestBody.addProperty("model", "nvidia/nemotron-3-super-120b-a12b:free");
            requestBody.addProperty("temperature", 0.7);

            JsonArray messages = new JsonArray();

            JsonObject systemMessage = new JsonObject();
            systemMessage.addProperty("role", "system");
            systemMessage.addProperty("content", "You are a helpful assistant that creates MCQ questions in a strict format.");
            messages.add(systemMessage);

            JsonObject userMessage = new JsonObject();
            userMessage.addProperty("role", "user");
            userMessage.addProperty("content", prompt);
            messages.add(userMessage);

            requestBody.add("messages", messages);

            try (OutputStream outputStream = connection.getOutputStream()) {
                outputStream.write(requestBody.toString().getBytes("UTF-8"));
                outputStream.flush();
            }

            int responseCode = connection.getResponseCode();
            InputStream responseStream;

            if (responseCode >= 200 && responseCode < 300) {
                responseStream = connection.getInputStream();
            } else {
                responseStream = connection.getErrorStream();
                String errorText = responseStream != null ? readStream(responseStream) : "Unknown API error.";
                throw new IOException("OpenRouter API error " + responseCode + ": " + errorText);
            }

            String responseText = readStream(responseStream);
            JsonObject jsonResponse = JsonParser.parseString(responseText).getAsJsonObject();
            return jsonResponse
                    .getAsJsonArray("choices")
                    .get(0).getAsJsonObject()
                    .getAsJsonObject("message")
                    .get("content").getAsString();

        } finally {
            connection.disconnect();
        }
    }

    // Parses text in the required MCQ format and turns it into Questions objects.
    private List<Questions> parseQuestions(String aiText) {
        List<Questions> questionList = new ArrayList<>();
        if (aiText == null || aiText.trim().isEmpty()) {
            return questionList;
        }

        String normalizedText = aiText.replace("\r", "").trim();
        String[] blocks = normalizedText.split("(?=Q\\d+:)");

        Pattern questionPattern = Pattern.compile("Q\\d+:\\s*(.+)");
        Pattern optionAPattern = Pattern.compile("A\\)\\s*(.+)");
        Pattern optionBPattern = Pattern.compile("B\\)\\s*(.+)");
        Pattern optionCPattern = Pattern.compile("C\\)\\s*(.+)");
        Pattern optionDPattern = Pattern.compile("D\\)\\s*(.+)");
        Pattern answerPattern = Pattern.compile("Answer:\\s*([A-Da-d])");

        for (String block1 : blocks) {
            String block = block1.trim();
            if (block.isEmpty()) continue;

            String questionText = getMatchedValue(questionPattern, block);
            String optionA = getMatchedValue(optionAPattern, block);
            String optionB = getMatchedValue(optionBPattern, block);
            String optionC = getMatchedValue(optionCPattern, block);
            String optionD = getMatchedValue(optionDPattern, block);
            String answer = getMatchedValue(answerPattern, block);

            if (questionText != null && optionA != null && optionB != null
                    && optionC != null && optionD != null && answer != null) {

                Questions question = new Questions();
                question.setQuestion(questionText.trim());
                question.setA(optionA.trim());
                question.setB(optionB.trim());
                question.setC(optionC.trim());
                question.setD(optionD.trim());
                question.setAnswer(answer.trim().toLowerCase());
                questionList.add(question);
            }
        }

        return questionList;
    }

    // Saves the parsed questions one by one using the existing DAO method.
    private int saveQuestions(List<Questions> questions) {
        int savedCount = 0;
        for (Questions q : questions) {
            if (QuestionsDao.insertQuestion(q)) {
                savedCount++;
            }
        }
        return savedCount;
    }

    private String getMatchedValue(Pattern pattern, String text) {
        Matcher matcher = pattern.matcher(text);
        return matcher.find() ? matcher.group(1) : null;
    }

    private String readStream(InputStream inputStream) throws IOException {
        BufferedReader reader = null;
        StringBuilder builder = new StringBuilder();
        try {
            reader = new BufferedReader(new InputStreamReader(inputStream, "UTF-8"));
            String line;
            while ((line = reader.readLine()) != null) {
                builder.append(line).append("\n");
            }
        } finally {
            if (reader != null) reader.close();
        }
        return builder.toString();
    }

    private String getSubmittedFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition == null) return null;
        for (String value1 : contentDisposition.split(";")) {
            String value = value1.trim();
            if (value.startsWith("filename")) {
                return value.substring(value.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }

    private String encodeMessage(String message) throws IOException {
        return URLEncoder.encode(message, "UTF-8");
    }
}