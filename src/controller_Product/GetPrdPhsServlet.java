package controller_Product;

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
@WebServlet("/GetPrdPhsServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50) // 50MB
public class GetPrdPhsServlet extends HttpServlet {
	
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
        System.out.println("GetPrdPhsServlet");
        String strdoID = request.getParameter("doID");
        String strprdID = request.getParameter("prdID");
        //int doID=Integer.parseInt(strdoID);
        int prdID=Integer.parseInt(strprdID);
        String ds = "java:comp/env/jdbc/TDB";
		Connection con = DB.getConnection(ds);
		String sql="SELECT `ProductPhotos_FileName`,`ProductPhotos_SellerID` FROM `ProductPhotos` WHERE `ProductPhotos_PrdID`=?";
		PreparedStatement select_pstmt = null;
		ResultSet rs = null;
		 try {
			select_pstmt=con.prepareStatement(sql); 
			select_pstmt.setInt(1,prdID);
			rs=select_pstmt.executeQuery();
			rsmd = rs.getMetaData();
			while(rs.next()) {
				element = new JsonObject();
				for (int i = 0; i < rsmd.getColumnCount(); i++) {
                    columnValue = rs.getString("ProductPhotos_FileName");
                    element.addProperty("ProductPhotos_FileName", columnValue);
                }
                ja.add(element);
				}
			} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			try {
//				查詢結束後將 con 的連線釋放，官還給 connection-pool				
			if (con != null)
				con.close();
				} catch (SQLException ignored) {
				}
			}	
		 out.print(ja);
	}
	

}
