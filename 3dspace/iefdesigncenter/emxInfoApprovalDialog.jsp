<%--  emxInfoApprovalDialog.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  
  $Archive: /InfoCentral/src/infocentral/emxInfoApprovalDialog.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$
  
  Name of the File : emxInfoApprovalDialog.jsp
  
  Description : This file displays dialog box for signature approval,rejection 
  and ignore. 

--%>

<%@include file = "emxInfoCentralUtils.inc"%>
<%@include file = "../emxUICommonHeaderBeginInclude.inc" %>
<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>
<%@include file = "../emxTagLibInclude.inc"%>

<%@ page import = "com.matrixone.MCADIntegration.server.beans.*,com.matrixone.apps.domain.*"%>



<%

  MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData)session.getAttribute("MCADIntegrationSessionDataObject");


  String jsTreeID         = emxGetParameter(request,"jsTreeID");
  String objectId         = emxGetParameter(request,"objectId");
  String initSource       = emxGetParameter(request,"initSource");
  String suiteKey         = emxGetParameter(request,"suiteKey");
  String sSigner          = emxGetParameter(request, "signatureName");
  String toState          = emxGetParameter(request, "toState");
  String fromState        = emxGetParameter(request, "fromState");
  String isInCurrentState = emxGetParameter(request, "isInCurrentState");
  /*****************************************************
  String sApprovalPasswordConfirmation =
  FrameworkUtil.i18nStringNow("emxIEFDesignCenter.Common.PasswordConfirmation", request.getHeader("Accept-Language"));
  ***********************/
  //Disabling password confirmation for signature approval,rejectiona and ignore
   String sApprovalPasswordConfirmation = "FALSE";
  
%>

<script language="JavaScript">
  var loginpassword = '';
  function checkInput() {
    var bSelected = false;

    for(var i=0 ; i < document.approvalForm.elements.length; i++)
    {
       var obj = document.approvalForm.elements[i];
       if(obj.type == "radio" && obj.checked == true)
       {
           bSelected = true;
           break;
       }
    }

    if(!bSelected)
    {
       var msg = "<%=i18nStringNow("emxIEFDesignCenter.Common.PleaseMakeASelection",
                                   request.getHeader("Accept-Language"))%>";
       alert(msg);
    }
    else
    {
<%
        if(sApprovalPasswordConfirmation.equalsIgnoreCase("TRUE") ){
%>
            var url = "emxInfoPasswordPopupFS.jsp?callbackFunctionName=passwordCallback()";
            var myWindow = window.open(url,"windowRef","width=300,height=300");
            if (!myWindow.opener)
             myWindow.opener = self;
<%
        }else{
%>
          document.approvalForm.submit();
<%
        }
%>
    }
  }

  function passwordCallback() {
    document.approvalForm.loginpassword.value=loginpassword;
    document.approvalForm.submit();
  }
  function closeApproveWindow()
  {
      parent.window.opener.close();
      parent.window.close();      
  }
</script>

<%@include file = "../emxUICommonHeaderEndInclude.inc" %>

<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>

<form name="approvalForm" method="post" action="emxInfoApprovalProcess.jsp">

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
//System.out.println("CSRFINJECTION::emxInfoApprovalDialog.jsp::form::approvalForm");
%>

<table border="0" cellpadding="3" cellspacing="2" width="100%">
  <tr>
    <td width="150" class="label"><framework:i18n localize="i18nId">emxIEFDesignCenter.Common.Approval</framework:i18n></td>
    <td class="inputField">
      <table border="0">
        <tr>
          <td><img alt="*" src="../common/images/iconSmallSignature.gif"></td>
          <td><span class="object"><%=MCADMxUtil.getNLSName(context, "Role", XSSUtil.encodeForHTML(context,sSigner), "", "", request.getHeader("Accept-Language")) %></span></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td width="150" class="label"><framework:i18n localize="i18nId">emxIEFDesignCenter.Common.Comments</framework:i18n></td>
    <td class="inputField"><textarea cols="25" rows="5" name="txtareaCmtApp" id=""></textarea></td>
  </tr>
  <tr>
    <td width="150" class="labelRequired"><framework:i18n localize="i18nId">emxIEFDesignCenter.Common.Action</framework:i18n></td>
    <td class="inputField">
      <table border="0">
        <tr>
          <td><input type="radio" name="approvalAction" id="" value="approve"><framework:i18n localize="i18nId">emxIEFDesignCenter.Button.Approve</framework:i18n></td>
        </tr>
        <tr>
          <td><input type="radio" name="approvalAction" id="" value="reject"><framework:i18n localize="i18nId">emxIEFDesignCenter.Button.Reject</framework:i18n></td>
        </tr>
        <tr>
          <td><input type="radio" name="approvalAction" id="" value="ignore"><framework:i18n localize="i18nId">emxIEFDesignCenter.Button.Ignore</framework:i18n></td>
        </tr>
      </table>
    </td>
    <input type="hidden" name="objectId" value="<xss:encodeForHTMLAttribute><%=objectId%></xss:encodeForHTMLAttribute>" />
    <input type="hidden" name="suiteKey" value="<xss:encodeForHTMLAttribute><%=suiteKey%></xss:encodeForHTMLAttribute>" >
    <input type="hidden" name="signer" value="<xss:encodeForHTMLAttribute><%=sSigner%></xss:encodeForHTMLAttribute>" >
    <input type="hidden" name="loginpassword" value="" >
    <input type="hidden" name="fromState" value="<xss:encodeForHTMLAttribute><%=fromState%></xss:encodeForHTMLAttribute>" >
    <input type="hidden" name="toState" value="<xss:encodeForHTMLAttribute><%=toState%></xss:encodeForHTMLAttribute>" >
    <input type="hidden" name="isInCurrentState" value="<xss:encodeForHTMLAttribute><%=isInCurrentState%></xss:encodeForHTMLAttribute>" >
  </tr>
</table>
</form>

<%@include file = "../common/emxNavigatorBottomErrorInclude.inc"%>
<%@include file = "../emxUICommonEndOfPageInclude.inc" %>
