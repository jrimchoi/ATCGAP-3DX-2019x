<%--  emxDSCWorkspaceMgmtDeleteFiles.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  IEFDSCWorkspaceMgmtDeleteFiles.jsp - Perform delete on selected files

--%>

<%@ include file="../integrations/MCADTopInclude.inc" %>
<%@ include file="../integrations/MCADTopErrorInclude.inc" %>

<%@ include file="emxDSCWorkspaceMgmtUtils.inc" %>

<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>

<html>
<head>
<script language="javascript" src="../common/scripts/emxUIConstants.js"></script>
<script language="javascript" src="../integrations/scripts/MCADUtilMethods.js" type="text/javascript"></script>
<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>

<%
   String acceptLanguage = request.getHeader("Accept-Language");

   // Retrieve selected items from the table
   String[] tableRowIds = emxGetParameterValues(request, "emxTableRowId");

   // Retrieve other parameters
   String action = emxGetParameter(request, "action");  // Currently unused
   String dirPath = (String) session.getAttribute("wsmDirPath");
	
   MCADServerResourceBundle serverResourceBundle = new MCADServerResourceBundle(acceptLanguage);
   MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
   MCADMxUtil util = new MCADMxUtil(integSessionData.getClonedContext(session), integSessionData.getLogger(), integSessionData.getResourceBundle(), integSessionData.getGlobalCache());
   MCADSessionData sessionData = integSessionData.getSessionData();

   Context context = integSessionData.getClonedContext(session);
   ENOCsrfGuard.validateRequest(context, session, request, response);
   
   if(integSessionData != null)
   {
      try
      {
         // Parse selections
         Vector parsedSelection = this.parseSelection(integSessionData.getClonedContext(session), tableRowIds, integSessionData, util, false, false);
         Vector objectIds		= (Vector) parsedSelection.elementAt(0);
         Vector fileNames		= (Vector) parsedSelection.elementAt(1);
		 
         // Cycle the selected files and build the string to send to the applet
         String appletFileList		= dirPath;
		 String integrationName		= "";

		 if(!objectIds.isEmpty())
		 {
			integrationName = util.getIntegrationName(integSessionData.getClonedContext(session), (String)objectIds.elementAt(0)); //Not safe if multiple integrations in use.
		 }

         for (int ii=0; ii < objectIds.size(); ii++)
         {
	        String objId = (String) objectIds.elementAt(ii);
            String fileName = (String) fileNames.elementAt(ii);
            //The delimiter is selected as '/' to make sure that the filename doesn't contain this character
            appletFileList += "|" + fileName + "/" + objId;
         }
         
		 // To protect backslash chars through to javascript
		 appletFileList = MCADUrlUtil.hexEncode(appletFileList);

       // Perform operation
%>
         <script language="JavaScript">

         // make call to command handler where confirmation, delete and
         // saving of working set are carried out

         var integFrame		= getIntegrationFrame(window);
		 //XSSOK
		 var appletFileList = hexDecode('<%=integrationName%>', "<%=appletFileList%>"); //NOTE: Use of integrationName not safe, might not work if multiple integrations are in use.
         integFrame.getAppletObject().callCommandHandler('', 'deleteWSMFiles', appletFileList);  // Note - Can not pass integrationName!

         </script>
<%
      }
      catch(Exception exception)
      {
         emxNavErrorObject.addMessage(exception.getMessage());
      }
   }
   else
   {
      String errorMessage  = serverResourceBundle.getString("mcadIntegration.Server.Message.ServerFailedToRespondSessionTimedOut");
      emxNavErrorObject.addMessage(errorMessage);
   }
%>

</head>
<body>
</body>
</html>
