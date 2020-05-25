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

import org.json.JSONObject;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.Map.Entry;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;

import model.DB;


@WebServlet("/RenewShopCartServlet")
public class RenewShopCartServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("RenewShopCartServlet");
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
		String[] prdid_incart = request.getParameterValues("prdid_incart[]");//款式ID
		
		String[] prdamount_incart = request.getParameterValues("prdamount_incart[]");
		
		String type=request.getParameter("type");
		Map<String,Integer> map = (Map<String, Integer>) request.getSession().getAttribute("cart");
		JsonArray checkcart = (JsonArray) request.getSession().getAttribute("checkcart");
		if(type.equals("side")) {
	    	element = new JsonObject();
	    	if(prdid_incart!=null) {
				for(int i=0;i<prdid_incart.length;i++) {
					map.remove(prdid_incart[i]);
					map.put(prdid_incart[i],Integer.parseInt(prdamount_incart[i]));
				}
			}
			request.getSession().setAttribute("cart",map);
		}else {
	    	if(prdid_incart!=null&&checkcart!=null) {
				for(int i=0;i<prdid_incart.length;i++) {
					for(int x=0;x<checkcart.size();x++) {
						if(checkcart.get(x).getAsJsonObject().get("ProductStyle_ID").toString().replaceAll("\"", "").equals(prdid_incart[i])) {
							checkcart.get(x).getAsJsonObject().remove("BuyNumber");
							checkcart.get(x).getAsJsonObject().addProperty("BuyNumber", Integer.parseInt(prdamount_incart[i]));
						}
					}

				}
			}
			//System.out.println("checkcart"+checkcart);
			request.getSession().setAttribute("cart",map);
			request.getSession().setAttribute("checkcart",checkcart);
		}

		ja.add(element);
		out.print(ja);

		}
		 
	}


