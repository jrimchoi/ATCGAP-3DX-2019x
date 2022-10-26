<%--  DSCReplaceObjectsOptionDialogFS.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  DSCReplaceObjectsOptionDialogFS.jsp   -   Gives option to select the templates for replace operation

--%>

<%@include file="emxInfoCentralUtils.inc"%> 
<%@ page import = "com.matrixone.MCADIntegration.server.beans.*, com.matrixone.MCADIntegration.utils.* ,com.matrixone.MCADIntegration.server.cache.* ,com.matrixone.MCADIntegration.server.*  " %>
<%
	framesetObject fs = new framesetObject();
	fs.setDirectory(appDirectory);
	
	String jsTreeID			= emxGetParameter(request, "jsTreeID");
	String suiteKey			= emxGetParameter(request, "suiteKey");
	String objectId			= emxGetParameter(request, "objectId");
	String[] objectIds		= emxGetParameterValues(request, "emxTableRowId");
	String acceptLanguage	= request.getHeader("Accept-Language");
	String errorMessage		= "";
	String isFeatureAllowed	= "";

	MCADIntegrationSessionData integSessionData	= (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");

	if(integSessionData == null)
	{
		MCADServerResourceBundle serverResourceBundle = new MCADServerResourceBundle(acceptLanguage);
		errorMessage = serverResourceBundle.getString("mcadIntegration.Server.Message.ServerFailedToRespondSessionTimedOut");
	}
	else if (objectIds.length > 1)
	{
		errorMessage = integSessionData.getResourceBundle().getString("mcadIntegration.Server.Message.MultipleSelection");
	}
	else
	{
		MCADMxUtil util			= new MCADMxUtil(context, integSessionData.getLogger(), integSessionData.getResourceBundle(), integSessionData.getGlobalCache());
		
		String relIDBusID		= objectIds[0]; 
		String selectedObjectID = relIDBusID.substring(relIDBusID.indexOf('|') + 1);
		String integrationName	= util.getIntegrationName(context, selectedObjectID);

		isFeatureAllowed		= integSessionData.isFeatureAllowedForIntegration(integrationName, MCADGlobalConfigObject.FEATURE_REPLACE);
	
		if(errorMessage.equals("") && integSessionData != null && !isFeatureAllowed.startsWith("true"))
			errorMessage		= isFeatureAllowed.substring(isFeatureAllowed.indexOf("|")+1, isFeatureAllowed.length());
	}

	if (!errorMessage.equals(""))
	{
%>
		<script>
		//XSSOK
		alert("<%=errorMessage%>");
		window.parent.close();
		</script>
<%
	}

	String contentURL		= "DSCReplaceObjectsOptionDialog.jsp";

	// add these parameters to each content URL, and any others the App needs
	contentURL += "?suiteKey=" + suiteKey + "&jsTreeID=" + jsTreeID + "&objectId="+ objectId;
	for(int i=0; i<objectIds.length; i++)
	{
		contentURL += "&emxTableRowId="+ objectIds[i];
	}
	
	String HelpMarker	= "emxHelpInfoAccessDialogFS";
	String roleList		= "role_GlobalUser";

	fs.initFrameset("emxIEFDesignCenter.ReplaceObject.ReplaceObject",
				  "",
				  contentURL,
				  false,
				  true,
				  false,
				  false);

	fs.setStringResourceFile("emxIEFDesignCenterStringResource");

	fs.createFooterLink("emxIEFDesignCenter.Command.Done",
					"submit()",
					roleList,
					false,
					true,
					"iefdesigncenter/images/emxUIButtonDone.gif",
					0);

	fs.createFooterLink("emxIEFDesignCenter.Command.Cancel",
					"parent.window.close()",
					roleList,
					false,
					true,
					"iefdesigncenter/images/emxUIButtonCancel.gif",
					0);
	
	fs.writePage(out);
%>





