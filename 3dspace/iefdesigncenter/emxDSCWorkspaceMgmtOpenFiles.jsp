<%--  emxDSCWorkspaceMgmtOpenFiles.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  IEFDSCWorkspaceMgmtOpenFiles.jsp - Perform Open on selected files



--%>

<%@ include file="../integrations/MCADTopInclude.inc" %>
<%@ include file="../integrations/MCADTopErrorInclude.inc" %>
<%@ include file="emxDSCWorkspaceMgmtUtils.inc" %>
<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>


<html>
<head>
</head>
<body>
<script language="javascript" src="../common/scripts/emxUIConstants.js"></script>
<script language="javascript" src="../integrations/scripts/MCADUtilMethods.js" type="text/javascript"></script>
<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>

<%
   String acceptLanguage = request.getHeader("Accept-Language");
   
   // Retrieve selected items from the table
   String[] tableRowIds = emxGetParameterValues(request, "emxTableRowId");

   // Retrieve other parameters
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
         String integName 		= (String) parsedSelection.elementAt(2);
         Vector wsEntryBoids 	= (Vector) parsedSelection.elementAt(3);
   
         // Cycle the selected files and build the string to send to the applet
         String appletFileBoidList = dirPath;
         for (int ii=0; ii < objectIds.size(); ii++)
         {
            String fileName = (String) fileNames.elementAt(ii);
            appletFileBoidList += "|" + fileName + "," + wsEntryBoids.elementAt(ii);
         }       

		 appletFileBoidList = MCADUrlUtil.hexEncode(appletFileBoidList);
      
         // Perform operation
         // Note the details frame will be refreshed from the applet
         String methodName = "openWSMFiles";
%>

         <script language="JavaScript">
            var integFrame			= getIntegrationFrame(window);            
            //XSSOK			
			var appletFileBoidList	= hexDecode('<%= integName %>', "<%= appletFileBoidList %>");
			//XSSOK
            integFrame.getAppletObject().callCommandHandler('<%= integName %>', "<%= methodName %>", appletFileBoidList);
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

</body>
</html>
