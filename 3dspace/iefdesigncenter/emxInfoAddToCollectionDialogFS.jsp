<%--  emxInfoAddToCollectionDialogFS.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoAddToCollectionDialogFS.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$


--%>

<%--
 *
 * $History: emxInfoAddToCollectionDialogFS.jsp $
 *
 * *****************  Version 8  *****************
 * User: Gauravg      Date: 11/27/02   Time: 12:34p
 * Updated in $/InfoCentral/src/infocentral
 *
 * *****************  Version 7  *****************
 * User: Mallikr      Date: 11/22/02   Time: 3:43p
 * Updated in $/InfoCentral/src/InfoCentral
 * code cleanup
 *
 * *****************  Version 6  *****************
 * User: Priteshb     Date: 11/18/02   Time: 5:12p
 * Updated in $/InfoCentral/src/InfoCentral
 * Help Marker change
 *
 * *****************  Version 5  *****************
 * User: Mallikr      Date: 10/30/02   Time: 3:32p
 * Updated in $/InfoCentral/src/InfoCentral
 *
 * *****************  Version 4  *****************
 * User: Bhargava     Date: 3/25/02    Time: 3:06p
 * Updated in $/InfoCentral/src/InfoCentral
 * removed emxTopUIInclude.jsp from the includes of this page ..this would
 * solve the method redifinition issue.
 *
 * *****************  Version 3  *****************
 * User: Bhargava     Date: 3/24/02    Time: 3:26p
 * Updated in $/InfoCentral/src/InfoCentral
 *
 * *****************  Version 2  *****************
 * User: Bhargava     Date: 10/21/02   Time: 7:09p
 * Updated in $/InfoCentral/src/InfoCentral
 *
 * *****************  Version 1  *****************
 * User: Bhargava     Date: 5/10/02    Time: 11:34a
 * Created in $/InfoCentral/src/InfoCentral
 *
 * ***********************************************
 *
--%>

<%@include file = "emxInfoCentralUtils.inc"%>

<title><framework:i18n localize="i18nId">emxIEFDesignCenter.Common.AddToCollection</framework:i18n></title>

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


	// ----------------- Do Not Edit Above ------------------------------

	// ----------------- Start:: Request Parameters ----------------------

	String setName = emxGetParameter(request,"setName");
	String startPage = emxGetParameter(request,"startPage");
	String[] objectId = emxGetParameterValues(request,"emxTableRowId");
	if(objectId==null)
		objectId = emxGetParameterValues(request,"emxTableRowId");
    //Get timeStamp to handle the list of object ids
	String timeStamp = emxGetParameter(request,"timeStamp");

    //Storing objectIds in session
    //session.setAttribute("ObjectIds" + timeStamp, objectId);


	// ----------------- End:: Request Parameters -------------------------

	// ----------------- Start:: URL for the middle frame -----------------
	// Specify URL to come in middle of frameset
	StringBuffer contentUrl  = null;

	contentUrl = new StringBuffer("emxInfoAddToCollectionDialog.jsp");
	contentUrl.append("?suiteKey=" + suiteKey);
	contentUrl.append("&initSource=" + initSource);
	contentUrl.append("&jsTreeID=" + jsTreeID);
	contentUrl.append("&setName=" + setName);
	contentUrl.append("&startPage=" + startPage);
	contentUrl.append("&timeStamp=" + timeStamp);

	System.out.println("contentUrl: "+contentUrl);

	/*for(int index = 0; index<objectId.length;index++)
	{
		contentUrl.append("&objectId=" + objectId[index]);
	}*/

	// ----------------- End:: URL for the middle frame -----------------
	String PageHeading = "emxIEFDesignCenter.Common.AddToCollection";
	// ------------------Page Header Token ------------------------------

	// ------------------Help Link ------------------------------
	String HelpMarker = "emxhelpdscnewcollection";

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
