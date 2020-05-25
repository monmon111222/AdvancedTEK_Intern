package filter;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.DB;

/**
 * Servlet Filter implementation class Login_Filter
 */
@WebFilter("/Admin_Filter")
public class Admin_Filter implements Filter {

    /**
     * Default constructor. 
     */
    public Admin_Filter() {
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see Filter#destroy()
	 */
	public void destroy() {
		// TODO Auto-generated method stub
	}

	/**
	 * @see Filter#doFilter(ServletRequest, ServletResponse, FilterChain)
	 */
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		// TODO Auto-generated method stub
		// place your code here
		System.out.println("Admin_Filter");
		HttpServletRequest req = (HttpServletRequest)request;
		HttpServletResponse res = (HttpServletResponse)response;
//		Boolean usercheck = false;
//		Cookie[] cookies = req.getCookies();
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
//		System.out.println(uservaild+"uservaild");
//		System.out.println(passvaild+"passvaild");
		String doID= (String)req.getSession().getAttribute("doID");
		String level="0";
		HttpSession session = req.getSession();
		if (session.getAttribute("level") != null) {
			level=session.getAttribute("level").toString();
		} 
//		String usernamevalue=(String) req.getAttribute("username");
//		String autologin=(String) req.getAttribute("autologin");
		if(!level.contains("1")){
			req.getRequestDispatcher("homepage.jsp").forward(request, response);
		}else {
			req.getRequestDispatcher("userview.jsp").forward(request, response);
			
		}
		// pass the request along the filter chain
		chain.doFilter(request, response);
	}

	/**
	 * @see Filter#init(FilterConfig)
	 */
	public void init(FilterConfig fConfig) throws ServletException {
		// TODO Auto-generated method stub
	}

}
