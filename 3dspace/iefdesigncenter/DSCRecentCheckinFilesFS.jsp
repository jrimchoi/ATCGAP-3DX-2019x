<%--  DSCRecentCheckinFilesFS.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>

<%@ page import="com.matrixone.MCADIntegration.utils.*,com.matrixone.MCADIntegration.server.beans.*,com.matrixone.MCADIntegration.server.*,com.matrixone.apps.domain.util.*"  %>
<%@page import="matrix.db.Context"%>

<%
	
	MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
    Context context = integSessionData.getClonedContext(session);
	String queryString = request.getQueryString();
%>

<html>
	<head>
	</head>

	<frameset>
		<frame name="recentCheckinFilesFrame" src="DSCRecentCheckinFiles.jsp?<%=XSSUtil.encodeForHTML(context, queryString)%>">
	</frameset>
</html>
