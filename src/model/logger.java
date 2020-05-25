package model;

import java.io.File;  
import java.io.IOException;  
import java.text.SimpleDateFormat;  
import java.util.Date;  
import java.io.*;
import java.text.*;
import java.util.*;
import java.util.logging.FileHandler;  
import java.util.logging.Level;  
import java.util.logging.Logger;  
import java.util.logging.SimpleFormatter;  
import java.util.logging.*;

public class logger {//private static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");  
	  private static final String LOG_FOLDER_NAME = "RaLog";  
	  private static final String LOG_FILE_SUFFIX = ".log";
	  public static Logger log = logger.setLoggerHanlder(Logger.getLogger("RA"));  

	  
		public static void put(String s) {
			log.info(s);
		}
	  
	  public static void out(Exception e){
	    Writer writer = new StringWriter();
	    PrintWriter printWriter = new PrintWriter(writer);
	    e.printStackTrace(printWriter);
	    String s = writer.toString();
	    int i1, i2, i3;
	    i1=s.indexOf("at ");
	    i2=i1;
	    i3=0;
	    while(i1>0 && i3<4){
	      i2=i1;
	      i1++;
	      i1=s.indexOf("at ", i1);
	      i3++;
	    }
	    if (i3==4) s=s.substring(0,i1-1);
	    
	    
	    log.info(e.getMessage()+s);
	  }
	  
	  
	  private synchronized static String getLogFilePath() {  
	    StringBuffer logFilePath = new StringBuffer();  
	    //logFilePath.append(System.getProperty("user.home"));  
	    // file:/R:/Tomcat_8.0.15/webapps/RA/WEB-INF/classes/
	    String s1=logger.class.getResource("/").toString();  //Class ¤å¥ó©Ò¦b¸ô®|
			System.out.println(s1);
	    int i1, i2;
	    i1=s1.indexOf("file:/");
	    if (i1>=0) s1=s1.substring(i1+6);
			s1 = s1.replaceAll("%20", " ");
	    logFilePath.append(s1);
	    //logFilePath.append(File.separatorChar);  
	    logFilePath.append(LOG_FOLDER_NAME);  
	    
	    File file = new File(logFilePath.toString());  
	    if (!file.exists()) file.mkdir();  

	    //logFilePath.append(File.separatorChar);
			logFilePath.append("/");
	    
	    DateFormat chtDateFormat = new SimpleDateFormat("yyyyMMdd");
	    s1=chtDateFormat.format(new Date()); 
	    s1=s1.substring(0,6);
	    logFilePath.append(s1);
	    logFilePath.append(LOG_FILE_SUFFIX);  

			System.out.println(logFilePath.toString());
	    return logFilePath.toString();  
	  }  

	 

		
		
		public synchronized static Logger setLoggerHanlder(Logger logger) {   

	      FileHandler fileHandler = null;  
	      try {  
	          //¤å¥ó¤é§Ó¤º®e¼Ð°O¬°¥i°l¥[  
	          fileHandler = new FileHandler(getLogFilePath(), true);  
						//fileHandler = new FileHandler("C:\\Program Files\\Apache Software Foundation\\Tomcat\\webapps\\Cur_A01\\WEB-INF\\classes\\test.log");

	          //¥H¤å¥»ªº§Î¦¡¿é¥X  
	          fileHandler.setFormatter(new SimpleFormatter());  
	            
	          logger.addHandler(fileHandler);  
	          logger.setLevel(java.util.logging.Level.ALL);  

	            

	      } catch (SecurityException e) {  
	          logger.severe(populateExceptionStackTrace(e));  
	      } catch (IOException e) {  
	          logger.severe(populateExceptionStackTrace(e));  
	      }  
				return logger; 
	  }
		
	  

	  private synchronized static String populateExceptionStackTrace(Exception e) {  
	      StringBuilder sb = new StringBuilder();  
	      sb.append(e.toString()).append("\n");  
	      for (StackTraceElement elem : e.getStackTrace()) {  
	          sb.append("\tat ").append(elem).append("\n");  
	      }  
	      return sb.toString();  
	  }  
	}  
