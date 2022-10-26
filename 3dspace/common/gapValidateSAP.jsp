<!DOCTYPE html>
<html>
<head>
</head>
<body>
<%@include file = "../common/emxNavigatorInclude.inc"%>
<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>
<script language="javascript" src="../common/scripts/emxUIConstants.js"></script>
<script language="javascript" src="../common/scripts/emxUICore.js"></script>
<script language="javascript" src="../common/scripts/emxUIModal.js"></script>
<%
		String strObjectId  = emxGetParameter(request,"objectId");
		
		String strErrorMessage = null;
		try{
		Map programMap = new HashMap();		
		programMap.put("objectId", strObjectId);
		String[] strArgs1  = JPO.packArgs(programMap);
		Map mpResult    = (Map) JPO.invoke(context, "gapSAPValidateUser", null, "validateUserCredentials", strArgs1, Map.class);
		strErrorMessage = (String) mpResult.get("ERROR_MSG"); 
	}
	catch (Exception exp)
	{
		exp.printStackTrace();
		strErrorMessage = exp.getMessage();
		System.out.println("from JSP : "+strErrorMessage);
	}
    StringBuffer sbURL = new StringBuffer();
    sbURL.append("../common/emxForm.jsp?form=cenitEV6SAPBaseForm&mode=edit&submitAction=refreshCaller&objectId=")
    	 .append(strObjectId)
    	 .append("&preProcessJPO=SyncToSAPfromCOMMAND&postProcessJPO=0&formHeader=cenitCONNECT Integration for 3DEXPERIENCE&PrinterFriendly=false&renderPDF=false&Export=false&findMxLink=false");
%>
<script type="text/javascript">
<%
	if (UIUtil.isNotNullAndNotEmpty(strErrorMessage))
	{
%>
	alert("SAP Error : <%=strErrorMessage%>");
	top.close();
	<%} else {%>
window.parent.location.href="<%=sbURL.toString()%>";
<%}%>
//top.close();
</script>
</body>
</html>