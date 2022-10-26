<%--  emxDSCDeleteLogFile.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  emxDSCDeleteLogFile.jsp   - Action handler for the delete logfile command

   static const char RCSID[] = $Id: /ENODesignerCentral/CNext/webroot/iefdesigncenter/emxDSCDeleteLogFile.jsp 1.3.1.3 Sat Apr 26 10:22:24 2008 GMT ds-mbalakrishnan Experimental$
--%>

<%-- <%@include file="../emxUIFramesetUtil.inc"%> --%>
<%-- <%@include file="../common/emxCompCommonUtilAppInclude.inc"%> --%>
<%@include file="../integrations/MCADTopInclude.inc"%>
<%@page import ="com.matrixone.apps.domain.util.*" %>

<%
   MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData)session.getAttribute("MCADIntegrationSessionDataObject");
   Context context = integSessionData.getClonedContext(session);
   ENOCsrfGuard.validateRequest(context, session, request, response);	
   String portalMode = emxGetParameter(request, "portalMode");
   if(portalMode == null || portalMode.equals("null"))
		portalMode = "false";
   // Get the parameters from the request URL.  emxTableRowId is the list of
   // selected file names.
   String sFileList[] = emxGetParameterValues(request,"emxTableRowId");
  
   // Concatenate into a single string

   String sFiles = "";
   for (int ii = 0; ii < sFileList.length ; ii++) {
      if (ii > 0) sFiles += "|";
      sFiles += sFileList[ii];
    }
   
   try 
   {
       sFiles = MCADUrlUtil.hexEncode(sFiles);
   }
   catch(Exception exception)
   {
	   System.out.println("Exception: " + exception.getMessage());
   }   
   
%>

<html>
<head>
<script language="javascript" src="../common/scripts/emxUIConstants.js"></script>
<script language="javascript" src="../integrations/scripts/MCADUtilMethods.js" type="text/javascript"></script>
<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>
<script language="javascript" type="text/javascript">

   var tabFrame = findFrame(parent, "listDisplay");
   if(tabFrame != 'undefined' && tabFrame != null)
   {
      var logFileType = "failure";
      if (tabFrame.parent.document.location.search.indexOf("logFileType=success") >= 0) logFileType = "success";
   
      var doDelete = true;
      if (logFileType == "failure")
      {
	     //XSSOK
         var confirmMsg = "<%=UINavigatorUtil.getI18nString("emxIEFDesignCenter.LogFile.DeleteConfirmDialog","emxIEFDesignCenterStringResource", request.getHeader("Accept-Language"))%>";
         doDelete		= confirm(confirmMsg);
      }
      if (doDelete)
      {
	     //XSSOK
		 var sFiles		= hexDecode('', "<%=sFiles%>");
         var integFrame	= getIntegrationFrame(window);
      	 integFrame.getAppletObject().callCommandHandlerSynchronously('', 'deleteBGCheckinLogFileList', sFiles);
   
		 var header = "emxIEFDesignCenter.Common.FailureLogFileTable";	
		 if(logFileType == "success")
			 header = "emxIEFDesignCenter.Common.SuccessLogFileTable";
         // Refresh the table (note we must reinvoke the table wrapper emxDSCLogFileTable to reinvoke the applet and get the updated file list)
         //var newHref = tabFrame.parent.document.location.href.replace('common/emxTable', 'iefdesigncenter/emxDSCLogFileTable');
         //tabFrame.parent.document.location.href = newHref;
		 tabFrame.parent.document.location.href = "../iefdesigncenter/emxDSCLogFileTable.jsp?logFileType="+logFileType+"&table=DSCLogFileList&program=DSCGenerateLogFileList:getFileList&objectBased=false&toolbar=DSCLogFileListTopActionBarActions&selection=multiple&header="+header+"&pagination=0&headerRepeat=0&suiteKey=DesignerCentral&portalMode=<%=XSSUtil.encodeForURL(context,portalMode)%>";
      }
   }
   else
   { // FIXME-KBD 
      alert ("Could not find table frame");
   }

</script>
</head>

<body>
</body>
</html>
