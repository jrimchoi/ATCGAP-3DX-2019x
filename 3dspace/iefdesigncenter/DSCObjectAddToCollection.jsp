<%--  DSCObjectAddToCollection.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  DSCObjectAddToCollection.jsp   -  Forwards the request to emxInfoAddToCollectionDialogFS.jsp.



--%>

<%@include file="emxInfoCentralUtils.inc"%>

<html>
<head>
<script language="JavaScript" type="text/javascript" src="../common/scripts/emxUICore.js"></script>
<script language="JavaScript" type="text/javascript" src="../common/scripts/emxUIModal.js"></script>
<script language="JavaScript" type="text/javascript" src="../emxUIPageUtility.js"></script>
<script language="JavaScript" src="../integrations//IEFUIConstants.js"></script>
<script language="JavaScript" src="../integrations/scripts/IEFUIModal.js"></script>
<script language="JavaScript" src="scripts/MCADUtilMethods.js" type="text/javascript"></script>
</head>

<%
	String timeStamp = Long.toString(System.currentTimeMillis());
	String[] emxTableRowId = emxGetParameterValues(request,"emxTableRowId"); 
	
	//set the ObjectIds in session. They will be retrieved in emxInfoAddToCollectionDialog.jsp
	session.setAttribute("ObjectIds" + timeStamp, emxTableRowId);	
	
	String url = "emxInfoAddToCollectionDialogFS.jsp?timeStamp=" + timeStamp;
	
	Enumeration enumParamNames = emxGetParameterNames(request);
	while(enumParamNames.hasMoreElements()) 
	{
		String paramName = (String) enumParamNames.nextElement();
		String paramValue = emxGetParameter(request, paramName);
		
		//pass all the values except emxTableRowId, it is set in the session
		if (!"emxTableRowId".equals(paramName)){
			url += "&" + paramName + "=" + paramValue;
		}
	}
	
%>

<script language="JavaScript">
	showIEFModalDialog("<%=XSSUtil.encodeForHTML(context,url)%>", '500', '500');
</script>

</html>
