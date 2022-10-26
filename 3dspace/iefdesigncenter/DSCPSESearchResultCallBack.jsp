<%--  DSCPSESearchResultCallBack.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>

<%@ include file ="../integrations/MCADTopInclude.inc" %>

<%
    Context context= Framework.getMainContext(session);
	String[] objectIds = emxGetParameterValues(request, "emxTableRowId");

	String childObjectId = "";

	for (int i = 0; i < objectIds.length; i++) 
	{
		//emxTableRowId value is obtained in the format relID|objectid Or ObjectId. Need to parse the value
		StringList sList = FrameworkUtil.split(objectIds[i], "|");

		if (sList.size() == 1 || sList.size() == 2 || sList.size() == 3)
		{
			if (i == 0)
				childObjectId = (String) sList.get(0);
			else
				childObjectId = childObjectId + "|" + (String) sList.get(0);
		}
		//StructureBrowser value is obtained in the format relID|objectID|parentID|additionalInformation
		else if (sList.size() == 4) 
		{
			if (i == 0)
				childObjectId = (String) sList.get(1);
			else
				childObjectId = childObjectId + "|" + (String) sList.get(1);
		}
	}
%>
<script language="JavaScript">
function doit(){
     parent.getTopWindow().getWindowOpener().processSearchResult("<%=XSSUtil.encodeForJavaScript(context, childObjectId)%>");	
	 setTimeout("top.closeWindow()", 10);
}
window.onload = doit;
</script>
