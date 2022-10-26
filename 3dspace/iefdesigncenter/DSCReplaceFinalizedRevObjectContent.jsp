<%--  IEFObjectRelatedObjects.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>

<%@ page import="java.util.*,java.io.*, java.net.*"%>
<%@ page import = "com.matrixone.MCADIntegration.server.*,com.matrixone.MCADIntegration.server.beans.*,com.matrixone.MCADIntegration.utils.*"%>

<%@ page import = "com.matrixone.MCADIntegration.utils.customTable.*" %>
<%@ page import = "matrix.db.*, matrix.util.*,com.matrixone.servlet.*,com.matrixone.apps.framework.ui.*, com.matrixone.apps.domain.*"%>

<%@ page import = "com.matrixone.apps.domain.util.*"%>
<%@ include file ="../integrations/MCADTopErrorInclude.inc" %>
<%@ include file ="../emxRequestWrapperMethods.inc" %>

<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>

<html>
<head>

<%
	String acceptLanguage = request.getHeader("Accept-Language");
	String errorMessage = "";

	String objectId			= (String)Request.getParameter(request,"objectId");
	String parentObjectId	= (String)Request.getParameter(request,"parentObjectId");
	String integrationName	= (String)Request.getParameter(request,"integrationName");	
	String queryString = emxGetQueryString (request);
	
	String sHelpMarker = "emxhelpreplacerevision";
	
	MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
	Context context								= integSessionData.getClonedContext(session);

	MCADServerResourceBundle resourceBundle     = new MCADServerResourceBundle(acceptLanguage);

	String replaceRevisionHeader = resourceBundle.getString("mcadIntegration.Server.Heading.ReplaceRevision");

	if(integSessionData == null)
	{
        errorMessage = resourceBundle.getString("mcadIntegration.Server.Message.ServerFailedToRespondSessionTimedOut");
	}
	else
	{
	
		Context IEFContext   = integSessionData.getClonedContext(session);
				
		MCADMxUtil util                             = new MCADMxUtil(IEFContext, integSessionData.getLogger(), resourceBundle, integSessionData.getGlobalCache());
		MCADGlobalConfigObject globalConfigObject	= integSessionData.getGlobalConfigObject(integrationName,IEFContext);
		MCADServerGeneralUtil serverUtil			= new MCADServerGeneralUtil(IEFContext, globalConfigObject, integSessionData.getResourceBundle(), integSessionData.getGlobalCache());

		session.setAttribute("GCO",globalConfigObject);
		session.setAttribute("LCO",integSessionData.getLocalConfigObject());
		session.setAttribute("GCOTable",integSessionData.getIntegrationNameGCOTable(IEFContext));
		
		objectId = parentObjectId + "|" + objectId;
	}
%>
</head>
<body>
<link rel="stylesheet" href="../common/styles/emxUIDefault.css" type="text/css">
<form name="replaceRevisionForm" action="../common/emxTable.jsp">
<%
boolean csrfEnabled = ENOCsrfGuard.isCSRFEnabled(context);
if(csrfEnabled)
{
  Map csrfTokenMap = ENOCsrfGuard.getCSRFTokenMap(context, session);
  String csrfTokenName = (String)csrfTokenMap .get(ENOCsrfGuard.CSRF_TOKEN_NAME);
  String csrfTokenValue = (String)csrfTokenMap.get(csrfTokenName);
%>
  <!--XSSOK-->
  <input type="hidden" name= "<%=ENOCsrfGuard.CSRF_TOKEN_NAME%>" value="<%=csrfTokenName%>" />
  <!--XSSOK-->
  <input type="hidden" name= "<%=csrfTokenName%>" value="<%=csrfTokenValue%>" />
<%
}
//System.out.println("CSRFINJECTION::DSCReplaceFinalizedRevObjectContent.jsp::form::replaceRevisionForm");
%>

	<!--XSSOK-->
	<input type="hidden" name="objectId" value="<%=XSSUtil.encodeForHTML(context,objectId)%>">
	<input type="hidden" name="program" value="DECGetAllFinalizedRevisions:getAllFinalizedIds">
	<input type="hidden" name="table" value="DSCReplaceFinalizedRevisionTable">
	<input type="hidden" name="jpoAppServerParamList" value="session:GCOTable,session:LCO,session:GCO">	
	<input type="hidden" name="selection" value="single">	
	<input type="hidden" name="suiteKey" value="eServiceSuiteDesignerCentral">
	<input type="hidden" name="funcPageName" value="ReplaceRevision">
	<input type="hidden" name="integrationName" value="<%=XSSUtil.encodeForHTML(context,integrationName)%>">
	<!--XSSOK-->
	<input type="hidden" name="languageStr" value="<%= acceptLanguage %>">
	<input type="hidden" name="showAllTables" value="false">
	<input type="hidden" name="massPromoteDemote" value="false">
	<input type="hidden" name="expandLevelFilter" value="false">
	<!--XSSOK-->
	<input type="hidden" name="header" value="<%= replaceRevisionHeader %>">
	<!--XSSOK-->
	<input type="hidden" name="HelpMarker" value="<%=sHelpMarker%>">
	<input type="hidden" name="portalMode" value="true">
</form>

<%@include file = "../integrations/MCADBottomErrorInclude.inc"%>

<%
	if ("".equals(errorMessage.trim()))
	{
%>
	<SCRIPT LANGUAGE="JavaScript">
		document.replaceRevisionForm.submit();
	</SCRIPT>
<%
	} else {
%>
	<link rel="stylesheet" href="../emxUITemp.css" type="text/css">
	&nbsp;
      <table width="90%" border=0  cellspacing=0 cellpadding=3  class="formBG" align="center" >
        <tr >
		  <!--XSSOK-->
          <td class="errorHeader"><%=resourceBundle.getString("mcadIntegration.Server.Heading.Error")%></td>
        </tr>
        <tr align="center">
		  <!--XSSOK-->
          <td class="errorMessage" align="center"><%=errorMessage%></td>
        </tr>
      </table>
<%
	}
%>

</body>
</html>
