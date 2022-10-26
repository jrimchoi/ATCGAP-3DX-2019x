<%--  emxDSCTableWrapper.inc

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  emxDSCTableWrapper.inc - Wraps emxTable so applet information can be passed to JPOs

 

   static const char RCSID[] = $Id: /ENODesignerCentral/CNext/webroot/iefdesigncenter/emxDSCTableWrapper.inc 1.3.1.3 Sat Apr 26 10:22:24 2008 GMT ds-mbalakrishnan Experimental$
--%>

<%--
   This file acts as a wrapper around emxTable.jsp so that information can be
   obtained from the MxMCAD applet and then passed through emxTable such that a 
   JPO called by emxTable (e.g. to populate the table) can retrieve the information
   obtained from the applet.  The information is passed as a POST request so length
   of the string should not be an issue (80K strings have been tested with no
   problems but this is not meant for passing megabytes of data). The string to 
   be passed is written to a hidden form field which is then submitted to 
   emxTable.jsp along with the URL parameters passed to the JSP containing this
   include file.
   
   To use this include, simply set the following variables in a <% %> block and
   then include this file (must be included after the variables are set).  This
   file writes a complete html page so the containing file can not include html,
   head, or body tags.
   
      String appletIntegration - The integration argument for callCommandHandlerSynchronously
      String appletMethod      - The applet method to invoke
      String appletArgs        - Arguments to pass to the applet

   Invoke the containing JSP with the URL parameters to be passed onto the table:
   
      MyJSP.jsp?table=IEFLogFileList&program=...

   JPOs called by the table can retrieve the passed information with:
   
      String appletReturn =  (String) paramMap.get("appletReturn");
--%>

<%@include file = "../emxUICommonAppInclude.inc"%>

<%@ page import = "com.matrixone.apps.domain.util.*" %>

<html>
<head>
<script language="javascript" src="../integrations/scripts/MCADUtilMethods.js" type="text/javascript"></script>
<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>
</head>

<body>

<form method="post" name="appletReturnHiddenForm" >
   <input type="hidden" value="" name="appletReturn">
   <input type="hidden" name="integrationName" value="<%= appletIntegration %>">
</form>

<script language="javascript" type="text/javascript">
	var integFrame	   = getIntegrationFrame(window);
	var mxmcadApplet = integFrame.getAppletObject(); 
	var isAppletInited = mxmcadApplet && mxmcadApplet.getIsAppletInited();
	
	if(isAppletInited == true)
	{
		var appletReturn = mxmcadApplet.callCommandHandlerSynchronously("<%= appletIntegration %>", "<%= appletMethod %>", "<%= appletArgs %>");

		document.appletReturnHiddenForm.action = "../common/emxTable.jsp?" + "<%= XSSUtil.encodeForJavaScript(context,request.getQueryString())%>";
		document.appletReturnHiddenForm.appletReturn.value = appletReturn;
		document.appletReturnHiddenForm.submit();
	}
</script>

</body>
</html>
