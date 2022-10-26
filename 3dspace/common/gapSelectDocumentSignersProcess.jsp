<%-- gapSelectDocumentSignersProcess.jsp - This file is for processing selected signers
	@author 	 : Mayuri Sangde (ENGMASA)
	@date   	 : 08-Apr-2019
	@description : This page displays document signers for selection
--%>
<%@page import="com.matrixone.apps.domain.util.PropertyUtil"%>
<%@page import="com.matrixone.apps.domain.DomainObject"%>
<%@page import="com.matrixone.apps.framework.ui.UIUtil"%>
<html>
<head></head>
<body>
<%@include file = "../common/emxNavigatorInclude.inc"%>
<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>
<script language="JavaScript" src="../common/scripts/emxUIConstants.js"></script>
<script type="text/javascript">
turnOnProgress();
</script>

<%
    String strChangeId  = emxGetParameter(request,"objectId");
	String strCurrentSelection = (String) emxGetParameter(request, "currentSel");
		//	System.out.println("strCurrentSelection processs>>>> "+strCurrentSelection);
	if (UIUtil.isNotNullAndNotEmpty(strCurrentSelection))
	{
		try
		{
			strCurrentSelection = strCurrentSelection.trim();
			DomainObject doObject = DomainObject.newInstance(context, strChangeId);
			doObject.setAttributeValue(context, PropertyUtil.getSchemaProperty(context, "attribute_gapSigners"), strCurrentSelection);
		}
		catch (Exception exp)
		{
			exp.printStackTrace();
			throw exp;
		}
	}
%>
<script type="text/javascript">
turnOffProgress();
parent.window.closeWindow();
</script>
</body></html>