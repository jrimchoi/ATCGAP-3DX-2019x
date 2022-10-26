
<%@ include file = "../emxUICommonAppInclude.inc"%>
<%@ page errorPage = "emxNavigatorErrorPage.jsp"%>
<%@ page import = "java.io.FileInputStream" %>
<%@ page import = "java.io.BufferedInputStream" %>
<%@ page import = "java.io.File" %>
<%@ page import = "java.io.IOException" %>
<%@page import="com.designrule.drv6tools.debug.drLoggerUtil"%>

<%
	drLoggerUtil logUtil = drLoggerUtil.getLogUtil();
	String filePath = logUtil.getLogFilePath();
	File logFile = new File(filePath);
	System.out.println("Loading data from : "+logFile.getAbsolutePath());
	StringBuilder logDataBuilder = new StringBuilder();
	if (logFile.exists()) {
		try {
			BufferedReader logData = new BufferedReader(new FileReader(logFile.getAbsolutePath()));
			String line = logData.readLine();
			while (line != null) {
				logDataBuilder.append(line).append("\n");
				line = logData.readLine();
			}
			logData.close();
		} catch(Exception ex){
			throw ex;
		}
	}
	out.clear();
	response.getWriter().write(logDataBuilder.toString());
%>

