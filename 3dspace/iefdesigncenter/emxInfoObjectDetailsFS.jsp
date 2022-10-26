<%--  emxInfoObjectDetailsFS.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  emxInfoObjectDetailsFS.jsp   -   FS page for ObjectDetails Dialog
  $Archive: /InfoCentral/src/infocentral/emxInfoObjectDetailsFS.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$

Note: [QTP:020913]- This JSP is being used when you navigate to "Derived Output" object's details page. hence restoring this jsp.

--%>

<%@include file= "emxInfoCentralUtils.inc"%>
<%

// ----------------- Do Not Edit Above ------------------------------

	  	//Specify URL to come in middle of frameset
		//String sHelpMarker = emxGetParameter(request, "HelpMarker");
		String sHelpMarker = "emxhelpdscproperties";
		String suiteKey = emxGetParameter(request, "suiteKey");
		String objectId = request.getParameter("objectId");
		String jsTreeID = emxGetParameter(request,"jsTreeID");
		String isTemplateType = request.getParameter("isTemplateType");

		String appendParams = emxGetQueryString(request);
		String contentURL = "emxInfoObjectDetailsDialog.jsp?" + appendParams;

		contentURL += "?objectId=" + objectId +"&jsTreeID=" + jsTreeID +"&suiteKey=" + suiteKey ;
		String PageHeading = "emxIEFDesignCenter.Common.PropertiesPageHeading";
		// Marker to pass into Help Pages, icon launches new window with help frameset inside
		framesetObject fs = new framesetObject();
		fs.setDirectory(appDirectory);
		fs.setStringResourceFile("emxIEFDesignCenterStringResource");
		fs.setObjectId(objectId);

		//(String pageHeading,String helpMarker, String middleFrameURL, boolean UsePrinterFriendly, boolean IsDialogPage, boolean ShowPagination, boolean ShowConversion)
		fs.initFrameset(PageHeading,
					  sHelpMarker,
					  contentURL,
					  true,
					  false,
					  false,
					  false);

		if(isTemplateType!= null && isTemplateType.equalsIgnoreCase("true"))
			fs.setToolbar("MCADModelTemplateObjectDetailsTopActionBarActions");
		//else
			//fs.setToolbar("IEFObjectDetailsTopActionBarActions");
		
		fs.setCategoryTree(emxGetParameter(request,"categoryTreeName"));
		//fs.setTopFrameCommonPage(objectLifecycleHeaderURL);
		//fs.setBottomFrameCommonPage("emxBlank.jsp");
  // ----------------- Do Not Edit Below ------------------------------
		fs.writePage(out);
  %>
