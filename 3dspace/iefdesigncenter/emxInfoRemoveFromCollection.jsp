<%--  emxInfoRemoveFromCollection.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoRemoveFromCollection.jsp $
  $Revision: 1.3.1.4$
  $Author: ds-hmahajan$

 
--%>

<%--
 *
 * $History: emxInfoRemoveFromCollection.jsp $
 * 
 * *****************  Version 17  *****************
 * User: Snehalb      Date: 1/13/03    Time: 1:15p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 16  *****************
 * User: Rahulp       Date: 1/10/03    Time: 2:56p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 15  *****************
 * User: Gauravg      Date: 1/08/03    Time: 6:08p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 14  *****************
 * User: Rahulp       Date: 12/14/02   Time: 2:43a
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 13  *****************
 * User: Gauravg      Date: 11/29/02   Time: 11:00a
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 12  *****************
 * User: Sameeru      Date: 02/11/28   Time: 7:05p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 11  *****************
 * User: Gauravg      Date: 11/28/02   Time: 5:45p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 10  *****************
 * User: Gauravg      Date: 11/28/02   Time: 5:04p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 9  *****************
 * User: Sameeru      Date: 02/11/28   Time: 4:15p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 8  *****************
 * User: Mallikr      Date: 11/22/02   Time: 3:43p
 * Updated in $/InfoCentral/src/InfoCentral
 * code cleanup
 * 
 * *****************  Version 7  *****************
 * User: Gauravg      Date: 11/21/02   Time: 9:53p
 * Updated in $/InfoCentral/src/InfoCentral
 * Debugging for 500 http error
 * 
 * *****************  Version 6  *****************
 * User: Gauravg      Date: 11/14/02   Time: 7:05p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 5  *****************
 * User: Gauravg      Date: 11/14/02   Time: 3:28p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 4  *****************
 * User: Gauravg      Date: 11/08/02   Time: 1:29p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 3  *****************
 * User: Rahulp       Date: 10/31/02   Time: 11:32a
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 2  *****************
 * User: Bhargava     Date: 10/21/02   Time: 12:43p
 * Updated in $/InfoCentral/src/InfoCentral
 *
 * ***********************************************
 *
--%>

<%@include file="emxInfoCentralUtils.inc" %>

<%@ page import="java.net.*, matrix.db.*, matrix.util.*, com.matrixone.servlet.*,com.matrixone.apps.domain.util.SetUtil;"%>


<%-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --%>
<%-- PUBLIC VARIABLE DECLARATION SECTION --%>
<%-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --%>

<%
	
	String[] tableRowOID	= emxGetParameterValues(request, "emxTableRowId");
	String setName		    = emxGetParameter(request, "setName");
	StringList partOID      = new StringList(tableRowOID.length);
	
	for(int i=0; i< tableRowOID.length; i++)
	{
		String tableRowStr = tableRowOID[i];
		StringTokenizer tableRowStrTokens = new StringTokenizer(tableRowStr, "|");
		
		if(tableRowStrTokens.hasMoreTokens()) 
			partOID.add(tableRowStrTokens.nextToken());
	}	
%>

<%-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --%>
<%-- 	General Code Section --%>
<%-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --%>

<%
try
{
	String strSystemCollection = FrameworkProperties.getProperty(context, "emxFramework.ClipBoardCollection.Name");
	SetUtil.removeMembers(context, setName, partOID, false);
	
	long documentCount = SetUtil.getCount(context, setName);
	
	if(documentCount == 0 && !setName.equals(strSystemCollection))
		 SetUtil.delete(context, setName, false);

	if(documentCount >0)
	{
%>			
		<script language="javascript">
			parent.document.location.href = parent.document.location.href;
		</script>
<%
	}
	else
	{
%>
		<script language="javascript">
			top.window.close();
			top.opener.parent.location.href = "./IEFListCollections.jsp";
		</script>
<%
	}	
}
catch(Exception ex)
{
 ex.printStackTrace();
}

%>
