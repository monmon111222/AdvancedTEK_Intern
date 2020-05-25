package contrller_OrderList;

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
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Map.Entry;

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
import model.Mail;

/**
 * Servlet implementation class uploadToDB
 */
@WebServlet("/OrderServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50) // 50MB
public class OrderServlet extends HttpServlet {
	
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
        System.out.println("OrderServlet");
        String strtotal = (String) request.getParameter("totalprice");
        String strshopsellerID = request.getParameter("shopsellerID");
        String strbuyerID = request.getParameter("buyerID");
        String uname = (String) request.getParameter("name");
        String phone = (String) request.getParameter("phone");
        String address =(String) request.getParameter("address");
        String email = (String) request.getParameter("email");
        System.out.println(strtotal+strshopsellerID+strbuyerID+uname+phone+address+email);
        int insertedID=0;
        int return_data1=0;
        int return_data2=0;
        int return_data3=0;
        int return_data4=0;
        Calendar calendar = Calendar.getInstance();		
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
        String ds = "java:comp/env/jdbc/TDB";
		Connection con = DB.getConnection(ds);
		String sql="INSERT INTO `OrderList`(`OrderList_OrderDate`, `OrderList_TotalPrice`,`OrderList_UserID`,`OrderList_State`,`OrderList_UName`,`OrderList_UPhone`,`OrderList_UAddress`,`OrderList_UEmail`) VALUES (?,?,?,?,?,?,?,?)";
		String sql2="";
		PreparedStatement insert_pstmt = null;
		PreparedStatement select_pstmt = null;
		PreparedStatement update_pstmt = null;
		ResultSet rs = null;
		
		 try {
			 insert_pstmt=con.prepareStatement(sql); 
			 insert_pstmt.setString(1,formatter.format(calendar.getTime()));
			 insert_pstmt.setInt(2, Integer.parseInt(strtotal));
			 insert_pstmt.setInt(3, Integer.parseInt(strbuyerID));
			 insert_pstmt.setInt(4, 1);
			 insert_pstmt.setString(5,uname);
			 insert_pstmt.setString(6,phone);
			 insert_pstmt.setString(7,address);
			 insert_pstmt.setString(8,email);			 
			 return_data1=insert_pstmt.executeUpdate();
			 select_pstmt=con.prepareStatement("SELECT LAST_INSERT_ID()");
			 rs=select_pstmt.executeQuery();
				while (rs.next()) {
					insertedID=rs.getInt("LAST_INSERT_ID()");
		            }
			} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		 sql="UPDATE `OrderList` SET `OrderList_ComID` ='S"+strshopsellerID+"D"+formatter.format(calendar.getTime())+"O"+Integer.toString(insertedID)
		 +"' WHERE `OrderList_ID`="+Integer.toString(insertedID);
		 try {
			 update_pstmt=con.prepareStatement(sql);		 
			 return_data2=update_pstmt.executeUpdate();
			} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		 String comID="S"+strshopsellerID+"D"+formatter.format(calendar.getTime())+"O"+Integer.toString(insertedID);
		 JsonArray ja =(JsonArray)request.getSession().getAttribute("checkcart");
		 ArrayList<String> paid = new ArrayList<String>();     
		 ArrayList<String> paidid = new ArrayList<String>();
		 ArrayList<String> styleid = new ArrayList<String>();
		 if (ja != null) { 
			   int len = ja.size();
			   for (int i=0;i<len;i++){ 
				   paid.add(ja.get(i).toString());
			   } 
			}
		 for(int i=0;i<paid.size();i++) {
			 paidid.add(paid.get(i).substring(paid.get(i).indexOf("Product_ID")+13,paid.get(i).indexOf("Product_SellerID")-3));
			 styleid.add(paid.get(i).substring(paid.get(i).indexOf("ProductStyle_ID")+18,paid.get(i).indexOf("ProductStyle_Vaule")-3));
		 }
		
		 Map<String,Integer> map = (Map<String, Integer>) request.getSession().getAttribute("cart");
		 for(int i=0;i<paidid.size();i++) {
			 for(String name : map.keySet()){
				 if(styleid.get(i).equals(name)) {
					 sql="UPDATE `ProductStyle` SET `ProductStyle_Quanity` =`ProductStyle_Quanity` -"+map.get(name)+" WHERE `ProductStyle_ID`="+name;
					 
						sql2="INSERT INTO `OrderItem`(`OrderItem_PID`, `OrderItem_Quanity`,`OrderItem_OID`,`OrderItem_SID`) VALUES (?,?,?,?)";
						try {
							 update_pstmt=con.prepareStatement(sql);		 
							 return_data3=update_pstmt.executeUpdate();
							 insert_pstmt=con.prepareStatement(sql2);
							 insert_pstmt.setInt(1, Integer.parseInt(paidid.get(i)));
							 insert_pstmt.setInt(4, Integer.parseInt(name));
							 insert_pstmt.setInt(2,map.get(name));
							 insert_pstmt.setInt(3,insertedID);
							 return_data4=insert_pstmt.executeUpdate();
							} catch (SQLException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
				 	}
				}
		 }
		 Mail.Send2BuyerMail(Integer.parseInt(strbuyerID),comID,email);
		 Mail.Send2SellerMail(Integer.parseInt(strshopsellerID),comID);
			if(return_data1==1&&return_data2==1&&return_data3==1&&return_data4==1) {
				 for(int i=0;i<paidid.size();i++) {
					 Set<Entry<String, Integer>> set=map.entrySet();
				     Iterator<Entry<String, Integer>> iterator=set.iterator();
					 while(iterator.hasNext()){
				            Entry<String, Integer> entry=iterator.next();
				            String name=entry.getKey();
				            if(paidid.get(i).equals(name)){
				            	//System.out.println("remove"+name);
				            	iterator.remove();
				            }
				        }
				 }
				request.getSession().setAttribute("cart",map);
				System.out.println(request.getSession().getAttribute("cart"));
				request.getSession().removeAttribute("checkcart");
				System.out.print("order1");
				out.print("1");
			}else {
				System.out.print("order0");
				out.print("0");
		 }
			
	
	}
	

}
