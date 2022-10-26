<html>
<%@ page import = "matrix.db.*, matrix.util.* , com.matrixone.servlet.*, java.util.*,
                   java.io.BufferedReader, java.io.StringReader" %>

<%@include file = "../common/emxNavigatorInclude.inc"%>
<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>
<%@include file = "../common/eServiceUtil.inc"%>
<%@include file = "../common/emxFormUtil.inc"%>


<%
	response.setHeader("Content-Type", "text/html; charset=UTF-8");
    response.setContentType("text/html; charset=UTF-8");
	String strAuditName = "";
	String strAuditId = "";

	if (context != null)
	{

		String form = emxGetParameter(request, "form");
		
		 String strObjectId= emxGetParameter(request,"emxTableRowId");
		
		StringTokenizer strTokenizer = new StringTokenizer(strObjectId , "|");
		strAuditId = strTokenizer.nextToken() ;
		
		if(null != strAuditId && !"null".equals(strAuditId) && !"".equals(strAuditId))
		{
			DomainObject doAuditTemplate = new DomainObject(strAuditId);
			strAuditName = doAuditTemplate.getInfo(context, DomainConstants.SELECT_NAME);
		}
	}//if(context)
%>
<script language="javascript" src="../common/scripts/emxUIConstants.js"></script>
<script language=javascript>
var fieldAuditReaudit = getTopWindow().getWindowOpener().document.getElementById("Audit ReAudit");
fieldAuditReaudit.value = '<%=XSSUtil.encodeForJavaScript(context,strAuditId)%>';
var fieldAuditReaudit1 = getTopWindow().getWindowOpener().document.getElementById("N_Audit ReAudit");
fieldAuditReaudit1.value = '<%=XSSUtil.encodeForJavaScript(context,strAuditName)%>';
getTopWindow().window.closeWindow();
</script>
<%@include file = "../common/emxNavigatorBottomErrorInclude.inc"%>
</html>
