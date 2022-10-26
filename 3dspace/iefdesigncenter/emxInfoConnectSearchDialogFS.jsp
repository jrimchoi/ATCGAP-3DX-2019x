<%--  emxInfoConnectSearchDialogFS.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%-- This file constructs frameset to disply connect find dialog pages.

 
  
  static const char RCSID[] = $Id: /ENODesignerCentral/CNext/webroot/iefdesigncenter/emxInfoConnectSearchDialogFS.jsp 1.3.1.3 Sat Apr 26 10:22:24 2008 GMT ds-mbalakrishnan Experimental$
--%>


<%@include file= "emxInfoCentralUtils.inc"%>



<%
// ----------------- Do Not Edit Above ------------------------------
    // Search message - Internationalized
    // rajeshg - changed for custom relationship addition- 01/09/04
	String sConnect = null;
	String searchPageHeader = "";

	sConnect = (String)session.getAttribute("DirectConnect");

	if( ( sConnect != null ) && ( !sConnect.equals("null") ) )
		searchPageHeader = "emxIEFDesignCenter.Common.ConnectDirectSearch";
	else
		searchPageHeader = "emxIEFDesignCenter.Common.ConnectSearch";
    // end
    // create a search frameset object
    searchFramesetObject fs =	 new searchFramesetObject();

    // Search Heading - Internationalized
    String searchHeading = "emxFramework.Suites.Display.IEF";
  
    fs.setDirectory(appDirectory);
    fs.setStringResourceFile("emxIEFDesignCenterStringResource");
    fs.setHelpMarker("emxHelpInfoObjectConnectWizard2FS");

    // Setup query limit
    //
    String sQueryLimit = getInfoCentralProperty(application,
                                                  session,
                                                  "eServiceInfoCentral",
                                                  "QueryLimit"); 
    if( ( sQueryLimit == null )
        || ( sQueryLimit.equals("null") )
        || ( sQueryLimit.equals("") ) )
        sQueryLimit = "";
    else 
    {
        Integer integerLimit = new Integer(sQueryLimit);
        int intLimit = integerLimit.intValue();
        fs.setQueryLimit(intLimit);
    }
      
    String roleList="role_GlobalUser";
    // Get list of searchLinks from properties
    //
    StringList searchLinks = getInfoCentralProperties(application, session, "eServiceInfoCentral", "ConnectSearchLinks");
    String linkEntry;
    String linkText;
    String displayString;
    String contentURL;

    // Populate left side of search dialog from properties    
    // rajeshg - changed for custom relationship addition- 01/09/04
	String objectId= "" ;
    String sObjType= "" ;
	String sRelName = "";
	String sRelDirection = "" ;

	if ( (sConnect == null) || (sConnect.equals("null")))
	{
	    sRelName = emxGetParameter(request,"sRelName");
		sRelDirection= emxGetParameter(request, "sRelDirection");
		objectId = emxGetParameter(request, "objectId");
		sObjType= emxGetParameter(request, "sObjType");
	}
	else
	{
	    sRelName = (String)request.getAttribute("sRelName");
		sRelDirection= (String)request.getAttribute("sRelDirection");
		objectId = (String)request.getAttribute("objectId");
		sObjType= (String)request.getAttribute("sObjType");
	}
	// end
	
//bug fix 277294[support linguistic character in Type] -start
Properties connectObjprop = new Properties();
if(sRelName != null)
	connectObjprop.setProperty("sRelName", sRelName );
connectObjprop.setProperty("sObjType", sObjType);
connectObjprop.setProperty("objectId", objectId);
connectObjprop.setProperty("sRelDirection", sRelDirection);
session.setAttribute("connectObjprop_KEY", connectObjprop );
//bug fix 277294[support linguistic character in Type] -end

	fs.setObjectId(objectId);  
	
    for (int i=0; i < searchLinks.size(); i++)
    {
        // Get the entry
        linkEntry = (String)searchLinks.get(i);
		if(linkEntry.equalsIgnoreCase("eServiceConnectSearchLinkFind"))
		{
			// Get the content URL
			contentURL = getInfoCentralProperty(application, session, linkEntry, "ContentPage");  
			String reqParam = com.matrixone.apps.domain.util.FrameworkUtil.encodeURL("sRelationName=" + sRelName
					+ "&objectId=" + objectId
					+ "&sObjType=" + sObjType
					+ "&sRelDirection=" + sRelDirection);

			if(contentURL.indexOf("?") == -1)
				contentURL += "?" + reqParam;
			else
				contentURL += "&" + reqParam;

			// Get string resource entry
			linkText = getInfoCentralProperty(application, session, linkEntry, "LinkText");
			
			// Link display - Internationalized
			displayString = linkText;

			// first pass is default content page
			if (i == 0)
				fs.initFrameset(searchPageHeader,contentURL,searchHeading,false);

			fs.createSearchLink(displayString, contentURL, roleList);
		}
    }

	//set the search footer page (required to fix a defect in the common search footer page) 
	fs.setSearchFooterPage("emxInfoConnectSearchFooterPage.jsp");
	
// ----------------- Do Not Edit Below ------------------------------
 
    fs.writePage(out);

	//set the search footer page back to the common one. This is required as the function is static function
	//and if this is not set in other centrals also our search footer page will be shown.
    fs.setSearchFooterPage("../common/emxUIGenericSearchFooterPage.jsp");
%>


