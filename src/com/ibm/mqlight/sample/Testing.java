package com.ibm.mqlight.sample;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Iterator;
import java.util.Set;

import javax.jms.TextMessage;

import com.ibm.json.java.JSONObject;

public class Testing {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		
		try {
		      //Initialize SecureRandom
		      //This is a lengthy operation, to be done only upon
		      //initialization of the application
		      SecureRandom prng = SecureRandom.getInstance("SHA1PRNG");

		      //generate a random number
		      int randomNum = Math.abs(prng.nextInt());		      

		      System.out.println("Random number: " + randomNum);
		      
		    }
		    catch (NoSuchAlgorithmException ex) {
		      System.err.println(ex);
		    }
		
		/*JSONObject jsonPayload = new JSONObject();
		jsonPayload.put("geoLoc", "700156");
		jsonPayload.put("userId", "1");
		jsonPayload.put("prodName", "Rice");					
		jsonPayload.put("quantity", "50kg");

		// Create our message
		try {
			String message = jsonPayload.serialize();
			JSONObject inputData = JSONObject.parse(message);
			String geoLoc = (String) inputData.get("GEOLOCATION");
			String userId = (String) inputData.get("USERID");
			String prodName = (String) inputData.get("PRODUCTNAME");
			String quantity = (String) inputData.get("QUANTITY");
			
			String strkey = "";
			Set keyset = inputData.keySet();
			Iterator itr = keyset.iterator();
			while(itr.hasNext())
			{
				strkey = itr.next().toString();
				System.out.println(inputData.get(strkey));
				//System.out.println(itr.next().toString());
			}
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}*/

	}

}
