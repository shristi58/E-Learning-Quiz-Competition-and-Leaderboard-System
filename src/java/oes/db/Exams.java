/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package oes.db;

/**
 *
 * @author HP
 */
public class Exams {
     private int examId;
    private String examName;
    private int duration; // in minutes
 
    public int getExamId()             { return examId; }
    public void setExamId(int e)       { this.examId = e; }
    public String getExamName()        { return examName; }
    public void setExamName(String n)  { this.examName = n; }
    public int getDuration()           { return duration; }
    public void setDuration(int d)     { this.duration = d; }
}
