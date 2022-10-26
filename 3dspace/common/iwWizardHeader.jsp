<%--
  iwWizardHeader.jsp

  Copyright (c) 2007 Integware, Inc.  All Rights Reserved.
  This program contains proprietary and trade secret information of
  Integware, Inc.
  Copyright notice is precautionary only and does not evidence any
  actual or intended publication of such program.

  $Rev: 802 $
  $Date: 2012-01-09 15:27:41 -0700 (Mon, 09 Jan 2012) $
--%>
<%@include file="../components/emxComponentsDesignTopInclude.inc"%>
<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>
<%@include file = "../emxUICommonHeaderBeginInclude.inc"%>
<%@page contentType="text/html; charset=UTF-8"%>

<%!
static private String i18nStringNow(final String sText,final String stringResource,final String sLanguage)throws Exception
{
   return (String)com.matrixone.apps.domain.util.ContextUtil.runInAnonymousContext(
      new com.matrixone.apps.domain.util.ContextUtil.Callable() {
      	public Object call(Context ctx) throws MatrixException {
              return EnoviaResourceBundle.getProperty(ctx, stringResource,ctx.getLocale(), sText);
              }});
}
%>
<%
String header = emxGetParameter(request, "header");
String stringResourceFileId = emxGetParameter(request, "StringResourceFileId");
header=i18nStringNow(header, stringResourceFileId, request.getHeader("Accept-Language"));
if (header == null) header = "";

String helpMarker = emxGetParameter(request, "HelpMarker");
if (helpMarker == null) helpMarker = "";

String suiteKey = emxGetParameter(request, "suiteKey");
String suiteDir = "";
String registeredSuite = suiteKey;
if ( suiteKey != null && suiteKey.startsWith("eServiceSuite") )
{
    registeredSuite = suiteKey.substring(13);
}
if ( (registeredSuite != null) && (registeredSuite.trim().length() > 0 ) )
{
        suiteDir = UINavigatorUtil.getRegisteredDirectory(context, registeredSuite);
}

String languageStr =  request.getHeader("Accept-Language");
String sHelpLanguage = emxGetParameter(request, "sHelpLanguage");
String required = emxGetParameter(request, "required");

%>

<html>

<head>
<title></title>
<%@include file = "../common/emxFormConstantsInclude.inc"%>

<link rel="stylesheet" href="styles/iwWizard.css" type="text/css">
 <link rel="stylesheet" href="styles/emxUIDefault.css" type="text/css">
  <link rel="stylesheet" href="styles/emxUIToolbar.css" type="text/css">
  <link rel="stylesheet" href="styles/emxUIMenu.css" type="text/css"> 
  <link rel="stylesheet" href="styles/emxUIDialog.css" type="text/css"> 
  <link rel="stylesheet" href="styles/emxUIDOMLayout.css" type="text/css">
  <link rel="stylesheet" href="styles/emxUIForm.css" type="text/css">
<link rel="stylesheet" href="styles/iwCommonStyles.css" type="text/css">
<script language="javascript" type="text/javascript" src="../common/scripts/emxNavigatorHelp.js"></script>
<script language="javascript" type="text/javascript" src="../common/scripts/emxUICore.js"></script>

</head>

<body class="header">
    <table border="0" cellspacing="2" cellpadding="0" width="95%" class="alignCenter">
    <tr><td>
      <table border="0" cellspacing="0" cellpadding="0" width="100%">
        <tr><td><img src="../common/images/utilSpacer.gif" width="1" height="10" alt=""></td></tr>
      </table>
      <table border="0" width="100%" cellspacing="1" cellpadding="2">
        <tr><td><span class="pageHeader"><%= header %></span>&nbsp;&nbsp;&nbsp;&nbsp;<img id="progressIcon" src="../common/images/utilProgressDialog.gif"></td></tr>
      </table>
      <table border="0" cellspacing="1" cellpadding="4" width="100%">
        <tr>
          <td class="alignLeft" width="20"><a href="javascript:openHelp('<%=helpMarker%>', '<%=suiteDir%>', '<%=sHelpLanguage%>', '', '', '<%=suiteKey%>')"><img src="../common/images/iconActionHelp.gif" alt="Help" border="0"></a></td><td class="reqdNotice" width="20">&nbsp;</td><td class="reqdNotice"><%= required %></td>
        </tr>
      </table>
    </td></tr>
    </table>
</body>

</html>
