<%--  IEFReplaceResultsFooter.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,java.io.*, java.net.*,com.matrixone.MCADIntegration.server.*,com.matrixone.MCADIntegration.server.beans.*, com.matrixone.MCADIntegration.utils.*,com.matrixone.MCADIntegration.utils.customTable.*" %>
<%@ page import = "matrix.db.*, matrix.util.*,com.matrixone.servlet.*,com.matrixone.apps.framework.ui.*,com.matrixone.apps.domain.util.*, com.matrixone.apps.domain.*"%>

<%
	MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
%>

<html>
<head>
<title></title>
	<link rel="stylesheet" href="../integrations/styles/emxIEFCommonUI.css" type="text/css">
<!--<script type="text/javascript" language="JavaScript" src="../common/scripts/emxUIBottomPageJavaScriptInclude.js"></script>-->
</head>

  <body>
<form name="bottomCommonForm" method="post">
      <table border="0" width="95%">
      <tr>
        <td align="left"><p align=left><img src="./images/utilSpace.gif"></p></td>
		<td align="right">
			<table border="0">
			  <tr>
				<td align="right" nowrap><a href="javascript:parent.selectObjectForReplace()"><img src="../iefdesigncenter/images/emxUIButtonNext.gif" border="0" alt="<%=integSessionData.getStringResource("mcadIntegration.Server.ButtonName.Replace")%>")></a>&nbsp;</td>
				<td align="right" nowrap><a href="javascript:parent.selectObjectForReplace()"><%=integSessionData.getStringResource("mcadIntegration.Server.ButtonName.Replace")%></a></td>
				<td align="right" nowrap>&nbsp;&nbsp;&nbsp;<a href="javascript:parent.closeModalDialog()"><img src="../iefdesigncenter/images/emxUIButtonCancel.gif" border="0" alt ="<%=integSessionData.getStringResource("mcadIntegration.Server.ButtonName.Cancel")%>"</a>&nbsp;</td>
				<td align="right" nowrap><a href="javascript:parent.closeModalDialog()"><%=integSessionData.getStringResource("mcadIntegration.Server.ButtonName.Cancel")%></a></td>
			  </tr>
			</table>
        </td>
      </tr>
    </table>

</form>
</body>
</html>
