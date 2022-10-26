<%--
  iwWizardFooter.jsp

  Copyright (c) 2007 Integware, Inc.  All Rights Reserved.
  This program contains proprietary and trade secret information of
  Integware, Inc.
  Copyright notice is precautionary only and does not evidence any
  actual or intended publication of such program.

  $Rev: 874 $
  $Date: 2012-06-29 12:36:46 -0600 (Fri, 29 Jun 2012) $
--%>

<%@include file = "../common/emxNavigatorInclude.inc"%>
<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>


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
langStr =  request.getHeader("Accept-Language");
%>

<html>
<%@include file = "../common/emxFormConstantsInclude.inc"%>

<head>
<title></title>

<link rel="stylesheet" href="styles/iwWizard.css" type="text/css">
 <link rel="stylesheet" href="styles/emxUIDefault.css" type="text/css">
  <link rel="stylesheet" href="styles/emxUIToolbar.css" type="text/css">
  <link rel="stylesheet" href="styles/emxUIMenu.css" type="text/css"> 
  <link rel="stylesheet" href="styles/emxUIDialog.css" type="text/css"> 
  <link rel="stylesheet" href="styles/emxUIDOMLayout.css" type="text/css">
  <link rel="stylesheet" href="styles/emxUIForm.css" type="text/css">
<link rel="stylesheet" href="styles/iwCommonStyle.css" type="text/css">

<script src="scripts/iwUIButton.js"></script>

</head>

<body class="footer">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
    <table border="0" cellspacing="0">
      <tr> 
        <td>
    <script>
        var btnBack = new Button("btnBack", "<%=i18nStringNow("LSACommonFramework.Button.Back", "LSACommonFrameworkStringResource", langStr)%>", "../common/images/buttonDialogPrevious.gif", "../common/images/buttonWizardPrevDisabled.gif", "top.wizBacktrack()");
		btnBack.disable();
    </script>
      </td>
      <td>&nbsp;&nbsp;</td>
      <td>
    <script>
        var btnNext = new Button("btnNext", "<%=i18nStringNow("LSACommonFramework.Button.Next", "LSACommonFrameworkStringResource", langStr)%>", "../common/images/buttonDialogNext.gif", "../common/images/buttonWizardNextDisabled.gif", "top.wizAdvance()");
		btnNext.disable();
    </script>
      </td>
      <td>&nbsp;&nbsp;</td>
      <td>
    <script>
        var btnDone = new Button("btnDone", "<%=i18nStringNow("LSACommonFramework.Button.Done", "LSACommonFrameworkStringResource", langStr)%>", "../common/images/buttonDialogDone.gif", "../common/images/buttonWizardDoneDisabled.gif", "top.wizFinish()");
		btnDone.disable();
    </script>
      </td>
      <td>&nbsp;&nbsp;</td>
      <td>
    <script>
        var btnCancel = new Button("btnCancel", "<%=i18nStringNow("LSACommonFramework.Button.Cancel", "LSACommonFrameworkStringResource", langStr)%>", "../common/images/buttonDialogCancel.gif", "./common/images/buttonDialogCancel.gif", "top.wizCancel()");
    </script>
      </td>
    </tr>
    </table>
   </td>
  </tr>
</table>
</body>
</html>
