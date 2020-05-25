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

public class jsoup2 {

	public static void main(String[] args) throws IOException {
		// TODO Auto-generated method stub
		List<String> herf2 = new ArrayList<>();
		String url = "https://www.hoganbakery.com.tw/product.php?lang=tw&tb=2&cid=30";
		try {
			Document document = Jsoup.connect(url).get();
			Elements articleEle = document.getElementsByTag("div");
			Elements linkEle = document.getElementsByClass("itemlink");//商品名
			Elements priceEle = document.getElementsByClass("price sellprice");
			linkEle.html();
			List<String> ahel = linkEle.eachAttr("title");
			List<String> herf = linkEle.eachAttr("href");
			
			System.out.println("priceEle"+priceEle.hasText());
//			String[] aherfUrl =new String[ahel.size()];//商品頁面 URL
//			ahel.toArray(aherfUrl);
//			FileWriter fw = new FileWriter("C:\\Users\\monmo\\OneDrive\\桌面\\ha_prd.txt");

			FileWriter fw = new FileWriter("C:\\Users\\User\\Desktop\\ha_cake.txt");
			for(int i=0;i<herf.size();i=i+2) {
				String tp="https://www.hoganbakery.com.tw/"+herf.get(i);
//				System.out.println("herf"+herf.get(i));
				herf2.add(tp);
			}
			int index=370;
			int fileindex=1;
			for (String line : herf2) {
//				System.out.println("line"+line);
				Document ha = Jsoup.connect(line).get();
				Elements prdname = ha.getElementsByClass("visible-lg");
				Elements prddeta = ha.getElementsByClass("product_text");
				Elements prdph = ha.getElementsByTag("a").select("img");
				fw.write(prdname.select("h2").html()+","+"120,"+prddeta.select("p").html().substring(0, prddeta.select("p").html().indexOf("\n"))+","+((int)(Math.random()*((50-1)+1))+1)+",32"+ System.getProperty("line.separator"));
				
				List<String> ph = prdph.eachAttr("src");
				for(String name:ph) {
					if(!name.contains("logo")&&!name.contains("icon")) {
						name=name.replace("_autos", "");
						URL urlimg = new URL(name);
						if(fileindex<=2) {
							String destName = "C:\\Users\\User\\Desktop\\hogan\\" + index+"("+fileindex+")"+".jpg";
							System.out.println(destName);
							
							InputStream is = urlimg.openStream();
							OutputStream os = new FileOutputStream(destName);
						 
							byte[] b = new byte[2048];
							int length;
						 
							while ((length = is.read(b)) != -1) {
								os.write(b, 0, length);
							}
							is.close();
							os.close();
							fileindex++;
						}else {
							index++;
							fileindex=1;
							String destName = "C:\\Users\\User\\Desktop\\hogan\\" + index+"("+fileindex+")"+".jpg";
							System.out.println(destName);
							InputStream is = urlimg.openStream();
							OutputStream os = new FileOutputStream(destName);
						 
							byte[] b = new byte[2048];
							int length;
						 
							while ((length = is.read(b)) != -1) {
								os.write(b, 0, length);
							}
							is.close();
							os.close();
							fileindex++;
						}
					}
				}
				

			}
			fw.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		

	}

}
