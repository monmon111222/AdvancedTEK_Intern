package contrller_OrderList;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import model.DB;

/**
 * Servlet implementation class SearchServelt
 */
@WebServlet("/OrderListUpdateMagServelt")
public class OrderListUpdateMagServelt extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request,response);
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		System.out.println("OrderListUpdateMagServelt");
		String doID=(String) request.getSession().getAttribute("doID");
		JsonObject element = null;
		JsonArray ja = new JsonArray();
	    ResultSetMetaData rsmd = null;
	    String columnName, columnValue = null;
		String enddate=request.getParameter("enddate");
		String startdate=request.getParameter("startdate");
		String ds = "java:comp/env/jdbc/TDB";
		Connection con = DB.getConnection(ds);
		PreparedStatement select_pstmt = null;
		ResultSet rs = null;
		PrintWriter out = response.getWriter();
		String sql="";
		if(request.getParameter("result")=="") {
			if(startdate==null) {
				request.getSession().setAttribute("startdate", "-1");
				request.getSession().setAttribute("enddate", "-1");
				sql="SELECT * FROM `OrderListUpdate` WHERE `OrderListUpdate_Result` = 2 AND `OrderListUpdate_ComID` LIKE ?";
				try {
					select_pstmt=con.prepareStatement(sql);
					select_pstmt.setString(1,"S"+doID+"%");
					rs=select_pstmt.executeQuery();
		            rsmd = rs.getMetaData();           
					while (rs.next()) {// 材料:物件 設計圖:類別
		                element = new JsonObject();
						for (int i = 0; i < rsmd.getColumnCount(); i++) {
		                    columnName = rsmd.getColumnName(i + 1);
		                    columnValue = rs.getString(columnName);
		                    element.addProperty(columnName, columnValue);
		                }
		                ja.add(element);
					}
				} catch (Exception e) {
					out.println("Exception caught: " + e.getMessage());
				}
			}else {
				request.getSession().setAttribute("startdate", startdate);
				request.getSession().setAttribute("enddate", enddate);
				sql="SELECT * FROM `OrderListUpdate` WHERE `OrderListUpdate_Result` = 2 AND `OrderListUpdate_ComID` LIKE ? AND `OrderListUpdate_Time` >= ? AND `OrderListUpdate_Time` <= ?";
				try {
					select_pstmt=con.prepareStatement(sql);
					select_pstmt.setString(1,"S"+doID+"%");
					select_pstmt.setString(2,startdate);
					select_pstmt.setString(3,enddate);
					rs=select_pstmt.executeQuery();
		            rsmd = rs.getMetaData();           
					while (rs.next()) {// 材料:物件 設計圖:類別
		                element = new JsonObject();
						for (int i = 0; i < rsmd.getColumnCount(); i++) {
		                    columnName = rsmd.getColumnName(i + 1);
		                    columnValue = rs.getString(columnName);
		                    element.addProperty(columnName, columnValue);
		                }
		                ja.add(element);
					}
				} catch (Exception e) {
					out.println("Exception caught: " + e.getMessage());
				}
			}
		}else {
			if(startdate==null) {
				request.getSession().setAttribute("startdate", "-1");
				request.getSession().setAttribute("enddate", "-1");
				sql="SELECT * FROM `OrderListUpdate` WHERE `OrderListUpdate_ComID` LIKE ?";
				try {
					select_pstmt=con.prepareStatement(sql);
					select_pstmt.setString(1,"S"+doID+"%");
					rs=select_pstmt.executeQuery();
		            rsmd = rs.getMetaData();           
					while (rs.next()) {// 材料:物件 設計圖:類別
		                element = new JsonObject();
						for (int i = 0; i < rsmd.getColumnCount(); i++) {
		                    columnName = rsmd.getColumnName(i + 1);
		                    columnValue = rs.getString(columnName);
		                    element.addProperty(columnName, columnValue);
		                }
		                ja.add(element);
					}
				} catch (Exception e) {
					out.println("Exception caught: " + e.getMessage());
				}
			}else {
				request.getSession().setAttribute("startdate", startdate);
				request.getSession().setAttribute("enddate", enddate);
				sql="SELECT * FROM `OrderListUpdate` WHERE `OrderListUpdate_ComID` LIKE ? AND `OrderListUpdate_Time` >= ? AND `OrderListUpdate_Time` <= ?";
				try {
					select_pstmt=con.prepareStatement(sql);
					select_pstmt.setString(1,"S"+doID+"%");
					select_pstmt.setString(2,startdate);
					select_pstmt.setString(3,enddate);
					rs=select_pstmt.executeQuery();
		            rsmd = rs.getMetaData();           
					while (rs.next()) {// 材料:物件 設計圖:類別
		                element = new JsonObject();
						for (int i = 0; i < rsmd.getColumnCount(); i++) {
		                    columnName = rsmd.getColumnName(i + 1);
		                    columnValue = rs.getString(columnName);
		                    element.addProperty(columnName, columnValue);
		                }
		                ja.add(element);
					}
				} catch (Exception e) {
					out.println("Exception caught: " + e.getMessage());
				}
			}	
		}
		out.print(ja);
	}

}
