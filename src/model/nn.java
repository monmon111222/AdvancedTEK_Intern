package model;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

public class nn {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		String comID="S12D20200407O23";
		comID=comID.substring(comID.indexOf("S")+1,comID.indexOf("D"));
//		System.out.println(comID);
//		System.out.println(removeRepeatChar.remove("耳環,耳環,耳扣,耳扣"));
		int x=147;
		for (int i=148;i<=170;i++) {
//			System.out.println("INSERT INTO `ProductStyle`(`ProductStyle_Vaule`, `ProductStyle_PID`, `ProductStyle_Quanity`) VALUES ('F',"+i+","+((int)(Math.random()*((50-1)+1))+1)+");");
//			System.out.println("INSERT INTO `ProductStyle`(`ProductStyle_PID`,`ProductStyle_Vaule`,`ProductStyle_Quanity`) VALUES ("+i+",'金',"+((int)(Math.random()*((50-1)+1))+1)+");");
//			System.out.println("INSERT INTO `ProductStyle`(`ProductStyle_PID`,`ProductStyle_Vaule`,`ProductStyle_Quanity`) VALUES ("+i+",'銀',"+((int)(Math.random()*((50-1)+1))+1)+");");
//			System.out.println("INSERT INTO `ProductStyle`(`ProductStyle_PID`,`ProductStyle_Vaule`,`ProductStyle_Quanity`) VALUES ("+i+",'黑',"+((int)(Math.random()*((50-1)+1))+1)+");");
			System.out.println("INSERT INTO `CategoryItem`(`CategoryItem_PID`, `CategoryItem_CID`) VALUES ("+i+",7);");
//			System.out.println("UPDATE `ProductPhotos` SET `ProductPhotos_PrdID`="+(i+3)+",`ProductPhotos_FileName`='"+(i+3)+".jpg' WHERE `ProductPhotos_ID`="+i+";");
//			System.out.println("UPDATE `ProductPhotos` SET `ProductPhotos_PrdID`="+x+",`ProductPhotos_FileName`="+x+".jpg WHERE `ProductPhotos_PrdID`="+i+";");
			x--;
		}
		//Mail.get2sellermessage(33,"S96D20200420O49");
//
//        FileReader fr = null;
//		try {
//			fr = new FileReader("C:\\Users\\User\\Desktop\\br_prd.csv");
//		} catch (FileNotFoundException e1) {
//			// TODO Auto-generated catch block
//			e1.printStackTrace();
//		}
//
//        BufferedReader br = new BufferedReader(fr);
//
//		        int insertedID=0;
//		        String line = null;
//		        try {
//					while(br.ready()){
//					String item[] = br.readLine().split(",");
//					String  name= item[0].trim();//Name
//					String  price= item[1].trim();//Price
//					String  detail= item[2].trim();//Detail
//					String  quanity= item[3].trim();//Color+Quanity
//					String  category= item[4].trim();//Category
//					System.out.println(quanity);
//					String style[] = quanity.split("-");
//					for(int i=0;i<style.length;i++) {
//					System.out.println(style[i]);
//					System.out.println(style[i].substring(0,style[i].indexOf(":")));
//					System.out.println(style[i].substring(style[i].indexOf(":")+1,style[i].length()));
//					}       
//
//}
//				} catch (IOException e) {
//					// TODO Auto-generated catch block
//					e.printStackTrace();
				}

	

}
