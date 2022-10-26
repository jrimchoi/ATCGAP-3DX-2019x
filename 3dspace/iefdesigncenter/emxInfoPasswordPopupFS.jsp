<%--  emxInfoPasswordPopupFS.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/InfoCentral/emxInfoPasswordPopupFS.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$
  
  Name of the File : emxInfoPasswordPopupFS.jsp
  
  Description :  FS page for password popup
  

--%>


<%@include file="emxInfoCentralUtils.inc"%>

<%
  //create new frameset object
  framesetObject fs = new framesetObject();

  fs.setDirectory(appDirectory);

  String initSource = emxGetParameter(request,"initSource");
  if (initSource == null){
		initSource = "";
	}
  String jsTreeID = emxGetParameter(request,"jsTreeID");
  String suiteKey = emxGetParameter(request,"suiteKey");
  String signName = emxGetParameter(request, "signatureName");
  String sFnName = emxGetParameter(request, "callbackFunctionName");


  // ----------------- Do Not Edit Above ------------------------------

  // Specify URL to come in middle of frameset
  String contentURL = "emxInfoPasswordPopup.jsp";

  // add these parameters to each content URL, and any others the App needs
  contentURL += "?suiteKey=" + suiteKey + "&initSource=" + initSource + "&jsTreeID=" + jsTreeID;
  contentURL += "&callbackFunctionName=" + sFnName;  

  // Marker to pass into Help Pages
  // icon launches new window with help frameset inside
  String HelpMarker = "emxHelpInfoPasswordPopupFS";
  
  //Access is applicable to global user
  String roleList = "role_GlobalUser";
  //Intializes frameset 
  fs.initFrameset("emxIEFDesignCenter.Common.VerifyPassword",
                  HelpMarker,
                  contentURL,
                  false,
                  true,
                  false,
                  false);
                  
  //Set string resource file
  fs.setStringResourceFile("emxIEFDesignCenterStringResource");                  
  
  //Create footer link
  fs.createFooterLink("emxIEFDesignCenter.Button.Done",
                      "returnDetails()",
                      roleList,
                      false,
                      true,
                      "iefdesigncenter/images/emxUIButtonDone.gif",
                      0);

  fs.writePage(out);

%>

