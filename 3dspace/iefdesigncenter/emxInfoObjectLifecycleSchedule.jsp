<%--  emxInfoObjectLifecycleSchedule.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  emxInfoObjectLifecycleSchedule.jsp   -  This page creates the Business Object
  $Archive: /InfoCentral/src/infocentral/emxInfoObjectLifecycleSchedule.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$

--%>

<%--
 *
 * $History: emxInfoObjectLifecycleSchedule.jsp $
 * 
 ************************************************
 *
--%>

<%@include file="emxInfoCentralUtils.inc"%> 			<%--For context, request wrapper methods, i18n methods--%><!-- content begins here -->
<%@include file="../common/emxNavigatorTopErrorInclude.inc"%>
<script language="JavaScript" src="../common/scripts/emxUIConstants.js"></script> <%--Required by emxUIActionbar.js below--%>
<script language="JavaScript" src="../common/scripts/emxUIActionbar.js" type="text/javascript"></script> <%--To show javascript error messages--%>

<!-- content begins here -->

<%@include file = "../common/enoviaCSRFTokenValidation.inc"%>
<%!

    public String formatMessage(String msg)
    {

        StringTokenizer st = new StringTokenizer(msg, "\n");
        StringBuffer sbuf = new StringBuffer();

        while(st.hasMoreTokens())
        {
           String token =st.nextToken();

           if(token.indexOf("#")== -1)
           {
               sbuf.append(token);
               sbuf.append("\\n");

           }
           else
           {
               sbuf.append(token.substring(token.lastIndexOf(":")+1));
               sbuf.append("\\n");
           }
        }
        return sbuf.toString();
    }



%>
<%
	// get the request parameters.	
	String sObjectId		= emxGetParameter(request, "txtObjectId");
	String sDisplayStateName= emxGetParameter(request, "txtDisplayStateName");
	String sActualStateName	= emxGetParameter(request, "txtActualStateName");
	String sScheduledDate	= emxGetParameter(request, "txtScheduled");
	String sMQLError = "";
	
	try 
	{
		MQLCommand mqlcommand = new MQLCommand();
		mqlcommand.open(context);
                //Enable mql notice change start 2/2/2004  
		if(!mqlcommand.executeCommand(context, "modify businessobject $1 state $2 schedule $3",sObjectId,sActualStateName,sScheduledDate))
                {
			sMQLError = mqlcommand.getError();		
            sMQLError = sMQLError.trim();
            sMQLError = formatMessage(sMQLError);
		}
		mqlcommand.close(context);
		if(!("".equalsIgnoreCase(sMQLError)))
		{		
%>    
			<script language=javascript>
			       //XSSOK
				  showError("<framework:i18nScript localize='i18nId'>emxInfoCentral.Schedule.Error</framework:i18nScript> : <%=sMQLError%>");
			</script>
<%
		}
                //Enable mql notice change start 2/2/2004  
%>    
<%@include file= "../common/emxNavigatorBottomErrorInclude.inc"%> <!-- enable MQL notice change -->	    
			<script language=javascript>
				parent.window.close();
			</script>
<%
		
	} catch (MatrixException matrixException) {
	    String sError = matrixException.getMessage();
	    sError = sError.replace('\n',' ');
	    sError = sError.replace('\r',' ');
	    //Alert the user for any exception.
%>    
		<script language=javascript>
		      //XSSOK
			  showError("<framework:i18nScript localize='i18nId'>emxIEFDesignCenter.Schedule.Error</framework:i18nScript> : <%=sError%>");
			  parent.window.location = "emxInfoObjectLifecycleProcessScheduleFS.jsp?objectId=<%=XSSUtil.encodeForURL(context,sObjectId)%>&displaystatename=<%=XSSUtil.encodeForURL(context,sDisplayStateName)%>&actualstatename=<%=XSSUtil.encodeForURL(context,sActualStateName)%>";
		</script>
<%
	} // End of try-catch
%>
<!-- content ends here -->
