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
		String sosMsg = request.getParameter("SOSMessage");
		JSONObject inputData = null;
		if (sosMsg != null) {

			inputData = JSONObject.parse(sosMsg);

		}

		System.out.println("SOSMobile.jsp:::::debug 1");
		
		Properties properties = new Properties();

		InitialContext ctx = new InitialContext();

		System.out.println("SOSMobile.jsp::::debug 2");
		ConnectionFactory mqlightCF = (ConnectionFactory) ctx
				.lookup("java:comp/env/jms/" + "MQLight-SysListener");

		System.out.println("SOSMobile.jsp::::debug 3");
		

		Connection jmsConn = null;
		try {

			jmsConn = mqlightCF.createConnection();
			System.out.println("SOSMobile.jsp:::::debug 4");

			// Create a session.
			Session jmsSess = jmsConn.createSession(false,
					Session.AUTO_ACKNOWLEDGE);
			
			System.out.println("SOSMobile.jsp:::5");
			// Create a producer on our topic
			Destination publishDest = jmsSess
					.createTopic("mqlight/sysListener/words");
			System.out.println("SOSMobile.jsp::::6");
			MessageProducer producer = jmsSess.createProducer(publishDest);
			
			System.out.println("SOSMobile.jsp:::::7");
			

			// Create our message
			TextMessage textMessage = jmsSess.createTextMessage(inputData
					.serialize());

			//TextMessage textMessage = jmsSess.createTextMessage(var1);
			
			// Send it
			System.out.println("SOSMobile.jsp::::Sending message " + textMessage.getText());
			producer.send(textMessage);

			System.out.println("SOSMobile.jsp::::::::: 9");

			

		} catch (JMSException e) {

			System.out.println("SOSMobile.jsp:::::::::" + e.getMessage());
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
	
</body>
</html>

