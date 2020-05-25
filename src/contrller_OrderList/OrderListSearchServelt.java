package contrller_OrderList;

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
@WebServlet("/OrderListSearchServelt")
public class OrderListSearchServelt extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request,response);
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		System.out.println("OrderListSearchServelt");
		JsonObject element = null;
		JsonArray ja = new JsonArray();
	    ResultSetMetaData rsmd = null;
	    String columnName, columnValue = null;
		String enddate=request.getParameter("enddate");
		String startdate=request.getParameter("startdate");
		String doID=request.getParameter("doID");
		String level=request.getParameter("level");
		String ds = "java:comp/env/jdbc/TDB";
		int selecter=0;
		Connection con = DB.getConnection(ds);
		PreparedStatement select_pstmt = null;
		ResultSet rs = null;
		PrintWriter out = response.getWriter();
		String sql="";
		if(enddate=="") {
				if(level.equals("mag")) {
					sql="SELECT * FROM `OrderList` WHERE `OrderList_ComID` LIKE ?";
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
					sql="SELECT `Shop_Name`,`OrderList_OrderDate`,`OrderList_TotalPrice`,`OrderList_State`,`OrderList_ID`,`OrderList_OrderDate`"
							+ "FROM `OrderList`,`Shop` "
							+ "WHERE `OrderList_UserID` = ? AND CAST(SUBSTRING(`OrderList_ComID`,2,LOCATE('D',`OrderList_ComID`)-2) AS DECIMAL(10))=`Shop_SellerID`";
					try {
						select_pstmt=con.prepareStatement(sql);
						select_pstmt.setInt(1,Integer.parseInt(doID));
						rs=select_pstmt.executeQuery();
			            rsmd = rs.getMetaData();
						while (rs.next()) {// 材料:物件 設計圖:類別
			                element = new JsonObject();
							for (int i = 0; i < rsmd.getColumnCount(); i++) {
			                    columnName = rsmd.getColumnName(i + 1);
			                    columnValue = rs.getString(columnName);
			                    if(columnName.equals("Shop_Name")) {
			                    	columnName="OrderList_ShopName";
			                    }
			                    element.addProperty(columnName, columnValue);
			                }
			                ja.add(element);
						}
					} catch (Exception e) {
						out.println("Exception caught: " + e.getMessage());
					}
				}
				
		}
		else{	
			if(level.equals("mag")) {
				sql="SELECT * FROM `OrderList` WHERE `OrderList_OrderDate` >= ? AND `OrderList_OrderDate` <= ? AND `OrderList_ComID` LIKE ?";
	
				try {
					select_pstmt=con.prepareStatement(sql);
					select_pstmt.setString(1,startdate);
					select_pstmt.setString(2,enddate);
					select_pstmt.setString(3,"S"+doID+"%");
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
				sql="SELECT `Shop_Name`,`OrderList_OrderDate`,`OrderList_TotalPrice`,`OrderList_State`,`OrderList_ID`,`OrderList_OrderDate`"
						+ " FROM `OrderList`,`Shop` "
						+ "WHERE `OrderList_OrderDate` >= ? AND `OrderList_OrderDate` <= ? AND `OrderList_UserID` LIKE ? AND CAST(SUBSTRING(`OrderList_ComID`,2,LOCATE('D',`OrderList_ComID`)-2) AS DECIMAL(10))=`Shop_SellerID`";
	
				try {
					select_pstmt=con.prepareStatement(sql);
					select_pstmt.setString(1,startdate);
					select_pstmt.setString(2,enddate);
					select_pstmt.setString(3,doID);
					rs=select_pstmt.executeQuery();
		            rsmd = rs.getMetaData();           
					while (rs.next()) {// 材料:物件 設計圖:類別
		                element = new JsonObject();
						for (int i = 0; i < rsmd.getColumnCount(); i++) {
		                    columnName = rsmd.getColumnName(i + 1);
		                    columnValue = rs.getString(columnName);
		                    if(columnName.equals("Shop_Name")) {
		                    	columnName="OrderList_ShopName";
		                    }
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
