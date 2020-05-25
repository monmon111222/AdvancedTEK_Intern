package controller_Product;


import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import javax.naming.Context;
import javax.sql.DataSource;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import model.*;

/**
 * Servlet implementation class SignupServlet
 */
@WebServlet("/InsPrdServelt")
public class InsPrdServelt extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		System.out.println("InsPrdServelt");
		String name,price ,detail,strdoID=null,quanity=null;
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
		if(tablename.equals("Product")) {
			name=request.getParameter("name");
			price=request.getParameter("price");
			detail= request.getParameter("detail");
			strdoID= request.getParameter("doID");
			quanity= request.getParameter("quanity");
			String[] styqu=request.getParameterValues("quanity[]");
			String[] styname=request.getParameterValues("style[]");
			Calendar calendar = Calendar.getInstance();		
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
			try {
				insert_pstmt = con.prepareStatement("INSERT INTO `Product`(`Product_Name`,`Product_Price`, `Product_Detail`, `Product_InsDate`,`Product_Vaild`,`Product_SellerID`) VALUES (?,?,?,?,?,?)");
				insert_pstmt.setString(1,name);
				insert_pstmt.setInt(2,Integer.parseInt(price));
				insert_pstmt.setString(3,detail);
				insert_pstmt.setString(4,formatter.format(calendar.getTime()));
	//			insert_pstmt.setInt(5,Integer.parseInt(quanity));
				insert_pstmt.setInt(5, 1);
				insert_pstmt.setInt(6,Integer.parseInt(strdoID));
				insert_pstmt.executeUpdate();
				select_pstmt=con.prepareStatement("SELECT LAST_INSERT_ID()");
				rs=select_pstmt.executeQuery();
				while (rs.next()) {// 材料:物件 設計圖:類別
					insertedID=rs.getInt("LAST_INSERT_ID()");
		            }
			} catch (Exception e) {
				out.println("Exception caught: " + e.getMessage());
			}
			for(int i=0;i<styqu.length;i++) {
				try {
					insert_pstmt = con.prepareStatement("INSERT INTO `ProductStyle`(`ProductStyle_Vaule`,`ProductStyle_PID`,`ProductStyle_Quanity`) VALUES (?,?,?)");
					insert_pstmt.setInt(2,insertedID);
					insert_pstmt.setInt(3,Integer.parseInt(styqu[i]));
					insert_pstmt.setString(1,styname[i]);
					insert_pstmt.executeUpdate();
				} catch (Exception e) {
					out.println("Exception caught: " + e.getMessage());
				}
			}
			String category[]=request.getParameterValues("category[]");
			String categoryname[]=request.getParameterValues("categoryname[]");
			for(int i=0;i<category.length;i++) {
				try {
					insert_pstmt = con.prepareStatement("INSERT INTO `CategoryItem`(`CategoryItem_PID`,`CategoryItem_CID`) VALUES (?,?)");
					insert_pstmt.setInt(1,insertedID);
					insert_pstmt.setInt(2,Integer.parseInt(category[i]));
					insert_pstmt.executeUpdate();
					} catch (Exception e) {
						out.println("Exception caught: " + e.getMessage());
					}
			}
		}else {
			strdoID= request.getParameter("doID");
			name=request.getParameter("name");

			try {
				insert_pstmt = con.prepareStatement("INSERT INTO `ShopCategory`(`ShopCategory_Name`,`ShopCategory_SellerID`,`ShopCategory_Vaild`) VALUES (?,?,?)");
				insert_pstmt.setString(1,name);
				insert_pstmt.setInt(2, Integer.parseInt(strdoID));
				insert_pstmt.setInt(3, 1);
				insert_pstmt.executeUpdate();
				select_pstmt=con.prepareStatement("SELECT LAST_INSERT_ID()");
				rs=select_pstmt.executeQuery();
				while (rs.next()) {// 材料:物件 設計圖:類別
					insertedID=rs.getInt("LAST_INSERT_ID()");
		            }
				} catch (Exception e) {
					out.println("Exception caught: " + e.getMessage());
				}
		}
		System.out.println(insert_pstmt);
		System.out.println(insertedID);
		 out.println(insertedID);
	}

}
