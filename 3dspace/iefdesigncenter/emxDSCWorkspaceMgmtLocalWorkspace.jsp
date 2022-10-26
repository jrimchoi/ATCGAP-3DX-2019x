<%--  emxDSCWorkspaceMgmtLocalWorkspace.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  emxDSCWorkspaceMgmtLocalWorkspaces.jsp   - Page displayed at start of WSM or when Local Workspaces is selected


   static const char RCSID[] = $Id: /ENODesignerCentral/CNext/webroot/iefdesigncenter/emxDSCWorkspaceMgmtLocalWorkspace.jsp 1.3.1.3 Sat Apr 26 10:22:24 2008 GMT ds-mbalakrishnan Experimental$
--%>

<%@include file="../integrations/MCADTopInclude.inc"%>

<html>
<head>

<%
   MCADIntegrationSessionData integSessionData	= (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
   MCADSessionData sessionData = integSessionData.getSessionData();
   Vector dirNames = sessionData.getAllDirectoryNames("");
   
   String msg;
   if (dirNames.size() == 0)
      msg = UINavigatorUtil.getI18nString("emxIEFDesignCenter.WorkspaceMgmt.NoLocalDirectories","emxIEFDesignCenterStringResource", request.getHeader("Accept-Language"));
   else
      msg = UINavigatorUtil.getI18nString("emxIEFDesignCenter.WorkspaceMgmt.LocalWorkspaceIntro","emxIEFDesignCenterStringResource", request.getHeader("Accept-Language"));
%>

<script language="javascript" src="../common/scripts/emxUIConstants.js"></script>
<script language="javascript" src="../integrations/scripts/MCADUtilMethods.js" type="text/javascript"></script>
<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>
<script language="javascript" type="text/javascript">

   //XSSOK
   document.write("<%= msg %>");

</script>
</head>

<body>
</body>
</html>
