package oes.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import oes.db.Exams;
import oes.db.Provider;

public class ExamsDao {

    public static Exams getExamById(int examId) {
        Exams exam = null;
        try {
            Connection con = Provider.getOracleConnection();
            String sql = "SELECT * FROM examtable WHERE examId = ?";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setInt(1, examId);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                exam = new Exams();
                exam.setExamId(rs.getInt("examId"));
                exam.setExamName(rs.getString("examName"));
                exam.setDuration(rs.getInt("duration"));
            }
        } catch (SQLException e) {
            System.out.println("ERROR! -> ExamsDao.getExamById");
            System.out.println(e);
        }
        return exam;
    }

    public static ArrayList<Exams> getAllExams() {
        ArrayList<Exams> list = new ArrayList<>();
        try {
            Connection con = Provider.getOracleConnection();
            String sql = "SELECT * FROM examtable";
            PreparedStatement pst = con.prepareStatement(sql);
            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                Exams exam = new Exams();
                exam.setExamId(rs.getInt("examId"));
                exam.setExamName(rs.getString("examName"));
                exam.setDuration(rs.getInt("duration"));
                list.add(exam);
            }
        } catch (SQLException e) {
            System.out.println("ERROR! -> ExamsDao.getAllExams");
            System.out.println(e);
        }
        return list;
    }

    public static boolean insertExam(Exams exam) {
        boolean status = false;
        try {
            Connection con = Provider.getOracleConnection();
            String sql = "INSERT INTO examtable (examName, duration) VALUES (?, ?)";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, exam.getExamName());
            pst.setInt(2, exam.getDuration());
            int val = pst.executeUpdate();
            status = val > 0;
        } catch (SQLException e) {
            System.out.println("ERROR! -> ExamsDao.insertExam");
            System.out.println(e);
        }
        return status;
    }

    public static boolean updateExam(Exams exam) {
        boolean status = false;
        try {
            Connection con = Provider.getOracleConnection();
            String sql = "UPDATE examtable SET examName = ?, duration = ? WHERE examId = ?";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, exam.getExamName());
            pst.setInt(2, exam.getDuration());
            pst.setInt(3, exam.getExamId());
            int val = pst.executeUpdate();
            status = val > 0;
        } catch (SQLException e) {
            System.out.println("ERROR! -> ExamsDao.updateExam");
            System.out.println(e);
        }
        return status;
    }
}