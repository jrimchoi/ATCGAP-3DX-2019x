<%--  emxSelectPolicyDialog.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxSelectPolicyDialog.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$


--%>

<%--
 *
 * $History: emxSelectPolicyDialog.jsp $
 * 
 * *****************  Version 6  *****************
 * User: Snehalb      Date: 1/13/03    Time: 9:39p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 5  *****************
 * User: Shashikantk  Date: 12/11/02   Time: 7:02p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 4  *****************
 * User: Shashikantk  Date: 11/23/02   Time: 6:56p
 * Updated in $/InfoCentral/src/InfoCentral
 * Code cleanup
 * 
 * *****************  Version 3  *****************
 * User: Shashikantk  Date: 11/21/02   Time: 6:56p
 * Updated in $/InfoCentral/src/InfoCentral
 * Removed the space between "include file" and '='.
 * 
 * ***********************************************
 *
--%>
<%@include file= "emxInfoCentralUtils.inc"%>
<!-- content begins here -->
<%
  framesetObject fs = new framesetObject();
  fs.setDirectory(appDirectory);
// ----------------- Do Not Edit Above ------------------------------
  
  //String appendParams = request.getQueryString();
    String sType= emxGetParameter(request,"sType");
    String sVault=emxGetParameter(request,"sVault");

  // Specify URL to come in middle of frameset
  //String contentURL = "emxSelectPolicyDialogDisplay.jsp?" + appendParams;
  String contentURL = "emxSelectPolicyDialogDisplay.jsp?";
  contentURL += "sType=" + sType + "&sVault=" + sVault;

  // Page Heading - Internationalized
  String PageHeading = "emxIEFDesignCenter.Common.SelectPolicy";
  
  String roleList = "role_GlobalUser";

  // Marker to pass into Help Pages
  // icon launches new window with help frameset inside
  String HelpMarker = "emxHelpSelectPolicyDialog";

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
