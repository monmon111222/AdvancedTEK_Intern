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
@WebServlet("/GetColValSearchServelt")
public class GetColValSearchServelt extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		JsonObject element = new JsonObject();
		JsonArray ja = new JsonArray();
	    ResultSetMetaData rsmd = null;
	    String tablename=request.getParameter("tablename");
	    String colname1=request.getParameter("colname1");
	    String colname2=request.getParameter("colname2");
	    String columnName, columnValue ,strid= null;
		String ds = "java:comp/env/jdbc/TDB";
		Connection con = DB.getConnection(ds);
		PreparedStatement select_pstmt = null;
		ResultSet rs = null;
		
		
		PrintWriter out = response.getWriter();
		String sql="SELECT`"+colname1+"`,`"+colname2+"` FROM `"+tablename+"`";
		if(tablename.equals("ProductStyle")) {
			sql="SELECT`"+colname1+"`,`"+colname2+"` FROM `"+tablename+"`WHERE `ProductStyle_PID`="+request.getParameter("pid");
		}
		try {
			select_pstmt=con.prepareStatement(sql);
			rs=select_pstmt.executeQuery();
            rsmd = rs.getMetaData();
			while (rs.next()) {// 材料:物件 設計圖:類別
//				element = new JsonObject();
					columnName = rs.getString(colname1);
                    columnValue = rs.getString(colname2);
                    element.addProperty(columnName, columnValue);
			}
            ja.add(element);

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

	}

}