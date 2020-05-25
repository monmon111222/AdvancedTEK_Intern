package controller_DB;

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

/**
 * Servlet implementation class uploadToDB
 */
@WebServlet("/ChartServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50) // 50MB
public class ChartServlet extends HttpServlet {
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		System.out.println("PrdChartServlet");
		PrintWriter out = response.getWriter();
		JsonObject element = null;
		JsonArray ja = new JsonArray();
	    ResultSetMetaData rsmd = null;
	    String columnName, columnValue= null;
        System.out.println("GetShopServlet");
        String tablename = request.getParameter("tablename");
        String strdoID = request.getParameter("doID");
//        String strprdID = request.getParameter("prdID");
//        int doID=Integer.parseInt(strdoID);
//        int prdID=Integer.parseInt(strprdID);
        String ds = "java:comp/env/jdbc/TDB";
		Connection con = DB.getConnection(ds);
		String sql="";
		if(tablename.equals("Prd")){
			request.getSession().setAttribute("prdID",strdoID);
			sql="SELECT SUM(`OrderItem_Quanity`) AS 'TotalQuanity',`Product_Name`,`Product_ID`,`ProductStyle_Vaule` FROM `OrderItem`,`Product`,`ProductStyle` WHERE `ProductStyle_PID`=`Product_ID` AND `OrderItem_PID`=`Product_ID` AND `Product_SellerID`="+strdoID
					+" GROUP BY `OrderItem_PID` ORDER BY `TotalQuanity` DESC";
		}else if(tablename.equals("`OrderItem`,`Product`")) {
			sql="SELECT `Product_Name`,`OrderItem_Quanity`,`OrderList_ComID`,`OrderList_ID`,`ProductStyle_Vaule` FROM `OrderItem`,`Product`,`OrderList`,`ProductStyle` WHERE `ProductStyle_PID`=`Product_ID` AND `OrderItem_PID`=`Product_ID` AND `Product_SellerID`="+strdoID+" AND `OrderItem_OID`=`OrderList_ID`";
		}else if(tablename.equals("Shop")) {
			sql="SELECT SUM(`OrderItem_Quanity`) AS 'TotalQuanity',`Shop_Name`" + 
					"FROM `OrderItem`,`Product` ,`OrderList`	,`Shop`" + 
					"WHERE `OrderItem_PID`=`Product_ID` AND `OrderItem_OID`=`OrderList_ID` AND CAST(SUBSTRING(`OrderList_ComID`,2,LOCATE('D',`OrderList_ComID`)-2) AS DECIMAL(10))=`Shop_SellerID`" + 
					"GROUP BY CAST(SUBSTRING(`OrderList_ComID`,2,LOCATE('D',`OrderList_ComID`)-2) AS DECIMAL(10))" + 
					"ORDER BY `TotalQuanity` DESC";
		}
		System.out.println(sql);

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
                    element.addProperty(columnName, columnValue);
                }
                ja.add(element);
				}
			} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
				try {
// 					查詢結束後將 con 的連線釋放，官還給 connection-pool				
 				if (con != null)
 					con.close();
 					} catch (SQLException ignored) {
 					}
 				}
		 System.out.print(ja);
		 out.print(ja);
	}
	

}
