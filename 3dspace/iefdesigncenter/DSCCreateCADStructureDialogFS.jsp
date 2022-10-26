<%--  DSCCreateCADStructureDialogFS.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  DSCCreateCADStructureDialogFS.jsp   -   FS page for Create CAD Structure dialog

--%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">

<%@include file="emxInfoCentralUtils.inc"%>

<%

	framesetObject fs = new framesetObject();
	fs.setDirectory(appDirectory);

	String jsTreeID		= emxGetParameter(request, "jsTreeID");
	String suiteKey		= emxGetParameter(request, "suiteKey");
	String objectId		= emxGetParameter(request, "objectId");

	String contentURL = "DSCCreateCADStructureDialog.jsp?";

	// add these parameters to each content URL, and any others the App needs
	contentURL += "?suiteKey=" + suiteKey + "&jsTreeID=" + jsTreeID;
	contentURL += "&objectId=" + objectId +"&partId="+objectId;

	String roleList		= "role_GlobalUser";

	fs.initFrameset("emxIEFDesignCenter.CreateCADStructure.CreateCADStructure",
				  "emxhelpdsccreatestructure",
				  contentURL,
				  false,
				  true,
				  false,
				  false);

	fs.setStringResourceFile("emxIEFDesignCenterStringResource");

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

	fs.writePage(out);
%>





