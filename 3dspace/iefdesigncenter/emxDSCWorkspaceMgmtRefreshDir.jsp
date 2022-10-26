<%--  emxDSCWorkspaceMgmtRefreshDir.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  emxDSCWorkspaceMgmtRefreshDir.jsp   - Action handler for the refresh dir command

   static const char RCSID[] = $Id: /ENODesignerCentral/CNext/webroot/iefdesigncenter/emxDSCWorkspaceMgmtRefreshDir.jsp 1.3.1.3 Sat Apr 26 10:22:24 2008 GMT ds-mbalakrishnan Experimental$
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

   // Refresh details frame
   
   var tabFrame = findFrame(parent, "listDisplay");

   if(tabFrame != 'undefined' && tabFrame != null)
   {
      // Refresh the table (note we must reinvoke the table wrapper emxDSCWorkspaceDetails to reinvoke the applet and get the updated file list)
      var newHref = tabFrame.parent.document.location.href.replace('common/emxTable', 'iefdesigncenter/emxDSCWorkspaceMgmtDetails');
      tabFrame.parent.document.location.href = newHref;
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
