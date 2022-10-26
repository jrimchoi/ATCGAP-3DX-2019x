<%--  emxInfoRelationshipDetailsDialogFS.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoRelationshipDetailsDialogFS.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$


--%>

<%--
 *
 * $History: emxInfoRelationshipDetailsDialogFS.jsp $
 *
 * *****************  Version 9  *****************
 * User: Shashikantk  Date: 1/16/03    Time: 8:27p
 * Updated in $/InfoCentral/src/infocentral
 * Cue and Tip is applied
 *
 * *****************  Version 8  *****************
 * User: Rahulp       Date: 12/02/02   Time: 5:50p
 * Updated in $/InfoCentral/src/infocentral
 *
 * *****************  Version 7  *****************
 * User: Priteshb     Date: 11/18/02   Time: 5:18p
 * Updated in $/InfoCentral/src/InfoCentral
 * HelpMarker change
 *
 * *****************  Version 6  *****************
 * User: Mallikr      Date: 10/31/02   Time: 9:30p
 * Updated in $/InfoCentral/src/InfoCentral
 * correcting the include files
 *
 * *****************  Version 5  *****************
 * User: Rahulp       Date: 10/28/02   Time: 1:14p
 * Updated in $/InfoCentral/src/InfoCentral
 *
 * *****************  Version 4  *****************
 * User: Mallikr      Date: 10/25/02   Time: 8:06p
 * Updated in $/InfoCentral/src/InfoCentral
 *
 * ***********************************************
 *
--%>

<%@include file="emxInfoCentralUtils.inc"%>


<%
	framesetObject fs = new framesetObject();

	fs.setDirectory(appDirectory);

	String initSource = emxGetParameter(request,"initSource");
	if (initSource == null){
	initSource = "";
	}
	String jsTreeID = emxGetParameter(request,"jsTreeID");
	String suiteKey = emxGetParameter(request,"suiteKey");


	// ----------------- Do Not Edit Above ------------------------------

	// Add Parameters Below
	String objectId = emxGetParameter(request,"objectId");
	String relId = emxGetParameter(request,"relId");

	// Specify URL to come in middle of frameset
	String contentURL = "emxInfoRelationshipDetailsDialog.jsp";

	// add these parameters to each content URL, and any others the App needs
	//contentURL += "?suiteKey=" + suiteKey + "&initSource=" + initSource + "&jsTreeID=" + jsTreeID;
	//contentURL += "&objectId=" + objectId + "&relId=" + relId;

	contentURL += "?" + emxGetQueryString(request);
	// Page Heading - Internationalized
	String PageHeading = "emxIEFDesignCenter.Header.RelationshipDetails";

	// Marker to pass into Help Pages
	// icon launches new window with help frameset inside
	String HelpMarker = "emxhelpdscrelationshipdetails";
	//(String pageHeading,String helpMarker, String middleFrameURL, boolean UsePrinterFriendly, boolean IsDialogPage, boolean ShowPagination, boolean ShowConversion)
	fs.initFrameset(PageHeading,
					HelpMarker,
					contentURL,
					false,
					true,
					false,
					false);

	fs.setStringResourceFile("emxIEFDesignCenterStringResource");

	// Narrow this list and add access checking
	//
	String roleList = "role_GlobalUser";

	//(String displayString,String href,String roleList, boolean popup, boolean isJavascript,String iconImage, int WindowSize (1 small - 5 large))
	fs.createFooterLink("emxIEFDesignCenter.Common.Done",
						"doneMethod()",
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


	// ----------------- Do Not Edit Below ------------------------------

	fs.writePage(out);

%>






