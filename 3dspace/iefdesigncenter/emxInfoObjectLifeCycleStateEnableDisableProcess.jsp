<%--  emxInfoObjectLifeCycleStateEnableDisableProcess.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoObjectLifeCycleStateEnableDisableProcess.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$

--%>

<%--

 *
 * $History: emxInfoObjectLifeCycleStateEnableDisableProcess.jsp $
 * 
 * ***********************************************
 *
--%>
<%@include file="emxInfoCentralUtils.inc"%> 			<%--For context, request wrapper methods, i18n methods--%><!-- content begins here -->
<%@include file="../common/emxNavigatorTopErrorInclude.inc"%>
<!-- content begins here -->

<%@include file = "../common/enoviaCSRFTokenValidation.inc"%>
<%
	// get the request parameters.	
	String sObjectId   = emxGetParameter(request, "sObjectId");
	String sStateNames = emxGetParameter(request, "selectedStateNames");
	String topActionbar = (String) emxGetParameter(request, "topActionbar");
	String header       = (String) emxGetParameter(request, "header");
	String helpMarker   = (String) emxGetParameter(request, "HelpMarker");
	String sCmd = emxGetParameter(request, "cmd");
	String sMQLError = "";
	String sErrorMsg = "";
	
	try {
        BusinessObject bo = new BusinessObject(sObjectId);
        bo.open(context);
		StringTokenizer stringtokenizer = new StringTokenizer(sStateNames, ",");
		MQLCommand mqlcommand = new MQLCommand();
		mqlcommand.open(context);		
		while(stringtokenizer.hasMoreTokens())
                {
			String sStateName = stringtokenizer.nextToken().toString().trim();        
                        //enable mql notice change start 2/2/2004
			if(!mqlcommand.executeCommand(context, "$1 businessobject $2 state $3",sCmd,sObjectId,sStateName))
                        {
				sErrorMsg =  mqlcommand.getError(); 
                                sErrorMsg = sErrorMsg.trim();
                                sErrorMsg = sErrorMsg.replace('\n',' ');
                                sErrorMsg = sErrorMsg.replace('\r',' ');
			}
                        if(!("".equalsIgnoreCase(sErrorMsg)))
                        {
                        %>
                                <script language="JavaScript">
								        //XSSOK
                                        alert("<%=sErrorMsg%>");
                                </script>
                        <%
                        }
                        //enable mql notice change end 2/2/2004  
		} 
	} catch (Exception ex) {
        if( ( ex.toString()!=null ) 
            && (ex.toString().trim()).length()>0 )
            emxNavErrorObject.addMessage(ex.toString().trim());
	}
%>
<%@include file= "../common/emxNavigatorBottomErrorInclude.inc"%> <!-- Added to enable MQL error/notice-->
<script>
  parent.window.close();
</script>

<!-- content ends here -->
