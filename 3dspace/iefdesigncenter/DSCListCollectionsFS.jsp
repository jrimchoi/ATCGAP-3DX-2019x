<%--  DSCListCollectionsFS.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%@ include file ="../integrations/MCADTopInclude.inc" %>
<%
	MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");	
	String queryString =null;
	if(integSessionData == null)
		queryString = request.getQueryString();
	else
		queryString = emxGetEncodedQueryString(integSessionData.getClonedContext(session),request);
%>

<html>
	<head>
	</head>

	<frameset>
	    <!--XSSOK-->
		<frame name="listCollectionsFrame" src="IEFListCollections.jsp?<%= queryString %>">
	</frameset>
</html>
