<%--  emxInfoRelationAttributesFS.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  FrameSet page for relationship attributes from connect wizard


   static const char RCSID[] = $Id: /ENODesignerCentral/CNext/webroot/iefdesigncenter/emxInfoRelationAttributesFS.jsp 1.3.1.4 Thu Jun 26 16:19:42 2008 GMT ds-ymore Experimental$
--%>


<%@include file="emxInfoCentralUtils.inc"%>
<%
    framesetObject fs = new framesetObject();
    fs.setDirectory(appDirectory);

    String initSource = emxGetParameter(request,"initSource");
    if (initSource == null)
    {
	    initSource = "";
	}
    String jsTreeID = emxGetParameter(request,"jsTreeID");
    String suiteKey = emxGetParameter(request,"suiteKey");

// ----------------- Do Not Edit Above ------------------------------
    // Specify URL to come in middle of frameset
    String contentURL = "emxInfoRelationAttributes.jsp";

    String parentOID =emxGetParameter(request,"parentOID");
    fs.setObjectId(parentOID);
    String rowIds[] =emxGetParameterValues(request, "emxTableRowId");
    //Get timeStamp to handle the list of object ids
    String timeStamp = Long.toString(System.currentTimeMillis());
    //Storing objectIds in session
    session.setAttribute("ObjectIds" + timeStamp,rowIds);
  
    String sRelDirection =emxGetParameter(request,"sRelDirection");
    String sRelationName=emxGetParameter(request,"sRelationName");

	//Changes due to emxTable.jsp
	if(sRelationName == null)
	{
		String sRelNameRelDirection = (String)session.getAttribute("sRelNameRelDirection");

		if(sRelNameRelDirection != null)
		{
			String []tokensArray = new String[2];

			int index = sRelNameRelDirection.indexOf("|");
			if(index >= 0)
			{
				sRelationName = sRelNameRelDirection.substring(0, index);
				sRelDirection = sRelNameRelDirection.substring(index + 1);
			}
			session.removeAttribute("sRelNameRelDirection");
		}
	}
	//Changes due to emxTable.jsp
	session.setAttribute("sRelationName" ,sRelationName );//bug fix 277294 [linguistic characters in relationship name]

    // add these parameters to each content URL, and any others the App needs
    contentURL += "?suiteKey=" + suiteKey + "&initSource=" + initSource + "&jsTreeID=" + jsTreeID;
    contentURL += "&parentOID=" + parentOID;
    contentURL += "&sRelDirection="+sRelDirection;
    contentURL += "&sRelationName="+sRelationName;
    contentURL += "&sRelDirection="+sRelDirection;
    contentURL += "&timeStamp=" + timeStamp;
    
    // Page Heading - Internationalized
	String PageHeading = null ;
    // rajeshg - changed for custom relationship addition- 01/09/04
	String sConnect = null;
	sConnect = (String)session.getAttribute("DirectConnect");
	if ( "true".equals(sConnect) )
		PageHeading = "emxIEFDesignCenter.Common.RelationshipDirectAttribute";
	else
	    PageHeading = "emxIEFDesignCenter.Common.RelationshipAttribute";
	// end



    // Marker to pass into Help Pages
    // icon launches new window with help frameset inside
    
    // *** Note: helpmarker is also set in command-object for "connect"    
    String sHelpMarker = emxGetParameter(request, "HelpMarker"); //emxHelpInfoObjectConnectDialogFS

    //(String pageHeading,String sHelpMarker, String middleFrameURL, boolean UsePrinterFriendly, boolean IsDialogPage, boolean ShowPagination, boolean ShowConversion)
    fs.initFrameset(PageHeading,
                  sHelpMarker,
                  contentURL,
                  false,
                  true,
                  false,
                  false);

    fs.setStringResourceFile("emxIEFDesignCenterStringResource");

    String roleList = "role_GlobalUser";

    //(String displayString,String href,String roleList, boolean popup, boolean isJavascript,String iconImage, int WindowSize (1 small - 5 large))
    fs.createFooterLink("emxIEFDesignCenter.Command.Connect",
                      "connect()",
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
