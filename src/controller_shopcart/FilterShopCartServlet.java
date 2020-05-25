package controller_shopcart;

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
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.Map.Entry;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import model.DB;

/**
 * Servlet implementation class ShopCartServlet
 */
@WebServlet("/FilterShopCartServlet")
public class FilterShopCartServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("FilterShopCartServlet");
		PrintWriter out = response.getWriter();
		JsonObject element = null;
		JsonArray ja = new JsonArray();
	    ResultSetMetaData rsmd = null;
	    String columnName, columnValue= null;
	    String ds = "java:comp/env/jdbc/TDB";
		Connection con = DB.getConnection(ds);
		PreparedStatement select_pstmt = null;
		ResultSet rs = null;
		String sql="";
		String shopsellerID="";
		String prdID[] = request.getParameterValues("prdID[]");
		//request.getSession().removeAttribute("cart");
		Map<String,Integer> map = (Map<String, Integer>) request.getSession().getAttribute("cart");
		int index=0;
		int total=0;
		int price=0;
	        if(map == null) {//購物車為空
	            map = new HashMap<>();
	            element = new JsonObject();
	            element.addProperty("CartState","購物車目前為空");
	            ja.add(element);
	        	}else {//取出map當中的所有值
	        	int[] prd_quanityinDB=new int[map.size()];
	        	 for(int x=0;x<prdID.length;x++) {
	        		 for(String name : map.keySet()){
	        			 if(name.equals(prdID[x])) {
	    	        		 sql="SELECT `ProductPhotos_FileName`,`ProductPhotos_SellerID`,`Product_Price`,`Product_Name`,`Product_ID`,`Product_SellerID`,`Shop_Name`,`ProductStyle_ID`,`ProductStyle_Vaule`,`ProductStyle_Quanity`"
	    		        		 		+ "FROM `Product`,`ProductPhotos`,`Shop`,`ProductStyle` "
	    		        		 		+ "WHERE `ProductStyle_ID`="+name+" AND `Product_ID` =`ProductStyle_PID` AND `ProductPhotos_PrdID` =`ProductStyle_PID` AND `Shop_SellerID`=`Product_SellerID` GROUP by `Product_ID`";
	    	     	        System.out.print(sql);

	    	        		 try {
	    	     				select_pstmt=con.prepareStatement(sql);
	    	     				rs=select_pstmt.executeQuery();
	    	     				rsmd = rs.getMetaData();
	    	     				while(rs.next()) {
	    	     					shopsellerID=rs.getString("ProductPhotos_SellerID");
	    	     					element = new JsonObject();
	    				            element.addProperty(name,map.get(name));
	    				            element.addProperty("BuyNumber",map.get(name));
	    				            element.addProperty("shopsellerID",shopsellerID);
	    				            price=rs.getInt("Product_Price");
	    				            prd_quanityinDB[index]=rs.getInt("ProductStyle_Quanity");
	    	     					for (int i = 0; i < rsmd.getColumnCount(); i++) {
	    	     						columnName = rsmd.getColumnName(i + 1);
	    	     	                    columnValue = rs.getString(columnName);
	    	     	                    element.addProperty(columnName, columnValue);
	    	     	                }
	    	     					index++;
	    	     					total+=map.get(name)*price;
	    	     	                ja.add(element);
	    	     					}
	    	     				} catch (SQLException e) {
	    	     				// TODO Auto-generated catch block
	    	     				e.printStackTrace();
	    	     				} 
	        			 	}
	        		 	}
	     			}
	        	 }
	        request.getSession().setAttribute("total",total);
	        request.getSession().setAttribute("shopsellerID", shopsellerID);
	        request.getSession().setAttribute("checkcart", ja);
	        System.out.print(request.getSession().getAttribute("checkcart"));
			out.print(ja);
        
		}
		 
	}


