<%--  emxInfoObjectLifecycleSignatures.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  
  $Archive: /InfoCentral/src/infocentral/emxInfoObjectLifecycleSignatures.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$

  
  Description : The frame where the signatures of the business obj are displayed
                for the given states.

--%>

<%@include file = "emxInfoCentralUtils.inc"%>
<%@include file = "../emxUICommonHeaderBeginInclude.inc"%>
<%@ page import = "com.matrixone.apps.common.util.*"%>
<%@ page import = "com.matrixone.MCADIntegration.server.beans.MCADMxUtil"%>
<html>
<head>
<link rel="stylesheet" href="../integrations/styles/emxIEFCommonUI.css" type="text/css">
<script language="JavaScript" src="../integrations/scripts/IEFUIModal.js"></script>
</head>

<%
    // Get the Business Id and create a BusinessObject
    // Get the from and to States names.
    //
    String languageStr        = request.getHeader("Accept-Language");
    String sBusId             = emxGetParameter(request, "objectId");
    String sFromStateName     = emxGetParameter(request, "fromState");
    String sToStateName       = emxGetParameter(request, "toState");
    String sIsInCurrentState  = emxGetParameter(request, "isInCurrentState");
    String sTargetPage        = "FSGenericDetails.jsp";
    Boolean BIsInCurrentState = new Boolean(sIsInCurrentState);
    boolean isInCurrentState  = BIsInCurrentState.booleanValue();
    String sErrorMessage      = (String)request.getAttribute("errMsg");
    String sStatePolicyName   = null;

	BusinessObject busObject = new BusinessObject(sBusId);
    boolean isObjectValid = true;
    try 
    {
      busObject.open(context);
      sStatePolicyName = ((Policy)(busObject.getPolicy())).getName();
    }
    catch (Exception e) 
    {
      isObjectValid = false;
    }
    String sDisplayState = " : " 
        + i18nNow.getStateI18NString(sStatePolicyName,sFromStateName,languageStr);
%>

<%@include file = "../emxUICommonHeaderEndInclude.inc"%>

<%-- This is for header at top of page --%>

<table border="0" cellspacing="0" cellpadding="0" width="100%">
<tr>
<td class="pageBorder"><img src="../common/images/utilSpacer.gif" width="1" height="1" alt=""></td>
</tr>
</table>
<table border="0" width="100%" cellspacing="2" cellpadding="4">
<tr>
<td class="pageHeader" width="99%"><framework:i18n localize="i18nId">emxIEFDesignCenter.Common.Approvals</framework:i18n><%=XSSUtil.encodeForHTML(context,sDisplayState)%></td>
<td width="1%"><img src="../common/images/utilSpacer.gif" width="1" height="28" alt=""></td>
</tr>
</table>
  
