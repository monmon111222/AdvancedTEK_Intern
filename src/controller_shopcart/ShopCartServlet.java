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

import java.util.ArrayList;
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
@WebServlet("/ShopCartServlet")
public class ShopCartServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	@SuppressWarnings("null")
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("ShopCartServlet");
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
		String prdID = request.getParameter("prdID");
		String styleID = request.getParameter("styleID");
		if(Integer.parseInt(prdID)==-1) {//clear cart
			request.getSession().removeAttribute("cart");
	        System.out.println("remove");
	    	element = new JsonObject();
	        element.addProperty("CartState","購物車目前為空");
	        ja.add(element);
			out.print(ja);
			}else {
				Map<String,Integer> map = (Map<String, Integer>) request.getSession().getAttribute("cart");
				
//				System.out.println("map == null"+map == null);
				element = new JsonObject();
				if(map == null) {//購物車為空
					map = new HashMap<>();
			        map.put(styleID, 1);
		            element.addProperty(styleID,map.get(styleID));
				}else if(map.isEmpty()){
					map.put(styleID, 1);
		            element.addProperty(styleID,map.get(styleID));
				}else{
//					String samepid = "";
//			        int pidcount = 0;
//					Set<Entry<String, Integer>> set=map.entrySet();
//			        Iterator<Entry<String, Integer>> iterator=set.iterator();
//		            System.out.println("iterator.hasNext()"+iterator.hasNext());
//		            System.out.println("set.size()"+set.size());			        
//			        while(iterator.hasNext()){
//			            Entry<String, Integer> entry=iterator.next();
//			            String name=entry.getKey();
//			            System.out.println("比較"+name.equals(prdID));
//			            int value=entry.getValue();
//			            if(name.equals(prdID)){
//			                //特别注意：不能使用map.remove(name)  否则会报同样的错误
//				            System.out.println("value"+value);
//			            	iterator.remove();
//				            value++;
//			            	map.put(prdID, value++);
//				            System.out.println(map.get(prdID));			            	
//			            }else {
//			            	map.put(prdID, 1);
//			            	System.out.println(map.get(prdID));	
//			            }
//			        }
			        String samepid = "";
			        int pidcount = 0;
					System.out.println("map"+map);
					
					for(String name : map.keySet()){
						if(name.equals(styleID)) {
							int count=map.get(styleID);
							count++;
							pidcount=count;
							samepid=styleID;
						}
					}
					if(samepid!="") {
						map.remove(samepid);
						map.put(samepid, pidcount);
					}else {
						map.put(styleID, 1);
					}
					
					element.addProperty(styleID,map.get(styleID));
    
				}
	            ja.add(element);
	            request.getSession().setAttribute("cart",map);
				out.print(ja);
				}
		}
		 
	}


