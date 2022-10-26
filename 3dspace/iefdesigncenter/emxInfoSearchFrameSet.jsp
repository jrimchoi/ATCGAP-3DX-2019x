<%--  emxInfoSearchFrameSet.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/InfoCentral/emxInfoSearchFrameSet.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$


--%>

<%--
 *
 * $History: emxInfoSearchFrameSet.jsp $
 * 
 * *****************  Version 2  *****************
 * User: Mallikr      Date: 10/30/02   Time: 3:32p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 1  *****************
 * User: Mallikr      Date: 10/17/02   Time: 4:31p
 * Created in $/InfoCentral/src/InfoCentral
 *
 * ***********************************************
 *
--%>

<%@page import="java.io.*" %>
<%@page import="java.net.*" %>


<%@include file = "emxInfoCentralUtils.inc"%>
<%--@ page import="com.matrixone.apps.domain.util.FrameworkUtil"--%>

<%
	// ----------------- Do Not Edit Above ------------------------------

	String sActionBarName = request.getParameter("ActionBarName");

	String timestampvalue = emxGetParameter(request,"timestamp");
	if(timestampvalue == null || timestampvalue.equals("null") || timestampvalue.equals(""))
		timestampvalue ="";
	
	String timeStampParam = "?timeStamp=" + timestampvalue;


	// Search message - Internationalized
	String searchMessage = "emxIEFDesignCenter.Common.Search";

	// create a search frameset object
	searchFramesetObject fs = new searchFramesetObject();


	// Search Heading - Internationalized
	String searchHeading = "emxFramework.Suites.Display.InfoCentral";

	fs.setDirectory(appDirectory);
	fs.setStringResourceFile("emxIEFDesignCenterStringResource");
	//fs.setHelpMarker("emxhelpsearch");
	fs.setHelpMarker("emxHelpInfoPeopleSearchDialog");

try
{
	// Setup query limit
	//
	String sQueryLimit = getInfoCentralProperty(application,
											  session,
											  "eServiceInfoCentral",
											  "QueryLimit");
  
  
	if (sQueryLimit == null || sQueryLimit.equals("null") || sQueryLimit.equals(""))
		sQueryLimit = "";
	else {
		Integer integerLimit = new Integer(sQueryLimit);
		int intLimit = integerLimit.intValue();
		fs.setQueryLimit(intLimit);
	}
	// TODO!
	// Narrow this list and add access checking
	//
	String roleList = "role_GlobalUser";

%>

<jsp:include page = "emxInfoSearchActionLinks.jsp" flush="true">
    <jsp:param name="actionBarName" value="<%=XSSUtil.encodeForHTML(context,sActionBarName)%>"/>
    <jsp:param name="DisplayFrameType" value="Form"/>
</jsp:include>

<%

    Vector vectorLinks = (Vector)session.getValue("vectorLinks");
    session.removeValue("vectorLinks");

    //pass all  info to the links 
    StringBuffer sb= new StringBuffer(); 
    for(Enumeration enu=request.getParameterNames();enu.hasMoreElements();)
    {
        String paramName = (String)enu.nextElement();
        sb.append("&");
        sb.append(paramName);
        sb.append("=");
        sb.append(emxGetParameter(request,paramName));
    }

	//create the search links extracting the list from the vector

    for (int i = 0; i < vectorLinks.size(); i++)
    {
        String[] saValues = (String[])vectorLinks.elementAt(i);

		// first pass is default content page
		if (i == 0)
		  fs.initFrameset(searchMessage,saValues[1],searchHeading,false);

		if(saValues[0] == null)
			saValues[0] = "";
    
		fs.createSearchLink(saValues[0], java.net.URLEncoder.encode(saValues[1]+sb.toString()), roleList);
		     
    }

	// ----------------- Do Not Edit Below ------------------------------
 
	fs.writePage(out);
}
catch( Exception ex )
{
	//TBD: Log the message
}

%>

