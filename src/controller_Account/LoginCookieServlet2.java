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
 * Servlet implementation class LoginCookieServlet2
 */
@WebServlet("/login.view2")
public class LoginCookieServlet2 extends HttpServlet {
	private static final long serialVersionUID = 1L;
   
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		System.out.println("CookieServlet");
		String cookiename="myuser";
		String findname =request.getParameter("username");// 該用戶名稱
		String findpassword =request.getParameter("password");// 該用戶密碼
		Cookie[] cookies = request.getCookies();
		  if (cookies != null) {
		   for (Cookie cookie : cookies) {
		    if (null != cookie.getName() && null != cookie.getValue()) {
		     String name = cookie.getName();
		     String value = cookie.getValue();
		     if (cookiename.equals(name) && (findname +"&"+findpassword).equals(value)) {
		      // 有取得user
//		      request.setAttribute("user", value.toString().split("||")[0]);
		      request.getRequestDispatcher("/user.view").forward(request, response);
		      return;
		     }
		    }
		   }
		  }
		  response.sendRedirect("login.jsp");
	
	}

}
