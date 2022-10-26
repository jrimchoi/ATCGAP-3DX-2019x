<%--  emxInfoNavigateCleanupSession.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoNavigateCleanupSession.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$

  Description: Cleaning up the session variables related to navigation

--%>

<%--
 *
 * $History: emxInfoNavigateCleanupSession.jsp $
 * 
 * *****************  Version 6  *****************
 * User: Shashikantk  Date: 2/07/03    Time: 8:02p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 5  *****************
 * User: Rahulp       Date: 1/15/03    Time: 3:40p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 4  *****************
 * User: Mallikr      Date: 10/31/02   Time: 4:21p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 3  *****************
 * User: Mallikr      Date: 10/30/02   Time: 12:09p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 2  *****************
 * User: Mallikr      Date: 10/24/02   Time: 11:37a
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 1  *****************
 * User: Mallikr      Date: 10/14/02   Time: 3:27p
 * Created in $/InfoCentral/src/InfoCentral
 *
 * ***********************************************
 *
--%>

<%@include file = "../common/emxNavigatorInclude.inc"%>

<%
	//Runtime objRuntime = Runtime.getRuntime ();
	

	//Cleanup the object lists stored in session
	String timeStamp = emxGetParameter(request, "TimeStamp");

	if (timeStamp != null && session.getValue("IEF_INFNavigateMap" + timeStamp) != null)
	{
		session.removeValue("IEF_INFNavigateMap" + timeStamp);
	}

	if (timeStamp != null && session.getValue("IEF_INFNavigateData" + timeStamp) != null)
	{
        session.removeValue("IEF_INFNavigateData" + timeStamp);
	}
	
	if (session.getValue("cueStyleMap") != null)
	{
        session.removeValue("cueStyleMap");
	}
	
	//call the garbage collector
	System.gc();
%>
<script language="JavaScript">
window.close();
</script>

