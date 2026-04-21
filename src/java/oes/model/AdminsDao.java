/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package oes.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import oes.db.Admins;
import oes.db.Provider;

/**
 *
 * @author adrianadewunmi
 */
public class AdminsDao {
    
    public static boolean doValidate(Admins ad){
        
        boolean status = false;
        
        try{
            Connection con = Provider.getOracleConnection();
            String sql = "select * from admintable where userid=? and password=?";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, ad.getUsername());
            pst.setString(2, ad.getPassword());
            ResultSet rs = pst.executeQuery();
            if(rs.next()){
                status = true;
            }else{
                status = false;
                System.out.println("ERROR! -> Connection status = false");
            }
        }catch(SQLException e){
            System.out.println("ERROR! -> SQLException");
            System.out.println(e);
        }
        return status;
    }
    public static Admins getAdminByEmail(String email) {
    Admins ad = null;
    try {
        Connection con = Provider.getOracleConnection();
        String sql = "SELECT * FROM admintable WHERE email = ?";
        PreparedStatement pst = con.prepareStatement(sql);
        pst.setString(1, email);
        ResultSet rs = pst.executeQuery();
        if (rs.next()) {
            ad = new Admins();
            ad.setUsername(rs.getString("userid"));
            ad.setEmail(rs.getString("email"));
        }
    } catch (SQLException e) {
        System.out.println("ERROR! -> " + e);
    }
    return ad;
}
    public static boolean insertAdmin(Admins ad) {
    boolean status = false;
    try {
        Connection con = Provider.getOracleConnection();
        String sql = "INSERT INTO admintable (userid, password, email) VALUES (?, ?, ?)";
        PreparedStatement pst = con.prepareStatement(sql);
        pst.setString(1, ad.getUsername());
        pst.setString(2, ad.getPassword());
        pst.setString(3, ad.getEmail());
        int val = pst.executeUpdate();
        status = val > 0;
    } catch (SQLException e) {
        System.out.println("ERROR! -> " + e);
    }
    return status;
}
    
}
