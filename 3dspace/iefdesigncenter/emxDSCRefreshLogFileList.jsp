<%--  emxDSCRefreshLogFileList.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  emxDSCRefreshLogFile.jsp   - Action handler for the refresh logfile list command



   static const char RCSID[] = $Id: /ENODesignerCentral/CNext/webroot/iefdesigncenter/emxDSCRefreshLogFileList.jsp 1.3.1.3 Sat Apr 26 10:22:24 2008 GMT ds-mbalakrishnan Experimental$
--%>

<%-- <%@include file="../emxUIFramesetUtil.inc"%> --%>
<%-- <%@include file="../common/emxCompCommonUtilAppInclude.inc"%> --%>
<%@include file="../integrations/MCADTopInclude.inc"%>
<html>
<head>
<script language="javascript" src="../common/scripts/emxUIConstants.js"></script>
<script language="javascript" src="../integrations/scripts/MCADUtilMethods.js" type="text/javascript"></script>
<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>
<script language="javascript" type="text/javascript">

   var tabFrame = findFrame(parent, "listDisplay");
   if(tabFrame != 'undefined' && tabFrame != null)
   {
	  var portalMode = "false";
      if (tabFrame.parent.document.location.href.indexOf("portalMode=true") >= 0) 
		  portalMode = "true";

	  var logFileType = "failure";
      if (tabFrame.parent.document.location.search.indexOf("logFileType=success") >= 0) logFileType = "success";
      var header = "emxIEFDesignCenter.Common.FailureLogFileTable";	
	  if(logFileType == "success")
		 header = "emxIEFDesignCenter.Common.SuccessLogFileTable";
      // Refresh the table (note we must reinvoke the table wrapper emxDSCLogFileTable to reinvoke the applet and get the updated file list)
      //var newHref = tabFrame.parent.document.location.href.replace('common/emxTable', 'iefdesigncenter/emxDSCLogFileTable');
	  //tabFrame.parent.document.location.href = newHref;
      tabFrame.parent.document.location.href = "../iefdesigncenter/emxDSCLogFileTable.jsp?logFileType="+logFileType+"&table=DSCLogFileList&program=DSCGenerateLogFileList:getFileList&objectBased=false&toolbar=DSCLogFileListTopActionBarActions&selection=multiple&header="+header+"&pagination=0&headerRepeat=0&suiteKey=DesignerCentral&portalMode="+portalMode;
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
