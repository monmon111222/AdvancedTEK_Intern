package controller_Account;


import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import javax.naming.Context;
import javax.sql.DataSource;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import model.*;

/**
 * Servlet implementation class SignupServlet
 */
@WebServlet("/SignupServlet")
public class SigupServelt extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		System.out.println("SignupServlet");
		String name,ename ,email,user,password,level,phone,address,admin=null;
		String strdoID=(String) request.getSession().getAttribute("doID");
		int doID=Integer.parseInt(strdoID);
	    String columnName, columnValue = null;
		PrintWriter out = response.getWriter();
		Boolean insert=false;
		String ds = "java:comp/env/jdbc/TDB";
		int check=0;
		Connection con = DB.getConnection(ds);
		Statement search_stmt  = null;
		ResultSet rs = null;
	    ResultSetMetaData rsmd = null;
		PreparedStatement insert_pstmt = null;
		PreparedStatement select_pstmt = null;
		JsonObject element = null;
		JsonArray ja = new JsonArray();
		Calendar calendar = Calendar.getInstance();		
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		name=request.getParameter("name");
		ename=request.getParameter("ename");
		password= request.getParameter("password");
		user= request.getParameter("user");
		email= request.getParameter("email");
		phone = request.getParameter("phone");
		level= request.getParameter("level");
		admin = request.getParameter("admin");
		address = request.getParameter("address");
		int insertedID=0;
		if(admin!=null) {
			admin=admin.replaceAll("\\[", "");
			admin=admin.replaceAll("\\]", "");
			admin=admin.replaceAll("\"", "");
			admin=admin.replaceAll(",", "");
			level="1"+admin;
			try {
				insert_pstmt = con.prepareStatement("INSERT INTO `Account`(`Account_UserName`, `Account_Password`, `Account_Name`,`Account_EName`, `Account_Email`, `Account_SignupDate`,`Account_Level`,`Account_Phone`,`Account_Vaild`,`Account_Address`, `Account_PhotoName`) VALUES (?,?,?,?,?,?,?,?,?,?,?)");
				insert_pstmt.setString(1,user);
				insert_pstmt.setString(2,password);
				insert_pstmt.setString(3,"");
				insert_pstmt.setString(4,"");
				insert_pstmt.setString(5,email);
				insert_pstmt.setString(6,formatter.format(calendar.getTime()));
				insert_pstmt.setString(7, level);
				insert_pstmt.setString(8, "");
				insert_pstmt.setInt(9, -1);
				insert_pstmt.setString(10, "無");
				insert_pstmt.setString(11, "default_user.png");
				check=insert_pstmt.executeUpdate();
				select_pstmt=con.prepareStatement("SELECT LAST_INSERT_ID()");
				rs=select_pstmt.executeQuery();
				while (rs.next()) {// 材料:物件 設計圖:類別
					insertedID=rs.getInt("LAST_INSERT_ID()");
		            }
				} catch (Exception e) {
					out.println("Exception caught: " + e.getMessage());
				}
			if(insertedID!=0) {
				String mail=Mail.SendAdminVaildMail(email,doID,insertedID,user,password);
			}
		}else {
			if(address==null) {
				address="無";
			}
			try {
				insert_pstmt = con.prepareStatement("INSERT INTO `Account`(`Account_UserName`, `Account_Password`, `Account_Name`,`Account_EName`, `Account_Email`, `Account_SignupDate`,`Account_Level`,`Account_Phone`,`Account_Vaild`,`Account_Address`) VALUES (?,?,?,?,?,?,?,?,?,?)");
				insert_pstmt.setString(1,user);
				insert_pstmt.setString(2,password);
				insert_pstmt.setString(3,name);
				insert_pstmt.setString(4,ename);
				insert_pstmt.setString(5,email);
				insert_pstmt.setString(6,formatter.format(calendar.getTime()));
				insert_pstmt.setString(7, level);
				insert_pstmt.setString(8, phone);
				insert_pstmt.setInt(9, -1);
				insert_pstmt.setString(10, address);
				check=insert_pstmt.executeUpdate();
				select_pstmt=con.prepareStatement("SELECT LAST_INSERT_ID()");
				rs=select_pstmt.executeQuery();
				while (rs.next()) {// 材料:物件 設計圖:類別
					insertedID=rs.getInt("LAST_INSERT_ID()");
		            }
				} catch (Exception e) {
					out.println("Exception caught: " + e.getMessage());
				}
			if(insertedID!=0) {
				String mail=Mail.SendVaildMail(email,insertedID);
			}
		}
		System.out.println("insertedID"+insertedID);
		out.print(insertedID);
	}

}
