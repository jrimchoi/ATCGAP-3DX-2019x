<%@page import="com.matrixone.apps.domain.DomainConstants"%>
<%@page import="com.matrixone.apps.domain.DomainObject"%>
<%@ include file = "../emxUICommonAppInclude.inc"%>
<%@ page errorPage = "emxNavigatorErrorPage.jsp"%>
<%@ page import = "com.designrule.drv6tools.common.drContext, com.designrule.drv6tools.Operations, com.designrule.drv6tools.eFunctionType, com.designrule.drv6tools.Result"%>
<%@ page import = "java.io.FileInputStream" %>
<%@ page import = "java.io.BufferedInputStream" %>
<%@ page import = "java.io.File" %>
<%@ page import = "java.io.IOException" %>
<%@ page import = "java.util.Map" %>
<%@ page import = "java.util.Map" %>
<%@ page import = "java.net.URLEncoder" %>
<%@ page import = "org.apache.log4j.Logger" %>
<%@page import="org.apache.log4j.Level"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="org.apache.log4j.MDC"%>
<%@page import="com.designrule.drv6tools.debug.drLoggerUtil"%>
<%
	String debugLevel = request.getParameter("debugLevel");
	String enableDebug = request.getParameter("enableDebug");
	String allUser = request.getParameter("alluser");
	String userList = request.getParameter("userList");
	String action = request.getParameter("action");
	String strContextUser=context.getUser();
	String users = "";
	
	drLoggerUtil logUtil=drLoggerUtil.getLogUtil();
	
	if("clear".equalsIgnoreCase(action)){
		String filePath = logUtil.getLogFilePath();
		File logFile = new File(filePath);
		System.out.println(logFile.getAbsolutePath());
		if(logFile.exists()){
			PrintWriter writer = new PrintWriter(logFile);
			writer.print("");
			writer.close();
		}
		return;
	}

	if("true".equalsIgnoreCase(allUser)){
		users = "All";
	}else{
		users = userList;
	}

	String applicationName=request.getContextPath();
	logUtil.resetLogConfiguration();
	if("true".equalsIgnoreCase(enableDebug)){
		logUtil.startLogger(debugLevel,users);
	}

%>

