<%--  DSCCompareStructureComparisonDetailsReportFS.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  DSCCompareStructureComparisonDetailsReportFS.jsp - Details Structure Compare Report frameset


--%>

<%@include file = "emxInfoCentralUtils.inc"%>

<%
	framesetObject fs = new framesetObject();

	fs.setDirectory(appDirectory);
	fs.removeDialogWarning();

	String initSource = emxGetParameter(request,"initSource");
	if (initSource == null)
		initSource = "";

	String jsTreeID = emxGetParameter(request, "jsTreeID");
	String suiteKey = emxGetParameter(request, "suiteKey");

	//Specify URL to come in middle of frameset
	StringBuffer contentURL = new StringBuffer("DSCCompareStructureComparisonDetailsReport.jsp");

	//Add these parameters to each content URL, and any others the App needs
	contentURL.append("?suiteKey=");
	contentURL.append(suiteKey);
	contentURL.append("&initSource=");
	contentURL.append(initSource);
	contentURL.append("&jsTreeID=");
	contentURL.append(jsTreeID);

	String amperStr = "&";
	String equalStr = "=";

	// Loop through parameters and pass on to summary page
	for(Enumeration names = emxGetParameterNames(request);names.hasMoreElements();)
	{
		String name		= (String)names.nextElement();
		String value	= emxGetParameter(request, name);

		contentURL.append(amperStr);
		contentURL.append(name);
		contentURL.append(equalStr);
		contentURL.append(value);
	}

	String pageHeading	= "emxIEFDesignCenter.CompareStructure.Details";
	String helpMarker	= "emxhelpdsccomparestructure";

	fs.initFrameset(pageHeading, helpMarker, contentURL.toString(), true, true, false, false);
	fs.setStringResourceFile("emxIEFDesignCenterStringResource");

	fs.createCommonLink("emxIEFDesignCenter.Common.Close",
						  "parent.window.close()",
						  "role_GlobalUser",
						  false,
						  true,
						  "iefdesigncenter/images/emxUIButtonCancel.gif",
						  false,
						  5);

	fs.writePage(out);
%>
