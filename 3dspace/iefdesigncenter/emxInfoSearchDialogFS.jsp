<%--  emxInfoSearchDialogFS.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoSearchDialogFS.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$

--%>

<%--
 *
 * $History: emxInfoSearchDialogFS.jsp $
 ******************  Version 48  *****************
 * User: Rajesh G  Date: 02/15/04    Time: 3:39p
 * Updated in $/InfoCentral/src/infocentral
 * To enable the esc key and key board support
 * 
 * *****************  Version 16  *****************
 * User: Rahulp       Date: 4/02/03    Time: 12:45
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 15  *****************
 * User: Snehalb      Date: 12/13/02   Time: 2:55p
 * Updated in $/InfoCentral/src/infocentral
 * passing help marker as request parameter to pages ahead
 * 
 * *****************  Version 14  *****************
 * User: Sameeru      Date: 02/11/26   Time: 1:11p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 13  *****************
 * User: Mallikr      Date: 11/26/02   Time: 12:41p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 12  *****************
 * User: Mallikr      Date: 11/22/02   Time: 8:32p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 11  *****************
 * User: Sameeru      Date: 02/11/15   Time: 5:19p
 * Updated in $/InfoCentral/src/InfoCentral
 * Correcting Header
 * 
 * ***********************************************
 *
--%>

<script language="JavaScript">
	//-- 02/15/2004         Start rajeshg   -->	
	//Function to check key pressed
	function cptKey(e) 
	{
		var pressedKey = ("undefined" == typeof (e)) ? event.keyCode : e.keyCode ;
		// for disabling backspace
		if (((pressedKey == 8) ||((pressedKey == 37) && (event.altKey)) || ((pressedKey == 39) && (event.altKey))) &&((event.srcElement.form == null) || (event.srcElement.isTextEdit == false)))
			return false;
		if( (pressedKey == 37 && event.altKey) || (pressedKey == 39 && event.altKey) && (event.srcElement.form == null || event.srcElement.isTextEdit == false))
			return false;

		if (pressedKey == "27") 
		{ 
			// ASCII code of the ESC key
			top.window.close();
		}
	}
	document.onkeypress = cptKey ;
	//-- 02/15/2004         End  rajeshg   -->

</script>
<%@include file= "emxInfoCentralUtils.inc"%>

<%
  // ----------------- Do Not Edit Above ------------------------------
  String sHelpMarker = emxGetParameter(request, "HelpMarker");

  String timestampvalue = emxGetParameter(request,"timestamp");
  if(timestampvalue == null || timestampvalue.equals("null") || timestampvalue.equals(""))
	timestampvalue ="";

  String timeStampParam = "?timeStamp=" + timestampvalue;
  String timeStampParamForSavedQueries = "&timeStampAdvancedSearch=" + timestampvalue;

  String suiteKey = "IEFDesignCenter";

  // Search message - Internationalized
  String searchMessage = "emxIEFDesignCenter.Common.Search";

  // create a search frameset object
  searchFramesetObject fs = new searchFramesetObject();


  // Search Heading - Internationalized
  String searchHeading = "emxFramework.Suites.Display.IEF";

  fs.setDirectory(appDirectory);
  fs.setStringResourceFile("emxIEFDesignCenterStringResource");
  fs.setHelpMarker( sHelpMarker );

  // Setup query limit
  //
  String sQueryLimit = getInfoCentralProperty(application,
                                                  session,
                                                  "eServiceInfoCentral",
                                                  "QueryLimit");
  
  
  if (sQueryLimit == null || sQueryLimit.equals("null") || sQueryLimit.equals(""))
    sQueryLimit = "";
  else {
    Integer integerLimit = new Integer(sQueryLimit);
    int intLimit = integerLimit.intValue();
    fs.setQueryLimit(intLimit);
  }
  
  //
  String roleList = "role_GlobalUser";


  // Get list of searchLinks from properties
  //
  StringList searchLinks = getInfoCentralProperties(application, session, "eServiceInfoCentral", "SearchLinks");
  String linkEntry;
  String linkText;
  String displayString;
  String contentURL;

  // Populate left side of search dialog from properties
  //
try
{
  for (int i=0; i < searchLinks.size(); i++)
  {
    // Get the entry
    linkEntry = (String)searchLinks.get(i);
    // Get the content URL
    contentURL = getInfoCentralProperty(application, session, linkEntry, "ContentPage");
    // Get string resource entry
    linkText = getInfoCentralProperty(application, session, linkEntry, "LinkText");

    // Link display - Internationalized
    displayString = linkText;

    if(linkText.equalsIgnoreCase("emxIEFDesignCenter.Common.SavedQueries"))
    {
	  contentURL+=timeStampParamForSavedQueries;
    }
    else{
      contentURL+=timeStampParam + "&suiteKey=" +suiteKey  ;
    }

    contentURL+="&HelpMarker=" + sHelpMarker;

    // first pass is default content page
    if (i == 0)
      fs.initFrameset(searchMessage,contentURL,searchHeading,false);

    fs.createSearchLink(displayString, java.net.URLEncoder.encode(contentURL), roleList);

  }
}
catch( Exception ex)
{
	//Log the message ??
	System.out.println("Exception occured while retrieving the search links:" + ex.toString());
}
	//set the search footer page (required to fix a defect in the common search footer page) 
	fs.setSearchFooterPage("emxInfoSearchFooterPage.jsp");

	// ----------------- Do Not Edit Below ------------------------------
 
	fs.writePage(out);

	//set the search footer page back to the common one. This is required as the function is static function
	//and if this is not set in other centrals also our search footer page will be shown.
	fs.setSearchFooterPage("../common/emxUIGenericSearchFooterPage.jsp");

%>


