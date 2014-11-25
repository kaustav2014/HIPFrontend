<%@page import="java.util.HashMap"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Map"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="com.ibm.json.java.JSONObject"%>
<%@page import="java.util.StringTokenizer"%>
<%@page import="javax.jms.MessageProducer"%>
<%@page import="javax.jms.Destination"%>
<%@page import="javax.jms.JMSException"%>
<%@page import="javax.jms.TextMessage"%>
<%@page import="javax.jms.QueueSender"%>
<%@page import="javax.jms.Session"%>
<%@page import="javax.jms.QueueSession"%>
<%@page import="javax.jms.QueueConnection"%>
<%@page import="javax.jms.QueueConnectionFactory"%>
<%@page import="javax.jms.ConnectionFactory"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.Context"%>
<%@page import="java.util.Properties"%>
<%@page import="javax.jms.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.beans.Statement"%>
<%@page import="java.net.URL"%>
<%@page import="java.net.URLConnection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<%		
		
		String var1 = request.getParameter("txtGeoLocation");
		
		String geoLoc = request.getParameter("txtGeoLocation");
		String userId = request.getParameter("txtUserID");
		String prodName = request.getParameter("txtProdName");
		String quantity = request.getParameter("txtQuantity");
		
		String strJson = "{\"geoLoc\":\""+geoLoc+"\",\"userId\":\""+userId+"\",\"prodName\":\""+prodName+"\",\"quantity\":\""+quantity+"\"}";
		
		System.out.println("debug 1");
		out.println("messaging 1" + var1 + "<br/>");
		Properties properties = new Properties();
		//properties.putAll((HashMap)vcap);
		
		
				
		//InitialContext ctx = new InitialContext(properties); 
		InitialContext ctx = new InitialContext();
		/*out.println("Environment "+ctx.getEnvironment()+"<BR/>");
		
		out.println("Environment "+ctx.getNameInNamespace()+"<BR/>");
		*/
		System.out.println("debug 2");
		ConnectionFactory mqlightCF = (ConnectionFactory) ctx
				.lookup("java:comp/env/jms/" + "MQLight-SysListener");
		
		System.out.println("debug 3");
		out.println("messaging 2" + "<br/>");

		Connection jmsConn = null;
		try {

			jmsConn = mqlightCF.createConnection();
			System.out.println("debug 4");

			// Create a session.
			Session jmsSess = jmsConn.createSession(false,
					Session.AUTO_ACKNOWLEDGE);
			out.println("messaging 3" + "<br/>");
			System.out.println("5");
			// Create a producer on our topic
			Destination publishDest = jmsSess
					.createTopic("mqlight/sysListener/words");
			System.out.println("6");
			MessageProducer producer = jmsSess.createProducer(publishDest);
			out.println("messaging 4" + "<br/>");
			System.out.println("7");
			// Create our message
			if (var1 != null) {

					JSONObject jsonPayload = new JSONObject();
					jsonPayload.put("GEOLOCATION", geoLoc);
					jsonPayload.put("USERID", userId);
					jsonPayload.put("PRODUCTNAME", prodName);					
					jsonPayload.put("QUANTITY", quantity);

					// Create our message
					TextMessage textMessage = jmsSess
							.createTextMessage(jsonPayload.serialize());

					//TextMessage textMessage = jmsSess.createTextMessage(var1);
					System.out.println("Connection factory successfully created 8");
					// Send it
					System.out.println("Sending message "
							+ textMessage.getText());
					producer.send(textMessage);
				
			}
			System.out.println("Connection factory successfully created 9");

			out.println("messaging 5" + "<br/>");

		} catch (JMSException e) {

			out.println("messaging 5" + e.getMessage() + "<br/>");
			throw new RuntimeException(e);
		} finally {
			// Ensure we cleanup our connection
			try {
				if (jmsConn != null)
					jmsConn.close();
			} catch (Exception e) {
				System.out
						.println("Exception closing connection to MQ Light");
			}
			ctx.close();
		}
	%>
	<H1>Submitting Text Fields</H1>
	<FORM ACTION="StartupFrontend.jsp" METHOD="POST">
		Geo Location: <INPUT TYPE="TEXT" NAME="txtGeoLocation"> This will be later derived automatically using BlueMix GEO service<BR>
		User ID: <INPUT TYPE="TEXT" NAME="txtUserID"> <BR>
		Product Name: <INPUT TYPE="TEXT" NAME="txtProdName"> <BR>
		Quantity: <INPUT TYPE="TEXT" NAME="txtQuantity"> <BR>

		<INPUT TYPE="SUBMIT" value="Submit">


	</FORM>
</body>
</html>

