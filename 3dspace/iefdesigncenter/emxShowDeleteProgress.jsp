<%--  emxShowDeleteProgress.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<!-- IEF imports Start -->
<%@ page import = "com.matrixone.MCADIntegration.server.beans.*, com.matrixone.MCADIntegration.utils.*" %>
<!-- IEF imports End -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">


<html>

<%@include file="emxInfoCentralUtils.inc"%>
<%@include file = "emxInfoTableInclude.inc"%>
<%@include file="../emxUICommonHeaderBeginInclude.inc"%>
<%  
String[] objectIds = emxGetParameterValues(request, "emxTableRowId");

	for(int i=0; i < objectIds.length; i++)
	{
		//emxTableRowId value is obtained in the format objectId|rowInfo Or ObjectId. Need to parse the value
		StringList sList = FrameworkUtil.split(objectIds[i],"|");
	
		if(sList.size() == 1 || sList.size() == 2)
			objectIds[i] = (String)sList.get(0);
			
		// StructureBrowser value is obtained in the format relID|objectID|parentID|additionalInformation 
		else if(sList.size() == 3)
			objectIds[i] = (String)sList.get(0);

		else if(sList.size() == 4)
				objectIds[i] = (String)sList.get(1);
	}
	
%>
<jsp:useBean id="emxNavErrorObject" class="com.matrixone.apps.domain.util.FrameworkException" scope="request"/> 
<script language="JavaScript" src="../common/scripts/emxUIConstants.js"></script> <%--Required for findFrame() function--%>
<script language="JavaScript" src="emxInfoUIModal.js"></script>
<script language="JavaScript" src="../integrations/scripts/MCADUtilMethods.js" type="text/javascript"></script>
<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>

<head>
<script language="JavaScript">	

	var listHeaderFrame = findFrame(parent, "listHead");
	
	if(listHeaderFrame)
	{
		listHeaderFrame.document.forms.tableHeaderForm.imgProgress.src = "../common/images/utilProgressDialog.gif";
	}

	var listContentFrame = findFrame(parent, "listDisplay");
	
    if (listContentFrame)
	{				
		listContentFrame.document.emxTableForm.action = "./emxInfoSearchResultsDelete.jsp";
		listContentFrame.document.emxTableForm.target = 'hiddenTableFrame';
		listContentFrame.document.emxTableForm.submit();
	}
	else 
	{
		listContentFrame = findFrame(top,"searchResults"); 
		if(listContentFrame == null)
		{
			listContentFrame = findFrame(top,"structure_browser"); //for Full Search
		}
		if (listContentFrame)
		{				
			listContentFrame.document.forms[0].action = "../iefdesigncenter/emxInfoSearchResultsDelete.jsp";
			listContentFrame.document.forms[0].target = "_self";
			listContentFrame.document.forms[0].method = "post"
			listContentFrame.document.forms[0].submit();
		}		
		
	}
	


</script>
</head>
</html>
