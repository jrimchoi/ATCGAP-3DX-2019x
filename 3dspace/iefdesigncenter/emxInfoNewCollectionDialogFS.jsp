<%--  emxInfoNewCollectionDialogFS.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoNewCollectionDialogFS.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$

--%>

<%--
 *
 * $History: emxInfoNewCollectionDialogFS.jsp $
 * 
 * *****************  Version 4  *****************
 * User: Gauravg      Date: 11/27/02   Time: 12:34p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 3  *****************
 * User: Mallikr      Date: 11/22/02   Time: 3:43p
 * Updated in $/InfoCentral/src/InfoCentral
 * code cleanup
 * 
 * *****************  Version 2  *****************
 * User: Priteshb     Date: 11/18/02   Time: 5:51p
 * Updated in $/InfoCentral/src/InfoCentral
 * help marker change
 * 
 * *****************  Version 1  *****************
 * User: Bhargava     Date: 9/27/02    Time: 11:54a
 * Created in $/InfoCentral/src/InfoCentral
 *
 * ***********************************************
 *
--%>

<%@include file="emxInfoCentralUtils.inc"%>

<title><framework:i18n localize="i18nId">emxIEFDesignCenter.Collection.NewCollection</framework:i18n></title>

<%
  framesetObject fs = new framesetObject();
  fs.setDirectory(appDirectory);
  fs.setStringResourceFile("emxIEFDesignCenterStringResource");


  String initSource = emxGetParameter(request,"initSource");
  if (initSource == null){
    initSource = "";
  }
  String jsTreeID = emxGetParameter(request,"jsTreeID");
  String suiteKey = emxGetParameter(request,"suiteKey");
  String ErrorMsg = emxGetParameter(request,"ErrorMsg");
  
  if(ErrorMsg != null && !"null".equals(ErrorMsg))
  {
 %>
	 <script language="JavaScript">
	 //XSSOK
	 alert("<%=ErrorMsg%>");
	 </script>
 <%
  }
  // ----------------- Do Not Edit Above ------------------------------

 // ----------------- Start:: Request Parameters ----------------------
  
  String setName = emxGetParameter(request,"setName");
  String startPage = emxGetParameter(request,"startPage");
  String[] objectId = emxGetParameterValues(request,"emxTableRowId");  
  //Get timeStamp to handle the list of object ids
  String timeStamp = Long.toString(System.currentTimeMillis());
  //Storing objectIds in session
  session.setAttribute("ObjectIds" + timeStamp, objectId);
  
  
 // ----------------- End:: Request Parameters -------------------------
 
 // ----------------- Start:: URL for the middle frame -----------------
 // Specify URL to come in middle of frameset
  StringBuffer contentUrl = new StringBuffer("emxInfoNewCollectionCreate.jsp");
  contentUrl.append("?suiteKey=" + suiteKey);
  contentUrl.append("&initSource=" + initSource);
  contentUrl.append("&jsTreeID=" + jsTreeID);
  contentUrl.append("&setName=" + setName);
  contentUrl.append("&startPage=" + startPage);
  contentUrl.append("&timeStamp=" + timeStamp);
  
  
   
 /*for(int index = 0; index<objectId.length;index++)
   {
    contentUrl.append("&objectId=" + objectId[index]);
   } 
  */   
  
  // ----------------- End:: URL for the middle frame -----------------
  
  // ------------------Page Header Token ------------------------------ 
  
  String PageHeading = "emxIEFDesignCenter.Collection.NewCollection";

  // ------------------Help Link ------------------------------ 
  String HelpMarker = "emxHelpInfoNewCollectionDialogFS";

  // ------------------farmeset call  ------------------------------ 
  fs.initFrameset(PageHeading,HelpMarker,contentUrl.toString(),false,true,false,false);

  // ------------------Start:: Buttons ------------------------------ 
  fs.createCommonLink("emxIEFDesignCenter.Button.Done",
                      "submitform()",
                      "role_GlobalUser",
                      false,
                      true,
                      "iefdesigncenter/images/emxUIButtonDone.gif",
                      false,
                      3);


  fs.createCommonLink("emxIEFDesignCenter.Button.Cancel",
                      "cancelCreate()",
                      "role_GlobalUser",
                      false,
                      true,
                      "iefdesigncenter/images/emxUIButtonCancel.gif",
                      false,
                      5);

 // ------------------End:: Buttons ------------------------------ 

  // ----------------- Do Not Edit Below ------------------------------

  fs.writePage(out);

%>
