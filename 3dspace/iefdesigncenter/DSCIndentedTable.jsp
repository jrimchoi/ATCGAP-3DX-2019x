<%--  DSCIndentedTable.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>

<%@include file = "../iefdesigncenter/DSCSearchUtils.inc" %>
<%@include file = "../emxUICommonAppInclude.inc"%>
<%@include file = "../emxUICommonHeaderBeginInclude.inc" %>
<%@ include file="../integrations/MCADTopErrorInclude.inc" %>
<%@ page import="com.matrixone.MCADIntegration.utils.*,com.matrixone.MCADIntegration.server.beans.*,com.matrixone.MCADIntegration.server.*,com.matrixone.apps.domain.util.*"  %>

<%
		MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
		String tableURL								= "";
		Context _context		= integSessionData.getClonedContext(session);
		if(integSessionData == null)
		{
			MCADServerResourceBundle serverResourceBundle = new MCADServerResourceBundle(request.getHeader("Accept-Language"));
			String errorMessage								  = serverResourceBundle.getString("mcadIntegration.Server.Message.ServerFailedToRespondSessionTimedOut");
			emxNavErrorObject.addMessage(errorMessage);
		}
		else
		{
			String integrationName	= Request.getParameter(request,"integrationName");
			String queryString		= emxGetQueryString (request);
			String funcPageName		= Request.getParameter(request,"funcPageName");
			String featureName		= Request.getParameter(request,"featureName");

			funcPageName			= (funcPageName == null) ? "" : funcPageName;
			featureName				= (featureName == null) ? funcPageName : featureName;

			tableURL				= "../common/emxIndentedTable.jsp?expandLevelFilter=false&" + queryString;

			if (integrationName == null || integrationName.equals(""))
			{
			   integrationName = getDefaultIntegrationName(request, integSessionData);
			   tableURL= tableURL + "&integrationName=" + integrationName;
			}

			if(integrationName != null)
			{
				MCADGlobalConfigObject globalConfigObject	= integSessionData.getGlobalConfigObject(integrationName,_context);
				HashMap globalConfigObjectTable				= (HashMap)integSessionData.getIntegrationNameGCOTable(_context);

				session.setAttribute("GCOTable", globalConfigObjectTable);
				session.setAttribute("GCO", globalConfigObject);
				session.setAttribute("LCO", (Object)integSessionData.getLocalConfigObject());
			}

			String isFeatureAllowed	= integSessionData.isFeatureAllowedForIntegration(integrationName, featureName);
			if(!isFeatureAllowed.startsWith("true") && integrationName.equals(""))
			{
				String errorPage	= "../integrations/emxAppletTimeOutErrorPage.jsp?featureName="+featureName;
%> 
				<jsp:forward page="<%=XSSUtil.encodeForHTML(_context, errorPage)%>" />  
<%
			}
		}
%>
<%@include file = "../integrations/MCADBottomErrorInclude.inc"%>
<%
	if ((emxNavErrorObject.toString()).trim().length() == 0)
	{
%>
				<script language="javascript">
					window.location.href = "<%=XSSUtil.encodeForJavaScript(_context,tableURL)%>"
				</script>
<%
	}

%>
