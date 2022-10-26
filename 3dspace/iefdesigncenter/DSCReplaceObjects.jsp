<%--  DSCReplaceObjects.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  DSCReplaceObjects.jsp   -  Replace selected object with the newly created templace object.


--%>

<%@ include file="../integrations/MCADTopInclude.inc" %>
<%@ include file="emxInfoUtils.inc"%>

<%
	String acceptLanguage		= request.getHeader("Accept-Language");
	String[] objectIds			= emxGetParameterValues(request, "emxTableRowId");
	String rootObjectId			= emxGetParameter(request, "objectId");
	String templateObjectID		= emxGetParameter(request, "template");
	String integrationName		= request.getParameter("integrationName");
	String errorString			= null;

	MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData)session.getAttribute("MCADIntegrationSessionDataObject");
	Context context								= integSessionData.getClonedContext(session);

	try
	{
		
		//Start the transaction
		context.start(true);

		MCADGlobalConfigObject globalConfigObject = integSessionData.getGlobalConfigObject(integrationName,context);
		MCADMxUtil util							  = new MCADMxUtil(context, integSessionData.getLogger(), integSessionData.getResourceBundle(), integSessionData.getGlobalCache());	
		
		String relIDBusID		= objectIds[0];
		String relID			= relIDBusID.substring(0, relIDBusID.indexOf('|'));
		String selectedObjectID = relIDBusID.substring(relIDBusID.indexOf('|')+1);
		String workingDir		= integSessionData.getUserWorkingDirectory().getName();

		if(relID.equals("null"))
		{
			String errorMessage = i18nStringNowLocal("emxIEFDesignCenter.RemoveObject.RootNodeCanNotBeSelected", acceptLanguage);
			MCADServerException.createException(errorMessage, null);
		}

		String[] packedGCO = new String[2];
		packedGCO = JPO.packArgs(globalConfigObject);

		String[] args = new String[9];
		args[0]  = packedGCO[0];
		args[1]  = packedGCO[1];
		args[2]  = integSessionData.getLanguageName();
		args[3]  = integrationName;
		args[4]  = relID;
		args[5]  = selectedObjectID;
		args[6]  = templateObjectID;
		args[7]  = workingDir;

		util.executeJPO(context, "IEFReplaceObjectsOption", "getReplaceObjectData", args, null);

		//Commit the transaction
        util.commitTransaction(context);
	}
	catch(Exception exception)
	{
		try
		{
			if(context.isTransactionActive())
			context.abort();
		}
		catch(Exception commitException){}

		errorString = exception.getMessage();
	}
%>
<html>
<head>
</head>
<body>
	
<%
	if (errorString != null)
	{
%>
    <!--XSSOK-->
	<h4><%= errorString %></h4>
<script language="javascript" >	
var formFooterURL  = "emxAppBottomPageInclude.jsp?beanName=null&dir=iefdesigncenter&links=1&dialog=true&usepg=false&ldisp1=emxIEFDesignCenter.Common.Close&lhref1=parent.window.close()&lacc1=role_GlobalUser &lpop1=false&ljs1=true&licon1=emxUIButtonCancel.gif&wsize1=0&oidp=null&strfile=emxIEFDesignCenterStringResource";

top.pagefooter.location.href = formFooterURL;
</script>
<%
	}
	else
	{
%>
<script language="javascript" >	
	//Refresh table content frame.	
	//XSSOK
	var objectIds = '<%=objectIds%>';
	top.opener.parent.reloadNavigateTable(objectIds);
	top.window.close();
</script>
<%
	}
%>
</body>
</html>
