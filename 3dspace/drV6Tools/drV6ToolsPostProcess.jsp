<%--
  FullSearchUtil.jsp
  Copyright (c) 1993-2015 Dassault Systemes.
  All Rights Reserved.
  This program contains proprietary and trade secret information of
  Dassault Systemes.
  Copyright notice is precautionary only and does not evidence any actual
  or intended publication of such program
--%>

<%-- Common Includes --%>
<%@include file="../common/emxNavigatorTopErrorInclude.inc"%>
<%@include file="../common/emxCompCommonUtilAppInclude.inc"%>
<%@include file="../emxUICommonAppInclude.inc"%>

<%@page import="com.matrixone.apps.domain.DomainObject"%>
<%@page import="com.matrixone.apps.domain.DomainRelationship"%>
<%@page import="matrix.db.Context"%>
<%@include file="../common/enoviaCSRFTokenValidation.inc"%>
<script language="JavaScript" src="../common/scripts/emxUICore.js"
	type="text/javascript"></script>
<%
	String relName = emxGetParameter(request, "relName");
	String relId = emxGetParameter(request, "relId");
	String mode = emxGetParameter(request, "mode");
	String selectedRowId[] = request.getParameterValues("emxTableRowId");
	String selectedTriggerId = "";
	
	if (UIUtil.isNotNullAndNotEmpty(mode) && "connect".equalsIgnoreCase(mode)) {
		for (int triggerCtr = 0; triggerCtr < selectedRowId.length; triggerCtr++) {
			selectedTriggerId = selectedRowId[triggerCtr].split("[|]")[1];
			MqlUtil.mqlCommand(context,"add connection $1 fromrel $2 to $3",PropertyUtil.getSchemaProperty(context,relName),relId,selectedTriggerId); 
		}
	}
%>

<script language="javascript">
	getTopWindow().opener.location.href = getTopWindow().opener.location.href;
	getTopWindow().location.href = "../common/emxCloseWindow.jsp";
</script>

<%@include file="../common/emxNavigatorBottomErrorInclude.inc"%>
