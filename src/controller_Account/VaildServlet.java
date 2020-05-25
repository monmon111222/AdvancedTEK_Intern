package controller_Account;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.DB;

import javax.servlet.http.Cookie;


/**
 * Servlet implementation class LogoutServlet
 */
@WebServlet("/VaildServlet")
public class VaildServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public VaildServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		System.out.println("VaildServlet");
		request.getParameter("AID");
		String ds = "java:comp/env/jdbc/TDB";
		Connection con = DB.getConnection(ds);
		PreparedStatement update_pstmt = null;
		PreparedStatement select_pstmt = null;
		ResultSet rs = null;
		int return_data=0;
		String vaild_username="";
		String sql="UPDATE `Account` SET `Account_Vaild`= 1  WHERE `Account_ID`=?";
		try {
			update_pstmt=con.prepareStatement(sql);
			update_pstmt.setInt(1,Integer.parseInt(request.getParameter("AID")));
			return_data=update_pstmt.executeUpdate();

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		sql="SELECT * FROM `Account` WHERE `Account_ID` = ?";
		try {
			select_pstmt=con.prepareStatement(sql);
			select_pstmt.setInt(1,Integer.parseInt(request.getParameter("AID")));
			rs=select_pstmt.executeQuery();
			rs.next(); 
			vaild_username=rs.getString("Account_Name");

		} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
		}finally {
			try {
//				查詢結束後將 con 的連線釋放，官還給 connection-pool				
			if (con != null)
				con.close();
				} catch (SQLException ignored) {
				}
			}	
		
//		PrintWriter out = response.getWriter();
		System.out.println(vaild_username);
		request.getSession().setAttribute("vaild",1);
		request.setAttribute("vaild_username", vaild_username);
		request.getRequestDispatcher ( "/OpenTurnpageServlet" ) .forward ( request , response ) ;
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
