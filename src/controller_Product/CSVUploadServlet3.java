package controller_Product;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
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
import model.*;

/**
 * Servlet implementation class uploadToDB
 */
@WebServlet("/CSVUploadServlet3")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50) // 50MB
public class CSVUploadServlet3 extends HttpServlet {
	
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
		System.out.println("CSVUploadServlet2");
        Part ph=request.getPart("input_product_csv");
        Part doid=request.getPart("doID");
        InputStream inputStream = ph.getInputStream();
        InputStream inputStream2=doid.getInputStream();
        String strdoID = InputStream2String.getStringFromInputStream(inputStream2);
        int doID=Integer.parseInt(strdoID);
        int insertedID=0;
        InputStreamReader isr = new InputStreamReader(inputStream,"UTF-8");//檔案讀取路徑
        BufferedReader reader = new BufferedReader(isr);
        String line = null;
        String ds = "java:comp/env/jdbc/TDB";
		Connection con = DB.getConnection(ds);
		ResultSet rs = null;
	    ResultSetMetaData rsmd = null;
		PreparedStatement insert_pstmt = null;
		PreparedStatement select_pstmt = null;
		int return_data=0;
		PreparedStatement ps;
		Calendar calendar = Calendar.getInstance();		
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        while((line=reader.readLine())!=null){
           String item[] = line.split(",");
           String  name= item[0].trim();//Name
           String  price= item[1].trim();//Price
           String  detail= item[2].trim();//Detail
           String  quanity= item[3].trim();//Color+Quanity
           String  category= item[4].trim();//Category
//         String  pid= item[5].trim();//pid
           try {
        	   insert_pstmt = con
   					.prepareStatement("INSERT INTO `Product` (`Product_Price`, `Product_Name`, `Product_Detail`,`Product_InsDate`,`Product_Vaild`,`Product_SellerID`) VALUES (?,?,?,?,?,?)");
        	   insert_pstmt.setInt(1,Integer.parseInt(price));        	   
        	   insert_pstmt.setString(2,name);
        	   insert_pstmt.setString(3,detail);
        	   insert_pstmt.setString(4,formatter.format(calendar.getTime()));
//        	   insert_pstmt.setInt(5,Integer.parseInt(quanity)); 
//        	   insert_pstmt.setInt(6,1);        	           	   
//        	   insert_pstmt.setInt(7,doID);
//        	   insert_pstmt.setInt(8,Integer.parseInt(pid));
        	   insert_pstmt.setInt(5,1);        	           	   
        	   insert_pstmt.setInt(6,doID);
        	   System.out.println(insert_pstmt);
        	   return_data=insert_pstmt.executeUpdate();
        	   select_pstmt = con
      					.prepareStatement("UPDATE `Product` set `Product_Detail`=REPLACE(`Product_Detail`, '+', '\r\n')");
        	   select_pstmt.executeUpdate();
	   		} catch (SQLException e) {
	   			out.print("Exception caught: " + e.getMessage());
	
			}
	        try {
	        	   select_pstmt=con.prepareStatement("SELECT LAST_INSERT_ID()");
					rs=select_pstmt.executeQuery();
					while (rs.next()) {// 材料:物件 設計圖:類別
						insertedID=rs.getInt("LAST_INSERT_ID()");
			            }
	   		} catch (SQLException e) {
	   			out.print("Exception caught: " + e.getMessage());
	
			}
	        String pcategory[] = category.split("-");
	        for(int i=0;i<pcategory.length;i++) {
		        try {
		        	insert_pstmt = con.prepareStatement("INSERT INTO `CategoryItem`(`CategoryItem_PID`,`CategoryItem_CID`) VALUES (?,?)");
		        	insert_pstmt.setInt(1,insertedID); 
		        	insert_pstmt.setInt(2,Integer.parseInt(pcategory[i]));
		        	insert_pstmt.executeUpdate();
				} catch (SQLException e) {
					out.print("Exception caught: " + e.getMessage());
	
				} 
	        }
			String style[] = quanity.split("-");
	        for(int i=0;i<style.length;i++) {
	        	try {
		        	insert_pstmt = con.prepareStatement("INSERT INTO `ProductStyle`(`ProductStyle_PID`,`ProductStyle_Vaule`,`ProductStyle_Quanity`) VALUES (?,?,?)");
		        	insert_pstmt.setInt(1,insertedID); 
		        	insert_pstmt.setString(2,style[i].substring(0,style[i].indexOf(":")));
		        	insert_pstmt.setInt(3,Integer.parseInt(style[i].substring(style[i].indexOf(":")+1,style[i].length())));
		        	System.out.println(insert_pstmt);
		        	return_data=insert_pstmt.executeUpdate();
		        	
				} catch (SQLException e) {
					out.print("Exception caught: " + e.getMessage());
		
				}
	        } 
      }       
      out.print(return_data);
	}
}
