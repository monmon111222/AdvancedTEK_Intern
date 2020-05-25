package controller_Product;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Objects;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import model.DB;
import model.removeRepeatChar;

/**
 * Servlet implementation class SearchServelt
 */
@WebServlet("/ProductUpdateServelt")
public class ProductUpdateServelt extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request,response);
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		if(request.getParameter("index")!=null) {
			request.getSession().setAttribute("index", (String)request.getParameter("index"));
		}else {
			request.getSession().setAttribute("index","");
		}
		JsonObject element = null;
		JsonArray ja = new JsonArray();
	    ResultSetMetaData rsmd = null;
	    String columnName, columnValue = null;
		String findname=request.getParameter("name");//商品名稱
		String doID=request.getParameter("doID");
		String type=request.getParameter("type");
		String prdID=null;
		String ds = "java:comp/env/jdbc/TDB";
		Connection con = DB.getConnection(ds);
		PreparedStatement select_pstmt = null;
		PreparedStatement insert_pstmt = null;
		PreparedStatement update_pstmt = null;
		int re=0;
		ResultSet rs = null;
		if(findname==null){
			findname="";
		}
		
		PrintWriter out = response.getWriter();
		String sql="";
		System.out.println("ProductUpdateServelt");							
		
				String updatesql="";
				String ori_name= null,ori_detail=null,ori_cate = null,ori_catename=null;
				String name=request.getParameter("name");
				String price=request.getParameter("price");
				String quanity=request.getParameter("quanity");
				String detail=request.getParameter("detail");
				String event="變更 ";
				int ori_quanity=0;int ori_price=0;
				String category[]=request.getParameterValues("category[]");
				String categoryname[]=request.getParameterValues("categoryname[]");
				String prdqu[]=request.getParameterValues("quanity[]");
				String prdquid[]=request.getParameterValues("quanityid[]");
				Boolean quchange[]=new Boolean[prdquid.length];
				for(int i=0;i<prdquid.length;i++) {
					sql="SELECT * FROM `ProductStyle`" + 
							"WHERE  `ProductStyle_ID`=?";
					try {
						select_pstmt=con.prepareStatement(sql);
						select_pstmt.setInt(1,Integer.parseInt(prdquid[i]));
						rs=select_pstmt.executeQuery();
						rs.next();
						if(rs.getString("ProductStyle_Quanity").equals(prdqu[i])) {
						
						}else {
							quchange[i]=false;
							updatesql+="UPDATE `ProductStyle` SET `ProductStyle_Quanity`="+prdqu[i]+" WHERE `ProductStyle_ID`="+prdquid[i]+";";
							event=event+rs.getString("ProductStyle_Vaule")+" 數量:"+rs.getString("ProductStyle_Quanity")+"->"+prdqu[i];
						}
					} catch (Exception e) {
						out.println("Exception caught: SELECT * FROM `ProductStyle`" + e.getMessage());
					}
				}
				String catename="";
				catename=categoryname[0];
				for(int i=1;i<categoryname.length;i++) {
					catename+=","+categoryname[i];
				}
				Boolean catecheck[]=new Boolean[category.length];
				for(int i=0;i<catecheck.length;i++) {
					catecheck[i]=false;
				}
				prdID=request.getParameter("id");
				sql="SELECT `Product_Vaild`,`Product_ID`,`Product_Name`,`Product_Detail`,`Product_Price`,`Product_Price`,`Product_SellerID`,GROUP_CONCAT(ShopCategory_ID  ORDER BY ShopCategory_ID ASC) AS 'ShopCategory_ID',GROUP_CONCAT(ShopCategory_Name ORDER BY ShopCategory_ID ASC) AS 'ShopCategory_Name' FROM `Product` LEFT JOIN `CategoryItem` ON `Product_ID` = `CategoryItem_PID` LEFT JOIN `ShopCategory`  ON `CategoryItem_CID`=`ShopCategory_ID`" + 
						"WHERE  `Product_ID`=? GROUP BY `Product_ID`";
				try {
					select_pstmt=con.prepareStatement(sql);
					select_pstmt.setInt(1,Integer.parseInt(prdID));
					rs=select_pstmt.executeQuery();
					rs.next();
					ori_name=rs.getString("Product_Name");
					ori_detail=rs.getString("Product_Detail");
					ori_cate=removeRepeatChar.remove(rs.getString("ShopCategory_ID"));
					ori_catename=removeRepeatChar.remove(rs.getString("ShopCategory_Name"));
					ori_price=rs.getInt("Product_Price");
				} catch (Exception e) {
					out.println("Exception caught: SELECT `Product_Vaild`" + e.getMessage());
				}
				String ori_category[]=ori_cate.split(",");
				Boolean ori_catecheck[]=new Boolean[ori_category.length];
				for(int i=0;i<ori_catecheck.length;i++) {
					ori_catecheck[i]=false;
				}
				if(category.length!=ori_category.length) {
					event=event+" 分類增加:"+ori_catename+"->"+catename;
					if(category.length>ori_category.length) {//該商品的分類增加
						for(int i=0;i<category.length;i++) {
							for(int j=0;j<ori_category.length;j++) {
								if(category[i].equals(ori_category[j])) {
									catecheck[i]=true;
								}
							}
						}
						String cateind="";
						for(int i=0;i<catecheck.length;i++) {
							if(catecheck[i]==false) {
								if(cateind==""){
									cateind=category[i];
								}else {
									cateind+=","+category[i];
								}
							}
						}
						String index[]=cateind.split(",");
						sql="INSERT INTO `CategoryItem` (`CategoryItem_PID`,`CategoryItem_CID`) VALUES(?,?)";
						for(int i=0;i<index.length;i++) {
						try {
							insert_pstmt = con.prepareStatement(sql);
							insert_pstmt.setInt(1,Integer.parseInt(prdID));
							insert_pstmt.setInt(2,Integer.parseInt(index[i]));
							insert_pstmt.executeUpdate();
							} catch (Exception e) {
								out.println("Exception caught: INSERT INTO `CategoryItem`" + e.getMessage());
							}
						}
					}else if(category.length<ori_category.length) {//該商品的分類減少
						for(int i=0;i<ori_category.length;i++) {
							for(int j=0;j<category.length;j++) {
								if(ori_category[i].equals(category[j])) {
									ori_catecheck[i]=true;
								}
							}
						}
						String cateind="";
						for(int i=0;i<ori_catecheck.length;i++) {
							if(ori_catecheck[i]==false) {
								if(cateind==""){
									cateind=ori_category[i];
								}else {
									cateind+=","+ori_category[i];
								}
							}
						}
						String index[]=cateind.split(",");
						sql="DELETE FROM `CategoryItem` WHERE `CategoryItem_PID`=? AND `CategoryItem_CID`=?";
						for(int i=0;i<index.length;i++) {
						try {
							insert_pstmt = con.prepareStatement(sql);
							insert_pstmt.setInt(1,Integer.parseInt(prdID));
							insert_pstmt.setInt(2,Integer.parseInt(index[i]));
							insert_pstmt.executeUpdate();
							} catch (Exception e) {
								out.println("Exception caught: DELETE CategoryItem" + e.getMessage());
							}
						}
					}
				}else {
					for(int i=0;i<category.length;i++) {//該商品的分類被修改
						for(int j=0;j<ori_category.length;j++) {
							if(category[i].equals(ori_category[j])) {
								catecheck[i]=true;
							}
						}
					}
					String deind="";
					String cateind="";
					for(int i=0;i<catecheck.length;i++) {
						if(catecheck[i]==false) {
							event=event+" 分類修改:"+ori_catename+"->"+catename;
							if(cateind==""){
								cateind=category[i];
								deind=ori_category[i];
							}else {
								cateind+=","+category[i];
								deind+=","+ori_category[i];
							}
						}
					}
					if(event.contains("分類修改")) {
						String deindex[]=deind.split(",");
						String index[]=cateind.split(",");
						sql="UPDATE `CategoryItem` SET `CategoryItem_CID`=? WHERE `CategoryItem_PID`=? AND `CategoryItem_CID`=?";
						for(int i=0;i<index.length;i++) {
						try {
							insert_pstmt = con.prepareStatement(sql);
							
								insert_pstmt.setInt(2,Integer.parseInt(prdID));
								insert_pstmt.setInt(1,Integer.parseInt(index[i]));
								insert_pstmt.setInt(3,Integer.parseInt(deindex[i]));
							
							insert_pstmt.executeUpdate();
							} catch (Exception e) {
								out.println("Exception caught CategoryItem: " + e.getMessage());
							}
						}
					}
				}
				sql="";
				if(!name .equals(ori_name)){
					event=event+" 商品名稱:"+ori_name+"->"+name;
					updatesql+="UPDATE `Product` SET `Product_Name`='"+name.trim()+"' WHERE `Product_ID`="+prdID+";";
				}
				if(!detail .equals(ori_detail.replaceAll("\r\n","\n"))){
					event=event+" 細節說明:"+ori_detail+"->"+detail;
					updatesql+="UPDATE `Product` SET `Product_Detail`='"+detail+"' WHERE `Product_ID`="+prdID+";";
				}
				if(!price .equals(Integer.toString(ori_price))){
					event=event+" 價格:"+ori_price+"->"+price;
					updatesql+="UPDATE `Product` SET `Product_Price`="+price+" WHERE `Product_ID`="+prdID+";";
				}
				if(updatesql!="") {
					try {
						insert_pstmt = con.prepareStatement(updatesql);
						insert_pstmt.executeUpdate();
					} catch (Exception e) {
							out.println("Exception caught Product: " + e.getMessage());
					}
					Calendar calendar = Calendar.getInstance();		
					SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm");
					String insql= "INSERT INTO `ProductLog`(`ProductLog_DolD`, `ProductLog_Event`, `ProductLog_Time`, `ProductLog_PID`) VALUES (?,?,?,?)";
					try {
						insert_pstmt = con.prepareStatement(insql);
						insert_pstmt.setInt(1, Integer.parseInt(doID));
						insert_pstmt.setString(2, event);
						insert_pstmt.setString(3, formatter.format(calendar.getTime()));
						insert_pstmt.setInt(4, Integer.parseInt(prdID));
						re=insert_pstmt.executeUpdate();
					} catch (Exception e) {
							out.println("Exception caught ProductLog: " + e.getMessage());
					
					}
					out.print(re);
				}else {
					out.print(1);
				}
				
			}

	}
