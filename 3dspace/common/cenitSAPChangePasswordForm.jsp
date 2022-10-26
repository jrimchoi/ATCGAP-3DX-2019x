

<%@include file = "emxNavigatorInclude.inc"%>
<%@page import="matrix.db.MQLCommand"%>
<%@page import="matrix.util.MatrixException"%>

<html>
<%@include file = "emxNavigatorTopErrorInclude.inc"%>
<head>
<title>Change Password</title>
<%@include file = "emxUIConstantsInclude.inc"%>
<%@include file = "../emxStyleDefaultInclude.inc"%>
<%@include file = "../emxStyleDialogInclude.inc"%>

<script language="Javascript">
//function to validate user entry
function submitForm()
{
	turnOnProgress("utilProgressBlue.gif");
  document.frmCenitChangePass.target = 'pagehidden';
  document.frmCenitChangePass.submit();
}

	function doCancel() {
		getTopWindow().closeWindow();
	}
</script>
</head>
<script type="text/javascript">
    addStyleSheet("emxUIForm");
</script>
<body onload="turnOffProgress();" leftMargin="0" topMargin="0" MARGINHEIGHT="0" MARGINWIDTH="0" class="content">
<%
  String Pageresponse = emxGetParameter(request, "pageResponse");
%>
<form name="frmCenitChangePass" method="post" onsubmit="submitForm(); return false" action="cenitSAPChangePasswordProcess.jsp">
<%@include file = "../common/enoviaCSRFTokenInjection.inc"%>
<table width="95%" border="0" cellpadding="2" cellspacing="1">


 <%
    try
    {
    MQLCommand MQL = new MQLCommand();
	MQL.executeCommand(context, "print context select user dump");
	String user = MQL.getResult();
	MQL.executeCommand(context, "print bus Person "+user+ " - select  attribute[cenitSAPUser].value dump");
     
	String sapUser =  MQL.getResult();
	
	MQL.executeCommand(context, "print bus Person "+user+ " - select  attribute[cenitSAPPassword].value dump");
	String sapPassword =  MQL.getResult();
	
%>
<tr>
	<td>&nbsp;</td><td class="requiredNotice"><emxUtil:i18n localize="i18nId">emxFramework.Commom.RequiredText</emxUtil:i18n></td>
</tr>
  <tr>
    <td class="labelRequired"><b><emxUtil:i18n localize="i18nId">SAP User</emxUtil:i18n></b></td>
    <td class="inputField"><input type="text" name="txtUserName" value="<%=sapUser%>" size="30" /></td>
  </tr>
  <tr>
    <td class="labelRequired"><b><emxUtil:i18n localize="i18nId">SAP Password</emxUtil:i18n></b></td>
    <td class="inputField"><input type="password" name="txtCurrentPassword" size="30" /></td>
  </tr>
  
  
  <%
     
    }
    catch (Exception ex)
    {
       
    }
   
%>	
</form>

</body>
<%@include file = "emxNavigatorBottomErrorInclude.inc"%>
</html>
