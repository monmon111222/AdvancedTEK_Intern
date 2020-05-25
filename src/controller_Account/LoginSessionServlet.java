package controller_Account;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.DB;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;

/**
 * Servlet implementation class LoginCookieServlet
 */
@WebServlet("/LoginSessionServlet")
public class LoginSessionServlet extends HttpServlet {

	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
//		Boolean usercheck = false;
//		Cookie[] cookies = request.getCookies();
//		String usernamevalue = null;
//		String passwdvalue = null;
//		Boolean usercookie=false;
//		Boolean passcookie=false;
//		Boolean uservaild=false;
//		Boolean passvaild=false;
//
//		//
//		if (cookies != null) {
//			for (Cookie cookie : cookies) {
//				if (cookie.getName().equals("username")) {
//					usernamevalue = cookie.getValue();
//					System.out.println("login filter" + usernamevalue+cookie.getMaxAge());
//					usercookie=true;
//				}
//				if (cookie.getName().equals("passwd")) {
//					passwdvalue = cookie.getValue();
//					System.out.println("login filter" + passwdvalue+cookie.getMaxAge());
//					passcookie=true;
//				}
//			}
//		}
//		String ds = "java:comp/env/jdbc/TDB";
//		Connection con = DB.getConnection(ds);
//		PreparedStatement select_pstmt = null;
//		ResultSet rs = null;
//		String sql="SELECT * FROM `Account` WHERE `Account_UserName` LIKE ? AND `Account_Password` LIKE ?";
//		try {
//			select_pstmt=con.prepareStatement(sql);
//			select_pstmt.setString(1,usernamevalue);
//			select_pstmt.setString(2,passwdvalue);
//			rs=select_pstmt.executeQuery();
//			while (rs.next()) {// 材料:物件 設計圖:類別
//				usercheck = true;
//				break;
//				}
//		} catch (Exception e) {
////				out.println("Exception caught: " + e.getMessage());
//		} finally {
//			try {
////						查詢結束後將 con 的連線釋放，官還給 connection-pool				
//				if (con != null)
//					con.close();
//			} catch (SQLException ignored) {
//			}
//		}
//		System.out.println("使用者"+usercheck);
//		if (usercheck) {
//			for (Cookie cookie : cookies) {
//				if (cookie.getName().equals("username")) {
//					if(cookie.getMaxAge()>0) {
//						uservaild=true;
//					}
//				}
//				if (cookie.getName().equals("passwd")) {
//					if(cookie.getMaxAge()>0) {
//						passvaild=true;
//					}
//				}
//			}
//		}
		System.out.println("LoginSessionServlet");		
		PrintWriter out = response.getWriter();
		String usernamevalue=(String) request.getSession().getAttribute("user");
		String autologin=(String) request.getSession().getAttribute("autologin");
		String vaild=(String) request.getSession().getAttribute("vaild");
		String level=null;
//		if(request.getSession().getAttribute("level")==null) {
//			request.getRequestDispatcher("homepage.jsp").forward(request, response);
//			}else {
//			level=(String)request.getSession().getAttribute("level");
//		}
		System.out.println(vaild);	
		if(usernamevalue==null){
			System.out.println("非使用者或已登出");	
			request.getRequestDispatcher("visitor/login.jsp").forward(request, response);
		}else if (usernamevalue!=null&&autologin==null||autologin.equals("false")){
			request.getRequestDispatcher("visitor/login.jsp").forward(request, response);
		System.out.println("使用者"+usernamevalue+"未設定自動登入 等級:"+level);
		}else if (usernamevalue!=null&&autologin.equals("true")) {
			System.out.println("使用者"+usernamevalue+"有設定自動登入 等級:"+level);
			if(level.equals("1")) {
				if(vaild.equals("-1")) {
					request.getRequestDispatcher("emptypage.jsp").forward(request, response);
				}else {
					request.getRequestDispatcher("visitor/userview.jsp").forward(request, response);
				}	
			}else {
				request.getRequestDispatcher("visitor/homepage.jsp").forward(request, response);
			}
		}
	}
}