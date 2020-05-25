package controller_Account;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Cookie;
import java.sql.*;
import javax.naming.Context;
import javax.sql.DataSource;
import model.*;

/**
 * Servlet implementation class LoginServlet2
 */
@WebServlet("/login.do2")
public class LoginServlet2 extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public LoginServlet2() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		String ds = "java:comp/env/jdbc/TDB";
		Connection con = DB.getConnection(ds);
		// Statement stmt = null;
		ResultSet rs = null;
		PrintWriter out = response.getWriter();
		Boolean userlogin = false;// 是否有該用戶
		String findname = request.getParameter("username");// 該用戶名稱
		String findpassword = request.getParameter("password");// 該用戶密碼
		String cookiename = "myuser";
		PreparedStatement select_pstmt = null;
		String sql = "SELECT * FROM `Account` WHERE `Account_UserName` LIKE ? AND `Account_Password` LIKE ?";
		try {
			select_pstmt = con.prepareStatement(sql);
			select_pstmt.setString(1, findname);
			select_pstmt.setString(2, findpassword);
			rs = select_pstmt.executeQuery();
//			stmt = con.createStatement();
//			rs = stmt.executeQuery("SELECT * FROM `Account`");
			while (rs.next()) {// 材料:物件 設計圖:類別
				userlogin = true;
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
		System.out.println("userlogin   " + userlogin);
		if (userlogin) {// userlogin->T 使用者 F 非使用者
			String login = request.getParameter("autologin");
			if ("auto".equals(login)) { // 判斷有無該使用者的cookie
				System.out.println("chooseauto");
				Cookie[] cookies = request.getCookies();
				for (Cookie cookie : cookies) {
					if (cookie.getName().equals(cookiename)) {
						if (cookie.getValue().equals(findname + "&" + findpassword)) {
							cookie.setMaxAge(2 * 60);
							response.addCookie(cookie);
							System.out.println(
									"find auto cookies" + cookie.getName() + cookie.getValue() + cookie.getMaxAge());
						}

					}
				}
				Cookie userpacoookie = new Cookie(cookiename, findname + "&" + findpassword);
				response.addCookie(userpacoookie);
				userpacoookie.setMaxAge(2 * 60);
				System.out.println("add auto cookies" + userpacoookie.getName() + userpacoookie.getValue()
						+ userpacoookie.getMaxAge());

			}
			// doGet(request, response);
			request.getSession().setAttribute("username", findname);
			request.getSession().setAttribute("password", findpassword);
			response.sendRedirect("userview.jsp");
		} else {
			System.out.println("輸入的帳號或密碼錯誤");
			request.getSession().setAttribute("correct", "false");
			response.sendRedirect("login.jsp");
		}
	}
}
