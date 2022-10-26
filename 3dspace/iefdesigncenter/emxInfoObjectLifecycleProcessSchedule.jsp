<%--  emxInfoObjectLifecycleProcessSchedule.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  emxInfoObjectLifecycleProcessSchedule.jsp   - This Page Displays the details to schedult the process
  $Archive: /InfoCentral/src/infocentral/emxInfoObjectLifecycleProcessSchedule.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$

--%>

<%--
 *
 * $History: emxInfoObjectLifecycleProcessSchedule.jsp $
 * 
 ************************************************
 *
--%>

<%@include file="emxInfoCentralUtils.inc"%> 			<%--For context, request wrapper methods, i18n methods--%>
<%@include file="../emxTagLibInclude.inc"%>


<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>

<script language="JavaScript" src="emxInfoUIModal.js"></script> 
<script language="javascript" src="emxInfoCentralJavaScriptUtils.js"></script>
<script language="javascript" src="../common/scripts/emxJSValidationUtil.js"></script> <%--For calling trimWhitespace() to remove leading and trailing whitespace from a string--%>
<script language="JavaScript" type="text/javascript" src="../common/scripts/emxUICore.js"></script>

<link rel="stylesheet" href="../common/styles/emxUIDefault.css" type="text/css">
<link rel="stylesheet" href="../common/styles/emxUIList.css" type="text/css">
<link rel="stylesheet" href="../common/styles/emxUIForm.css" type="text/css">
<link rel="stylesheet" href="../common/styles/emxUIDialog.css" type="text/css" ><!--This is required for the cell (td) back ground colour-->
<link rel="stylesheet" href="../emxUITemp.css" type="text/css">

<!-- content begins here -->
<script language="JavaScript">
	//Submit the form
	function submit() {		
		document.tempForm.submit();					
	}
</script>

<%
	String sObjectId = emxGetParameter(request, "objectId");
	String sDisplayStateName = emxGetParameter(request, "displaystatename");
	String sActualStateName = emxGetParameter(request, "actualstatename");
	if(sActualStateName == null || "null".equalsIgnoreCase(sActualStateName))
		sActualStateName = sDisplayStateName;
	String sActualDate = "";
	String sScheduledDate = "";
	try {
		MQLCommand mqlcommand = new MQLCommand();
		mqlcommand.open(context);
		mqlcommand.executeCommand(context, "print bus $1 select $2 dump",sObjectId,"state[" + sActualStateName + "].actual");
		sActualDate = mqlcommand.getResult();
		if(sActualDate == null || ("null".equalsIgnoreCase(sActualDate)))
			sActualDate = "";
		else
			sActualDate = sActualDate.trim();
		
		mqlcommand.executeCommand(context, "print bus $1 select $2 dump",sObjectId,"state[" + sActualStateName + "].scheduled");
		sScheduledDate = mqlcommand.getResult();

		if(sScheduledDate == null || "null".equalsIgnoreCase(sScheduledDate))
			sScheduledDate = "";
		else
			sScheduledDate = sScheduledDate.trim();

		mqlcommand.close(context);
	} catch (MatrixException matrixException) {
		String sError = matrixException.getMessage();
		sError = sError.replace('\n','-');
		sError = sError.replace('\r','-');
		//Alert the user for any exception.
	}
%>
<body class="content">
<BR>
<center>
	<form name="tempForm" method="post" action="emxInfoObjectLifecycleSchedule.jsp" target=_parent id="idForm" onSubmit="return false">


<%
boolean csrfEnabled = ENOCsrfGuard.isCSRFEnabled(context);
if(csrfEnabled)
{
  Map csrfTokenMap = ENOCsrfGuard.getCSRFTokenMap(context, session);
  String csrfTokenName = (String)csrfTokenMap .get(ENOCsrfGuard.CSRF_TOKEN_NAME);
  String csrfTokenValue = (String)csrfTokenMap.get(csrfTokenName);
%>
  <!--XSSOK-->
  <input type="hidden" name= "<%=ENOCsrfGuard.CSRF_TOKEN_NAME%>" value="<%=csrfTokenName%>" />
  <!--XSSOK-->
  <input type="hidden" name= "<%=csrfTokenName%>" value="<%=csrfTokenValue%>" />
<%
}
//System.out.println("CSRFINJECTION");
%>

		<table border="0" cellpadding="5" cellspacing="2" width="100%">
		  <th><framework:i18n localize="i18nId">emxIEFDesignCenter.Common.ForState</framework:i18n> : <%=XSSUtil.encodeForHTML(context,sDisplayStateName)%> </th>
		</table>
		<table border="0" cellpadding="5" cellspacing="2" width="100%">		 
		<input type="hidden" name="txtObjectId" value="<xss:encodeForHTMLAttribute><%=sObjectId%></xss:encodeForHTMLAttribute>">
		<input type="hidden" name="txtDisplayStateName" value="<xss:encodeForHTMLAttribute><%=sDisplayStateName%></xss:encodeForHTMLAttribute>">		
		<input type="hidden" name="txtActualStateName" value="<xss:encodeForHTMLAttribute><%=sActualStateName%></xss:encodeForHTMLAttribute>">		
		  <tr>
			<td width="25%"  class="label"><framework:i18n localize="i18nId">emxIEFDesignCenter.Common.Scheduled</framework:i18n></td>
			<!--XSSOK-->
			<td class="field"><input type=text value="<%=sScheduledDate%>" size="42" name="txtScheduled" id="IdScheduled" onkeypress="javascript:if((event.keyCode == 13) || (event.keyCode == 10) || (event.which == 13) || (event.which == 10)) parent.frames[1].submit()">&nbsp;</td>
		  </tr>
		  <tr>
			<td class="label"><framework:i18n localize="i18nId">emxIEFDesignCenter.Common.Actual</framework:i18n></td>
			<!--XSSOK-->
			<td class="field"><input type=text READONLY onFocus="this.blur()" value="<%=sActualDate%>" size="42" name="txtActual" id="IdActual">&nbsp;
		  </tr>
		</table>
	</form>
</center>
</body>
<!-- content ends here -->
