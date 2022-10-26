<%--  emxInfoEditTableDialogFS.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--emxInfoAccessDialogFS.jsp - dialog for displaying emxInfoAccessDialog.jsp 

  $Archive: /InfoCentral/src/infocentral/emxInfoEditTableDialogFS.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$

--%>

<%--
 *
 * $History: emxInfoEditTableDialogFS.jsp $
 * 
 * *****************  Version 7  *****************
 * User: Rahulp       Date: 1/15/03    Time: 3:40p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * ***********************************************
 *
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">

<%@include file="emxInfoCentralUtils.inc"%> 			<%--For context, request wrapper methods, i18n methods--%>
<!-- content begins here -->
<%
	framesetObject fs = new framesetObject();
	fs.setDirectory(appDirectory);
// ----------------- Do Not Edit Above ------------------------------

	// Specify URL to come in middle of frameset
	String contentURL = "emxInfoEditTableDialog.jsp?" + emxGetQueryString(request);  

	// Marker to pass into Help Pages, icon launches new window with help frameset inside
	String HelpMarker = "emxInfoEditTableDialogFS";

	String roleList = "role_GlobalUser";

	//(String pageHeading,String helpMarker, String middleFrameURL, boolean UsePrinterFriendly, boolean IsDialogPage, boolean ShowPagination, boolean ShowConversion)
	fs.initFrameset("emxIEFDesignCenter.Common.EditAttribute",
				  "",
				  contentURL,
				  false,
				  true,
				  false,
				  false);

	fs.setStringResourceFile("emxIEFDesignCenterStringResource");

	//(String displayString,String href,String roleList, boolean popup, boolean isJavascript,String iconImage, int WindowSize (1 small - 5 large))
	fs.createFooterLink("emxIEFDesignCenter.Command.Done",
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
