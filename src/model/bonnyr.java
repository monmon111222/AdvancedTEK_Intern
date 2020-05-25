package model;

import java.io.File;
import java.io.FileNotFoundException;
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

public class bonnyr {

	public static void main(String[] args) throws IOException {
		// TODO Auto-generated method stub
		List<String> herf2 = new ArrayList<>();
		String url = "https://www.bonnyread.com.tw/categories/earclip-%E5%A4%BE%E5%BC%8F%E8%80%B3%E7%92%B0?page=3&sort_by=&order_by=&limit=24";
//		String url = "https://www.bonnyread.com.tw/categories/bracelets?page=2&sort_by=&order_by=&limit=24";
		try {
			Document document = Jsoup.connect(url).get();
			Elements articleEle = document.getElementsByTag("span");
			Elements phEle=document.getElementsByClass("Image-boxify-image js-image-boxify-image sl-lazy-image ");
			Elements linkEle = document.getElementsByClass("Product-title Label mix-primary-text");
			Elements priceEle = document.getElementsByClass("Label-price sl-price ");//價錢
			Elements herfEle = document.getElementsByClass("Product-item         ");
			linkEle.html();
			List<String> ahel = phEle.eachAttr("style");
			List<String> herf = herfEle.eachAttr("href");//商品頁面 URL
			String[] name =linkEle.html().split("\n");//商品名
			String[] price =priceEle.html().split("\n");//商品名
//			System.out.println("linkEle"+name[0]);
//			System.out.println("priceEle"+priceEle.html());
//			System.out.println("articleEle"+articleEle);
			FileWriter fw = new FileWriter("C:\\Users\\User\\Desktop\\br_prdhh.txt");

//			FileWriter fw = new FileWriter("C:\\Users\\monmo\\OneDrive\\桌面\\br_prd4.txt");
			int fileindex=207;
//			for(int y=0;y<ahel.size();y++) {
//				String picurl=ahel.get(y).replace("800x.jpg", "400x.jpg").substring(ahel.get(y).indexOf("l(")+2,ahel.get(y).length()-2);
//				System.out.println("urlimg"+picurl);
//				URL urlimg = new URL(picurl);
//				String destName = "C:\\Users\\monmo\\OneDrive\\桌面\\br\\" +fileindex+".jpg";
//				System.out.println(destName);
//				
//				InputStream is = urlimg.openStream();
//				OutputStream os = new FileOutputStream(destName);
//			 
//				byte[] b = new byte[2048];
//				int length;
//			 
//				while ((length = is.read(b)) != -1) {
//					os.write(b, 0, length);
//				}
//				is.close();
//				os.close();
//				fileindex++;
//			}
			fileindex=255;
			for(int i=0;i<name.length;i++) {
				fw.write(name[i].subSequence(0, name[i].lastIndexOf("/"))+","+price[i].replace("NT$", "")+",商品皆為實際拍攝+商品材質：合金 +耳夾材質：耳夾：三角夾 (附軟塞)+ 耳夾SIZE長寬約：1 cm  x 1 cm,"+((int)(Math.random()*((50-1)+1))+1)+",36,"+fileindex+ System.getProperty("line.separator"));
				fileindex++;
//				String tp="https://www.hoganbakery.com.tw/"+herf.get(i);
//				System.out.println("herf"+herf.get(i));
//				herf2.add(tp);
			}
//			int index=370;
//			int fileindex=1;
//			for (String line : herf) {
//				System.out.println("line"+line);
//				Document ha = Jsoup.connect(line).get();
//				Elements prdname = ha.getElementsByClass("ng-scope");
//				Elements prddeta = ha.getElementsByClass("product_text");
//				Elements prdph = ha.getElementsByTag("a").select("img");
//				fw.write(prdname.select("h2").html()+","+"120,"+prddeta.select("p").html().substring(0, prddeta.select("p").html().indexOf("\n"))+","+((int)(Math.random()*((50-1)+1))+1)+",32"+ System.getProperty("line.separator"));
//				
//				List<String> ph = prdph.eachAttr("src");
//				for(String name:ph) {
//					if(!name.contains("logo")&&!name.contains("icon")) {
//						name=name.replace("_autos", "");
//						URL urlimg = new URL(name);
//						if(fileindex<=2) {
//							String destName = "C:\\Users\\User\\Desktop\\hogan\\" + index+"("+fileindex+")"+".jpg";
//							System.out.println(destName);
//							
//							InputStream is = urlimg.openStream();
//							OutputStream os = new FileOutputStream(destName);
//						 
//							byte[] b = new byte[2048];
//							int length;
//						 
//							while ((length = is.read(b)) != -1) {
//								os.write(b, 0, length);
//							}
//							is.close();
//							os.close();
//							fileindex++;
//						}else {
//							index++;
//							fileindex=1;
//							String destName = "C:\\Users\\User\\Desktop\\hogan\\" + index+"("+fileindex+")"+".jpg";
//							System.out.println(destName);
//							InputStream is = urlimg.openStream();
//							OutputStream os = new FileOutputStream(destName);
//						 
//							byte[] b = new byte[2048];
//							int length;
//						 
//							while ((length = is.read(b)) != -1) {
//								os.write(b, 0, length);
//							}
//							is.close();
//							os.close();
//							fileindex++;
//						}
//					}
//				}
//				
//
//			}
			fw.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		

	}

}
