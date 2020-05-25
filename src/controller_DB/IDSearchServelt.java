package controller_DB;

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
@WebServlet("/IDSearchServelt")
public class IDSearchServelt extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request,response);
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	    System.out.println("IDSearchServelt");
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
		Connection con = DB.getConnection(ds);
		PreparedStatement select_pstmt = null;
		ResultSet rs = null;
		PrintWriter out = response.getWriter();
		if(type.equals("log")) {
			if(tablename.equals("ProductLog")) {
				sql="SELECT * FROM `"+tablename+"` WHERE `"+tablename+"_PID` = ?";//ProductLog的所有資訊	
			}else if(tablename.equals("AccountLog")) {
				sql="SELECT * FROM `"+tablename+"` WHERE `"+tablename+"_AID` = ?";//AccountLog的所有資訊					
			}else {
				sql="SELECT * FROM `"+tablename+"` WHERE `"+tablename+"_OID` = ?";	
			}
		}else {
			if(tablename.equals("Shop")) {
				sql="SELECT `Shop_Name`,`Shop_Detail`,`Shop_CoverFileName`,`Shop_SellerID`,`Shop_ShipFee`,`Shop_Type` FROM `"+tablename+"` WHERE `"+tablename+"_SellerID` = ?";
			}else if(tablename.equals("OrderListUpdate")||tablename.equals("OrderListLog")) {//OrderListLog/OrderListUpdate 用OID查
				sql="SELECT * FROM `"+tablename+"` WHERE `"+tablename+"_OID` = ?";
			}else if(tablename.equals("ShopCategory")) {
				sql="SELECT * FROM `ShopCategory`,`CategoryItem` WHERE`ShopCategory_SellerID` =? and `CategoryItem_CID`=`ShopCategory_ID` and `ShopCategory_Vaild`=1 GROUP by `ShopCategory_Name`";
			}else if(tablename.equals("ShopCategoryPrd")) {
				sql="SELECT * FROM `Product`,`ShopCategory`,`CategoryItem` WHERE `Product_ID`=? AND `ShopCategory_SellerID` =`Product_SellerID`  and `CategoryItem_CID`=`ShopCategory_ID` and `ShopCategory_Vaild`=1 GROUP by `ShopCategory_Name`";
//				sql="SELECT * FROM `Product`,`ShopCategory` WHERE `Product_ID`=? AND `ShopCategory_SellerID` =`Product_SellerID`";
			}else if(tablename.equals("ShopCategoryAll")) {
				sql="SELECT * FROM `ShopCategory` WHERE `ShopCategory_SellerID` =?";
			}else if(tablename.equals("ShopType")) {
				sql="SELECT * FROM `ShopType`,`Shop`,`Product` WHERE `ShopType_ID`=`Shop_Type`AND `Product_SellerID`=`Shop_SellerID` GROUP by `ShopType_ID` ORDER by `ShopType_ID`";
			}else if(tablename.equals("OrderListUpdateDESC")) {
				sql="SELECT * FROM `OrderListUpdate` WHERE `OrderListUpdate_OID`=? ORDER BY `OrderListUpdate_ID` DESC";
			}else if(tablename.equals("ShopProduct")) {
				sql="SELECT * FROM `Shop`,`Product` WHERE `Product_SellerID`=?";
			}else if(tablename.equals("ShopCategoryEdit")) {
				sql="SELECT * FROM `ShopCategory` WHERE `ShopCategory_ID`=?";
			}else{
				sql="SELECT * FROM `"+tablename+"` WHERE `"+tablename+"_ID` = ?";//Product/Account/OrderList的所有資訊
			}
		}
		try {
			select_pstmt=con.prepareStatement(sql);
			if(id!=-1) {
			select_pstmt.setInt(1,id);
			}
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
		} finally {
			try {
				if (con != null)
					con.close();
			} catch (SQLException ignored) {
			
		}
		}
	    out.print(ja);
	}

}
