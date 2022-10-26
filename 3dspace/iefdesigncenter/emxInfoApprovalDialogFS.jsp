<%--  emxInfoApprovalDialogFS.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/InfoCentral/emxInfoApprovalDialogFS.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$
  
  Name of the File : emxInfoApprovalDialogFS.jsp
  
  Description : FS page for Approval dialog
  

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
  String signName = emxGetParameter(request, "signatureName");
  String fromState = emxGetParameter(request, "fromState");
  String toState = emxGetParameter(request, "toState");
  String isInCurrentState = emxGetParameter(request, "isInCurrentState");

  // ----------------- Do Not Edit Above ------------------------------

  // Specify URL to come in middle of frameset
  String contentURL = "emxInfoApprovalDialog.jsp";

  // add these parameters to each content URL, and any others the App needs
  contentURL += "?suiteKey=" + suiteKey + "&initSource=" + initSource + "&jsTreeID=" + jsTreeID;
  contentURL += "&objectId=" + objectId;
  contentURL += "&signatureName=" + signName + "&fromState=" + fromState + "&toState=" + toState + "&isInCurrentState=" + isInCurrentState;


  // Page Heading - Internationalized
  String PageHeading = "emxIEFDesignCenter.Common.Approval";

  // Marker to pass into Help Pages
  // icon launches new window with help frameset inside
  String HelpMarker = "emxHelpInfoApprovalDialogFS";
  
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
  fs.createFooterLink("emxIEFDesignCenter.Button.Done",
                      "checkInput()",
                      roleList,
                      false,
                      true,
                      "iefdesigncenter/images/emxUIButtonDone.gif",
                      0);

                      
  fs.createFooterLink("emxIEFDesignCenter.Button.Cancel",
                      "closeApproveWindow()",
                      roleList,
                      false,
                      true,
                      "iefdesigncenter/images/emxUIButtonCancel.gif",
                      0);


  // ----------------- Do Not Edit Below ------------------------------

  fs.writePage(out);

%>

