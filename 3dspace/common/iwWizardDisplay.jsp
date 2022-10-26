<%--
  iwWizardDisplay.jsp

  Copyright (c) 2007 Integware, Inc.  All Rights Reserved.
  This program contains proprietary and trade secret information of
  Integware, Inc.
  Copyright notice is precautionary only and does not evidence any
  actual or intended publication of such program.

  $Rev: 673 $
  $Date: 2011-04-01 15:25:38 -0600 (Fri, 01 Apr 2011) $
--%>

<%@include file = "../common/emxNavigatorInclude.inc"%>
<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>

<%@ page import="matrix.db.*, matrix.util.*, com.matrixone.apps.domain.util.*" %>
<%@page import="com.dassault_systemes.enovia.lsa.Helper"%>

<%
String wizard = emxGetParameter(request, "wizard");
String stringResourceFileId = emxGetParameter(request, "StringResourceFileId");
String sSuiteKey = emxGetParameter(request, "suiteKey");
String sAppDirectory = Helper.getProperty(context, sSuiteKey + ".Directory");

Enumeration enumSession = session.getAttributeNames();
String[] emxTableRowId = null;
while (enumSession.hasMoreElements())
{
    String sessionAttrName = (String) enumSession.nextElement();
    if (sessionAttrName.equalsIgnoreCase("emxTableRowIdList"))
    {
        emxTableRowId = (String[])session.getAttribute("emxTableRowIdList");
        session.removeAttribute("emxTableRowIdList");
    }
}

Enumeration enumToken = request.getParameterNames();
String urlParams = "";
HashMap paramMap = new HashMap();
while (enumToken.hasMoreElements())
{
    String name  = (String) enumToken.nextElement();
    String value = request.getParameter(name);

    if (urlParams.equals("")) urlParams += "?";
    else urlParams += "&";

    urlParams += name + "=" + value;
    paramMap.put(name, value);
}
if(emxTableRowId != null) {
	paramMap.put("emxTableRowIdList", emxTableRowId);

} else {
	paramMap.put("emxTableRowIdList", "");
}
if (emxGetParameter(request, "complete")==null)
{
    if (urlParams.equals("")) urlParams += "?";
    else urlParams += "&";
    urlParams += "complete" + "=" + "javascript:getTopWindow().handleComplete('$<id>')";
}
if (emxGetParameter(request, "error")==null)
{
    if (urlParams.equals("")) urlParams += "?";
    else urlParams += "&";
    
    String errorJPOJSP = Helper.getI18NString(context,Helper.StringResource.LSA,"emxFramework.IWWizard.ErrorMsg.TargetJSPJPO");
    urlParams += "error" + "=" + "javascript:getTopWindow().handleError('" + errorJPOJSP + "')";
    errorJPOJSP.substring(1, 2);
}

paramMap.put("wizard", wizard);
String[] methodArgs = JPO.packArgs(paramMap);
String displayCode = (String)JPO.invoke(context, "iwWizard", null, "getWizardCode", methodArgs, String.class);
%>

<html>
<%@include file = "../common/emxFormConstantsInclude.inc"%>
<!-- XSSOK -->
<script type="text/javascript" src="../<%=sAppDirectory%>/scripts/iwWizardValidation.js"></script>
<!-- XSSOK -->
<script type="text/javascript" src="../<%=sAppDirectory%>/scripts/iwWizardValidation.jsp"></script>

<head>
<title></title>

<link rel="stylesheet" href="styles/iwWizard.css" type="text/css">
 <link rel="stylesheet" href="styles/emxUIDefault.css" type="text/css">
  <link rel="stylesheet" href="styles/emxUIToolbar.css" type="text/css">
  <link rel="stylesheet" href="styles/emxUIMenu.css" type="text/css"> 
  <link rel="stylesheet" href="styles/emxUIDialog.css" type="text/css"> 
  <link rel="stylesheet" href="styles/emxUIForm.css" type="text/css">

<script type="text/javascript">

</script>

</head>

<body onload="getTopWindow().hideDivs()">

  <iframe name="processingFrame" src="" width="0" height="0" frameborder="0"></iframe>

  <form name="formWizard" action="../common/iwExecute.jsp<%=urlParams%>" target="processingFrame" method="post">
    <input id="result" name="result" type="hidden" value=""/>
    <%
    if (emxTableRowId != null) {
        for (int i=0; i<emxTableRowId.length; i++) {
            %><input type="hidden" name="emxTableRowId" value="<%=emxTableRowId[i]%>"/><%
        }
    }
    %>
    <%= XSSUtil.encodeForJavaScript(context, displayCode) %>

  </form>

</body>

</html>
