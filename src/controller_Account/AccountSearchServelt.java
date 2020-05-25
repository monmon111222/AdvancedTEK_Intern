package controller_Account;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import model.DB;

/**
 * Servlet implementation class SearchServelt
 */
@WebServlet("/AccountSearchServelt")
public class AccountSearchServelt extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request,response);
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		JsonObject element = null;
		JsonArray ja = new JsonArray();
	    ResultSetMetaData rsmd = null;
	    String columnName, columnValue = null;
		String finduser=request.getParameter("user");
		String findname=request.getParameter("name");
		String ds = "java:comp/env/jdbc/TDB";
		int selecter=0;
		Connection con = DB.getConnection(ds);
		PreparedStatement select_pstmt = null;
		ResultSet rs = null;
		if(findname==null){//只有查詢帳號的條件 把姓名的input給""
			findname="";
		}
		if(finduser==null){//只有查詢姓名的條件 把帳號的input給""
			finduser="";
		}
		PrintWriter out = response.getWriter();
		String sql="SELECT * FROM `Account` WHERE `Account_UserName` LIKE ? AND `Account_Name` LIKE ?";
		try {
			select_pstmt=con.prepareStatement(sql);
			select_pstmt.setString(1,"%"+finduser+"%");
			select_pstmt.setString(2,"%"+findname+"%");
			rs=select_pstmt.executeQuery();
            rsmd = rs.getMetaData();
			while (rs.next()) {// 材料:物件 設計圖:類別
                element = new JsonObject();
//				userlogin=true;
				for (int i = 0; i < rsmd.getColumnCount(); i++) {
                    columnName = rsmd.getColumnName(i + 1);
                    columnValue = rs.getString(columnName);
                    element.addProperty(columnName, columnValue);
                }
                ja.add(element);
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
		out.print(ja);
//	    System.out.println("SearchServelt"+ja);
	}

}
