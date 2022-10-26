<%@ include file = "../emxUICommonAppInclude.inc"%>
<%@ page errorPage = "emxNavigatorErrorPage.jsp"%>
<script language = "Javascript" src="../common/scripts/emxUIConstants.js"></script>
<%
String strKey = request.getParameter("drtoolsKey");
String strRowId[] = request.getParameterValues("emxTableRowId");
boolean bRequeue = false;
try {
	String [] splittedStrRowId = com.matrixone.apps.common.util.ComponentsUIUtil.getSplitTableRowIds(strRowId);
	String initargs[]    = {};
	HashMap params      = new HashMap();
	for (int i=0; i < strRowId.length ; i++) {
		String strObjId = splittedStrRowId[i];
		params.put("objectId", strObjId);
		bRequeue = JPO.invoke(context, "drV6ToolsJPO",initargs,"requeueObjects",JPO.packArgs (params),boolean.class);
	}
	if(bRequeue)
	{
%>
<script language="Javascript">
alert("Selected Queue objects set back to Waiting");
</script>
	
<%}
}
catch(Exception e)
{
	e.printStackTrace();
}

%>