<%
    try 
    {
        //Starts Database transaction  
        ContextUtil.startTransaction(context,false);

        if (isObjectValid) 
        {
            StateList stateList = busObject.getStates(context);
            StateItr stateItr = new StateItr(stateList);

            State toState = null;
            State fromState = null;
            State state = null;

            while (stateItr.next()) 
            {
                state = stateItr.obj();
                String stateName = state.getName();
                if (stateName.equalsIgnoreCase(sFromStateName)) 
                {
                  fromState = state;
                }
                if (stateName.equalsIgnoreCase(sToStateName)) 
                {
                  toState = state;
                }
            }
			// Check for signatures.
            SignatureList signatureList = busObject.getSignatures(context,fromState,toState);
			if (signatureList != null && signatureList.size() > 0) 
            {
				SignatureItr signatureItr = new SignatureItr(signatureList);
%>
        <table border="0" cellspacing="2" cellpadding="3" width="100%">
        <tr>
          <th align="left"><framework:i18n localize="i18nId">emxIEFDesignCenter.Common.Signature</framework:i18n></th>
          <th align="left"><framework:i18n localize="i18nId">emxIEFDesignCenter.Common.Signer</framework:i18n></th>
          <th align="left"><framework:i18n localize="i18nId">emxIEFDesignCenter.Common.Comments</framework:i18n></th>
          <th align="left"><framework:i18n localize="i18nId">emxIEFDesignCenter.Common.Response</framework:i18n></th>
        </tr>
<%
                // check if there was any error while processing the actions
                if((sErrorMessage != null)&&(!sErrorMessage.equalsIgnoreCase("null"))) 
                {
%>
          <tr>
            <td colspan="6">
              <font color=red><b><framework:i18n localize="i18nId"><xss:encodeForHTML><%=sErrorMessage%></xss:encodeForHTML></framework:i18n></b></font>
            </td>
<%
                }

                String nextURL = null;
                int iOddEvenApproval = 1;
                String sRowClassApproval = "";

                while (signatureItr.next()) 
                {
                    Signature signature = signatureItr.obj();
                    boolean boolDataFound = true;
                    String sSignStatus = "";

                    if (signature.isSigned()) 
                    {
                        if (signature.isApproved())
                            sSignStatus = i18nStringNow("emxIEFDesignCenter.Common.Approved", 
                                languageStr);
                        else if (signature.isIgnored())
                            sSignStatus = i18nStringNow("emxIEFDesignCenter.Common.Ignored", 
                                languageStr);
                        else if (signature.isRejected())
                            sSignStatus = i18nStringNow("emxIEFDesignCenter.Common.Rejected", 
                                languageStr);
                        else
                          sSignStatus = i18nStringNow("emxIEFDesignCenter.Common.Signed", 
                            languageStr);
                    }           

                    //Define display variables
                    String sSignName = signature.getName();
                    String sSigner = signature.getSigner();
                    String sSignDesc = signature.getComment();

                    sRowClassApproval = (iOddEvenApproval%2 == 0) ? "even" : "odd";
                    iOddEvenApproval++;

                    nextURL = "emxInfoApprovalDialogFS.jsp?objectId=" 
                        + sBusId + "&signatureName=" + sSignName;
                    nextURL += "&toState=" + sToStateName + "&fromState=" 
                        + sFromStateName + "&isInCurrentState=" + sIsInCurrentState;
	                nextURL = JSPUtil.encodeHref(request, nextURL);
%>
      <!--XSSOK-->
      <tr class="<%=sRowClassApproval%>">
        <td>
<%
                if (isInCurrentState)
                {
%>
          <!--XSSOK-->
          <a href="javascript:showIEFModalDialog('<%=nextURL%>',500,400,false)"><img border="0" src="../common/images/iconSmallSignature.gif" align="middle"></a>&nbsp;
          <!--XSSOK-->
          <a href="javascript:showIEFModalDialog('<%=nextURL%>',500,400,false)"><%= MCADMxUtil.getNLSName(context, "Role", sSignName, "", "", languageStr)%></a>
<%
                }
                else
                {
%>
          <img border="0" src="../common/images/iconSmallSignature.gif" align="middle"></a>&nbsp;
          <!--XSSOK-->
          <%=MCADMxUtil.getNLSName(context, "Role", sSignName, "", "", languageStr)%></a>
<%
                }
%>
        </td>
	<!--XSSOK-->
        <td><%=MCADMxUtil.getNLSName(context, "Person", sSigner, "", "", languageStr)%>&nbsp;</td>
        <!--XSSOK-->
        <td><%=sSignDesc%>&nbsp;</td>
	<!--XSSOK-->
        <td><%=sSignStatus%>&nbsp;</td>
      </tr>
<%
                } //End of while (signatureItr.next())
%>
        </table>
<%
            } // end of if (signatureList != null && signatureList.size() > 0) 
        } // end outer if (isObjectValid)

        ContextUtil.commitTransaction(context);
    }
    catch(Exception e) 
    {    
        ContextUtil.abortTransaction(context);
        String sErrorDetails = e.getMessage();
%>
<script language="JavaScript">
		showError("<%=XSSUtil.encodeForJavaScript(context,sErrorDetails)%>");
</script>
<%  	    
    }
    finally 
	{
	}
%>
<%@include file = "../emxUICommonEndOfPageInclude.inc" %>

</html>
