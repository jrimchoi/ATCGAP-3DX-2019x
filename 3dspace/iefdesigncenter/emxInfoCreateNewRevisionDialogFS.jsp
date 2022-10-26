<%--  emxInfoCreateNewRevisionDialogFS.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/InfoCentral/emxInfoCreateNewRevisionDialogFS.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$


--%>

<%--
 *
 * $History: emxInfoCreateNewRevisionDialogFS.jsp $
 *
 * *****************  Version 8  *****************
 * User: Mallikr      Date: 11/22/02   Time: 5:57p
 * Updated in $/InfoCentral/src/InfoCentral
 * changed headers and added previous button
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
  String objectId = emxGetParameter(request,"parentOID");

  // Specify URL to come in middle of frameset
  String contentURL = "emxInfoCreateNewRevisionDialog.jsp";

  // add these parameters to each content URL, and any others the App needs
  contentURL += "?suiteKey=" + suiteKey + "&initSource=" + initSource + "&jsTreeID=" + jsTreeID;
  contentURL += "&objectId=" + objectId;

  // Page Heading - Internationalized
  String PageHeading = "emxIEFDesignCenter.Revision.CreateNewRevisionStep1";

  // Marker to pass into Help Pages
  // icon launches new window with help frameset inside
  String HelpMarker = "emxhelpcreaterevision";

  //(String pageHeading,String helpMarker, String middleFrameURL, boolean UsePrinterFriendly, boolean IsDialogPage, boolean ShowPagination, boolean ShowConversion)
  fs.initFrameset(PageHeading,
                  HelpMarker,
                  contentURL,
                  false,
                  true,
                  false,
                  false);

  fs.setStringResourceFile("emxIEFDesignCenterStringResource");

  // TODO!
  // Narrow this list and add access checking
  //
  String roleList = "role_GlobalUser";

  //(String displayString,String href,String roleList, boolean popup, boolean isJavascript,String iconImage, int WindowSize (1 small - 5 large))
  fs.createFooterLink("emxIEFDesignCenter.Common.Next",
                      "next()",
                      roleList,
                      false,
                      true,
                      "iefdesigncenter/images/emxUIButtonNext.gif",
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






