<%--
  iwWizardFS.jsp

  Copyright (c) 2007 Integware, Inc.  All Rights Reserved.
  This program contains proprietary and trade secret information of
  Integware, Inc.
  Copyright notice is precautionary only and does not evidence any
  actual or intended publication of such program.

  $Rev: 851 $
  $Date: 2012-03-29 14:39:38 -0600 (Thu, 29 Mar 2012) $
--%>

<%@include file = "../common/emxNavigatorInclude.inc"%>
<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>
<%@page import="com.matrixone.apps.domain.util.EnoviaResourceBundle, com.matrixone.apps.domain.util.XSSUtil"%>

<%!
static private String getI18NString(final String sText,final String stringResource)throws Exception
{
   return (String)com.matrixone.apps.domain.util.ContextUtil.runInAnonymousContext(
      new com.matrixone.apps.domain.util.ContextUtil.Callable() {
      	public Object call(Context ctx) throws MatrixException {
              return XSSUtil.encodeForJavaScript(ctx, EnoviaResourceBundle.getProperty(ctx, stringResource, ctx.getLocale(), sText));
              }});
}
%>
<%!
static private String getProperty(final String sText)throws Exception
{
   return (String)com.matrixone.apps.domain.util.ContextUtil.runInAnonymousContext(
      new com.matrixone.apps.domain.util.ContextUtil.Callable() {
      	public Object call(Context ctx) throws MatrixException {
              return XSSUtil.encodeForJavaScript(ctx, EnoviaResourceBundle.getProperty(ctx, sText));
              }});
}
%>
<%
String header = emxGetParameter(request, "header");
String sCustValidation = emxGetParameter(request, "custWizValidation");
String sWizard = emxGetParameter(request, "wizard");
String sRegSuite = emxGetParameter(request, "registeredSuite");
langStr =  request.getHeader("Accept-Language");
String stringResourceFileId = emxGetParameter(request, "StringResourceFileId");

if (header == null) header = "";

if (sWizard == null ) {
    sWizard = "";
} else {
    sWizard = sWizard.replaceAll(" ", "");
}

String sSuiteKey = emxGetParameter(request, "suiteKey");
  if (sSuiteKey == null) {
      String errorSuiteKey = getI18NString("emxFramework.IWWizard.ErrorMsg.SuiteKey", stringResourceFileId);
    throw new FrameworkException(errorSuiteKey);
  }
String sAppDirectory = getProperty(sSuiteKey + ".Directory");

String sHelpLanguage = getI18NString( "emxFramework.HelpDirectory","emxFrameworkStringResource");
String required = getI18NString("emxFramework.Common.RedItalic","emxFrameworkStringResource");

Enumeration enumTokens = request.getParameterNames();
String urlParams = "";
int count = 0;
while (enumTokens.hasMoreElements())
{
    String name = (String) enumTokens.nextElement();
    if (name.equalsIgnoreCase("emxTableRowId")) {
        session.setAttribute("emxTableRowIdList",request.getParameterValues(name));
    } else {
        String value = request.getParameter(name);

        if (count == 0)
            urlParams += "?";
        else
            urlParams += "&";

    if(name.equalsIgnoreCase("header"))
      urlParams += "header=" + header;
    else
          urlParams += name + "=" + value;

        count++;

    }
}
urlParams += "&sHelpLanguage=" + sHelpLanguage + "&required=" + required;
%>

<html>

<head>

<link rel="stylesheet" href="styles/iwWizard.css" type="text/css">
 <link rel="stylesheet" href="styles/emxUIDefault.css" type="text/css">
  <link rel="stylesheet" href="styles/emxUIToolbar.css" type="text/css">
  <link rel="stylesheet" href="styles/emxUIMenu.css" type="text/css">
  <link rel="stylesheet" href="styles/emxUIDialog.css" type="text/css">
  <link rel="stylesheet" href="styles/emxUIDOMLayout.css" type="text/css">
  <link rel="stylesheet" href="styles/emxUIForm.css" type="text/css">
<!-- XSSOK -->
  <title> <%= getI18NString(header, stringResourceFileId)%> </title>
  <%@include file = "../common/emxFormConstantsInclude.inc"%>
  <script type="text/javascript" src="../common/scripts/emxNavigatorHelp.js"></script>
  <script type="text/javascript" src="../common/scripts/iwWizard.jsp"></script>
  <script type="text/javascript" src="../common/scripts/iwWizardValidation.js"></script>
  <!-- XSSOK -->
  <script type="text/javascript" src="../<%=sAppDirectory%>/scripts/iwWizardValidation.js"></script>
  <!-- XSSOK -->
  <script type="text/javascript" src="../<%=sAppDirectory%>/scripts/iwWizardValidation.jsp"></script>

  <script language="javascript">
    var sCustValidation = "<%=XSSUtil.encodeForJavaScript(context, sCustValidation)%>";
    var sWizardName = "<%=XSSUtil.encodeForJavaScript(context, sWizard)%>";
    function refreshFrame() {
        frames['wizardContent'].window.location.href = "iwWizardDisplay.jsp<%= XSSUtil.encodeForJavaScript(context, urlParams) %>"; //page of last frame to load
    }
  </script>

</head>

<body onLoad="refreshFrame();">
<div id='pageHeadDiv' >
  <iframe name='wizardHead' id='wizardHead' frameborder="0" src="iwWizardHeader.jsp<%= urlParams %>"></iframe>
</div>
<div id='divPageBody'>
  <iframe name='wizardContent' id='wizardContent' frameborder="0" src="blank.html"></iframe>
</div>
<div id='divPageFoot'>
  <iframe name='wizardFoot' id='wizardFoot' frameborder="0" src="iwWizardFooter.jsp"></iframe>
</div>
</body>



</html>

