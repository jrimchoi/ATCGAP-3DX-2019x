<%@page import="com.dassault_systemes.enovia.lsa.Helper"%>
<%@page import="com.dassault_systemes.enovia.lsa.EmxTableRowId"%>
<%@ page import = "matrix.db.*, matrix.util.* , com.matrixone.servlet.*, java.util.*,
java.io.BufferedReader, java.io.StringReader" %>


<%@include file = "../common/emxNavigatorInclude.inc"%>
<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>
<%@include file = "../common/eServiceUtil.inc"%>
<%@include file = "../common/emxFormUtil.inc"%>

<html>


<%
	response.setHeader("Content-Type", "text/html; charset=UTF-8");
    response.setContentType("text/html; charset=UTF-8");
	String strAuditorName = "";
	String strAuditorFormattedName = "";
	String strAuditorId = "";
	String strfieldName = "";
	if (context != null)
	{

		String form = emxGetParameter(request, "form");
		strAuditorId = emxGetParameter(request,"emxTableRowId");
		if(!Helper.isNullOrEmpty(strAuditorId)){
			EmxTableRowId emxTableRowId = new EmxTableRowId(strAuditorId);
			strAuditorId = emxTableRowId.getObjectId();	
		}
		

		strfieldName = emxGetParameter(request,"fieldName");

		if(null != strAuditorId && !"null".equals(strAuditorId) && !"".equals(strAuditorId))
		{
			DomainObject doAuditor = new DomainObject(strAuditorId);
			strAuditorName = doAuditor.getInfo(context, DomainConstants.SELECT_NAME);
			strAuditorFormattedName = PersonUtil.getFullName( context, strAuditorName );
		}
	}//if(context)
%>
<script language="javascript" src="../common/scripts/emxUIConstants.js"></script>
<script language="javascript" src="../common/scripts/emxUICore.js"></script>
<script language=javascript>
	var element = getTopWindow().getWindowOpener().window.document.getElementById('<%=XSSUtil.encodeForJavaScript(context,strfieldName)%>');
	var fieldname = element.name ; 
	element.value = '<%=XSSUtil.encodeForJavaScript(context,strAuditorName)%>';
	var elementDisplay = getTopWindow().getWindowOpener().window.document.getElementById('display_<%=XSSUtil.encodeForJavaScript(context,strfieldName)%>');
	elementDisplay.value = '<%=XSSUtil.encodeForJavaScript(context,strAuditorName)%>';
	if(fieldname == "Audit Lead Auditor" || fieldname == "Audit Resolution Assigned To" || fieldname == "Audit Responder" || fieldname == "Audit Verified By")
	{
		getTopWindow().window.getWindowOpener().addAuditorSingle('<%=XSSUtil.encodeForJavaScript(context,strfieldName)%>');
	}
	else
	{
		getTopWindow().window.getWindowOpener().addAuditorMultiple('<%=XSSUtil.encodeForJavaScript(context,strfieldName)%>');
		//	getTopWindow().getWindowOpener().window.getWindowOpener().addAuditorMultiple('<%=strfieldName%>');
	}
	parent.window.closeWindow();
</script>
</html>

