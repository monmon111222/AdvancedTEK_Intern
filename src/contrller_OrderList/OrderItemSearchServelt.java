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
@WebServlet("/OrderItemSearchServelt")
public class OrderItemSearchServelt extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request,response);
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	    System.out.println("OrderItemSearchServelt");
		JsonObject element = null;
		JsonArray ja = new JsonArray();
	    ResultSetMetaData rsmd = null;
	    String columnName, columnValue ,strid="0",type="",sql= null;
	    if(request.getParameter("type")!=null) {
	    type=request.getParameter("type");}
	    if(request.getParameter("id")!="") {
		    strid=request.getParameter("id");}
	    String tablename=request.getParameter("tablename");
		int id=Integer.parseInt(strid);
		String ds = "java:comp/env/jdbc/TDB";
		int selecter=0;
		Connection con = DB.getConnection(ds);
		PreparedStatement select_pstmt = null;
		ResultSet rs = null;
		PrintWriter out = response.getWriter();
		
		if(type.equals("log")) {
				sql="SELECT * FROM `"+tablename+"` WHERE `"+tablename+"_SellerID` = ?";
				try {
					select_pstmt=con.prepareStatement(sql);
					select_pstmt.setInt(1,id);
					rs=select_pstmt.executeQuery();
		            rsmd = rs.getMetaData();
					while (rs.next()) {// 材料:物件 設計圖:類別
		                element = new JsonObject();
//						userlogin=true;
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
			int max=0;
				if(tablename.equals("OrderListUpdate")) {
					sql="SELECT MAX(`OrderListUpdate_ID`) FROM `OrderListUpdate`,`OrderItem`,`Product`,`ProductStyle` WHERE `OrderItem_OID` = ? AND `OrderListUpdate_OID`=? AND `ProductStyle_PID`=`Product_ID`  AND `OrderItem_PID`=`Product_ID`  ORDER BY `OrderListUpdate_ID` DESC";
					try {
						select_pstmt=con.prepareStatement(sql);
						select_pstmt.setInt(1,id);
						select_pstmt.setInt(2,id);
						rs=select_pstmt.executeQuery();
			            rsmd = rs.getMetaData();
						rs.next();
						max = rs.getInt("MAX(`OrderListUpdate_ID`)");
					} catch (Exception e) {
						out.println("Exception caught: " + e.getMessage());
					}
				sql="SELECT * FROM `OrderListUpdate`,`OrderItem`,`Product`,`ProductStyle` WHERE `OrderItem_OID` = ? AND `OrderListUpdate_OID`=? AND `ProductStyle_PID`=`Product_ID`  AND `OrderItem_PID`=`Product_ID` AND `OrderListUpdate_ID` =?";

					try {
						select_pstmt=con.prepareStatement(sql);
						select_pstmt.setInt(1,id);
						select_pstmt.setInt(2,id);
						select_pstmt.setInt(3,max);
						rs=select_pstmt.executeQuery();
			            rsmd = rs.getMetaData();
						while (rs.next()) {// 材料:物件 設計圖:類別
			                element = new JsonObject();
//							userlogin=true;
							for (int i = 0; i < rsmd.getColumnCount(); i++) {
			                    columnName = rsmd.getColumnName(i + 1);
			                    columnValue = rs.getString(columnName);
			                    if(columnName.equals("ProductStyle_Quanity")) {
			                    	columnName="Product_Quanity";
			                    }
			                    element.addProperty(columnName, columnValue);
			                }
			                ja.add(element);
						}
					} catch (Exception e) {
						out.println("Exception caught: " + e.getMessage());
					}
				}else {
					sql="SELECT * FROM `"+tablename+"`,`OrderItem`,`Product`,`ProductStyle` WHERE `Product_ID`=`OrderItem_PID` AND `OrderItem_SID`=`ProductStyle_ID` AND `OrderList_ID`=? AND `OrderItem_OID`=?";
//					sql="SELECT * FROM `"+tablename+"`,`OrderItem`,`Product`,`Shop` WHERE `"+tablename+"_ID` = ? AND `OrderItem_OID` = ? AND `OrderItem_PID`=`Product_ID` AND `Product_SellerID`=`Shop_SellerID`";
					try {
						select_pstmt=con.prepareStatement(sql);
						select_pstmt.setInt(1,id);
						select_pstmt.setInt(2,id);
						rs=select_pstmt.executeQuery();
			            rsmd = rs.getMetaData();
						while (rs.next()) {// 材料:物件 設計圖:類別
			                element = new JsonObject();
//							userlogin=true;
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
		System.out.println(sql);
	    out.print(ja);
	}

}
