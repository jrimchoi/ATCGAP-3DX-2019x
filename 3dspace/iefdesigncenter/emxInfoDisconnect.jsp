<%--  emxInfoDisconnect.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoDisconnect.jsp $
  $Revision: 1.3.1.4$
  $Author: ds-kmahajan$

--%>

<%--
 *
 * $History: emxInfoDisconnect.jsp $
 * 
 * *****************  Version 13  *****************
 * User: Rahulp       Date: 12/09/02   Time: 5:37p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 12  *****************
 * User: Mallikr      Date: 11/26/02   Time: 2:35p
 * Updated in $/InfoCentral/src/InfoCentral
 * code review
 *
 * ***********************************************
 *
--%>

<%@include file= "emxInfoCentralUtils.inc"%>
<%@include file="../common/emxNavigatorTopErrorInclude.inc"%>
<script language="JavaScript" src="../common/scripts/emxUIConstants.js"></script> <%--To get findFrame() function and required by emxUIActionbar.js below--%>
<script language="JavaScript" src="../common/scripts/emxUIActionbar.js" type="text/javascript"></script>

<html>
<%
	//get the request parameters
	String objectId = emxGetParameter(request, "objectId");
	String IdList[] = emxGetParameterValues(request, "emxTableRowId");
	StringList exceptionList = new StringList();
	
	//get all the selected objects
	for(int index=0; index<IdList.length;index++)
	{
		String ids = IdList[index];
		String busId="";
		String relId="";
		StringTokenizer strTk = new StringTokenizer(ids,"|");
		int tokenIndex = 0;
		
		while(strTk.hasMoreTokens())
		{
			if(tokenIndex==1)
				busId = strTk.nextToken();
			else
			{
				if(tokenIndex==0)
					relId = strTk.nextToken();
				else
					strTk.nextToken();
			}
			tokenIndex++;
		}

		Relationship relObject = new Relationship(relId);
		
		//disconnect the objects
		try{
			ContextUtil.startTransaction(context, true);
			relObject.open(context);
			relObject.remove(context);
			relObject.close(context);
			ContextUtil.commitTransaction(context);
		}
		catch(Exception exception)
		{
			ContextUtil.abortTransaction(context);
			exceptionList.add(exception.toString().trim());
		}

	} //end for

for (int k =0 ;k<exceptionList.size();k++)
{
	 String exceptionMsg=((String)(exceptionList.get(k))).trim();
	 exceptionMsg = exceptionMsg.replace('\n',' ');
%>
   <script language="JavaScript">
                //XSSOK
				alert("<%=exceptionMsg%>");
	</script>		
<%
}
%>
<%@include file= "../common/emxNavigatorBottomErrorInclude.inc"%> <!-- Added to enable MQL error/notice-->

<script language="JavaScript">
		var sTargetFrame = findFrame(parent.window, "listHead");
		if(sTargetFrame)
		{
			sTargetFrame.document.tableHeaderForm.action = parent.location;
			sTargetFrame.document.tableHeaderForm.target = "detailsDisplay";
			sTargetFrame.document.tableHeaderForm.submit();
		}
	   parent.location.href=parent.location.href;
</script>  
