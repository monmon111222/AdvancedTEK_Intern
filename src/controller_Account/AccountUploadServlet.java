package controller_Account;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import model.DB;
import model.InputStream2String;

/**
 * Servlet implementation class uploadToDB
 */
@WebServlet("/AccountUploadServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50) // 50MB
public class AccountUploadServlet extends HttpServlet {
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request, response);
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub		
        System.out.println("AccountUploadServlet");
		PrintWriter out = response.getWriter();
        Part ph=request.getPart("input_account_photo");
		InputStream inputStream = ph.getInputStream();
        Part userid=request.getPart("userID");
        Part tablename=request.getPart("tablename");
        Part doID=request.getPart("doID");
        Part type=request.getPart("type");
        InputStream inputStream2=userid.getInputStream();
        InputStream inputStream3=tablename.getInputStream();
        InputStream inputStream4=doID.getInputStream();
        InputStream inputStream5=type.getInputStream();
        String struserID = InputStream2String.getStringFromInputStream(inputStream2);
        String strtablename = InputStream2String.getStringFromInputStream(inputStream3);
        String strdoID = InputStream2String.getStringFromInputStream(inputStream4);
        String strtype = InputStream2String.getStringFromInputStream(inputStream5);
        int userID=Integer.parseInt(struserID);
        String ds = "java:comp/env/jdbc/TDB";
		Connection con = DB.getConnection(ds);
		PreparedStatement insert_pstmt = null;
		PreparedStatement update_pstmt = null;
		PreparedStatement select_pstmt = null;
		Calendar calendar = Calendar.getInstance();		
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
//		String sql="UPDATE `Account` SET `Account_Photo`= ? ,`Account_PhotoName`= ? WHERE `Account_ID`=?";
		String sql="UPDATE `Account` SET `Account_PhotoName`= ? WHERE `Account_ID`=?";

		String savepath=this.getServletContext().getRealPath("//")+File.separator+"upload"+File.separator+strtablename;
		File uploadedFile = new File(savepath);
		String sql_s="SELECT `Account_PhotoName` FROM `Account`  WHERE `Account_ID`=?";
		ResultSet rs = null;
		String oldfilename=this.getServletContext().getRealPath("//")+File.separator+"upload"+File.separator+strtablename+File.separator;
		try {
			select_pstmt=con.prepareStatement(sql_s);
			select_pstmt.setInt(1,Integer.parseInt(struserID));
			rs=select_pstmt.executeQuery();
			rs.next();
			oldfilename=oldfilename+rs.getString("Account_PhotoName");
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		File deleteFile = new File(oldfilename);
		deleteFile.delete();
		if(!uploadedFile.exists()) {
			uploadedFile.mkdirs();
		}
		ph.write(savepath+File.separator+struserID+".jpg");
		int return_data=0;
		String sql2="INSERT INTO `AccountLog`(`AccountLog_DoID`, `AccountLog_Event`, `AccountLog_Time`,`AccountLog_AID`) VALUES (?,?,?,?)";
		if (inputStream != null) {
            // fetches input stream of the upload file for the blob column
		 try {
			if(strtype.equals("update")) {
			insert_pstmt=con.prepareStatement(sql2); 
			insert_pstmt.setInt(1,Integer.parseInt(strdoID));
			insert_pstmt.setString(2,"修改大頭貼 上傳的檔名: "+ph.getSubmittedFileName());
			insert_pstmt.setString(3,formatter.format(calendar.getTime()));
			insert_pstmt.setInt(4,Integer.parseInt(struserID));
			insert_pstmt.executeUpdate();
			}
//			update_pstmt=con.prepareStatement(sql); 
//			update_pstmt.setBlob(1,inputStream);
//			update_pstmt.setString(2,struserID+".jpg");
//			update_pstmt.setInt(3,userID);
//			return_data=update_pstmt.executeUpdate();
			update_pstmt=con.prepareStatement(sql); 
			//update_pstmt.setBlob(1,inputStream);
			update_pstmt.setString(1,struserID+".jpg");
			update_pstmt.setInt(2,userID);
			return_data=update_pstmt.executeUpdate();

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			try {
//				查詢結束後將 con 的連線釋放，官還給 connection-pool				
			if (con != null)
				con.close();
				} catch (SQLException ignored) {
				}
			}	
        }
		System.out.println("return_data"+return_data);
		out.print(return_data);

	}

}
