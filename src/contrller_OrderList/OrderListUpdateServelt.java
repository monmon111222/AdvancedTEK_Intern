package contrller_OrderList;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import model.DB;
import model.InputStream2String;
import model.Mail;
/**
 * Servlet implementation class SearchServelt
 */
@WebServlet("/OrderListUpdateServelt")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
maxFileSize = 1024 * 1024 * 10, // 10MB
maxRequestSize = 1024 * 1024 * 50) // 50MB
public class OrderListUpdateServelt extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request, response);
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		if((String) request.getSession().getAttribute("doID")==null) {
			
		}
		System.out.println("OrderListUpdateServelt");
		String type=""; String OID="";String sqlevent="";String cancel_detail="";String AID=""; String reject_detail="";
		String sele_sql=""; String inst_sql="";String upda_sql=""; String comID=""; String sqlinDB="";
        String uname = "";
        String uphone = "";
        String uaddress ="";
        String uemail = "";
		int check=0;
		Part doid=request.getPart("doID");
//        Part tablename=request.getPart("tablename");
        InputStream inputStream2=doid.getInputStream();
//        InputStream inputStream3=tablename.getInputStream();
        String strdoID = InputStream2String.getStringFromInputStream(inputStream2);
//        String strtablename = InputStream2String.getStringFromInputStream(inputStream3);
        PrintWriter out = response.getWriter();
		String ds = "java:comp/env/jdbc/TDB";
		Connection con = DB.getConnection(ds);
		PreparedStatement update_pstmt = null;
		List<String> sid = new ArrayList<>();
		List<String> ori_sid = new ArrayList<>();
		List<String> pid = new ArrayList<>();
		List<String> quanity = new ArrayList<>();
		List<String> ori_quanity = new ArrayList<>();
		List<String> prdname = new ArrayList<>();
		List<Part> parts = (List<Part>) request.getParts();
        int doID=Integer.parseInt(strdoID);
		PreparedStatement select_pstmt = null;
		ResultSet rs = null;
		PreparedStatement insert_pstmt = null;
		Calendar calendar = Calendar.getInstance();		
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		String event="";
		for(Part part : parts) {
			if(part.getName().equals("PID")) {
				pid.add(InputStream2String.getStringFromInputStream(part.getInputStream()));
			}
			if(part.getName().equals("SID")) {
				sid.add(InputStream2String.getStringFromInputStream(part.getInputStream()));
			}
			if(part.getName().equals("quanity")) {
				quanity.add(InputStream2String.getStringFromInputStream(part.getInputStream()));
			}
			if(part.getName().equals("type")) {
				type=InputStream2String.getStringFromInputStream(part.getInputStream());
			}
			if(part.getName().equals("OID")) {
				OID=InputStream2String.getStringFromInputStream(part.getInputStream());
			}
			if(part.getName().equals("cancel_detail")) {
				cancel_detail=InputStream2String.getStringFromInputStream(part.getInputStream());
			}
			if(part.getName().equals("AID")) {
				AID=InputStream2String.getStringFromInputStream(part.getInputStream());
			}
			if(part.getName().equals("reject_detail")) {
				reject_detail=InputStream2String.getStringFromInputStream(part.getInputStream());
			}
			if(part.getName().equals("uname")) {
				uname=InputStream2String.getStringFromInputStream(part.getInputStream());
			}
			if(part.getName().equals("uaddress")) {
				uaddress=InputStream2String.getStringFromInputStream(part.getInputStream());
			}
			if(part.getName().equals("uemail")) {
				uemail=InputStream2String.getStringFromInputStream(part.getInputStream());
			}
			if(part.getName().equals("uphone")) {
				uphone=InputStream2String.getStringFromInputStream(part.getInputStream());
			}
			
        }
		sele_sql="SELECT `OrderList_ComID` FROM `OrderList` WHERE `OrderList_ID` = ?";
		try {
			select_pstmt=con.prepareStatement(sele_sql);
			select_pstmt.setInt(1,Integer.parseInt(OID));
			rs=select_pstmt.executeQuery();
			rs.next();
			comID=rs.getString("OrderList_ComID");
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		if(type.equals("delete")) {//買家提刪除需求
			event="要求 刪除訂單  原因: "+cancel_detail;
			inst_sql="INSERT INTO `OrderListLog`(`OrderListLog_OID`,`OrderListLog_Event`,`OrderListLog_Time`,`OrderListLog_AID`,`OrderListLog_ComID`,`OrderListLog_Reson`)VALUES(?,?,?,?,?,?)";
			sqlevent="UPDATE `OrderList` SET `OrderList_Vaild`=0 WHERE `OrderList_ID`="+OID+";";
			try {
				insert_pstmt=con.prepareStatement(inst_sql);
				insert_pstmt.setInt(1,Integer.parseInt(OID));
				insert_pstmt.setString(2,event);
				insert_pstmt.setString(3,formatter.format(calendar.getTime()));
				insert_pstmt.setInt(4,doID);
				//insert_pstmt.setString(5,sqlevent);
				insert_pstmt.setString(5,comID);
				insert_pstmt.setString(6,cancel_detail);
				check=insert_pstmt.executeUpdate();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			inst_sql="INSERT INTO `OrderListUpdate`(`OrderListUpdate_OID`,`OrderListUpdate_Event`,`OrderListUpdate_Time`,`OrderListUpdate_AID`,`OrderListUpdate_State`,`OrderListUpdate_ComID`,`OrderListUpdate_Result`,`OrderListUpdate_SqlEvent`)VALUES(?,?,?,?,?,?,?,?)";
			try {
				
				insert_pstmt=con.prepareStatement(inst_sql);
				insert_pstmt.setInt(1,Integer.parseInt(OID));
				insert_pstmt.setString(2,event);
				insert_pstmt.setString(3,formatter.format(calendar.getTime()));
				insert_pstmt.setInt(4,doID);
				insert_pstmt.setInt(5,0);
				insert_pstmt.setString(6,comID);
				insert_pstmt.setInt(7,2);
				insert_pstmt.setString(8,sqlevent);
				check=insert_pstmt.executeUpdate();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			comID.substring(comID.indexOf("S")+1,comID.indexOf("D"));
			Mail.SendReqMail(event,doID,Integer.parseInt(comID.substring(comID.indexOf("S")+1,comID.indexOf("D"))));
		}else if(type.equals("read")) {//賣家已讀需求
			upda_sql="UPDATE `OrderListUpdate` SET `OrderListUpdate_State`= 1 WHERE `OrderListUpdate_OID`=?";	
			try {
				update_pstmt=con.prepareStatement(upda_sql);
				update_pstmt.setInt(1,Integer.parseInt(OID));
				update_pstmt.executeUpdate();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}else if(type.equals("allow")){//賣家允許需求
			sele_sql="SELECT `OrderListUpdate_SqlEvent`,`OrderListUpdate_Event` FROM `OrderListUpdate` WHERE `OrderListUpdate_OID`=? ORDER BY `OrderListUpdate_ID` DESC";
			String retreatsql="";
			try {
				select_pstmt=con.prepareStatement(sele_sql);
				select_pstmt.setInt(1,Integer.parseInt(OID));
				rs=select_pstmt.executeQuery();
				rs.next();
				sqlinDB=rs.getString("OrderListUpdate_SqlEvent");
				event=rs.getString("OrderListUpdate_Event");
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			if(event.contains("數量")) {//要求修改的內容有修改商品數量
				sele_sql="SELECT `OrderItem_Quanity`,`ProductStyle_PID` FROM `OrderItem`,`ProductStyle` WHERE `OrderItem_OID`=? AND `OrderItem_PID`=`ProductStyle_PID`";
				try {
					select_pstmt=con.prepareStatement(sele_sql);
					select_pstmt.setInt(1,Integer.parseInt(OID));
					rs=select_pstmt.executeQuery();
					while(rs.next()) {
						retreatsql+="UPDATE `ProductStyle` SET `ProductStyle_Quanity`=`ProductStyle_Quanity`+"+rs.getInt("OrderItem_Quanity")+" WHERE `ProductStyle_PID`="+rs.getInt("ProductStyle_PID")+";";
					}
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			System.out.println("retreatsql"+"\n"+retreatsql);
			String[] resql=retreatsql.split(";");
			for(int i=0;i<resql.length;i++) {
				try {
					update_pstmt=con.prepareStatement(resql[i]);
					update_pstmt.executeUpdate();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			int total_ch=0;
			String[] orisql=sqlinDB.split(";");
			int []price=new int[orisql.length];
			int []quanity_ch=new int[orisql.length];
			int shipfee=0;
			for(int i=0;i<orisql.length;i++) {
				try {
					update_pstmt=con.prepareStatement(orisql[i]);
					update_pstmt.executeUpdate();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			upda_sql="UPDATE `OrderListUpdate` SET `OrderListUpdate_Result`=1,`OrderListUpdate_State`=1 WHERE `OrderListUpdate_OID`=?";	
				try {
					update_pstmt=con.prepareStatement(upda_sql);
					update_pstmt.setInt(1,Integer.parseInt(OID));
					update_pstmt.executeUpdate();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			inst_sql="INSERT INTO `OrderListLog`(`OrderListLog_OID`,`OrderListLog_Event`,`OrderListLog_Time`,`OrderListLog_AID`,`OrderListLog_ComID`)VALUES(?,?,?,?,?)";
				try {
					event=event.replace("要求", "允許");
					insert_pstmt=con.prepareStatement(inst_sql);
					insert_pstmt.setInt(1,Integer.parseInt(OID));
					insert_pstmt.setString(2,"賣家"+event);
					insert_pstmt.setString(3,formatter.format(calendar.getTime()));
					insert_pstmt.setInt(4,doID);
					insert_pstmt.setString(5,comID);
					check=insert_pstmt.executeUpdate();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			if(event.contains("數量")) {//要求修改的內容有修改商品數量
				sele_sql="SELECT `OrderItem_Quanity`,`Product_Price`,`Shop_ShipFee`,`Product_ID` FROM `OrderItem`,`Product`,`Shop` WHERE `OrderItem_OID`=? AND `OrderItem_PID`=`Product_ID` AND `Product_SellerID`=`Shop_SellerID`";
//				for(int i=0;i<orisql.length;i++) {
//					if(orisql[i].contains("OrderItem")) {
//						quanity_ch[i]=Integer.parseInt(orisql[i].substring(orisql[i].indexOf("y`=")+3,orisql[i].indexOf(" W")));
//						String pid_ch=orisql[i].substring(orisql[i].indexOf("PID`=")+5,orisql[i].indexOf("AND")).trim();
//						try {
//							select_pstmt=con.prepareStatement(sele_sql);
//							select_pstmt.setInt(1,Integer.parseInt(pid_ch));
//							rs=select_pstmt.executeQuery();
//							rs.next();
//							price[i]=Integer.parseInt(rs.getString("Product_Price"));
//						} catch (SQLException e) {
//							// TODO Auto-generated catch block
//							e.printStackTrace();
//						}
//						total_ch+=quanity_ch[i]*price[i];
//					}
//				}
				String stoclsql="";
				try {
					select_pstmt=con.prepareStatement(sele_sql);
					select_pstmt.setInt(1,Integer.parseInt(OID));
					rs=select_pstmt.executeQuery();
					while(rs.next()) {
						stoclsql+="UPDATE `ProductStyle` SET `ProductStyle_Quanity`=`ProductStyle_Quanity`-"+rs.getInt("OrderItem_Quanity")+" WHERE `ProductStyle_PID`="+rs.getInt("Product_ID")+";";
						total_ch+=rs.getInt("OrderItem_Quanity")*rs.getInt("Product_Price");
						shipfee=rs.getInt("Shop_ShipFee");
					}
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				System.out.println("stoclsql"+"\n"+stoclsql);
				String []resql2=stoclsql.split(";");
				for(int i=0;i<resql2.length;i++) {
					try {
						update_pstmt=con.prepareStatement(resql2[i]);
						update_pstmt.executeUpdate();
					} catch (SQLException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
				if(total_ch<shipfee) {
					total_ch=total_ch+60;
				}
				
				upda_sql="UPDATE `OrderList` SET `OrderList_TotalPrice`="+total_ch+" WHERE `OrderList_ID`=?";	
				try {
					update_pstmt=con.prepareStatement(upda_sql);
					update_pstmt.setInt(1,Integer.parseInt(OID));
					check=update_pstmt.executeUpdate();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			if(event.contains("刪除訂單")) {//顧客要求刪除訂單
				upda_sql="UPDATE `OrderList` SET `OrderList_State`=3 WHERE `OrderList_ID`=?";	
				try {
					update_pstmt=con.prepareStatement(upda_sql);
					update_pstmt.setInt(1,Integer.parseInt(OID));
					check=update_pstmt.executeUpdate();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			Mail.SendResMail(event,Integer.parseInt(AID));
			out.print(check);
		}else if(type.equals("update")) {//update(買家提修改需求)
			int qu=0;
			for(int j=0;j<quanity.size();j++) {
				qu=Integer.parseInt(quanity.get(j))+qu;
			}
			System.out.println("qu"+qu);
			if(qu==0) {
				check=-1;
			}else{
				for(int i=0;i<pid.size();i++) {//找出訂單內所購買的商品原本的購買數量
					sele_sql="SELECT `OrderItem_Quanity`,`Product_Name`,`OrderItem_SID`,`ProductStyle_Vaule` FROM `OrderItem`,`Product`,`ProductStyle` WHERE `OrderItem_PID` = ? and `Product_ID` =? and `OrderItem_OID`=? AND `OrderItem_SID`=`ProductStyle_ID`";
					try {
						select_pstmt=con.prepareStatement(sele_sql);
						select_pstmt.setInt(1, Integer.parseInt(pid.get(i)));
						select_pstmt.setInt(2, Integer.parseInt(pid.get(i)));
						select_pstmt.setInt(3, Integer.parseInt(OID));
						rs=select_pstmt.executeQuery();
						rs.next();
						ori_quanity.add(i, Integer.toString(rs.getInt("OrderItem_Quanity")));
						ori_sid.add(i, Integer.toString(rs.getInt("OrderItem_SID")));
						prdname.add(i, rs.getString("Product_Name"));
					} catch (NumberFormatException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					} catch (SQLException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
				sele_sql="SELECT `OrderList_UName`,`OrderList_UPhone`,`OrderList_UAddress`,`OrderList_UEmail` FROM `OrderList` WHERE `OrderList_ID` = ?";
				try {
					select_pstmt=con.prepareStatement(sele_sql);
					select_pstmt.setInt(1,Integer.parseInt(OID));
					rs=select_pstmt.executeQuery();
					rs.next();
					Boolean editu=false;
					if(!uname.equals(rs.getString("OrderList_UName"))) {
						editu=true;
							sqlevent+="UPDATE `OrderList` SET `OrderList_UName`='"+uname+"'WHERE `OrderList_ID` ="+Integer.parseInt(OID)+";";
						event+="收件人:"+rs.getString("OrderList_UName")+"->"+uname+";"+ System.getProperty("line.separator");
					}
					if(!uphone.equals(rs.getString("OrderList_UPhone"))) {
						editu=true;
							sqlevent+="UPDATE `OrderList` SET `OrderList_UPhone`='"+uphone+"'WHERE `OrderList_ID` ="+Integer.parseInt(OID)+";";
						event+="手機號碼:"+rs.getString("OrderList_UPhone")+"->"+uphone+";"+ System.getProperty("line.separator");
					}
					if(!uaddress.equals(rs.getString("OrderList_UAddress"))) {
						editu=true;
							sqlevent+="UPDATE `OrderList` SET `OrderList_UAddress`='"+uaddress+"'WHERE `OrderList_ID` ="+Integer.parseInt(OID)+";";
						event+="收件地址:"+rs.getString("OrderList_UAddress")+"->"+uaddress+";"+ System.getProperty("line.separator");
					}
					if(!uemail.equals(rs.getString("OrderList_UEmail"))) {
						editu=true;
							sqlevent+="UPDATE `OrderList` SET `OrderList_UEmail`='"+uemail+"'WHERE `OrderList_ID` ="+Integer.parseInt(OID)+";";
						event+="電子郵件:"+rs.getString("OrderList_UEmail")+"->"+uemail+";"+ System.getProperty("line.separator");
					}
				} catch (NumberFormatException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				for(int i=0;i<pid.size();i++) {
					String old_stylename = null;
					sele_sql="SELECT `ProductStyle_Vaule` FROM `ProductStyle` WHERE `ProductStyle_ID` = ?";	
					try {
						select_pstmt=con.prepareStatement(sele_sql);
						select_pstmt.setInt(1,Integer.parseInt(ori_sid.get(i)));
						rs=select_pstmt.executeQuery();
						rs.next();
						old_stylename=rs.getString("ProductStyle_Vaule");
					} catch (SQLException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					if(!ori_sid.get(i).equals(sid.get(i))) {//款式不同
						
						String new_stylename = null;
						sele_sql="SELECT `ProductStyle_Vaule` FROM `ProductStyle` WHERE `ProductStyle_ID` = ?";	
						try {
							select_pstmt=con.prepareStatement(sele_sql);
							select_pstmt.setInt(1,Integer.parseInt(sid.get(i)));
							rs=select_pstmt.executeQuery();
							rs.next();
							new_stylename=rs.getString("ProductStyle_Vaule");
						} catch (SQLException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
						if(!ori_quanity.get(i).equals(quanity.get(i))) {//數量也不同
							event+="商品 :"+prdname.get(i)+"款式  :"+old_stylename+"->"+new_stylename+" 數量 :"+ori_quanity.get(i)+"->"+quanity.get(i)+";"+ System.getProperty("line.separator");
							sqlevent+="UPDATE `OrderItem` SET  WHERE `OrderItem_SID`="+sid.get(i)+" WHERE `OrderItem_SID`="+sid.get(i)+" AND  `OrderItem_OID`="+Integer.parseInt(OID)+";";
						}else {//數量相同
							event+="商品 :"+prdname.get(i)+"款式  :"+old_stylename+"->"+new_stylename+";"+ System.getProperty("line.separator");
							sqlevent+="UPDATE `OrderItem` SET  WHERE `OrderItem_SID`="+sid.get(i)+" WHERE `OrderItem_SID`="+sid.get(i)+" AND  `OrderItem_OID`="+Integer.parseInt(OID)+";";	
						}
					}else if(!ori_quanity.get(i).equals(quanity.get(i))) {//只有變動數量
						event+="商品 :"+prdname.get(i)+"款式  :"+old_stylename+"數量 :"+ori_quanity.get(i)+"->"+quanity.get(i)+";"+ System.getProperty("line.separator");
						sqlevent+="UPDATE `OrderItem` SET `OrderItem_Quanity`="+quanity.get(i)+ " WHERE `OrderItem_SID`="+sid.get(i)+" AND `OrderItem_OID`="+Integer.parseInt(OID)+";";
					}
				}
			}	
			if(check!=-1) {
				if(event!="") {
					event="要求 "+event;
					inst_sql="INSERT INTO `OrderListLog`(`OrderListLog_OID`,`OrderListLog_Event`,`OrderListLog_Time`,`OrderListLog_AID`,`OrderListLog_ComID`)VALUES(?,?,?,?,?)";
						try {
							insert_pstmt=con.prepareStatement(inst_sql);
							insert_pstmt.setInt(1,Integer.parseInt(OID));
							insert_pstmt.setString(2,event);
							insert_pstmt.setString(3,formatter.format(calendar.getTime()));
							insert_pstmt.setInt(4,doID);
							insert_pstmt.setString(5,comID);
							check=insert_pstmt.executeUpdate();
						} catch (SQLException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
						inst_sql="INSERT INTO `OrderListUpdate`(`OrderListUpdate_OID`,`OrderListUpdate_Event`,`OrderListUpdate_Time`,`OrderListUpdate_AID`,`OrderListUpdate_State`,`OrderListUpdate_ComID`,`OrderListUpdate_Result`,`OrderListUpdate_SqlEvent`)VALUES(?,?,?,?,?,?,?,?)";
						try {
							
							insert_pstmt=con.prepareStatement(inst_sql);
							insert_pstmt.setInt(1,Integer.parseInt(OID));
							insert_pstmt.setString(2,event);
							insert_pstmt.setString(3,formatter.format(calendar.getTime()));
							insert_pstmt.setInt(4,doID);
							insert_pstmt.setInt(5,0);
							insert_pstmt.setString(6,comID);
							insert_pstmt.setInt(7,2);
							insert_pstmt.setString(8,sqlevent);
							check=insert_pstmt.executeUpdate();
						} catch (SQLException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
						comID.substring(comID.indexOf("S")+1,comID.indexOf("D"));
						Mail.SendReqMail(event,doID,Integer.parseInt(comID.substring(comID.indexOf("S")+1,comID.indexOf("D"))));	
						out.print(check);
					}
			}else {
					System.out.println(check);
					out.print(check);
				
			
			}
		}else if(type.equals("reject")) {
			upda_sql="UPDATE `OrderListUpdate` SET `OrderListUpdate_Result`=0,`OrderListUpdate_State`=1 WHERE `OrderListUpdate_OID`=?";	
			try {
				update_pstmt=con.prepareStatement(upda_sql);
				update_pstmt.setInt(1,Integer.parseInt(OID));
				check=update_pstmt.executeUpdate();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			inst_sql="INSERT INTO `OrderListLog`(`OrderListLog_OID`,`OrderListLog_Event`,`OrderListLog_Time`,`OrderListLog_AID`,`OrderListLog_ComID`)VALUES(?,?,?,?,?)";
			try {
				insert_pstmt=con.prepareStatement(inst_sql);
				insert_pstmt.setInt(1,Integer.parseInt(OID));
				insert_pstmt.setString(2,"賣家拒絕請求 原因: "+reject_detail);
				insert_pstmt.setString(3,formatter.format(calendar.getTime()));
				insert_pstmt.setInt(4,doID);
				insert_pstmt.setString(5,comID);
				check=insert_pstmt.executeUpdate();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			Mail.SendResMail("賣家拒絕請求 原因: "+reject_detail,Integer.parseInt(AID));
			out.print(check);
		}
//		System.out.println(check);
		
	}

}
