package controller_Product;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
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
import org.apache.jasper.tagplugins.jstl.core.Out;

import model.DB;
import model.InputStream2String;

/**
 * Servlet implementation class uploadToDB
 */
@WebServlet("/PrdPhsUploadServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50) // 50MB
public class PrdPhsUploadServlet extends HttpServlet {
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub		
		System.out.println("PrdPhsUploadServlet");
		PrintWriter out = response.getWriter();
        Part doid=request.getPart("doID");
        Part tablename=request.getPart("tablename");
        InputStream inputStream2=doid.getInputStream();
        InputStream inputStream3=tablename.getInputStream();
        String strdoID = InputStream2String.getStringFromInputStream(inputStream2);
        String strtablename = InputStream2String.getStringFromInputStream(inputStream3);
        int doID=Integer.parseInt(strdoID);
        String ds = "java:comp/env/jdbc/TDB";
		Connection con = DB.getConnection(ds);
		String sql="INSERT INTO `ProductPhotos` (`ProductPhotos_Phs`,`ProductPhotos_PrdID`,`ProductPhotos_FileName`,`ProductPhotos_SellerID`) VALUES(?,?,?,?)";
		PreparedStatement insert_pstmt = null;
		List<InputStream> phs = new ArrayList<>();
		List<String> ori_phsname = new ArrayList<>();
		List<String> phsname = new ArrayList<>();
        List<Part> parts = (List<Part>) request.getParts();
        int returndata=0;
        String savepath=this.getServletContext().getRealPath("//")+File.separator+"upload"+File.separator+strtablename+File.separator+strdoID;
        File uploadedFile = new File(savepath);
		if(!uploadedFile.exists()) {
			uploadedFile.mkdirs();
		}
		int fileindex=1;
		if(request.getPart("prdid")!=null) {
			String prdid=InputStream2String.getStringFromInputStream(request.getPart("prdid").getInputStream());
			System.out.println("prdid"+prdid);
//			Integer.parseInt(prdid.replaceAll("[^0-9.]", ""));
			for(Part part : parts) {
				if(part.getName().equals("input_product_phs")) {
					phs.add(part.getInputStream());
					String filename=prdid+"("+fileindex+").jpg";
					ori_phsname.add(filename);
					part.write(savepath+File.separator+filename.trim().replace(" ", ""));
					fileindex++;
				}
			}
			System.out.println("prdid2"+Integer.parseInt(prdid));
			if (phs != null) {
				try {
					for(int i=0;i<phs.size();i++) {
					insert_pstmt=con.prepareStatement(sql); 
					insert_pstmt.setBlob(1,phs.get(i));
					insert_pstmt.setInt(2,Integer.parseInt(prdid.replaceAll("[^0-9.]", "")));
					insert_pstmt.setString(3, ori_phsname.get(i));
					insert_pstmt.setInt(4,doID);
					returndata=insert_pstmt.executeUpdate();
					}
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			out.print(returndata);
		}else {//多個商品的照片上傳
	        for(Part part : parts) {
	        	
	        	String subname = null;
	        	if(part.getSubmittedFileName()!=null) {
	        		phs.add(part.getInputStream());
	        		if(part.getSubmittedFileName().contains("(")) {
	        		subname=part.getSubmittedFileName().substring(0,part.getSubmittedFileName().indexOf("("));
	        		phsname.add(subname.replace(" ", ""));
	        		}else{
			        subname=part.getSubmittedFileName().substring(0,part.getSubmittedFileName().indexOf("."));
			        phsname.add(subname.replace(" ", ""));
	        		}
	        		ori_phsname.add(part.getSubmittedFileName().replace(" ", ""));
	        		part.write(savepath+File.separator+part.getSubmittedFileName().trim().replace(" ", ""));
	        		System.out.println(savepath+File.separator+part.getSubmittedFileName().trim().replace(" ", ""));
	        	}
	        	
	        }
			if (phs != null) {
	            // fetches input stream of the upload file for the blob column
			 try {
				for(int i=0;i<phs.size();i++) {
				insert_pstmt=con.prepareStatement(sql); 
				insert_pstmt.setBlob(1,phs.get(i));
				insert_pstmt.setInt(2,Integer.parseInt(phsname.get(i)));
				insert_pstmt.setString(3, ori_phsname.get(i));
				insert_pstmt.setInt(4,doID);
				returndata=insert_pstmt.executeUpdate();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}finally {
				try {
//					查詢結束後將 con 的連線釋放，官還給 connection-pool				
				if (con != null)
					con.close();
					} catch (SQLException ignored) {
					}
				}	
	        }
		out.print(returndata);
		}
	}

}
