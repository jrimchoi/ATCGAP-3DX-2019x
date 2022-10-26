<%--  emxDSCWorkspaceMgmtFS.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  emxDSCWorkspaceMgmtFS.jsp - Main frameset for WSM



   static const char RCSID[] = $Id: /ENODesignerCentral/CNext/webroot/iefdesigncenter/emxDSCWorkspaceMgmtFS.jsp 1.3.1.4 Thu Jul 17 07:29:08 2008 GMT ds-agautam Experimental$
--%>

<%--
This file is used to obtain info needed from the applet, store it
in a hidden form field, and then invoke emxDSCWorkspaceMgmtFS2.jsp which
does all the actual processing.
--%>

<%@ include file ="../integrations/MCADTopInclude.inc" %>
<%@ include file = "DSCAppletUtils.inc" %>
<%@page import ="com.matrixone.apps.domain.util.*" %>

<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>

<%
   MCADIntegrationSessionData integSessionData	= (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
   MCADSessionData sessionData					= integSessionData.getSessionData();
   String integrationName						= Request.getParameter(request,"integrationName");
   String queryString                            = emxGetQueryString(request);

   String initialDir = (String) session.getAttribute("initialDirectory");
   String initialFolderId = (String) session.getAttribute("initialFolderId");
   session.removeAttribute("initialDirectory");
   session.removeAttribute("initialFolderId");
   if (integrationName == null) integrationName = "";

   if (initialDir == null)
		initialDir = Request.getParameter(request,"initialDirectory");

   if (initialDir == null)
		initialDir = "";
	else
		initialDir  = getHtmlSafeString(initialDir);
	if (initialFolderId == null)
		initialFolderId = "";
	else
	{
		initialDir = "";
	}
	Context context = integSessionData.getClonedContext(session);
	
	Enumeration enumParamNames = emxGetParameterNames(request);
	while(enumParamNames.hasMoreElements()) 
	{
		String paramName =XSSUtil.encodeForJavaScript(context,XSSUtil.encodeForURL(context,(String) enumParamNames.nextElement()));
		String paramValue = emxGetParameter(request, paramName);
		if (paramValue != null && paramValue.trim().length() > 0 )
			paramValue = XSSUtil.encodeForJavaScript(context,XSSUtil.encodeForURL(context,paramValue));
		queryString += "&"+paramName+ "=" +paramValue;
	}
%>

<html>
<head>
<script language="javascript" src="../integrations/scripts/MCADUtilMethods.js" type="text/javascript"></script>
<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>
</head>

<body>

<form name="appletReturnHiddenForm" action="emxDSCWorkspaceMgmtFS2.jsp?<%=XSSUtil.encodeForJavaScript(context,queryString)%>">

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
//System.out.println("CSRFINJECTION::emxDSCWorkspaceMgmtFS.jsp::form::appletReturnHiddenForm");
%>

   <input type="hidden" value="" name="dirAliases">
   <input type="hidden" value="" name="initialDir">
   <input type="hidden" value="" name="initialFolderId">
</form>

<script language="javascript" type="text/javascript">
<%
MCADLocalConfigObject lco = integSessionData.getLocalConfigObject();
 if(lco == null  ||  lco.getIntegrationNameGCONameMapping().size() == 0 || integSessionData.isNonIntegrationUser())
	{
		String errorPage = "/integrations/emxAppletTimeOutErrorPage.jsp?featureName=Workspace";
%> 
        //XSSOK
        <jsp:forward page="<%=errorPage%>" />              
<%
	} 
	else
	{
%>
	   //XSSOK
	   var initialDir = "<%= initialDir %>";
<%
   boolean bEnableAppletFreeUI = MCADMxUtil.IsAppletFreeUI(context);

   if(!bEnableAppletFreeUI)
   {
%>
	   var integFrame	= getIntegrationFrame(window);
	   var mxmcadApplet = integFrame.getAppletObject(); 
	   var dirAliases = mxmcadApplet.callCommandHandlerSynchronously('', 'getDirAliases', '');     //XSSOK
	   if(initialDir == "" || initialDir == "undefined")
	   {
	                //XSSOK
			initialDir = mxmcadApplet.callCommandHandlerSynchronously('<%= integrationName %>', 'getWSMInitialDir', '');
	   }

	
	   document.appletReturnHiddenForm.dirAliases.value = dirAliases;
<%}%>
		var initialFolderId = "<%= initialFolderId %>";
	   document.appletReturnHiddenForm.initialDir.value = initialDir;
	   document.appletReturnHiddenForm.initialFolderId.value = initialFolderId;
	   document.appletReturnHiddenForm.submit();
<%
	}
%>
</script>

</body>
</html>
