package controller_DB;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Calendar;

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
@WebServlet("/DBUpdateServelt")
public class DBUpdateServelt extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request, response);
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		int doID=Integer.parseInt((String) request.getSession().getAttribute("doID"));
		System.out.println("DBUpdateServelt "+doID);
		String address=null,name= null, ename= null, email= null, user= null, password= null, strid= null, type= null, strvaild= null,phone= null,level= null,admin= null,price= null,detail= null,quanity = null;
		String ori_address=null,ori_strvaild=null,ori_name= null, ori_ename= null, ori_email= null, ori_password= null, ori_level= null,ori_phone = null,ori_price=null,ori_detail=null,ori_quanity=null;
		String tablename= request.getParameter("tablename");
		int ori_vaild=0;
		PrintWriter out = response.getWriter();
		String ds = "java:comp/env/jdbc/TDB";
		Connection con = DB.getConnection(ds);
		PreparedStatement update_pstmt = null;
		PreparedStatement insert_pstmt = null;
		PreparedStatement select_pstmt = null;
		int insertout=0;
		int updateout=0;
		int id=0;
		int vaild=0;
		type = request.getParameter("type");
		if(tablename.equals("Account")) {
			name = request.getParameter("name");
			ename = request.getParameter("ename");
			password = request.getParameter("password");
			user = request.getParameter("user");
			email = request.getParameter("email");
			phone = request.getParameter("phone");
			strid = request.getParameter("id");
			level= request.getParameter("level");
			admin= request.getParameter("admin");
			strvaild = request.getParameter("vaild");
			address = request.getParameter("address");
			if(strvaild!="") {
				vaild = Integer.parseInt(strvaild);
			}
			id = Integer.parseInt(strid);//被修改的user id
			if(admin!=null) {
				admin=admin.replaceAll("\\[", "");
				admin=admin.replaceAll("\\]", "");
				admin=admin.replaceAll("\"", "");
				admin=admin.replaceAll(",", "");
				level="1"+admin;
			}
		}else if(tablename.equals("Product")) {
			name = request.getParameter("name");
			detail= request.getParameter("detail");
			price= request.getParameter("price");
			quanity= request.getParameter("quanity");
			strvaild = request.getParameter("vaild");
			vaild = Integer.parseInt("DBUpdateServelt strvaild"+strvaild);
			if(strvaild!="") {
				vaild = Integer.parseInt(strvaild);}
				strid = request.getParameter("id");
				id = Integer.parseInt(strid);//被修改的prd id
		}else if(tablename.equals("ShopCategory")) {
				name = request.getParameter("name");
				strvaild = request.getParameter("vaild");
			if(strvaild!="") {
				vaild = Integer.parseInt(strvaild);}
				strid = request.getParameter("id");
				id = Integer.parseInt(strid);//被修改的prd id
		}
		
		Calendar calendar = Calendar.getInstance();		
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		String event=null;
		String sql = "";//update Account sqlquery
		String sqllog = "";//insert into AccountLog
		String searchsql="SELECT * FROM `"+tablename+"` WHERE `"+tablename+"_ID` LIKE ?";//Select Account all info
		ResultSet rs = null;
		JsonObject element =  new JsonObject();
		JsonArray ja = new JsonArray();
	    String columnName, columnValue = null;
	    ResultSetMetaData rsmd = null;
	    int return_data=0;
	    //找出該ID的所有會員資訊
	    if(tablename.equals("Account")||tablename.equals("Product")) {
//	    	searchsql=searchsql.replaceAll("Account", "Member");
			try {
				select_pstmt = con.prepareStatement(searchsql);
				select_pstmt.setInt(1, id);
				rs=select_pstmt.executeQuery();
	            rsmd = rs.getMetaData();
	            if(tablename.equals("Account")) {
				while (rs.next()) {
					ori_name=rs.getString("Account_Name");
					ori_ename=rs.getString("Account_EName");
					ori_email=rs.getString("Account_Email");
					ori_password=rs.getString("Account_Password");
					ori_phone=rs.getString("Account_Phone");
	                ori_vaild=rs.getInt("Account_Vaild");
	                ori_level=rs.getString("Account_Level");
	                ori_address=rs.getString("Account_Address");
	                }
				}else if(tablename.equals("Product")) {
					while (rs.next()) {
					ori_name=rs.getString("Product_Name");
					ori_price=rs.getString("Product_Price");
					ori_detail=rs.getString("Product_Detail");
					ori_quanity=Integer.toString(rs.getInt("Product_Quanity"));
	                ori_vaild=rs.getInt("Product_Vaild");
					}
				}
			} catch (SQLException e) {
				if(con != null) {
					 try {
				            con.rollback();}
				        catch(SQLException ex) {
				            ex.printStackTrace();
				        }
				}
				out.println("Exception caught: " + e.getMessage());
			}
	    }
		event="變更 ";
		if (type.equals("delete")) {	
			if(tablename.equals("Account")) {
				ori_strvaild=Integer.toString(ori_vaild);
					if(strvaild.equals("0")) {
						event=event+"為有效";
						}else {
						event=event+"為無效";
						}
				}else if(tablename.equals("Product")){
					ori_strvaild=Integer.toString(ori_vaild);
					if(strvaild.equals("0")) {
						event=event+"重新上架";
						}else {
						event=event+"下架";
						}
						
				}
			}
		//AccountLog_Event's content
		String sqlvaild="";
		if (type.equals("update")) {
			if(tablename.equals("Account")) {
//				if(!name.equals(ori_name)){
//					event=event+" 中文姓名:"+ori_name+"->"+name;
//					sql+= "UPDATE `Account` SET `Account_Name`='" + name+" WHERE `Account_ID`=" + id+";";
//				}
//				
//				if(!email.equals(ori_email)){
//					event=event+" 電子信箱:"+ori_email+"->"+email;
//					sql+= "UPDATE `Account` SET `Account_Email`='" + email+" WHERE `Account_ID`=" + id+";";
//				}
//				
//				if(!ename.equals(ori_ename)){
//					event=event+" 英文姓名:"+ori_ename+"->"+ename;
//					sql+= "UPDATE `Account` SET `Account_EName`='" + ename+" WHERE `Account_ID`=" + id+";";
//				}
//				if(!phone.equals(ori_phone)){
//					event=event+" 手機號碼:"+ori_phone+"->"+phone;
//					sql+= "UPDATE `Account` SET `Account_Phone`='" + phone+" WHERE `Account_ID`=" + id+";";
//
//				}
//				if(!address.equals(ori_address)){
//					event=event+" 地址:"+ori_address+"->"+address;
//					sql+= "UPDATE `Account` SET `Account_Address`='" + address+" WHERE `Account_ID`=" + id+";";
//				}
//				if(!password.isEmpty()) {
//					if(!password.equals(ori_password)){
//					event=event+" 密碼";
//					sql+= "UPDATE `Account` SET `Account_Password`='" + password+" WHERE `Account_ID`=" + id+";";
//					}
//				}
				
				if(!level.equals(ori_level)){
					event=event+" 身分權限:"+ori_level+"->"+level;
					sql+= "UPDATE `Account` SET `Account_Level`='" + level+"' WHERE `Account_ID`=" + id+";";
				}
			}
		}else if (type.equals("user_update")) {
			System.out.println("ori_address"+ori_address+"ename"+ename+"ori_ename"+ori_ename);
			if(!name.equals(ori_name)){
				event=event+" 中文姓名:"+ori_name+"->"+name;
				sql+= "UPDATE `Account` SET `Account_Name`='" + name+"' WHERE `Account_ID`=" + id+";";
			}
			
			if(!email.equals(ori_email)){
				event=event+" 電子信箱:"+ori_email+"->"+email;
				sql+= "UPDATE `Account` SET `Account_Email`='" + email+"' WHERE `Account_ID`=" + id+";";
			}
			
			if(!ename.equals(ori_ename)){
				event=event+" 英文姓名:"+ori_ename+"->"+ename;
				sql+= "UPDATE `Account` SET `Account_EName`='" + ename+"' WHERE `Account_ID`=" + id+";";
			}
			if(!phone.equals(ori_phone)){
				event=event+" 手機號碼:"+ori_phone+"->"+phone;
				sql+= "UPDATE `Account` SET `Account_Phone`='" + phone+"' WHERE `Account_ID`=" + id+";";
			}
			if(!address.equals(ori_address)){
				event=event+" 地址:"+ori_address+"->"+address;
				sql+= "UPDATE `Account` SET `Account_Address`='" + address+"' WHERE `Account_ID`=" + id+";";
			}
			if(!password.isEmpty()) {
				if(!password.equals(ori_password)){
				event=event+" 密碼";
				sql+= "UPDATE `Account` SET `Account_Password`='" + password+"' WHERE `Account_ID`=" + id+";";
				}
			}
		}else if (type.equals("cateupdate")) {
			sql += "UPDATE `ShopCategory` SET `ShopCategory_Name` = '"+name+"' WHERE `ShopCategory_ID`="+ id+";";
		}else if (vaild==0) {
			if(tablename.equals("Account")) {
				sql += "UPDATE `Account` SET `Account_Vaild` = 1 WHERE `Account_ID`="+ id+";";
			}else if(tablename.equals("Product")) {
				sql += "UPDATE `Product` SET `Product_Vaild` = 1 WHERE `Product_ID`="+ id+";";
			}else if (type.equals("catedelete")) {
				sql += "UPDATE `ShopCategory` SET `ShopCategory_Vaild` = 1 WHERE `ShopCategory_ID`="+ id+";";
				sqlvaild += "UPDATE `Product`,`CategoryItem`,`ShopCategory`\r\n" + 
						"SET `Product_Vaild`= 1 \r\n" + 
						"WHERE `ShopCategory_ID`="+id+" AND `ShopCategory_ID`=`CategoryItem_CID` AND `CategoryItem_PID`=  `Product_ID` and `ShopCategory_SellerID`="+Integer.toString(doID)+";";
			}
		} else if (vaild==1) {
			if(tablename.equals("Account")) {
				sql += "UPDATE `Account` SET `Account_Vaild` = 0 WHERE `Account_ID`="+ id+";";
			}else if(tablename.equals("Product")) {
				sql += "UPDATE `Product` SET `Product_Vaild` = 0 WHERE `Product_ID`="+ id+";";
			}else if (type.equals("catedelete")) {
				sql += "UPDATE `ShopCategory` SET `ShopCategory_Vaild` = 0 WHERE `ShopCategory_ID`="+ id +";";
				sqlvaild += "UPDATE `Product`,`CategoryItem`,`ShopCategory`\r\n" + 
						"SET `Product_Vaild`= 0  \r\n" + 
						"WHERE `ShopCategory_ID`="+id+" AND `ShopCategory_ID`=`CategoryItem_CID` AND `CategoryItem_PID`=  `Product_ID` and `ShopCategory_SellerID`="+Integer.toString(doID)+";";
			}
		}
		System.out.println(sql);
		System.out.println(event);
		if(tablename.equals("Account")) {
			sqllog = "INSERT INTO `AccountLog`(`AccountLog_DoID`, `AccountLog_Event`, `AccountLog_Time`, `AccountLog_AID`) VALUES (?,?,?,?)";
		}else if(tablename.equals("Product")) {
			sqllog = "INSERT INTO `ProductLog`(`ProductLog_DolD`, `ProductLog_Event`, `ProductLog_Time`, `ProductLog_PID`) VALUES (?,?,?,?)";
		}

		if(!sql.equals("")) {
			if(tablename.equals("Account")||tablename.equals("Product")) {
				try {
					insert_pstmt = con.prepareStatement(sqllog);
					insert_pstmt.setInt(1, doID);
					insert_pstmt.setString(2, event);
					insert_pstmt.setString(3, formatter.format(calendar.getTime()));
					insert_pstmt.setInt(4, id);
					return_data=insert_pstmt.executeUpdate();

				} catch (Exception e) {
					out.println("Exception caught: " + e.getMessage());
				}
			}
			try {
				update_pstmt = con.prepareStatement(sql.substring(0,sql.indexOf(";")));
				return_data=update_pstmt.executeUpdate();
				if(sqlvaild!="") {
					update_pstmt = con.prepareStatement(sqlvaild);
				}

			} catch (Exception e) {
				out.println("Exception caught: " + e.getMessage());
			}
			out.print(return_data);
		}else {
			out.print(2);
		}
		
	}
	
}
