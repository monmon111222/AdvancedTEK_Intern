package model;

import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import java.util.*;

public class jsoup {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		String url = "https://www.scheminggg.com/categories/%E7%86%B1%E9%96%80%E5%95%86%E5%93%81";
		try {
			Document document = Jsoup.connect(url).get();
			Elements articleEle = document.getElementsByTag("div");
			Elements linkEle = document.getElementsByClass("boxify-container");
			Elements imgEle = document.getElementsByClass("global-primary dark-primary price price-crossed force-text-align-");
			Elements imgEle4 = document.getElementsByClass("global-primary dark-primary price  force-text-align-");
			imgEle.addAll(imgEle4);
			
			Elements imgEle2 = document.getElementsByClass("boxify-image center-contain sl-lazy-image  ");

			Elements imgEle3 = document.getElementsByClass("title text-primary-color title-container ellipsis force-text-align-");
			Elements ahe=linkEle.select("li").select("a");
			List<String> ahel = ahe.eachAttr("href");
			String[] aherfUrl =new String[ahel.size()];//商品頁面 URL
			ahel.toArray(aherfUrl);
//			FileWriter fw = new FileWriter("C:\\Users\\User\\Desktop\\sch_a.txt");
//			for (String line : aherfUrl) {
//			String url_a=	"https://www.scheminggg.com"+line;
//			Document document_a = Jsoup.connect(url_a).get();
//			System.out.println("https://www.scheminggg.com"+line);
//			Elements detailEle = document.getElementsByTag("div");
//			System.out.println(detailEle);
//			fw.write("https://www.scheminggg.com"+line+ System.getProperty("line.separator"));
//			}
//			fw.close();
			Elements h4 = articleEle.select("h4");
			String html = imgEle.html();
			String[] price = html.split("\\s*\\r?\\n\\s*");
			List<String> href = imgEle2.eachAttr("style");
			List<String> scr = imgEle.eachAttr("src");
			html = imgEle3.html();
			String[] prd_name = html.split("\\s*\\r?\\n\\s*");//商品名稱
			String[] herfUrl =new String[href.size()];//商品頁面 URL
			href.toArray(herfUrl);
//			for (String line : herfUrl) {
//				System.out.println(line.substring(line.indexOf("l(")+2,line.length()-2));
//				}
//			for (String line : prd_name) {
//				System.out.println(line.substring(0,line.indexOf("/")));
//				}
//			for (String line : price) {
//				System.out.println(line.replace("NT$", ""));
//				}
//			String[] imageUrl =new String[scr.size()];//封面圖片URL
//			scr.toArray(imageUrl);
//			FileWriter fw = new FileWriter("C:\\sch_a.txt");
			System.out.println("prd_name"+prd_name.length+"price"+price.length);
//			for(int i=0;i<prd_name.length;i++) {
//				System.out.println(prd_name[i].substring(0,prd_name[i].indexOf("/"))+","+price[i].replace("NT$", "")+",,"+((int)(Math.random()*((50-1)+1))+1)+ System.getProperty("line.separator"));

//				fw.write(prd_name[i].substring(0,prd_name[i].indexOf("/"))+","+price[i].replace("NT$", "")+",,"+((int)(Math.random()*((50-1)+1))+1)+ System.getProperty("line.separator"));
//			}
//			fw = new FileWriter("C:\\herfUrl.txt");
//			for (String line : herfUrl) {
//				fw.write(line+ System.getProperty("line.separator"));
//				}
//			fw.close();
			int index=172;
			
			for (String line : herfUrl) {
				
//				String fileName = line.substring(line.indexOf("i=https:")+2,line.indexOf("&v"));
				URL urlimg = new URL(line.substring(line.indexOf("l(")+2,line.length()-2));
//				fileName=fileName.substring(fileName.lastIndexOf("/")+1,fileName.length());
//				System.out.println(fileName);
				String destName = "C:\\Users\\User\\Desktop\\sch\\" + index+".jpg";
				System.out.println(destName);
//			 
				InputStream is = urlimg.openStream();
				OutputStream os = new FileOutputStream(destName);
			 
				byte[] b = new byte[2048];
				int length;
			 
				while ((length = is.read(b)) != -1) {
					os.write(b, 0, length);
				}
				is.close();
				os.close();
				index++;
			}
//			for(int nn=58;nn<147;nn++) {
//			File oldFile = new File("C:\\Users\\User\\\\Desktop\\mag\\"+nn+".jpg");
//            System.out.println(oldFile.exists());//看檔案是否存在
//            File newFile = new File("C:\\Users\\User\\\\Desktop\\mag\\"+(nn-10)+".jpg");
//            oldFile.renameTo(newFile);
//            }
//			System.out.println("imageUrl"+imageUrl.length+"prd_name"+prd_name.length+"price"+price.length);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		

	}

}
