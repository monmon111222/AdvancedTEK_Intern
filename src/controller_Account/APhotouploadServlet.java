package controller_Account;


import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.Part;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import model.DB;



/**
 * Servlet implementation class File_upload
 */
@WebServlet("/APhotouploadServlet")
@MultipartConfig(maxFileSize = 16177215)
public class APhotouploadServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		boolean isMultipart = ServletFileUpload.isMultipartContent(req);
		String return_data = "123";
		String dir_name ="0";
		System.out.println("APhotouploadServlet");
		if(isMultipart) {
			//建立FileItem物件工廠
			DiskFileItemFactory factory = new DiskFileItemFactory();
			// 獲取Servlet上下文
			ServletContext servletContext = this.getServletConfig().getServletContext();
			//獲取臨時資料夾
			File repository = (File) servletContext.getAttribute("javax.servlet.context.tempdir");
			factory.setRepository(repository);
			//建立檔案上傳處理器
			ServletFileUpload upload = new ServletFileUpload((FileItemFactory) factory);
			//解決中文亂碼引數
			upload.setHeaderEncoding("UTF-8");
			// 解析request獲取上傳的引數
			// 使用ServletFileUpload解析器解析上傳資料，解析結果返回的是一個List<FileItem>集合，每一個FileItem對應一個Form表單的輸入項
			List<FileItem> items = null;
			try {
				items = upload.parseRequest(req);
			} catch (FileUploadException e) {
				e.printStackTrace();
			}
			// 處存檔案物件
			FileItem file = null;
			// 儲存所有輸入框參數
			Map<String,String> input_array = new HashMap<String,String>();
			// 處理引數 
			for(FileItem item:items) {
				// 判斷是否為Form的表單域，即判斷是否為普通的資料，若不是則為檔案。
				if(item.isFormField()) {
					//	取得前端物件的 name 名稱
					String name = item.getFieldName();
					//	取得前端物件的 value 值，需使用轉碼避免產生亂滿
					String value = item.getString("UTF-8");
					input_array.put(name, value);
				}else {	
					// 取得要儲存的檔案物件
					file = item;
				}
			}
			
			//	userID 為前端傳來的其他參數的 name
			dir_name = (input_array.get("userID").equals("") || input_array.get("userID").equals("0")) ? "" : input_array.get("userID");
			//	建立 model.fileupload 物件
			//	將檔案儲存
			return_data = Savefile(file, this.getServletContext().getRealPath("//"), dir_name);
			System.out.println("return_data"+return_data);
			if(return_data.equals("123")) {
				res.getWriter().write("1");
			}else {
				res.getWriter().write(return_data);
			}
		}

	}
	
	public String Savefile(FileItem item,String root_dir,String dir_name) {
		//此處獲取的是檔案的全路徑
		String fileFullName = item.getName();
		String temp = (dir_name.equals(""))? "temp" : "Account"+File.separator+dir_name.trim();
//		String temp = "temp"+dir_name.trim();
//		System.out.println("temp :"+temp);
//		System.out.println("file save dir = "+root_dir+File.separator+"upload"+File.separator+temp);
		File savePath = new File(root_dir+File.separator+"upload"+File.separator+temp);
		//	如果路徑不存在，就新建目錄
		if(!savePath.exists()) {
			savePath.mkdirs();
		}
		File uploadedFile = new File(savePath+File.separator+fileFullName);
		System.out.println("file save dir2 = "+savePath+File.separator+fileFullName);
		try {
			//	寫入
			item.write(uploadedFile);
		} catch (Exception e) {
			System.out.println("儲存檔案失敗");
			System.out.println(e);
		}
		if(!uploadedFile.exists()) {
			fileFullName="F";
		}else {
			fileFullName="T";
		}
		return fileFullName;
	}
}
