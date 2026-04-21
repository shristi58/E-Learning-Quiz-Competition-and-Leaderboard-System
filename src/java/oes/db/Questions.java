package oes.db;

public class Questions {

    private int questionId; // ← primary key from DB
    private String question;
    private String a;
    private String b;
    private String c;
    private String d;
    private String answer;
    private int examId;

    public int getQuestionId()              { return questionId; }
    public void setQuestionId(int id)       { this.questionId = id; }

    public String getQuestion()             { return question; }
    public void setQuestion(String q)       { this.question = q; }

    public String getA()                    { return a; }
    public void setA(String a)              { this.a = a; }

    public String getB()                    { return b; }
    public void setB(String b)              { this.b = b; }

    public String getC()                    { return c; }
    public void setC(String c)              { this.c = c; }

    public String getD()                    { return d; }
    public void setD(String d)              { this.d = d; }

    public String getAnswer()               { return answer; }
    public void setAnswer(String answer)    { this.answer = answer; }

    public int getExamId()                  { return examId; }
    public void setExamId(int examId)       { this.examId = examId; }
}