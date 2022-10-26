<%--  emxInfoObjectEditDetailsDialogFS.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  emxInfoObjectEditDetailsDialogFS.jsp   -   FS page for Edit Object dialog

  $Archive: /InfoCentral/src/infocentral/emxInfoObjectEditDetailsDialogFS.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$


--%>

<%--
 *
 * $History: emxInfoObjectEditDetailsDialogFS.jsp $
 * 
 * *****************  Version 17  *****************
 * User: Rahulp       Date: 1/14/03    Time: 4:00p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 16  *****************
 * User: Shashikantk  Date: 12/11/02   Time: 6:26p
 * Updated in $/InfoCentral/src/infocentral
 * Set window title as object name
 * 
 * *****************  Version 15  *****************
 * User: Gauravg      Date: 12/04/02   Time: 4:29p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 14  *****************
 * User: Shashikantk  Date: 11/28/02   Time: 11:05a
 * Updated in $/InfoCentral/src/infocentral
 * Object TYPE NAME REVISION in the header
 * 
 * *****************  Version 13  *****************
 * User: Shashikantk  Date: 11/23/02   Time: 5:59p
 * Updated in $/InfoCentral/src/InfoCentral
 * Code cleanup
 * 
 * *****************  Version 12  *****************
 * User: Shashikantk  Date: 11/21/02   Time: 6:56p
 * Updated in $/InfoCentral/src/InfoCentral
 * Removed the space between <%@include file and '='.
 * 
 * ***********************************************
 *
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">

<%@include file="emxInfoCentralUtils.inc"%>			<%--For context, request wrapper methods, i18n methods--%>

<%@ page import="matrix.db.BusinessObject"%><%--This class is required to show the TNR--%>
<!-- content begins here --> 
<%
		String objectId = emxGetParameter(request, "parentOID");	
		framesetObject fs = new framesetObject();
		fs.setDirectory(appDirectory);
		fs.setStringResourceFile("emxIEFDesignCenterStringResource");
		fs.setObjectId(objectId);
// ----------------- Do Not Edit Above ------------------------------

		//Open the current BusinessObject
		BusinessObject boGeneric = new BusinessObject(objectId);
		boGeneric.open(context);

		//Get the TNR of the BusinessObject
		String sType = boGeneric.getTypeName();
		String sName = boGeneric.getName();
		String sRevision = boGeneric.getRevision();
		String sObjectId = boGeneric.getObjectId();
		boGeneric.close(context);
	  
	    //Set window title as object name
	    fs.setPageTitle(sName);

	  	//Specify URL to come in middle of frameset
		String appendParams = emxGetQueryString(request);
		String contentURL = "emxInfoObjectDetailsDialog.jsp";

		//add these parameters to each content URL, and any others the App needs
		contentURL += "?objectId=" + objectId;
		contentURL += "&hasModify=true";
		contentURL += "&" + appendParams;

		String PageHeading = "emxIEFDesignCenter.ObjectDetails.EditDetails";
		//PageHeading += "Edit Details of " + sName;

		//contentURL = Framework.encodeURL(response, contentURL);

		// Marker to pass into Help Pages, icon launches new window with help frameset inside
		String HelpMarker = "featureIEFObjectEditDetails.HelpMarker";

		String roleList = "role_GlobalUser";
		
		//(String pageHeading,String helpMarker, String middleFrameURL, boolean UsePrinterFriendly, boolean IsDialogPage, boolean ShowPagination, boolean ShowConversion)
		fs.initFrameset(PageHeading,
					  HelpMarker,
					  contentURL,
					  false,
					  true,
					  false,
					  false);

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
<!-- content ends here -->
