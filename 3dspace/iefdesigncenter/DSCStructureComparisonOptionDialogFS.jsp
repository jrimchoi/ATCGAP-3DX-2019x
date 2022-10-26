<%--  DSCStructureComparisonOptionDialogFS.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>


<%@include file= "emxInfoCentralUtils.inc"%>
<%@ page import = "matrix.db.*,com.matrixone.MCADIntegration.uicomponents.util.*" %>
<%@ page import = "com.matrixone.apps.domain.util.CacheUtil"%>

<%
	framesetObject fs = new framesetObject();
	fs.setDirectory(appDirectory);

	// Add Parameters Below
	String objectId		= emxGetParameter(request, "objectId");
	//String strSelPartId	= emxGetParameter(request, "emxTableRowId");
	String strSelPartId = CacheUtil.getCacheString(context, "DECCompStructUsrSelOid");

	// Specify URL to come in middle of frameset
	StringBuffer contentURL = new StringBuffer("DSCStructureComparisonOptionDialog.jsp");

	// Add these parameters to each content URL, and any others the App needs
	contentURL.append("?structure1Id=");
	contentURL.append(objectId);
	contentURL.append("&structure2Id=");
	contentURL.append(strSelPartId);

	String amperStr = "&";
	String equalStr = "=";

	// Loop through parameters and pass on to summary page
	for(Enumeration names = emxGetParameterNames(request);names.hasMoreElements();)
	{
		String name		= (String) names.nextElement();
		String value	= emxGetParameter(request, name);

		contentURL.append(amperStr);
		contentURL.append(name);
		contentURL.append(equalStr);
		contentURL.append(value);
	}

	String pageHeading	= "emxIEFDesignCenter.CompareStructure.SelectOptions";
	String helpMarker	= "emxhelpdsccomparestructure";

	fs.setObjectId(objectId);
	fs.initFrameset(pageHeading, helpMarker, contentURL.toString(), false, true, false, false);
	fs.setStringResourceFile("emxIEFDesignCenterStringResource");
	fs.removeDialogWarning();

	String roleList ="role_GlobalUser";

	fs.createFooterLink("emxIEFDesignCenter.Common.Previous",
						"goBack()",
						roleList,
						false,
						true,
						"iefdesigncenter/images/emxUIButtonPrevious.gif",
						0);

	fs.createFooterLink("emxIEFDesignCenter.Common.Done",
					  "submit()",
					  roleList,
					  false,
					  true,
					  "iefdesigncenter/images/emxUIButtonDone.gif",
					  0);

	fs.createFooterLink("emxIEFDesignCenter.Common.Cancel",
					  "parent.window.close()",
					  roleList,
					  false,
					  true,
					  "iefdesigncenter/images/emxUIButtonCancel.gif",
					  0);

	fs.writePage(out);
%>
