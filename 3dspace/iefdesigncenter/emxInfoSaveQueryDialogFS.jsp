<%--  emxInfoSaveQueryDialogFS.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoSaveQueryDialogFS.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$

--%>

<%--
 *
 * $History: emxInfoSaveQueryDialogFS.jsp $
 *
 * *****************  Version 9  *****************
 * User: Rahulp       Date: 12/03/02   Time: 6:23p
 * Updated in $/InfoCentral/src/infocentral
 *
 * *****************  Version 8  *****************
 * User: Rahulp       Date: 12/02/02   Time: 5:50p
 * Updated in $/InfoCentral/src/infocentral
 *
 * *****************  Version 7  *****************
 * User: Priteshb     Date: 11/18/02   Time: 5:17p
 * Updated in $/InfoCentral/src/InfoCentral
 * Help Marker change
 *
 * *****************  Version 6  *****************
 * User: Gauravg      Date: 11/14/02   Time: 1:44p
 * Updated in $/InfoCentral/src/InfoCentral
 *
 * *****************  Version 5  *****************
 * User: Gauravg      Date: 11/13/02   Time: 4:13p
 * Updated in $/InfoCentral/src/InfoCentral
 *
 * *****************  Version 4  *****************
 * User: Bhargava     Date: 10/17/02   Time: 5:42p
 * Updated in $/InfoCentral/src/InfoCentral
 *
 * *****************  Version 2  *****************
 * User: Bhargava     Date: 9/24/02    Time: 6:25p
 * Updated in $/InfoCentral/src/InfoCentral
 *
 * *****************  Version 1  *****************
 * User: Bhargava     Date: 9/24/02    Time: 6:02p
 * Created in $/InfoCentral/src/InfoCentral
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
  String objectId = emxGetParameter(request,"objectId");
  String queryType = emxGetParameter(request, "queryType"); // DSCINC 1200
  // ----------------- Do Not Edit Above ------------------------------
  // Specify URL to come in middle of frameset
  String contentURL = "emxInfoSaveQueryDialog.jsp";
  // add these parameters to each content URL, and any others the App needs
  // DSCINC 1200
  contentURL += "?suiteKey=" + suiteKey + "&initSource=" + initSource + "&jsTreeID=" + jsTreeID + "&objectId=" + objectId + "&queryType=" + queryType;
  // Page Heading - Internationalized
  String PageHeading = "emxIEFDesignCenter.Common.SaveQuery";
  String HelpMarker = "emxhelpdscsavequery";
  String roleList = "role_GlobalUser";
  //(String pageHeading,String helpMarker, String middleFrameURL, boolean UsePrinterFriendly, boolean IsDialogPage, boolean ShowPagination, boolean ShowConversion)
  fs.initFrameset(PageHeading,
                  HelpMarker,
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





