package controller_Product;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Objects;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import model.DB;
import model.removeRepeatChar;

/**
 * Servlet implementation class SearchServelt
 */
@WebServlet("/StyleSearchServelt")
public class StyleSearchServelt extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request,response);
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		JsonObject element = new JsonObject();
		JsonArray ja = new JsonArray();
	    ResultSetMetaData rsmd = null;
	    String columnName, columnValue = null;
//		String pid[]=request.getParameterValues("pid[]");
	    String pid=request.getParameter("pid");
		String tablename=request.getParameter("tablename");
		ResultSet rs = null;
		String ds = "java:comp/env/jdbc/TDB";
		Connection con = DB.getConnection(ds);
		PreparedStatement select_pstmt = null;
		int re=0;
		
		PrintWriter out = response.getWriter();
		String sql="";
		
		sql="SELECT `ProductStyle_Vaule`,`ProductStyle_ID` FROM `ProductStyle` WHERE `ProductStyle_PID`=?";
//		for(int x=0;x<pid.length;x++) {
//			try {
//				select_pstmt=con.prepareStatement(sql);
//				select_pstmt.setString(1,pid[x]);
//				rs=select_pstmt.executeQuery();
//	            rsmd = rs.getMetaData();
//				while (rs.next()) {// 材料:物件 設計圖:類別
//	                element = new JsonObject();
//					for (int i = 0; i < rsmd.getColumnCount(); i++) {
//	                    columnName = rsmd.getColumnName(i + 1);
//	                    columnValue = rs.getString(columnName);
//	                    if(columnName.equals("ShopCategory_Name")||columnName.equals("Product_Quanity")) {
//	                    	columnValue=removeRepeatChar.remove(columnValue);
//	                    }
//	                    element.addProperty(columnName, columnValue);
//	                }
//	                ja.add(element);
//				}
//			} catch (Exception e) {
//				out.println("Exception caught: " + e.getMessage());
//			} 
//		}
			try {
				select_pstmt=con.prepareStatement(sql);
				select_pstmt.setString(1,pid);
				rs=select_pstmt.executeQuery();
				while (rs.next()) {// 材料:物件 設計圖:類別
						columnName = rs.getString("ProductStyle_ID");
	                    columnValue = removeRepeatChar.remove(rs.getString("ProductStyle_Vaule"));
	                    element.addProperty(columnName, columnValue);
	                       
				}
				ja.add(element);
				
			} catch (Exception e) {
				out.println("Exception caught: " + e.getMessage());
			} 
		System.out.println(ja);	
		out.print(ja);	
		
		
	}

}
