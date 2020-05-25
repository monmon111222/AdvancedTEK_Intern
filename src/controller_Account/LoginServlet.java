package controller_Account;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import model.*;

/**
 * Servlet implementation class LoginServlet
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private String AUTO_USER_KEY = "AUTO_USER_KEY";
	// private String ServeltContext =getServletName();

	@Override
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// System.out.println(ServeltContext);
		String ds = "java:comp/env/jdbc/TDB";
		Connection con = DB.getConnection(ds);
//		String sendresult =Mail.SendMail("monmon111222@gmail.com","xh61371@gmail.com", "xh61371", "br171001","smtp.gmail.com","587");
		//Statement stmt = null;
		ResultSet rs = null;
		PrintWriter out = response.getWriter();
		Boolean userlogin = false;// 是否有該用戶
		String findname = request.getParameter("user");// 該用戶名稱
		String findpassword = request.getParameter("password");// 該用戶密碼
		String level=null;
		int vaild=-1;
		int doID=0;
		PreparedStatement select_pstmt = null;
		String sql="SELECT * FROM `Account` WHERE `Account_UserName` = ? AND `Account_Password` = ?";
//		String sql="SELECT * FROM `Member` WHERE `Member_UserName` = ? AND `Member_Password` = ?";
		try {
			select_pstmt=con.prepareStatement(sql);
			select_pstmt.setString(1,findname);
			select_pstmt.setString(2,findpassword);
			rs=select_pstmt.executeQuery();
			while (rs.next()) {// 材料:物件 設計圖:類別
						userlogin = true;
						level=rs.getString("Account_Level");
						doID=rs.getInt("Account_ID");
						vaild=rs.getInt("Account_Vaild");
//						level=rs.getString("Member_Level");
//						doID=rs.getInt("Member_ID");
//						vaild=rs.getInt("Member_Vaild");
						break;
						}
		} catch (Exception e) {
			out.println("Exception caught: " + e.getMessage());
		} finally {
			try {
//					查詢結束後將 con 的連線釋放，官還給 connection-pool				
				if (con != null)
					con.close();
			} catch (SQLException ignored) {
			}
		}
		String strdoID=Integer.toString(doID);
		request.getSession().setAttribute("user", findname);
		request.getSession().setAttribute("level", level);
		request.getSession().setAttribute("doID", strdoID);
		request.getSession().setAttribute("vaild", vaild);
		if (userlogin) {//userlogin->T 使用者  F 非使用者
			String login = request.getParameter("autologin");
			if(vaild!=0) {
				if ("auto".equals(login)) {
					request.getSession().setAttribute("autologin", "true");
					if(level.contains("1")) {
						if(vaild==-1) {
							response.sendRedirect("OpenEmptyServlet");
						}else {
							response.sendRedirect("OpenMagAccountServlet");
						}
						
					}else {
						response.sendRedirect("HomeServlet");		
					}

				}else {
					request.getSession().setAttribute("autologin", "false");
					if(level.contains("1")) {
						if(vaild==-1) {
							response.sendRedirect("OpenEmptyServlet");
						}else {
							response.sendRedirect("OpenMagAccountServlet");
						}
					}else {
						response.sendRedirect("HomeServlet");
						}
				}
			}else {
				response.sendRedirect("UnvaildServlet");
			}
			

		} else {
			System.out.println("輸入的帳號或密碼錯誤");
			response.sendRedirect("LoginSessionServlet");
		}
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	}

}
