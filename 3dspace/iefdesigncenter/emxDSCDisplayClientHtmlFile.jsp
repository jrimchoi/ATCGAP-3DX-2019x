<%--  emxDSCDisplayClientHtmlFile.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  emxDSCDisplayClientHtmlFile.jsp   - Displays a client side HTML file

   static const char RCSID[] = $Id: /ENODesignerCentral/CNext/webroot/iefdesigncenter/emxDSCDisplayClientHtmlFile.jsp 1.3.1.3 Sat Apr 26 10:22:24 2008 GMT ds-mbalakrishnan Experimental$
--%>

<%--
   This program retrieves the contents of a client side file and renders them
   into the current frame (invoke this JSP with a target frame of _new to 
   create a new window with the file).  The file is retrieved via the applet
   command getFileAsString.
   
   Parameters:
      fileName - Name of the client side HTML file to display
--%>
<%@ page import = "com.matrixone.MCADIntegration.utils.*,com.matrixone.apps.domain.util.*" %>

<%

// Get the parameters from the Request URL
   String sFileName = Request.getParameter(request,"fileName");  
   //sFileName = java.net.URLEncoder.encode(sFileName);  /* Escape to protect backslash chars through to javascript */
   
   //i18n fix
   String fileSeparator	  = java.io.File.separator + "";
   try 
   {
       sFileName = MCADUrlUtil.hexEncode(sFileName);
   }
   catch(Exception exception)
   {
	   System.out.println("Exception: " + exception.getMessage());
   }
%>

<html>
<head>
<script language="javascript" src="../integrations/scripts/MCADUtilMethods.js" type="text/javascript"></script>
<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>
</head>

<body>
<script language="javascript" type="text/javascript">
   //var sFileName = unescape("<%=sFileName%>".replace(/\+/g, " "));  // Note file path is passed in escaped format from the Java code
    //XSSOK
	var sFileName = hexDecode('', "<%=sFileName%>");  // Note file path is passed in escaped format from the Java code
	
	var integFrame	= getIntegrationFrame(window);
	var fileContents = integFrame.getAppletObject().callCommandHandlerSynchronously('', 'getFileAsString', sFileName);
//   var newWindow = window.open()
//   newWindow.document.write(fileContents);
   document.write(fileContents);
</script>

</body>
</html>
