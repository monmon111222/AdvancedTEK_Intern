package controller_Shop;


import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;

import javax.naming.Context;
import javax.sql.DataSource;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import model.*;

@WebServlet("/InsShopServelt")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
maxFileSize = 1024 * 1024 * 10, // 10MB
maxRequestSize = 1024 * 1024 * 50) // 50MB
public class InsShopServelt extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated InsShopServelt stub
		System.out.println("InsPrdServelt");
		List<Part> parts = (List<Part>) request.getParts();
		String name = null,detail = null,strdoID=null,type=null,phname=null,shipfee=null,shoptype=null;
		InputStream ph =null;
		String tablename=request.getParameter("tablename");
		PrintWriter out = response.getWriter();
		String ds = "java:comp/env/jdbc/TDB";
		Connection con = DB.getConnection(ds);
		Statement search_stmt  = null;
		ResultSet rs = null;
	    ResultSetMetaData rsmd = null;
		PreparedStatement insert_pstmt = null;
		PreparedStatement select_pstmt = null;

		int insertedID=0;
		for(Part part : parts) {
			if(part.getName().equals("input_shop_name")) {
				name=InputStream2String.getStringFromInputStream(part.getInputStream());
			}
			if(part.getName().equals("input_shop_detail")) {
				detail=InputStream2String.getStringFromInputStream(part.getInputStream());
			}
			if(part.getName().equals("input_shop_photo")) {
				ph=part.getInputStream();
				phname=part.getSubmittedFileName();
			}
			if(part.getName().equals("doID")) {
				strdoID=InputStream2String.getStringFromInputStream(part.getInputStream());
			}
			if(part.getName().equals("type")) {
				type=InputStream2String.getStringFromInputStream(part.getInputStream());
			}
			if(part.getName().equals("tablename")) {
				tablename=InputStream2String.getStringFromInputStream(part.getInputStream());
			}
			if(part.getName().equals("input_shop_shipfee")) {
				shipfee=InputStream2String.getStringFromInputStream(part.getInputStream());
			}
			if(part.getName().equals("shop_type")) {
				shoptype=InputStream2String.getStringFromInputStream(part.getInputStream());
			}
			
        }
		System.out.println("shop_type"+shoptype);

		if(type.equals("insert")) {
			detail=detail.replaceAll("[+]",System.getProperty("line.separator"));
			try {
			insert_pstmt = con.prepareStatement("INSERT INTO `Shop`(`Shop_Name`,`Shop_Detail`, `Shop_SellerID`,`Shop_ShipFee`,`Shop_Type`) VALUES (?,?,?,?,?,?)");
			insert_pstmt.setString(1,name);
			insert_pstmt.setString(2,detail);
			insert_pstmt.setInt(3, Integer.parseInt(strdoID));
			insert_pstmt.setInt(4, Integer.parseInt(shipfee));
			insert_pstmt.setInt(4, Integer.parseInt(shoptype));
			System.out.println(insert_pstmt.executeUpdate());
			select_pstmt=con.prepareStatement("SELECT LAST_INSERT_ID()");
			rs=select_pstmt.executeQuery();
			while (rs.next()) {// 材料:物件 設計圖:類別
				insertedID=rs.getInt("LAST_INSERT_ID()");
	            }
			} catch (Exception e) {
				out.println("Exception caught: " + e.getMessage());
			}
			try {
				insert_pstmt = con.prepareStatement("UPDATE `Shop` SET `Shop_Cover`=?,`Shop_CoverFileName`=? WHERE `Shop_SellerID`=?");
				insert_pstmt.setBlob(1, ph);
				insert_pstmt.setString(2,Integer.toString(insertedID)+".jpg");
				insert_pstmt.setInt(3, Integer.parseInt(strdoID));
				insert_pstmt.executeUpdate();
				} catch (Exception e) {
					out.println("Exception caught: " + e.getMessage());
				}
			try {
				insert_pstmt = con.prepareStatement("INSERT INTO `ShopCategory`(`ShopCategory_Name`,`ShopCategory_SellerID`) VALUES (?,?)");
				insert_pstmt.setString(1,"未分類");
				insert_pstmt.setInt(2, Integer.parseInt(strdoID));
				insert_pstmt.executeUpdate();
				} catch (Exception e) {
					out.println("Exception caught: " + e.getMessage());
				}
			String savepath=this.getServletContext().getRealPath("//")+File.separator+"upload"+File.separator+tablename+File.separator+strdoID;
			System.out.println(savepath);
			File uploadedFile = new File(savepath);
			if(!uploadedFile.exists()) {
				uploadedFile.mkdirs();
			}
	        Part pph=request.getPart("input_shop_photo");
			pph.write(savepath+File.separator+Integer.toString(insertedID)+".jpg");
		}else if(type.equals("update")){
			detail=detail.replaceAll("[+]",System.getProperty("line.separator"));
			try {
				insert_pstmt = con.prepareStatement("UPDATE `Shop` SET `Shop_Name`=?,`Shop_Detail`=?,`Shop_ShipFee`=? WHERE `Shop_SellerID`=?");
				insert_pstmt.setString(1,name);
				insert_pstmt.setString(2,detail);
				insert_pstmt.setInt(4, Integer.parseInt(strdoID));
				insert_pstmt.setInt(3, Integer.parseInt(shipfee));
				insert_pstmt.executeUpdate();
				} catch (Exception e) {
					out.println("Exception caught: " + e.getMessage());
				}
			if(phname!="") {
				String sql_s="SELECT `Shop_CoverFileName` FROM `Shop`  WHERE `Shop_SellerID`=?";
				String savepath=this.getServletContext().getRealPath("//")+File.separator+"upload"+File.separator+tablename+File.separator+strdoID+File.separator;
				File uploadedFile = new File(savepath);
				try {
					select_pstmt=con.prepareStatement(sql_s);
					select_pstmt.setInt(1,Integer.parseInt(strdoID));
					rs=select_pstmt.executeQuery();
					rs.next();
					savepath=savepath+rs.getString("Shop_CoverFileName");
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				uploadedFile.delete();
				System.out.println(savepath);
				Part pph=request.getPart("input_shop_photo");
				pph.write(savepath);
			}
			if(shoptype!="") {
				String sql_u="UPDATE `Shop` SET `Shop_Type`= ?  WHERE `Shop_SellerID`=?";
				String savepath=this.getServletContext().getRealPath("//")+File.separator+"upload"+File.separator+tablename+File.separator+strdoID+File.separator;
				File uploadedFile = new File(savepath);
				try {
					select_pstmt=con.prepareStatement(sql_u);
					select_pstmt.setInt(2,Integer.parseInt(strdoID));
					select_pstmt.setInt(1,Integer.parseInt(shoptype));
					select_pstmt.executeUpdate();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
			
		 out.println(insertedID);
	}

}
