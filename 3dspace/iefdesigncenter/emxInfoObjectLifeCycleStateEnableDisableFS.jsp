<%--  emxInfoObjectLifeCycleStateEnableDisableFS.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoObjectLifeCycleStateEnableDisableFS.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$


--%>

<%--
 *
 * $History: emxInfoObjectLifeCycleStateEnableDisableFS.jsp $
 *
 * ***********************************************
 *
--%>
<%@include file= "emxInfoCentralUtils.inc"%>
<!-- content begins here -->
<%
	String sObjectId = emxGetParameter(request, "parentOID");
	framesetObject fs = new framesetObject();
	fs.setDirectory(appDirectory);
	fs.setObjectId(sObjectId);
	// ----------------- Do Not Edit Above ------------------------------

	String initSource = emxGetParameter(request,"initSource");
	if (initSource == null){
	initSource = "";
	}
	String jsTreeID = emxGetParameter(request,"jsTreeID");
	String suiteKey = emxGetParameter(request,"suiteKey");

	// Specify URL to come in middle of frameset
	String contentURL = "emxInfoObjectLifeCycleStateEnableDisable.jsp?" +emxGetQueryString(request);

	// Page Heading - Internationalized
	String sCmd = emxGetParameter(request, "cmd");
	String PageHeading = "emxIEFDesignCenter.Common."+sCmd;

	String roleList = "role_GlobalUser";

	// Marker to pass into Help Pages
	// icon launches new window with help frameset inside
	String HelpMarker = "";
	if(sCmd.equalsIgnoreCase("enable"))
		HelpMarker = "emxhelpdscenablestate";
	else if(sCmd.equalsIgnoreCase("disable"))
		HelpMarker = "emxhelpdscdisablestate";

	//(String pageHeading,String helpMarker, String middleFrameURL, boolean UsePrinterFriendly, boolean IsDialogPage, boolean ShowPagination, boolean ShowConversion)
	fs.initFrameset(PageHeading,HelpMarker,contentURL,false,true,false,false);

	fs.removeDialogWarning();

	fs.setStringResourceFile("emxIEFDesignCenterStringResource");

	//(String displayString,String href,String roleList, boolean popup, boolean isJavascript,String iconImage, int WindowSize (1 small - 5 large))
	fs.createFooterLink("emxIEFDesignCenter.Button.Select",
					  "submitForm()",
					  roleList,
					  false,
					  true,
					  "iefdesigncenter/images/emxUIButtonDone.gif",
					  5);

	fs.createFooterLink("emxIEFDesignCenter.Button.Cancel",
					  "parent.window.close()",
					  roleList,
					  false,
					  true,
					  "iefdesigncenter/images/emxUIButtonCancel.gif",
					  4);

	// ----------------- Do Not Edit Below ------------------------------
	fs.writeSelectPage(out);
%>
<!-- content ends here -->
