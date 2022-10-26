<%--  emxInfoObjectLifecycleProcessScheduleFS.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  emxInfoObjectLifecycleProcessScheduleFS.jsp   -   FS page to schedule the process
$Archive: /InfoCentral/src/infocentral/emxInfoObjectLifecycleProcessScheduleFS.jsp $
$Revision: 1.3.1.3$
$Author: ds-mbalakrishnan$


--%>

<%--
*
* $History: emxInfoObjectLifecycleProcessScheduleFS.jsp $
* 
* ***********************************************
*
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">

<%@include file="emxInfoCentralUtils.inc"%> 			<%--For context, request wrapper methods, i18n methods--%>
<!-- content begins here -->
<%
	String sObjectId = emxGetParameter(request, "objectId");
	framesetObject fs = new framesetObject();
	fs.setDirectory(appDirectory);
	fs.setObjectId(sObjectId);

	// ----------------- Do Not Edit Above ------------------------------

	// Specify URL to come in middle of frameset
	String contentURL = "emxInfoObjectLifecycleProcessSchedule.jsp?"+emxGetQueryString(request);  

	// Marker to pass into Help Pages, icon launches new window with help frameset inside
	String HelpMarker = "emxInfoObjectLifecycleProcessScheduleFS";
	
	// Role based access
	String roleList = "role_GlobalUser";

	//(String pageHeading,String helpMarker, String middleFrameURL, boolean UsePrinterFriendly, boolean IsDialogPage, boolean ShowPagination, boolean ShowConversion)
	fs.initFrameset("emxIEFDesignCenter.Common.StateSchedule",
				  HelpMarker,
				  contentURL,
				  false,
				  true,
				  false,
				  false);

	fs.setStringResourceFile("emxIEFDesignCenterStringResource");

	//(String displayString,String href,String roleList, boolean popup, boolean isJavascript,String iconImage, int WindowSize (1 small - 5 large))
	fs.createFooterLink("emxIEFDesignCenter.Common.Done",
					"submit()",
					roleList,
					false,
					true,
					"iefdesigncenter/images/emxUIButtonDone.gif",
					0);

	fs.createFooterLink("emxIEFDesignCenter.Command.Cancel",
					"parent.window.close()",
					roleList,
					false,
					true,
					"iefdesigncenter/images/emxUIButtonCancel.gif",
					0);

	// ----------------- Do Not Edit Below ------------------------------
	
	fs.writePage(out);
%>
<!-- content ends here -->
