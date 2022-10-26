<%--  DSCReplaceSearchWizardFS.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%-- DSCCompareStructureWizardFS.jsp - This file constructs frameset to disply connect find dialog pages.

  
--%>

<%@include file= "emxInfoCentralUtils.inc"%>

<%
	String objectId				= emxGetParameter(request, "objectId");
	String timeStamp			= emxGetParameter(request, "timeStamp");
	String replacedObjectType	= emxGetParameter(request, "replacedObjectType");

	String searchPageHeader = "emxIEFDesignCenter.ReplaceObject.SearchObjects";
	String searchHeading	= "emxFramework.Suites.Display.IEF";

	if(timeStamp == null)
		timeStamp = "";

    searchFramesetObject fs = new searchFramesetObject();
	fs.setObjectId(objectId); 
    fs.setDirectory("iefdesigncenter");
    fs.setStringResourceFile("emxIEFDesignCenterStringResource");
    fs.setHelpMarker("emxHelpInfoObjectConnectWizard2FS");

    String queryLimit = getInfoCentralProperty(application, session, "eServiceInfoCentral", "QueryLimit"); 
    if(queryLimit!=null && !queryLimit.equals("null") && !queryLimit.equals(""))
    {
        Integer integerLimit	= new Integer(queryLimit);
        int intLimit			= integerLimit.intValue();

        fs.setQueryLimit(intLimit);
    }
      
    String roleList			= "role_GlobalUser";
	String contentURL		= "DSCReplaceSearchWizardDialog.jsp?objectId=" + objectId + "&timeStamp=" + timeStamp + "&replacedObjectType=" + replacedObjectType;
	String displayString	= "emxIEFDesignCenter.Common.Find";

	fs.initFrameset(searchPageHeader, contentURL, searchHeading, false);
	fs.createSearchLink(displayString, contentURL, roleList);




	//set the search footer page (required to fix a defect in the common search footer page) 
	fs.setSearchFooterPage("DSCReplaceSearchFooterPage.jsp?queryLimit=100&previousRequired=false");
 
    fs.writePage(out);
%>

