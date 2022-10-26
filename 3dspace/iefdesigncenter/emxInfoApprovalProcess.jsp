<%--  emxInfoApprovalProcess.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoApprovalProcess.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$

  Name of the File : emxInfoApprovalProcess.jsp

  Description : The processing page of the Approval dialog.

--%>


<%@include file = "emxInfoCentralUtils.inc"%>
<%@ page import="com.matrixone.apps.domain.util.*" %>
<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>
<script language="JavaScript" src="../common/scripts/emxUIConstants.js"></script> <%--Required by emxUIActionbar.js below--%>
<script language="JavaScript" src="../common/scripts/emxUIActionbar.js" type="text/javascript"></script> <%--To show javascript error messages--%>

<%
    // Get the required parameters from the request object.
    // These are busObjId, from and to states, the action which can be approve, reject, or ignore,
    // and Comment for signature.

    // Make sure that user has reentered the password and verify it against the database
    String loginPassword = emxGetParameter(request, "loginpassword");
    String sBusId = (String) emxGetParameter(request, "objectId");
    String sFromStateName = (String) emxGetParameter(request, "fromState");
    String sToStateName = (String) emxGetParameter(request, "toState");
    String sApprovalAction = (String) emxGetParameter(request, "approvalAction");
    String sSigner = (String) emxGetParameter(request, "signer");
    String sSignComment = (String) emxGetParameter(request, "txtareaCmtApp");
    String sIsInCurrentState = emxGetParameter(request, "isInCurrentState");
    /***********************
    String sApprovalPasswordConfirmation = FrameworkUtil.i18nStringNow("emxIEFDesignCenter.Common.PasswordConfirmation", request.getHeader("Accept-Language"));
    ************************************/
    //Disabling password confirmation for signature approval,rejectiona and ignore
    String sApprovalPasswordConfirmation = "FALSE";

    if (sApprovalPasswordConfirmation != null
            && (!sApprovalPasswordConfirmation.equalsIgnoreCase("null"))
            && sApprovalPasswordConfirmation.equalsIgnoreCase("true")) {
        if ((loginPassword != null)
                && (!loginPassword.equalsIgnoreCase("null"))) {
            if (!loginPassword.equals(context.getPassword())) {
                String url = "emxInfoApprovalDialog.jsp?signatureName="
                        + sSigner + "&fromState=" + sFromStateName
                        + "&toState=" + sToStateName + "&isInCurrentState="
                        + sIsInCurrentState;

                 emxNavErrorObject.addMessage(FrameworkUtil.i18nStringNow("emxIEFDesignCenter.Common.InvalidPassword", request.getHeader("Accept-Language")));
              //  session.setAttribute("error.message", FrameworkUtil.i18nStringNow("emxIEFDesignCenter.Common.InvalidPassword", request.getHeader("Accept-Language")));
                %><jsp:forward page="<%=FrameworkUtil.encodeURLParamValues(url)%>" /><%
            }
        }
    }
%>


<%
    try {
			String sMQLError = "";

			sSignComment = sSignComment.replaceAll("\"", "\\\\\"");
			MQLCommand mqlCommand = new MQLCommand();

					mqlCommand.open(context);
			// Enable MQL notice change start 2/2/2004
			if(!mqlCommand.executeCommand(context, "escape $1 bus $2 $3 $4 $5 $6",sApprovalAction,sBusId,"signature",sSigner,"comment",sSignComment))
			 {
					sMQLError = mqlCommand.getError();
					sMQLError = sMQLError.trim();
					sMQLError = sMQLError.replace('\n',' ');
					sMQLError = sMQLError.replace('\r',' ');
			}

			//String strQueryResult = MqlUtil.mqlCommand(context, "escape $1 bus $2 $3 $4 $5 $6",sApprovalAction,sBusId,"signature",sSigner,"comment",sSignComment);

			mqlCommand.close(context);
			if(!("".equalsIgnoreCase(sMQLError)))
			{
			%>
                <script language="JavaScript">
				        //XSSOK
                        showError("<%=sMQLError%>");
                </script>
			<%
			}
         // Enable MQL notice change end 2/2/2004
    } catch (MatrixException me) {
        // ContextUtil.abortTransaction(context);
        if (me.toString() != null && (me.toString().trim()).length() > 0)
            emxNavErrorObject.addMessage(me.toString().trim());
        // Throw the exception again to stop any further processing
        // throw e;
    } catch (Exception ex) {
        // ContextUtil.abortTransaction(context);
        if (ex.toString() != null && (ex.toString().trim()).length() > 0)
            emxNavErrorObject.addMessage(ex.toString().trim());
        // Throw the exception again to stop any further processing
        // throw e;
    } finally {// /ContextUtil.commitTransaction(context);
    }
%>
<%@include file = "../common/emxNavigatorBottomErrorInclude.inc"%>
<script language=javascript>

function closeWindow()
{
	parent.window.opener.close();
	parent.window.close();
}

		//refresh the content page
	var contentFrame = findFrame(parent.window.opener.parent,"Lifecycle");;

	<%
	if(sApprovalAction!=null && sApprovalAction.equals("approve")){
	%>



		if(contentFrame != null)
		{
			contentFrame.location.href=contentFrame.location.href;
		}

	<%}%>

	parent.window.opener.location.href=parent.window.opener.location.href;

	if(contentFrame != null)
	{
		contentFrame.focus();
	}

	window.setTimeout("closeWindow()",1000);
	//Close signature report page



</script>
