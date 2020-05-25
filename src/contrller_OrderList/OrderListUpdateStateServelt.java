package contrller_OrderList;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import model.DB;
import model.Mail;

/**
 * Servlet implementation class SearchServelt
 */
@WebServlet("/OrderListUpdateStateServelt")
public class OrderListUpdateStateServelt extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request,response);
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		System.out.println("OrderListUpdateMagServelt");
		int re=0;
		String ds = "java:comp/env/jdbc/TDB";
		Connection con = DB.getConnection(ds);
		PreparedStatement select_pstmt = null;
		PrintWriter out = response.getWriter();
		String sql="";
		String orderstate=request.getParameter("orderstate");
		String oid=request.getParameter("oid");
		String startdate=request.getParameter("startdate");
		String enddate=request.getParameter("enddate");
		System.out.println(startdate+enddate);
		request.getSession().setAttribute("startdate", startdate);
		request.getSession().setAttribute("enddate", enddate);
		String aid=request.getParameter("aid");
		String comid=request.getParameter("comID");
		String statename=request.getParameter("statename");
		sql="UPDATE `OrderList` SET `OrderList_State`=? WHERE `OrderList_ID`= ?";
				try {
					select_pstmt=con.prepareStatement(sql);
					select_pstmt.setInt(1, Integer.parseInt(orderstate));
					select_pstmt.setInt(2, Integer.parseInt(oid));
					re=select_pstmt.executeUpdate();
				} catch (Exception e) {
					out.println("Exception caught: " + e.getMessage());
				}
		
			out.print(re);
		Mail.SendState(Integer.parseInt(aid), comid,statename);	
		}

}
