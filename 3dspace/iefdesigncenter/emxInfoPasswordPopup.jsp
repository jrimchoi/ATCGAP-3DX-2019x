<%--  emxInfoPasswordPopup.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/InfoCentral/emxInfoPasswordPopup.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$
  
  Name of the File : emxInfoPasswordPopup.jsp
  
  Description : This page displays password dialog to user

--%>

<%@include file = "emxInfoCentralUtils.inc"%>
<%@include file = "../emxUICommonHeaderBeginInclude.inc"%>

<%
    String sFnName = emxGetParameter(request, "callbackFunctionName");
%>

<script language="JavaScript">

  //XSSOK
  var functionName = "<%=sFnName%>"
  // alert (functionName);
  function returnDetails() {
    parent.window.opener.loginpassword = document.passwordForm.loginpassword.value;
    eval("parent.window.opener." + functionName);
    parent.window.close();
  }

</script>

<% String sSubmit = FrameworkUtil.i18nStringNow("emxIEFDesignCenter.Button.Submit", request.getHeader("Accept-Language"));%>

<%@include file = "../emxUICommonHeaderEndInclude.inc"%>

<form name="passwordForm" action="javascript:returnDetails()">
<table border="0" cellpadding="3" cellspacing="2" width="100%">
  <tr>
    <td class="labelRequired"><framework:i18n localize="i18nId">emxIEFDesignCenter.Button.Password</framework:i18n></td>
    <td class="inputField"><input type="password" name="loginpassword"></td>
  </tr>
</table>

<input type="hidden" name="callbackFunctionName" value="<%=sFnName%>">
     
</form>

<%@include file = "../emxUICommonEndOfPageInclude.inc"%>

