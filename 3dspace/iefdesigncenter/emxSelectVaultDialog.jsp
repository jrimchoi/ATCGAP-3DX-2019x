<%--  emxSelectVaultDialog.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxSelectVaultDialog.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$

--%>

<%--
 *
 * $History: emxSelectVaultDialog.jsp $
 * 
 * *****************  Version 5  *****************
 * User: Priteshb     Date: 12/11/02   Time: 4:03p
 * Updated in $/InfoCentral/src/infocentral
 * Changing Done button to Select
 * 
 * *****************  Version 4  *****************
 * User: Shashikantk  Date: 11/23/02   Time: 6:56p
 * Updated in $/InfoCentral/src/InfoCentral
 * Code cleanup
 * 
 * *****************  Version 3  *****************
 * User: Shashikantk  Date: 11/21/02   Time: 6:56p
 * Updated in $/InfoCentral/src/InfoCentral
 * Removed the space between <%@include file and '='.
 * ***********************************************
 *
--%>
<%@include file= "emxInfoCentralUtils.inc"%>
<!-- content begins here -->
<%
	framesetObject fs = new framesetObject();
	fs.setDirectory(appDirectory);
	// ----------------- Do Not Edit Above ------------------------------

	String initSource = emxGetParameter(request,"initSource");
	if (initSource == null){
	initSource = "";
	}
	String jsTreeID = emxGetParameter(request,"jsTreeID");
	String suiteKey = emxGetParameter(request,"suiteKey");

	// Specify URL to come in middle of frameset
	String contentURL = "emxSelectVaultDialogDisplay.jsp";

	// Page Heading - Internationalized
	String PageHeading = "emxIEFDesignCenter.Common.SelectVault";

	String roleList = "role_GlobalUser";

	// Marker to pass into Help Pages
	// icon launches new window with help frameset inside
	String HelpMarker = "emxHelpSelectVaultDialog";

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
