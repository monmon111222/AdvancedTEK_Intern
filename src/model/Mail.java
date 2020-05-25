package model;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.activation.DataSource;
import com.google.gson.JsonObject;
public class Mail {
	public static String SendVaildMail(String email,int AID) {
		  
//	      String to = "";//收件信箱
//	      String from = "";//顯示在寄件者的信箱
//	      final String username = "";//登入帳號
//	      final String password = "";//登入密碼
//	      // Assuming you are sending email through relay.jangosmtp.net
//	      String host = "smtp.gmail.com";
	      Properties props = new Properties();
	      props.put("mail.smtp.auth", "true");
	      props.put("mail.smtp.starttls.enable", "true");
	      props.put("mail.smtp.host", "smtp.gmail.com");
	      props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
	      props.put("mail.smtp.port", "587");
	      // gmail 的 smtp 設定值為 587
//	      props.put("mail.smtp.port", "587");
	      //	錯誤發生在 session 或 message 時
	      //	請檢察 web-inf 有無匯入檔案 javax.mail 及 activation
	      //	google 帳號需開啟 低安全性應用程式存取權 才行
	      // Get the Session object.
	      String from="bigoni@gmail.com";
	      String mailun="xh61371@gmail.com";
	      String mailpsd="br171001";
	      Session session = Session.getInstance(props,
	      new javax.mail.Authenticator() {
	         protected PasswordAuthentication getPasswordAuthentication() {
	            return new PasswordAuthentication(mailun, mailpsd);
	         }
	      });
	      try {
	         // Create a default MimeMessage object.
	         Message message = new MimeMessage(session);

	         // Set From: header field of the header.
	         message.setFrom(new InternetAddress(from));

	         // Set To: header field of the header.
	         message.setRecipients(Message.RecipientType.TO,
	         InternetAddress.parse(getemail(AID)));

	         // Set Subject: header field
	         message.setSubject("BIGONI 購物網站驗證");

	         // Now set the actual message
	         message.setContent(getvaildmessage(AID),"text/html; charset=UTF-8");
	         // Send message
	         Transport.send(message);

	         System.out.println("Sent successfully....");

	      } catch (MessagingException e) {
	            throw new RuntimeException(e);
	      }
		return from;
	}
	public static String SendAdminVaildMail(String email,int FromID,int AID,String un,String pa) {
		  
	      Properties props = new Properties();
	      props.put("mail.smtp.auth", "true");
	      props.put("mail.smtp.starttls.enable", "true");
	      props.put("mail.smtp.host", "smtp.gmail.com");
	      props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
	      props.put("mail.smtp.port", "587");
	      String from="bigoni@gmail.com";
	      String mailun="xh61371@gmail.com";
	      String mailpsd="br171001";
	      Session session = Session.getInstance(props,
	      new javax.mail.Authenticator() {
	         protected PasswordAuthentication getPasswordAuthentication() {
	            return new PasswordAuthentication(mailun, mailpsd);
	         }
	      });
	      try {
	         // Create a default MimeMessage object.
	         Message message = new MimeMessage(session);

	         // Set From: header field of the header.
	         message.setFrom(new InternetAddress(from));

	         // Set To: header field of the header.
	         message.setRecipients(Message.RecipientType.TO,
	         InternetAddress.parse(getemail(AID)));

	         // Set Subject: header field
	         message.setSubject("BIGONI 購物網站驗證");

	         // Now set the actual message
	         message.setContent(getadminvaildmessage(FromID,AID,un,pa),"text/html; charset=UTF-8");
	         // Send message
	         Transport.send(message);

	         System.out.println("Sent successfully....");

	      } catch (MessagingException e) {
	            throw new RuntimeException(e);
	      }
		return from;
	}
	public static String SendReqMail(String event,int AID,int SID) {
	      Properties props = new Properties();
	      props.put("mail.smtp.auth", "true");
	      props.put("mail.smtp.starttls.enable", "true");
	      props.put("mail.smtp.host", "smtp.gmail.com");
	      props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
	      // gmail 的 smtp 設定值為 587
	      props.put("mail.smtp.port", "587");
//	      props.put("mail.smtp.port", "587");
	      //	錯誤發生在 session 或 message 時
	      //	請檢察 web-inf 有無匯入檔案 javax.mail 及 activation
	      //	google 帳號需開啟 低安全性應用程式存取權 才行
	      // Get the Session object.
	      String from="bigoni@gmail.com";
	      String mailun="xh61371@gmail.com";
	      String mailpsd="br171001";
	      Session session = Session.getInstance(props,
	      new javax.mail.Authenticator() {
	         protected PasswordAuthentication getPasswordAuthentication() {
	            return new PasswordAuthentication(mailun, mailpsd);
	         }
	      });
	      try {
	         // Create a default MimeMessage object.
	         Message message = new MimeMessage(session);

	         // Set From: header field of the header.
	         message.setFrom(new InternetAddress(from));

	         // Set To: header field of the header.
	         message.setRecipients(Message.RecipientType.TO,
	         InternetAddress.parse(getemail(SID)));
	         // Set Subject: header field
	         message.setSubject("BIGONI 買家提出修改訂單需求");

	         // Now set the actual message
	         message.setContent(getreqdmessage(AID,event),"text/html; charset=UTF-8");
	         // Send message
	         Transport.send(message);

	         System.out.println("Sent to "+getemail(SID)+" successfully....");

	      } catch (MessagingException e) {
	            throw new RuntimeException(e);
	      }
		return from;
	}
	public static String SendResMail(String event,int AID) {
	      Properties props = new Properties();
	      props.put("mail.smtp.auth", "true");
	      props.put("mail.smtp.starttls.enable", "true");
	      props.put("mail.smtp.host", "smtp.gmail.com");
	      props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
	      props.put("mail.smtp.port", "587");
	      String from="bigoni@gmail.com";
	      String mailun="xh61371@gmail.com";
	      String mailpsd="br171001";
	      // Get the Session object.
	      Session session = Session.getInstance(props,
	      new javax.mail.Authenticator() {
	         protected PasswordAuthentication getPasswordAuthentication() {
	            return new PasswordAuthentication(mailun, mailpsd);
	         }
	      });
	      try {
	         // Create a default MimeMessage object.
	         Message message = new MimeMessage(session);

	         // Set From: header field of the header.
	         message.setFrom(new InternetAddress(from));

	         // Set To: header field of the header.
	         message.setRecipients(Message.RecipientType.TO,
	         InternetAddress.parse(getemail(AID)));

	         // Set Subject: header field
	         message.setSubject("BIGONI 賣家回復您所提出的修改訂單需求");

	         // Now set the actual message
	         message.setContent(getresdmessage(AID,event),"text/html; charset=UTF-8");
	         // Send message
	         Transport.send(message);

	         System.out.println("Sent to "+getemail(AID)+" successfully....");

	      } catch (MessagingException e) {
	            throw new RuntimeException(e);
	      }
		return from;
	}
	public static String Send2BuyerMail(int AID,String comID,String email) {
	      Properties props = new Properties();
	      props.put("mail.smtp.auth", "true");
	      props.put("mail.smtp.starttls.enable", "true");
	      props.put("mail.smtp.host", "smtp.gmail.com");
	      props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
	      props.put("mail.smtp.port", "587");
	      String from="bigoni@gmail.com";
	      String mailun="xh61371@gmail.com";
	      String mailpsd="br171001";
	      Session session = Session.getInstance(props,
	      new javax.mail.Authenticator() {
	         protected PasswordAuthentication getPasswordAuthentication() {
	            return new PasswordAuthentication(mailun, mailpsd);
	         }
	      });
	      try {
	    	 System.out.println(email);
	         // Create a default MimeMessage object.
	         Message message = new MimeMessage(session);

	         // Set From: header field of the header.
	         message.setFrom(new InternetAddress(from));

	         // Set To: header field of the header.
	         message.setRecipients(Message.RecipientType.TO,
	         InternetAddress.parse(email));
	         // Set Subject: header field
	         message.setSubject("BIGONI 收到您的訂單");

//	         // Now set the actual message
//	         message.setContent(get2buyermessage(AID,comID),"text/html; charset=UTF-8");
//	         // Send message
//	         Transport.send(message);
	      // This mail has 2 part, the BODY and the embedded image
	          MimeMultipart multipart = new MimeMultipart("related");

	          // first part (the html)
	          BodyPart messageBodyPart = new MimeBodyPart();
	          String htmlText = "<img src=\"cid:image\" style=\"height=300px;width=300px;\">";
	          messageBodyPart.setContent(get2buyermessage(AID,comID),"text/html; charset=UTF-8");
	          // add it
	          multipart.addBodyPart(messageBodyPart);

	          // second part (the image)
	          
	          ArrayList<DataSource> img =getprdimg(AID,comID);
	          for(int i=0;i<img.size();i++) {
	        messageBodyPart = new MimeBodyPart();  
	          messageBodyPart.setDataHandler(new DataHandler(img.get(i)));
	          messageBodyPart.setHeader("Content-ID", "<image>");
	          multipart.addBodyPart(messageBodyPart);
	          }
	          // add image to the multipart
	          

	          // put everything together
	          message.setContent(multipart);
	          // Send message
	          Transport.send(message);
	         System.out.println("Sent to "+email+" successfully....");

	      } catch (MessagingException e) {
	            throw new RuntimeException(e);
	      }
		return from;
	}
	public static String Send2SellerMail(int AID,String comID) {
	      Properties props = new Properties();
	      props.put("mail.smtp.auth", "true");
	      props.put("mail.smtp.starttls.enable", "true");
	      props.put("mail.smtp.host", "smtp.gmail.com");
	      props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
	      props.put("mail.smtp.port", "587");
	      String from="bigoni@gmail.com";
	      String mailun="xh61371@gmail.com";
	      String mailpsd="br171001";
	      Session session = Session.getInstance(props,
	      new javax.mail.Authenticator() {
	         protected PasswordAuthentication getPasswordAuthentication() {
	            return new PasswordAuthentication(mailun, mailpsd);
	         }
	      });
	      try {
	         // Create a default MimeMessage object.
	         Message message = new MimeMessage(session);

	         // Set From: header field of the header.
	         message.setFrom(new InternetAddress(from));

	         // Set To: header field of the header.
	         message.setRecipients(Message.RecipientType.TO,
	         InternetAddress.parse(getemail(AID)));
	         // Set Subject: header field
	         message.setSubject("BIGONI 提醒您有一筆新的訂單");
//
//	         // Now set the actual message
//	         message.setContent(get2sellermessage(AID,comID),"text/html; charset=UTF-8");
//	         // Send message
//	         Transport.send(message);
	          // This mail has 2 part, the BODY and the embedded image
	          MimeMultipart multipart = new MimeMultipart("related");

	          // first part (the html)
	          BodyPart messageBodyPart = new MimeBodyPart();
	          String htmlText = "<img src=\"cid:image\" style=\"height=300px;width=300px;\">";
	          messageBodyPart.setContent(get2sellermessage(AID,comID),"text/html; charset=UTF-8");
	          // add it
	          multipart.addBodyPart(messageBodyPart);

	          // second part (the image)
	          
	          ArrayList<DataSource> img =getprdimg(AID,comID);
	          //DataSource fds =  new FileDataSource("D:/Bonnie_Project/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps/Cookies/upload/Product/29/147.jpg");
	          for(int i=0;i<img.size();i++) {
	        messageBodyPart = new MimeBodyPart();
	          messageBodyPart.setDataHandler(new DataHandler(img.get(i)));
	          messageBodyPart.setHeader("Content-ID", "<image>");
	          multipart.addBodyPart(messageBodyPart);
	          }	          

	          // put everything together
	          message.setContent(multipart);
	          // Send message
	          Transport.send(message);
	         System.out.println("Sent to "+getemail(AID)+" successfully....");

	      } catch (MessagingException e) {
	            throw new RuntimeException(e);
	      }
		return from;
	}
	public static String SendState(int AID,String comID,String statename) {
	      Properties props = new Properties();
	      props.put("mail.smtp.auth", "true");
	      props.put("mail.smtp.starttls.enable", "true");
	      props.put("mail.smtp.host", "smtp.gmail.com");
	      props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
	      props.put("mail.smtp.port", "587");
	      String from="bigoni@gmail.com";
	      String mailun="xh61371@gmail.com";
	      String mailpsd="br171001";
	      Session session = Session.getInstance(props,
	      new javax.mail.Authenticator() {
	         protected PasswordAuthentication getPasswordAuthentication() {
	            return new PasswordAuthentication(mailun, mailpsd);
	         }
	      });
	      try {
	         // Create a default MimeMessage object.
	         Message message = new MimeMessage(session);

	         // Set From: header field of the header.
	         message.setFrom(new InternetAddress(from));

	         // Set To: header field of the header.
	         message.setRecipients(Message.RecipientType.TO,
	         InternetAddress.parse(getemail(AID)));
	         // Set Subject: header field
	         String title="BIGONI 提醒您賣家更新訂單狀態:"+statename;
	         message.setSubject(title);
//
//	         // Now set the actual message
//	         message.setContent(get2sellermessage(AID,comID),"text/html; charset=UTF-8");
//	         // Send message
//	         Transport.send(message);
	          // This mail has 2 part, the BODY and the embedded image
	          MimeMultipart multipart = new MimeMultipart("related");

	          // first part (the html)
	          BodyPart messageBodyPart = new MimeBodyPart();
	          String htmlText = "<img src=\"cid:image\" style=\"height=300px;width=300px;\">";
	          messageBodyPart.setContent(getstatemessage(AID,comID),"text/html; charset=UTF-8");
	          // add it
	          multipart.addBodyPart(messageBodyPart);

	          // second part (the image)
	          
	          ArrayList<DataSource> img =getprdimg(AID,comID);
	          //DataSource fds =  new FileDataSource("D:/Bonnie_Project/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps/Cookies/upload/Product/29/147.jpg");
	          for(int i=0;i<img.size();i++) {
	        messageBodyPart = new MimeBodyPart();
	          messageBodyPart.setDataHandler(new DataHandler(img.get(i)));
	          messageBodyPart.setHeader("Content-ID", "<image>");
	          multipart.addBodyPart(messageBodyPart);
	          }	          

	          // put everything together
	          message.setContent(multipart);
	          // Send message
	          Transport.send(message);
	         System.out.println("Sent to "+getemail(AID)+" successfully....");

	      } catch (MessagingException e) {
	            throw new RuntimeException(e);
	      }
		return from;
	}
public static String getvaildmessage(int AID) {
	
	String messagetext="<html lang=\"zh-TW\"><head>\r\n" + 
			"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">\r\n" +
			"<meta charset='utf-8' />"+
			"</head>\r\n" + 
			"<body>\r\n" + 
			"<h3 style=\"color: black;font-family: monospace;font-size:large\">"+getusername(AID)+"</h3><br>\r\n" + 
			"<h4 style=\"color: black;font-family: monospace;\">感謝您註冊本平台的會員，請點選以下連結進行會員帳號驗證</h4><br>\r\n" + 
			"<a href='http://localhost:8081/Cookies/VaildServlet?AID="+Integer.toString(AID)+"' style=\"color: black;font-family: monospace;\">連結</a>"+
			"</body>\r\n" + 
			"</html>";
	return messagetext;
}
public static String getadminvaildmessage(int FromID,int AID,String un,String pa) {
	
	String messagetext="<html lang=\"zh-TW\"><head>\r\n" + 
			"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">\r\n" +
			"<meta charset='utf-8' />"+
			"</head>\r\n" + 
			"<body>\r\n" + 
			"<h3 style=\"color: black;font-family: monospace;font-size:large\">"+getusername(AID)+"</h3><br>\r\n" + 
			"<h4 style=\"color: black;font-family: monospace;\">管理員"+getusername(FromID)+" 已為你新增一組帳號密碼</h4><br>\r\n" + 
			"<h4 style=\"color: black;font-family: monospace;\">帳號 :  "+un+"</h4><br>\r\n" + 
			"<h4 style=\"color: black;font-family: monospace;\">密碼 :  "+pa+"</h4><br>\r\n" + 
			"<h4 style=\"color: black;font-family: monospace;\">請點選以下連結進行會員帳號驗證</h4><br>\r\n" +
			"<h4 style=\"color: black;font-family: monospace;\">驗證後再到到個人專區/會員資料 修正密碼</h4><br>\r\n" + 
			"<a href='http://localhost:8081/Cookies/VaildServlet?AID="+Integer.toString(AID)+"' style=\"color: black;font-family: monospace;\">連結</a>"+
			"</body>\r\n" + 
			"</html>";
	return messagetext;
}
public static String getreqdmessage(int AID,String event) {
	String messagetext="<html lang=\"zh-TW\"><head>\r\n" + 
			"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">\r\n" +
			"<meta charset='utf-8' />"+
			"</head>\r\n" + 
			"<body>\r\n" + 
			"<h3 style=\"color: black;font-family: monospace;font-size:large\">"+getusername(AID)+" 向平台提出變更訂單的需求 :</h3><br>\r\n" + 
			"<h4 style=\"color: black;font-family: monospace;\">"+event+"</h4><br>\r\n" + 
			"</body>\r\n" + 
			"</html>";
	return messagetext;
}
public static String getresdmessage(int AID,String event) {
	String messagetext="<html lang=\"zh-TW\"><head>\r\n" + 
			"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">\r\n" +
			"<meta charset='utf-8' />"+
			"</head>\r\n" + 
			"<body>\r\n" + 
			"<h3 style=\"color: black;font-family: monospace;font-size:large\">賣家回復您的需求 :</h3><br>\r\n" + 
			"<h4 style=\"color: black;font-family: monospace;\">"+event+"</h4><br>\r\n" + 
			"</body>\r\n" + 
			"</html>";
	return messagetext;
}
public static String get2buyermessage(int AID,String comID) {
	String ds = "java:comp/env/jdbc/TDB";
	Connection con = DB.getConnection(ds);
	PreparedStatement select_pstmt = null;
	ResultSet rs = null;
	String oricomid=comID;
    comID=comID.substring(comID.indexOf("O")+1);
	int id=Integer.parseInt(comID);
	String tbody="";
	String sql="SELECT * FROM `OrderList`,`OrderItem`,`Product`,`ProductPhotos`,`ProductStyle` "
			+ "WHERE `OrderList_ID` = ? AND `OrderItem_OID` = ? AND `OrderItem_PID`=`Product_ID` AND `ProductPhotos_PrdID`=`Product_ID` AND `OrderItem_SID`=`ProductStyle_ID` "
			+ "GROUP BY `ProductStyle_ID`";
	try {
		select_pstmt=con.prepareStatement(sql);
		select_pstmt.setInt(1,id);
		select_pstmt.setInt(2,id);
		rs=select_pstmt.executeQuery();
		while (rs.next()) {// 材料:物件 設計圖:類別
			tbody+="<tr>";
//			tbody+="<td> <img src=\"cid:image\"></td>";
			tbody+="<td>"+rs.getString("Product_Name")+"</td>";
			tbody+="<td>"+rs.getString("OrderItem_Quanity")+"</td>";
			tbody+="<td>"+rs.getString("ProductStyle_Vaule")+"</td>";
			tbody+="<td>"+rs.getString("Product_Price")+"</td>";
			tbody+="</tr>";
		}
	} catch (Exception e) {
		System.out.println("Exception caught: " + e.getMessage());
	}
//	System.out.println(tbody);
	String messagetext="<html lang=\"zh-TW\"><head>\r\n" + 
			"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">\r\n" +
			"<meta charset='utf-8' />"+
			"</head>\r\n" + 
			"<body>\r\n" + 
			"<h3 style=\"color: black;font-family: monospace;font-size:large\">"+getusername(AID)+"</h3><br>\r\n" +
			"<h4 style=\"color: black;font-family: monospace;\">您的商店於 BIGONI 感謝您的訂單: "+oricomid+"</h4><br>\r\n" ;
	messagetext+="<table id='tbody'><thead><tr><th>名稱</th><th>款式</th><th>數量</th><th>單價</th></tr></thead><tbody>";
	messagetext+=tbody+"</tbody></table><br><h4 style=\"color: brown;font-family: monospace;\">如對於商品有疑問，請先查附件圖片是否為您的商品，再到BIGIBI的個人專區/訂單查詢向賣家提出訂單修改的需求</h4>";
			messagetext+="</body>\r\n" + 
					"</html>";
	return messagetext;
}
public static String getstatemessage(int AID,String comID) {
	String ds = "java:comp/env/jdbc/TDB";
	Connection con = DB.getConnection(ds);
	PreparedStatement select_pstmt = null;
	ResultSet rs = null;
	String oricomid=comID;
    comID=comID.substring(comID.indexOf("O")+1);
	int id=Integer.parseInt(comID);
	String tbody="";
	String sql="SELECT * FROM `OrderList`,`OrderItem`,`Product`,`ProductPhotos` "
			+ "WHERE `OrderList_ID` = ? AND `OrderItem_OID` = ? AND `OrderItem_PID`=`Product_ID` AND `ProductPhotos_PrdID`=`Product_ID` "
			+ "GROUP by `ProductPhotos_PrdID`";
	try {
		select_pstmt=con.prepareStatement(sql);
		select_pstmt.setInt(1,id);
		select_pstmt.setInt(2,id);
		rs=select_pstmt.executeQuery();
		while (rs.next()) {// 材料:物件 設計圖:類別
			tbody+="<tr>";
//			tbody+="<td> <img src=\"cid:image\"></td>";
			tbody+="<td>"+rs.getString("Product_Name")+"</td>";
			tbody+="<td>"+rs.getString("OrderItem_Quanity")+"</td>";
			tbody+="<td>"+rs.getString("Product_Price")+"</td>";
			tbody+="</tr>";
		}
	} catch (Exception e) {
		System.out.println("Exception caught: " + e.getMessage());
	}
//	System.out.println(tbody);
	String messagetext="<html lang=\"zh-TW\"><head>\r\n" + 
			"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">\r\n" +
			"<meta charset='utf-8' />"+
			"</head>\r\n" + 
			"<body>\r\n" + 
			"<h3 style=\"color: black;font-family: monospace;font-size:large\">"+getusername(AID)+"</h3><br>\r\n" +
			"<h4 style=\"color: black;font-family: monospace;\">訂單編號: "+oricomid+"</h4><br>\r\n" ;
	messagetext+="<table id='tbody'><thead><tr><th>名稱</th><th>數量</th><th>單價</th></tr></thead><tbody>";
	messagetext+=tbody+"</tbody></table><br><h4 style=\"color: brown;font-family: monospace;\">如對於商品有疑問，請先查附件圖片是否為您的商品，再到BIGIBI的個人專區/訂單查詢向賣家提出訂單修改的需求</h4>";
			messagetext+="</body>\r\n" + 
					"</html>";
	return messagetext;
}
public static ArrayList<DataSource> getprdimg(int AID,String comID) {
	ArrayList<DataSource> img = new ArrayList<DataSource>();
	String ds = "java:comp/env/jdbc/TDB";
	Connection con = DB.getConnection(ds);
	PreparedStatement select_pstmt = null;
	ResultSet rs = null;
    ResultSetMetaData rsmd = null;
    comID=comID.substring(comID.indexOf("O")+1);
    System.out.println(comID);
	int id=Integer.parseInt(comID);
	int row=0;
	String tbody="";
	String sql="SELECT * FROM `OrderList`,`OrderItem`,`Product`,`ProductPhotos` "
			+ "WHERE `OrderList_ID` = ? AND `OrderItem_OID` = ? AND `OrderItem_PID`=`Product_ID` AND `ProductPhotos_PrdID`=`Product_ID` "
			+ "GROUP by `ProductPhotos_PrdID`";
	try {
		select_pstmt=con.prepareStatement(sql);
		select_pstmt.setInt(1,id);
		select_pstmt.setInt(2,id);
		rs=select_pstmt.executeQuery();
		rsmd = rs.getMetaData();
		row=rs.getRow();
		while (rs.next()) {// 材料:物件 設計圖:類別
			img.add(new FileDataSource("D:/Bonnie_Project/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps/Cookies/upload/Product/"+rs.getString("Product_SellerID")+"/"+rs.getString("ProductPhotos_FileName")));
		}
	} catch (Exception e) {
		System.out.println("Exception caught: " + e.getMessage());
	}
	return img;
}
public static String get2sellermessage(int AID,String comID) {
	String ds = "java:comp/env/jdbc/TDB";
	Connection con = DB.getConnection(ds);
	PreparedStatement select_pstmt = null;
	ResultSet rs = null;
	String oricomid=comID;
    comID=comID.substring(comID.indexOf("O")+1);
	int id=Integer.parseInt(comID);
	String tbody="";
	String sql="SELECT * FROM `OrderList`,`OrderItem`,`Product`,`ProductPhotos` "
			+ "WHERE `OrderList_ID` = ? AND `OrderItem_OID` = ? AND `OrderItem_PID`=`Product_ID` AND `ProductPhotos_PrdID`=`Product_ID` "
			+ "GROUP by `ProductPhotos_PrdID`";
	try {
		select_pstmt=con.prepareStatement(sql);
		select_pstmt.setInt(1,id);
		select_pstmt.setInt(2,id);
		rs=select_pstmt.executeQuery();
		while (rs.next()) {// 材料:物件 設計圖:類別
			tbody+="<tr>";
//			tbody+="<td> <img src=\"cid:image\"></td>";
			tbody+="<td>"+rs.getString("Product_Name")+"</td>";
			tbody+="<td>"+rs.getString("OrderItem_Quanity")+"</td>";
			tbody+="<td>"+rs.getString("Product_Price")+"</td>";
			tbody+="</tr>";
		}
	} catch (Exception e) {
		System.out.println("Exception caught: " + e.getMessage());
	}
	String messagetext="<html lang=\"zh-TW\"><head>\r\n" + 
			"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">\r\n" +
			"<meta charset='utf-8' />"+
			"</head>\r\n" + 
			"<body>\r\n" + 
			"<h3 style=\"color: black;font-family: monospace;font-size:large\">"+getusername(AID)+"</h3><br>\r\n" +
			"<h4 style=\"color: black;font-family: monospace;\">您的商店於 BIGONI 購物網站 收到一筆新的訂單: "+oricomid+"</h4><br>\r\n" ;
			messagetext+="<table id='tbody'><thead><tr><th>名稱</th><th>數量</th><th>單價</th></tr></thead><tbody>";
			messagetext+=tbody+"</tbody></table>";
					messagetext+="</body>\r\n" + 
							"</html>";
	return messagetext;
}
public static String getusername(int AID) {
	String ds = "java:comp/env/jdbc/TDB";
	Connection con = DB.getConnection(ds);
	PreparedStatement select_pstmt = null;
	ResultSet rs = null;
	String sql="SELECT * FROM `Account` WHERE `Account_ID` = ?";
	String username="";
	try {
		select_pstmt=con.prepareStatement(sql);
		select_pstmt.setInt(1,AID);
		rs=select_pstmt.executeQuery();
		rs.next(); 
		username=rs.getString("Account_Name");
		
	} catch (Exception e) {
		System.out.println("Exception caught: " + e.getMessage());
	} finally {
		try {
//				查詢結束後將 con 的連線釋放，官還給 connection-pool				
			if (con != null)
				con.close();
		} catch (SQLException ignored) {
		
	}
	}
	return username;
}
public static String getemail(int AID) {
	String ds = "java:comp/env/jdbc/TDB";
	Connection con = DB.getConnection(ds);
	PreparedStatement select_pstmt = null;
	ResultSet rs = null;
	String sql="SELECT * FROM `Account` WHERE `Account_ID` = ?";
	String email="";
	try {
		select_pstmt=con.prepareStatement(sql);
		select_pstmt.setInt(1,AID);
		rs=select_pstmt.executeQuery();
		rs.next(); 
		email=rs.getString("Account_Email");
		
	} catch (Exception e) {
		System.out.println("Exception caught: " + e.getMessage());
	} finally {
		try {
//				查詢結束後將 con 的連線釋放，官還給 connection-pool				
			if (con != null)
				con.close();
		} catch (SQLException ignored) {
		
	}
	}
	return email;
}
public static String convertBlobToBase64String(Blob blob) {
	System.out.println(blob);
	String result = "";
	if(null != blob) {
	try {
	InputStream msgContent = blob.getBinaryStream();
	ByteArrayOutputStream output = new ByteArrayOutputStream();
	byte[] buffer = new byte[100];
	int n = 0;
		while (-1 != (n = msgContent.read(buffer))) {
		output.write(buffer, 0, n);
		}
	result =Base64.getEncoder().encodeToString(output.toByteArray());
	output.close();
		} catch (SQLException e) {
		e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		} 
	return result;
	}else {
	return null;
	}
}
}
