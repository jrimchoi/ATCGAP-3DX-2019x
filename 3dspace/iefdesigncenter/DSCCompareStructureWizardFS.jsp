<%--  DSCCompareStructureWizardFS.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  This file constructs frameset to disply connect find dialog pages.

--%>

<%@include file= "emxInfoCentralUtils.inc"%>

<%
	String objectId			= emxGetParameter(request, "objectId");
	String timeStamp		= emxGetParameter(request, "timeStamp");

	String searchPageHeader = "emxIEFDesignCenter.CompareStructure.SearchObjects";
	String searchHeading	= "emxFramework.Suites.Display.IEF";

	if(timeStamp == null)
		timeStamp = "";

    searchFramesetObject fs = new searchFramesetObject();
	fs.setObjectId(objectId);
	fs.setDirectory("iefdesigncenter");

    fs.setStringResourceFile("emxIEFDesignCenterStringResource");
    fs.setHelpMarker("emxhelpdsccomparestructure");

    String queryLimit = getInfoCentralProperty(application, session, "eServiceInfoCentral", "QueryLimit");
    if(queryLimit!=null && !queryLimit.equals("null") && !queryLimit.equals(""))
    {
        Integer integerLimit	= new Integer(queryLimit);
        int intLimit			= integerLimit.intValue();

        fs.setQueryLimit(intLimit);
    }

    String roleList			= "role_GlobalUser";
	String contentURL		= "DSCCompareStructureWizardDialog.jsp?objectId=" + objectId + "&timeStamp=" + timeStamp;
	String displayString	= "emxIEFDesignCenter.Common.Find";

	fs.initFrameset(searchPageHeader, contentURL, searchHeading, false);
	fs.createSearchLink(displayString, contentURL, roleList);

	//set the search footer page (required to fix a defect in the common search footer page)
	fs.setSearchFooterPage("DSCCompareStructureFooterPage.jsp?queryLimit=100&previousRequired=false");

    fs.writePage(out);
%>


