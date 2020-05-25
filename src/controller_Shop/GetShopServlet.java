package controller_Shop;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import model.DB;
import model.InputStream2String;
import model.removeRepeatChar;

/**
 * Servlet implementation class uploadToDB
 */
@WebServlet("/GetShopServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50) // 50MB
public class GetShopServlet extends HttpServlet {
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		PrintWriter out = response.getWriter();
		JsonObject element = null;
		JsonArray ja = new JsonArray();
	    ResultSetMetaData rsmd = null;
	    String columnName, columnValue= null;
        String tablename = request.getParameter("tablename");
        String strdoID = request.getParameter("doID");
        String ds = "java:comp/env/jdbc/TDB";
		Connection con = DB.getConnection(ds);
		String sql="";
		System.out.println("GetShopServlet"+tablename);
		if(request.getParameter("shopsellerID")!=null) {
			String shopsellerID=request.getParameter("shopsellerID");
			String cateID=request.getParameter("cateID");
//			sql="SELECT * FROM `Shop`,`Product`,`CategoryItem`,`ShopCategory`,`ProductPhotos` WHERE `ShopCategory_ID`=`CategoryItem_CID` AND `Shop_SellerID`="+shopsellerID+" AND `Product_SellerID`="+shopsellerID+" AND `ProductPhotos_PrdID`=`Product_ID` AND `CategoryItem_CID`="+cateID+" AND `Product_Vaild`=1  AND `CategoryItem_PID` = `Product_ID` GROUP BY `Product_ID` ORDER by `Product_ID` DESC";			
			sql="SELECT `Shop_Name`,`Product_Name`,`Product_Vaild`,`ProductPhotos_FileName`,GROUP_CONCAT(CONCAT(`ProductStyle_Vaule`,' : ',`ProductStyle_Quanity`)) AS 'Product_Quanity',GROUP_CONCAT(CONCAT(`ProductStyle_ID`)) AS 'ProductStyle_ID',`Product_Vaild`,`Product_ID`,`Product_Name`,`Product_Price`,`Product_Detail`,`Product_SellerID`,GROUP_CONCAT(ShopCategory_Name) AS 'ShopCategory_Name'  \r\n" + 
					"FROM `Product`  \r\n" + 
					"LEFT JOIN `CategoryItem` ON `Product_ID` = `CategoryItem_PID`" + 
					"LEFT JOIN `ShopCategory`  ON `CategoryItem_CID`=`ShopCategory_ID`"+ 
					"LEFT JOIN `ProductStyle`  ON `ProductStyle_PID`=`Product_ID`"+ 
					"LEFT JOIN `ProductPhotos` ON `ProductPhotos_PrdID`=`Product_ID`"+
					"LEFT JOIN `Shop` ON `Product_SellerID`=`Shop_SellerID`"+
					"WHERE  `Product_SellerID`="+shopsellerID+" and  `CategoryItem_CID`="+cateID+" AND `Product_Vaild`= 1 AND `ProductPhotos_FileName` IS NOT null GROUP BY `Product_ID` DESC";
		}else {

			if (tablename.equals("Shop")) {
				if(request.getParameter("shoptype")!=null&&!request.getParameter("shoptype").equals("0")&&request.getParameter("shoptype")!="") {
					sql="SELECT * FROM `"+tablename+"`,`Product` WHERE `Shop_Type`="+request.getParameter("shoptype")+" AND `Product_SellerID`=`Shop_SellerID` AND `Product_Vaild`=1 GROUP by `Shop_SellerID`";
				}else {
					sql="SELECT * FROM `"+tablename+"`,`Product` WHERE `Product_SellerID`=`Shop_SellerID` AND `Product_Vaild`=1 GROUP by `Shop_SellerID`";
				}
			}else if(tablename.equals("Products")){
				//request.getSession().setAttribute("shopsellerID",strdoID);
//				sql="SELECT GROUP_CONCAT(CONCAT(`ProductStyle_Vaule`,' : ',`ProductStyle_Quanity`)) AS 'Product_Quanity',GROUP_CONCAT(CONCAT(`ProductStyle_ID`)) AS 'ProductStyle_ID',`Product_Vaild`,`Product_ID`,`Product_Name`,`Product_Price`,`Product_Detail`,`Product_SellerID`,GROUP_CONCAT(ShopCategory_Name) AS 'ShopCategory_Name'" + 
//						"FROM `Product`" + 
//						"LEFT JOIN `CategoryItem` ON `Product_ID` = `CategoryItem_PID` "+ 
//						"LEFT JOIN `ShopCategory`  ON `CategoryItem_CID`=`ShopCategory_ID`" + 
//						"LEFT JOIN `ProductStyle`  ON `ProductStyle_PID`=`Product_ID`" + 
//						"WHERE  `Shop_SellerID`="+strdoID+" GROUP BY `Product_ID` DESC";
				sql="SELECT GROUP_CONCAT(CONCAT(`ProductStyle_Vaule`,' : ',`ProductStyle_Quanity`)) AS 'Product_Quanity',`Product_Vaild`,`Product_Name`, `Product_SellerID`,`ProductPhotos_FileName`,`Shop_Name`,`Product_ID`"
						+"FROM `Product`,`ProductPhotos`,`Shop`,`ProductStyle` WHERE `ProductPhotos_PrdID`=`Product_ID` AND `ProductStyle_PID`=`Product_ID` AND `Product_SellerID`="+strdoID
						+" AND `Shop_SellerID`="+strdoID+" AND `Product_Vaild`=1 AND `ProductPhotos_FileName` IS NOT null GROUP BY `Product_Name` ORDER by `Product_ID` DESC";
			}else if(tablename.equals("Product")){
				//request.getSession().setAttribute("prdID",strdoID);
				sql="SELECT GROUP_CONCAT(CONCAT(`ProductStyle_Vaule`,' : ',`ProductStyle_Quanity`)) AS 'Product_Quanity',GROUP_CONCAT(CONCAT(`ProductStyle_ID`)) AS 'ProductStyle_ID',`Product_Vaild`,`Product_ID`,`Product_Name`,`Product_Price`,`Product_Detail`,`Product_SellerID`,GROUP_CONCAT(ShopCategory_Name) AS 'ShopCategory_Name'" + 
						"FROM `Product`" + 
						"LEFT JOIN `CategoryItem` ON `Product_ID` = `CategoryItem_PID` "+ 
						"LEFT JOIN `ShopCategory`  ON `CategoryItem_CID`=`ShopCategory_ID`" + 
						"LEFT JOIN `ProductStyle`  ON `ProductStyle_PID`=`Product_ID`" + 
						"WHERE  `Product_ID`="+strdoID+" GROUP BY `Product_ID`";
			}
		}      
			PreparedStatement select_pstmt = null;
			ResultSet rs = null;
			 try {
				select_pstmt=con.prepareStatement(sql);
				rs=select_pstmt.executeQuery();
				rsmd = rs.getMetaData();
				while(rs.next()) {
					element = new JsonObject();
					for (int i = 0; i < rsmd.getColumnCount(); i++) {
						columnName = rsmd.getColumnName(i + 1);
	                    columnValue = rs.getString(columnName);
	                    if(columnName.equals("ShopCategory_Name")||columnName.equals("ProductStyle_ID")||columnName.equals("Product_Quanity")) {
	                    	columnValue=removeRepeatChar.remove(columnValue);
	                    }
	                    element.addProperty(columnName, columnValue);
	                }
	                ja.add(element);
					}
				} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}finally {
					try {
	 				if (con != null)
	 					con.close();
	 					} catch (SQLException ignored) {
	 					}
	 	}
//			System.out.print(select_pstmt);
		 out.print(ja);
	}
	

}
