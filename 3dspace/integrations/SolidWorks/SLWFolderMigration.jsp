<%--  SLWFolderMigration.jsp

   Copyright Dassault Systemes, 1992-2007. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>

<%@ include file = "../MCADTopInclude.inc" %>
<%@ include file = "../MCADTopErrorInclude.inc" %>

<script language="JavaScript" src="../scripts/IEFUIConstants.js"></script>
<script language="JavaScript" src="../scripts/IEFUIModal.js"></script>
<script language="JavaScript" src="../scripts/MCADUtilMethods.js"></script>
<script language="JavaScript" src="../../common/scripts/emxUIConstants.js" type="text/javascript"></script>
<%@ page import="com.matrixone.apps.domain.util.*" %>
<%
	java.util.Enumeration itl = emxGetParameterNames(request);

	String sIntegrationName	=Request.getParameter(request,"tableFilter");
	String sAction			=Request.getParameter(request,"action");
	String sRefreshFrame	=Request.getParameter(request,"refreshFrame");
	String currentObjectId	=Request.getParameter(request,"objectId");
	String launchCADTool	=Request.getParameter(request,"LaunchCADTool");
    String folderObjectId	=Request.getParameter(request,"folderObjectId");
	String actionURL		= "";
	String sObjectId		= "";
	String integrationName  = "";
	String checkoutStatus   = "";
	String objectsInfo      = "";
	String checkoutMessage  = "";
	String errorMessage		= "";
	String params			= "";
	String sTargetLocation	= "";
	String errMsg			= "";
	String helpUrl			= "";
	String featureName		= sAction;
	String isFeatureAllowed	= "";

	String showBareboardPage		= "";
	Context _context				= null;
	String[] objectCheckoutDetails	= null;
    StringBuilder selectedObjectIds = new StringBuilder();

	MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData)session.getAttribute("MCADIntegrationSessionDataObject");
	String unSupportedCommandErrorMessage		= "";
	String otherCommandActiveErrorMessage		= "";

	if(integSessionData != null)
	{
		String[] objectIds	= emxGetParameterValues(request, "emxTableRowId");

		sTargetLocation =Request.getParameter(request,"Target Location");

		if (objectIds == null || objectIds.equals("null"))
		{
		    String objectId = (String)Request.getParameter(request,"objectId");
		    if (null != objectId && !objectId.equals("null"))
		    {
				objectIds		= new String[1];
		        objectIds[0]	= objectId;
		    }
		}
		else if(objectIds!=null && objectIds.length>0)
		{
			for(int i=0; i < objectIds.length; i++)
			{
			    //If the node is selected from Navigate page relID|objectId or ObjectId combination will come as node value				
                StringList sList = FrameworkUtil.split(objectIds[i],"|");
        
			    if(sList.size() == 1 || sList.size() == 2)
				    objectIds[i] = (String)sList.get(0);

			    //Structure Browser value is obtained in the format relID|objectID|parentID|additionalInformation
                else if(sList.size() == 3) //when relID comes as blank 
				    objectIds[i] = (String)sList.get(0);

				else if(sList.size() == 4)
				    objectIds[i] = (String)sList.get(1);
			}
		}

		for(int i=0; i<objectIds.length; ++i)
		{
			selectedObjectIds.append(objectIds[i]).append("|");
		}

		Context context = integSessionData.getClonedContext(session);

		MCADGlobalConfigObject globalConfigObject	= integSessionData.getGlobalConfigObject(sIntegrationName,context);
		HashMap globalConfigObjectTable			  = (HashMap)integSessionData.getIntegrationNameGCOTable(context);
		
		session.setAttribute("GCOTable", globalConfigObjectTable);
		session.setAttribute("GCO", globalConfigObject);				
		session.setAttribute("LCO", (Object)integSessionData.getLocalConfigObject());

		MCADMxUtil util	= new MCADMxUtil(context, integSessionData.getLogger(), integSessionData.getResourceBundle(),integSessionData.getGlobalCache());

		if(null == objectIds || objectIds.length <= 0)
		{
			String message	= integSessionData.getResourceBundle().getString("mcadIntegration.Server.Message.ErrorNoSelection");
			actionURL		= "../MCADMessageFS.jsp?";
			actionURL		+= "&message=" + message;
			errorMessage	= message.trim();
		}
	}
	else
	{
		String acceptLanguage							= request.getHeader("Accept-Language");
		MCADServerResourceBundle serverResourceBundle	= new MCADServerResourceBundle(acceptLanguage);

		String message	= serverResourceBundle.getString("mcadIntegration.Server.Message.ServerFailedToRespondSessionTimedOut");
		//emxNavErrorObject.addMessage(message);
		errorMessage	= message.trim();
	}

String fwdPage = "../../common/emxIndentedTable.jsp?program=SLWFolderMigration:addToFolder&direction=from&tableMenu=SLWFolderMigrationTableFilter&jpoAppServerParamList=session:GCO,session:GCOTable,session:LCO&freezePane=Name&editLink=false&toolbar=SLWFolderMigrationToolbar&header=emxIEFDesignCenter.Header.Navigate&suiteKey=DesignerCentral&portalMode=false&expandProgram=SLWFolderMigration:getRelatedData&expandLevel=All&expandByDefault=true&submitURL=../integrations/SolidWorks/SLWFolderMigrationSelector.jsp&folderObjectId="+folderObjectId+"&selection=none&cancelLabel=emxIEFDesignCenter.Button.Cancel";
%>

<html>
<head>
<script type="text/javascript">
	function DoSubmit()
    {
		document.forms.DoExpand.submit();
	}
</script>
</head>
<body onload='DoSubmit()'>
<form name="DoExpand" action='<%=fwdPage%>' method="post">
<input type="hidden" name="selectedobjectids" value='<%=selectedObjectIds.toString()%>' />
</form>
</body>
</html>
