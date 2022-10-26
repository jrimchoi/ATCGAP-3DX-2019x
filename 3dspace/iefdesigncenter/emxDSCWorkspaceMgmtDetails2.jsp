<%--
   emxDSCWorkspaceMgmtDetails2.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
	emxDSCWorkspaceMgmtDetails.jsp   - Displays detailed file information in the WSM table
--%>
<%@ include file ="../integrations/MCADTopInclude.inc" %>
<%@ page import="com.matrixone.MCADIntegration.server.beans.checkin.*, com.matrixone.MCADIntegration.utils.*, com.matrixone.MCADIntegration.server.beans.*"%>

<%
   MCADIntegrationSessionData integSessionData	= (MCADIntegrationSessionData)session.getAttribute("MCADIntegrationSessionDataObject");
   MCADSessionData sessionData					= integSessionData.getSessionData();
   Context context								= integSessionData.getClonedContext(session);
   
   String dirPath								= "";
   String dirContents							= "";
   String header								= UINavigatorUtil.getI18nString("emxIEFDesignCenter.Header.WSMHeader","emxIEFDesignCenterStringResource", request.getHeader("Accept-Language"));

   try
   {
		dirPath									= MCADUrlUtil.hexDecode(emxGetParameter(request, "dirPath"));
		dirContents								= MCADUrlUtil.hexDecode(emxGetParameter(request, "dirContents"));
   }
   catch(Exception exception)
   {
		System.out.println("[emxDSCWorkspaceMgmtDetails2.jsp] Exception in decoding: " + exception.getMessage());
   }
   
   String filesInSession						= emxGetParameter(request, "filesInSession");
   String isCSECommand							= emxGetParameter(request, "isCSECommand");	
   
   session.setAttribute("wsmDirPath", dirPath);  // Save for use by commands invoked from the details page
   session.setAttribute("wsmDirSep", "");
  
   StringTokenizer st							=  new StringTokenizer(filesInSession, "|"); 
   int numFiles									= java.lang.Integer.parseInt(st.nextToken()); 
   
   String delim									= "";

   if (dirContents.length() > 0)
   {
	  st		=  new StringTokenizer(dirContents, "|"); 
	  numFiles	= java.lang.Integer.parseInt(st.nextToken()); 
   }

   boolean bWorkingSetNeedsSaved = false;

   if (numFiles > 0)
   {
	  delim = st.nextToken();
	  session.setAttribute("wsmDirSep", delim);
   }

	IEFDesktopHelper helper = new IEFDesktopHelper(integSessionData);
			
	HashMap fileDetails		= helper.getLocalWorkspaceObjectsDetails(context, dirPath, dirContents, filesInSession, isCSECommand);
    String jpoPackedArgs	= MCADUtil.covertToString(fileDetails,true);
	jpoPackedArgs			= MCADUtil.replaceString(jpoPackedArgs, "\n", "");
    jpoPackedArgs			= MCADUrlUtil.hexEncode(jpoPackedArgs); 

	String queryString		= request.getQueryString();
	if(queryString.contains("&portalMode=true"))
	{
		queryString = queryString.replace("&portalMode=true", "&portalMode=false");
	}

%>

<html>
<head>
<script language="javascript" src="../integrations/scripts/MCADUtilMethods.js" type="text/javascript"></script>
<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>
</head>
<body>
<form method="post" name="appletReturnHiddenForm" action="../common/emxTable.jsp?<%=XSSUtil.encodeForHTML(context,queryString) %>">
   <input type="hidden" value="" name="jpoPackedArgsFileDetails">
   <input type="hidden" value="" name="dirPath">
   <input type="hidden" value="" name="header">
</form>
<script language="javascript" type="text/javascript">
	var integFrame	= getIntegrationFrame(window);
	//XSSOK
	document.appletReturnHiddenForm.jpoPackedArgsFileDetails.value = "<%= jpoPackedArgs %>";
	//XSSOK
	document.appletReturnHiddenForm.header.value = "<%= header %>";
	document.appletReturnHiddenForm.submit();
</script>

</body>
</html>
