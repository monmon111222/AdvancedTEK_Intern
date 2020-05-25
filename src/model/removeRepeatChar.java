package model;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.*;


public class removeRepeatChar {
	public static String remove(String s) {
		String finalst ="";
		String item[]=s.split(",");
		Boolean same=false;
		List<String> re=new ArrayList<>();
//		for(int i=0;i<item.length;i++) {
//			for(int j=1;j<item.length;j++) {
//				if(item[i].equals(item[j])) {
//					same=true;
//				}
//			}
//		}
//		int index=item.length-1;
//		if(re.isEmpty()) {
//			finalst =item[index];
//		}
		for (int i=0; i<item.length; i++  ) {
			if(!re.contains(item[i])) {
				re.add(item[i]);
			}
		}
		for(int i=0;i<re.size();i++) {
			if(i==0) {
				finalst+=re.get(0);
			}else {
				finalst+=","+re.get(i);
			}
		}
		
	    return finalst.toString();     
	}
}
