<%--  SLWDoFolderAddition.jsp

   Copyright Dassault Systemes, 1992-2007. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>

<%@ include file = "../MCADTopInclude.inc" %>
<%@ include file = "../MCADTopErrorInclude.inc" %>

<%@ page import="com.matrixone.apps.domain.util.*" %>
<%
	  String idsToAdd = Request.getParameter(request,"idsToAdd");
      String folderId = Request.getParameter(request,"folderId");

      MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData)session.getAttribute("MCADIntegrationSessionDataObject");

	  if(integSessionData != null)
	  {
		  Context context           = integSessionData.getClonedContext(session);
		  StringTokenizer tokenizer = new StringTokenizer(idsToAdd, "|");
		  MCADFolderUtil folderUtil = new MCADFolderUtil(context, integSessionData.getResourceBundle(),integSessionData.getGlobalCache());
		  while(tokenizer.hasMoreTokens())
		  {
			  String id = (String)tokenizer.nextToken();
			  folderUtil.assignToFolder(context, new BusinessObject(id), folderId, "false");
		  }
	  }
	  else
	  {
		String acceptLanguage							= request.getHeader("Accept-Language");
		MCADServerResourceBundle serverResourceBundle	= new MCADServerResourceBundle(acceptLanguage);

		String message	= serverResourceBundle.getString("mcadIntegration.Server.Message.ServerFailedToRespondSessionTimedOut");
	  }
%>
<html>
<head>
	<script type="text/javascript">
		  function closeWindow()
          {
			  top.window.close();
          }
	</script>
</head>
<body onload='closeWindow()'>
</body>
</html>
