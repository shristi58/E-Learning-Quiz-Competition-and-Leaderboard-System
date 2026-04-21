package oes.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import oes.db.Provider;
import oes.db.Questions;

public class QuestionsDao {

    // ── Insert question ───────────────────────────────────────────────────────
    public static boolean insertQuestion(Questions q) {
        boolean status = false;
        try {
            Connection con = Provider.getOracleConnection();
            String sql = "INSERT INTO questiontable (question, a, b, c, d, answer, examId) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, q.getQuestion());
            pst.setString(2, q.getA());
            pst.setString(3, q.getB());
            pst.setString(4, q.getC());
            pst.setString(5, q.getD());
            pst.setString(6, q.getAnswer());
            pst.setInt(7, q.getExamId());
            int val = pst.executeUpdate();
            status = val > 0;
        } catch (SQLException e) {
            System.out.println("ERROR! -> QuestionsDao.insertQuestion");
            System.out.println(e);
        }
        return status;
    }

    // ── Get ALL questions ─────────────────────────────────────────────────────
    public static ArrayList<Questions> getAllRecords() {
        ArrayList<Questions> list = new ArrayList<>();
        try {
            Connection con = Provider.getOracleConnection();
            String sql = "SELECT * FROM questiontable ORDER BY questionId";
            PreparedStatement pst = con.prepareStatement(sql);
            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                Questions q = new Questions();
                q.setQuestionId(rs.getInt("questionId")); // ← real primary key
                q.setQuestion(rs.getString("question"));
                q.setA(rs.getString("a"));
                q.setB(rs.getString("b"));
                q.setC(rs.getString("c"));
                q.setD(rs.getString("d"));
                q.setAnswer(rs.getString("answer"));
                try { q.setExamId(rs.getInt("examId")); } catch (SQLException ex) {}
                list.add(q);
            }
        } catch (SQLException e) {
            System.out.println("ERROR! -> QuestionsDao.getAllRecords");
            System.out.println(e);
        }
        return list;
    }

    // ── Get questions for a SPECIFIC exam ────────────────────────────────────
    public static ArrayList<Questions> getByExamId(int examId) {
        ArrayList<Questions> list = new ArrayList<>();
        try {
            Connection con = Provider.getOracleConnection();
            String sql = "SELECT * FROM questiontable WHERE examId = ? ORDER BY questionId";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setInt(1, examId);
            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                Questions q = new Questions();
                q.setQuestionId(rs.getInt("questionId"));
                q.setQuestion(rs.getString("question"));
                q.setA(rs.getString("a"));
                q.setB(rs.getString("b"));
                q.setC(rs.getString("c"));
                q.setD(rs.getString("d"));
                q.setAnswer(rs.getString("answer"));
                q.setExamId(rs.getInt("examId"));
                list.add(q);
            }
        } catch (SQLException e) {
            System.out.println("ERROR! -> QuestionsDao.getByExamId");
            System.out.println(e);
        }
        return list;
    }

    // ── Delete question by questionId (primary key) ───────────────────────────
    public static int deleteRecord(int questionId) {
        int status = 0;
        try {
            Connection con = Provider.getOracleConnection();
            String sql = "DELETE FROM questiontable WHERE questionId = ?";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setInt(1, questionId);
            int val = pst.executeUpdate();
            status = val > 0 ? 1 : 0;
            System.out.println("Deleted questionId: " + questionId + " | status: " + status);
        } catch (SQLException e) {
            System.out.println("ERROR! -> QuestionsDao.deleteRecord");
            System.out.println(e);
        }
        return status;
    }
}