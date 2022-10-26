<%--  emxDSCLogFileTable.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  emxDSCLogFileTable.jsp   - Retrieves list of log files from applet and displays



   static const char RCSID[] = $Id: /ENODesignerCentral/CNext/webroot/iefdesigncenter/emxDSCLogFileTable.jsp 1.3.1.3 Sat Apr 26 10:22:24 2008 GMT ds-mbalakrishnan Experimental$
--%>

<%--
   This file acts as a wrapper around emxTable.jsp so that information can be
   obtained from the MxMCAD applet and then passed through emxTable such that a 
   JPO called by emxTable (e.g. to populate the table) can retrieve the information
   obtained from the applet.
--%>
<%@include file  = "DSCAppletUtils.inc" %>
<%@ include file = "../integrations/MCADTopErrorInclude.inc" %>
<%@ page import  = "com.matrixone.MCADIntegration.utils.*,com.matrixone.MCADIntegration.server.*,com.matrixone.apps.domain.util.*" %>

<%
   String appletIntegration = "";
   String appletMethod = "unknown";
   String appletArgs = "";
   String errorMessage = "";
   String logFileType	 = (String) Request.getParameter(request,"logFileType");
   String featureName	 = "";

	if(logFileType.equalsIgnoreCase("success"))		
		featureName = "SuccessLogs";
	else
		featureName = "FailureLogs";
   
   //initialize appletIntegration
   MCADIntegrationSessionData integSessionData	= (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
   Context _context		= integSessionData.getClonedContext(session);
   if(integSessionData != null)
   {
		MCADLocalConfigObject lco					=  integSessionData.getLocalConfigObject();
		Hashtable integrationNameGCONameMap			= new Hashtable(1);
   
		if(lco != null)
			integrationNameGCONameMap = lco.getIntegrationNameGCONameMapping();
   
		MapList integrationList = new MapList();
		if(integrationNameGCONameMap.size() > 0)
		{
			int i = 0;
			Enumeration integrationNameElements = integrationNameGCONameMap.keys();
			while(integrationNameElements.hasMoreElements())
			{
				String integrationName = (String)integrationNameElements.nextElement();
				if(i == 0) 
				   appletIntegration = integrationName;
				appletArgs = appletArgs+ integrationName + "|";
				i++;
			}
		}
		else
		{
			String errorPage	= "/integrations/emxAppletTimeOutErrorPage.jsp";
			errorPage += "?featureName="+featureName;			
%> 

			<jsp:forward page="<%=XSSUtil.encodeForHTML(_context, errorPage)%>" />              
<%
		}

		if (logFileType.equalsIgnoreCase("success"))
		  appletMethod = "getBGCheckinSuccessLogFileList";
		else if (logFileType.equalsIgnoreCase("failure"))
		  appletMethod = "getBGCheckinFailureLogFileList";
   }
   else
   {
		MCADServerResourceBundle serverResourceBundle = new MCADServerResourceBundle(request.getHeader("Accept-Language"));
		errorMessage								  = serverResourceBundle.getString("mcadIntegration.Server.Message.ServerFailedToRespondSessionTimedOut");
		emxNavErrorObject.addMessage(errorMessage);
   }
   
%>

<%@include file = "emxDSCTableWrapper.inc"%>
<%@include file = "../integrations/MCADBottomErrorInclude.inc"%>
