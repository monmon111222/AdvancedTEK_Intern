package controller_DB;


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
@WebServlet("/ShowColServelt")
public class ShowColServelt extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request, response);
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		JsonObject element = new JsonObject();
		JsonArray ja = new JsonArray();
	    ResultSetMetaData rsmd = null;
	    System.out.println("ShowColServelt");
	    String tablename=request.getParameter("tablename");
	    String columnName, columnValue= null;
		String ds = "java:comp/env/jdbc/TDB";
		Connection con = DB.getConnection(ds);
		PreparedStatement select_pstmt = null;
		ResultSet rs = null;
		
		PrintWriter out = response.getWriter();
		
		String sql="SELECT * FROM `ShowCol` ORDER BY `ShowCol`.`Show_Order` ASC";
		try {
			select_pstmt=con.prepareStatement(sql);
			rs=select_pstmt.executeQuery();
            rsmd = rs.getMetaData();
			while (rs.next()) {// 材料:物件 設計圖:類別
				element = new JsonObject();
            for (int i = 0; i < rsmd.getColumnCount(); i++) {
                    columnName = rsmd.getColumnName(i + 1);
                    columnValue=rs.getString(columnName);
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
//		System.out.print(ja);
    	out.print(ja);
	}

}