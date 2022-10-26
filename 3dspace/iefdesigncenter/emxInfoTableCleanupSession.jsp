<%--  emxInfoTableCleanupSession.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/InfoCentral/emxInfoTableCleanupSession.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$

--%>

<%--
 *
 * $History: emxInfoTableCleanupSession.jsp $
 * 
 * *****************  Version 6  *****************
 * User: Rahulp       Date: 11/14/02   Time: 1:34p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 5  *****************
 * User: Mallikr      Date: 10/31/02   Time: 5:16p
 * Updated in $/InfoCentral/src/InfoCentral
 * cleanup session 
 * 
 * *****************  Version 4  *****************
 * User: Rahulp       Date: 10/31/02   Time: 11:32a
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * ***********************************************
 *
--%>
<%@ page import = "com.matrixone.MCADIntegration.utils.*" %>
<%@include file = "../common/emxNavigatorInclude.inc"%>


<%
	//Cleanup the object list stored in session

	String timeStamp     = emxGetParameter(request, "timeStamp");
	String funcPageName  = emxGetParameter(request, "funcPageName");

    if (timeStamp != null && session.getAttribute("BusObjList" + timeStamp) != null)
	{
		session.removeAttribute("BusObjList" + timeStamp);
	}

    if (session.getAttribute("CurrentIndex" + timeStamp) != null)
	{
        session.removeAttribute("CurrentIndex" + timeStamp);
	}
	session.removeAttribute("ParameterList" + timeStamp);
    
%>

<script language="JavaScript">
    //XSSOK
    var funcPageName		= "<%=XSSUtil.encodeForJavaScript(context,funcPageName)%>";
	var versionsServerPage	= "<%=MCADGlobalConfigObject.PAGE_VERSIONS_SERVERSIDE%>";
	var versionsClientPage	= "<%=MCADGlobalConfigObject.PAGE_VERSIONS_CLIENTSIDE%>";

	if(funcPageName != null && funcPageName != "null" && funcPageName != "" && (funcPageName == versionsServerPage || funcPageName == versionsClientPage))
	{
		//Fix for PBN issue: 124158. This issue seems to be due to IE 7 problem. The fix can be removed if it is fixed in later IE version or patch.
		window.open('','_parent','');
	}
	window.close();
</script>
