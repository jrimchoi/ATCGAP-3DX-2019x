<%--  emxDSCWorkspaceMgmtDetails.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  emxDSCWorkspaceMgmtDetails.jsp   - Displays detailed file information in the WSM table
--%>

<%--
This file is used to obtain the directory contents from the applet, store it
in a hidden form field, and then invoke emxDSCWorkspaceMgmtDetails2.jsp which
does all the actual details processing.
--%>

<%@ include file ="../integrations/MCADTopInclude.inc" %>
<%@page import ="com.matrixone.apps.domain.util.*" %>

<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>

<script language="javascript" src="../integrations/scripts/MCADUtilMethods.js" type="text/javascript"></script>
<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>

<%
   MCADIntegrationSessionData integSessionData	= (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
Context context								= integSessionData.getClonedContext(session);

   MCADSessionData sessionData = integSessionData.getSessionData();

   String integrationName = Request.getParameter(request,"integrationName");   
   if (integrationName == null) integrationName = "";

   String dirPath			= Request.getParameter(request,"dirPath");
   String unencodedDirPath	= MCADUrlUtil.hexDecode(dirPath);   
   
   // Find which files have hashcodes store and pass over to applet (so it 
   // only computes hashcodes for files that need them)
   
   String filesNeedingHashcode = "";
   StringBuffer filesNeedingHashcodeBuffer = new StringBuffer("");
   Vector fileNames = sessionData.getAllFileNames(unencodedDirPath, "");
   for (int ii=0; ii < fileNames.size(); ii++)
   {
      String curFile = (String) fileNames.elementAt(ii);
      MCADBusObjectSessionInfo[] boInfo = sessionData.getData(curFile, unencodedDirPath, "");
      
	  if (boInfo[0].getHashCode().length() > 0)
      {
		 filesNeedingHashcodeBuffer.append("|").append(curFile);
	  }
   }

   filesNeedingHashcode = filesNeedingHashcodeBuffer.toString();
%>

<html>
<head>
<script language="javascript" src="../integrations/scripts/MCADUtilMethods.js" type="text/javascript"></script>
<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>
</head>

<body>
<form method="post" name="appletReturnHiddenForm" action="emxDSCWorkspaceMgmtDetails2.jsp?<%=XSSUtil.encodeForHTML(context, emxGetQueryString(request))%>">

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
// System.out.println("CSRFINJECTION::emxDSCWorkspaceMgmtDetails.jsp::form::appletReturnHiddenForm");
%>

   <input type="hidden" value="" name="dirContents">
   <input type="hidden" value="" name="dirPath">
   <input type="hidden" value="" name="filesInSession">
</form>

<script language="javascript" type="text/javascript">
   var integFrame	= getIntegrationFrame(window);
   //XSSOK
   var dirPath		= hexDecode('<%= XSSUtil.encodeForHTML(context,integrationName) %>', "<%=dirPath%>");
	var mxmcadApplet = integFrame.getAppletObject(); 
   //XSSOK
   var dirContents	= mxmcadApplet.callCommandHandlerSynchronously('', 'getWSMDirectoryContents', dirPath + "<%= filesNeedingHashcode %>");  // Note - Can not pass integrationName!
      
   dirContents	= hexEncodeWithoutIntegName(dirContents); 

   //XSSOK
   var filesInSession = mxmcadApplet.callCommandHandlerSynchronously("<%= XSSUtil.encodeForHTML(context,integrationName) %>", 'getFilesInSession', '');

   document.appletReturnHiddenForm.dirContents.value = dirContents;
   document.appletReturnHiddenForm.dirPath.value = dirPath;
   document.appletReturnHiddenForm.filesInSession.value = filesInSession;
   document.appletReturnHiddenForm.submit();
</script>

</body>
</html>
