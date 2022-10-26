/*  emxInfoHelpInclude.js

   Copyright Dassault Systemes, 1992-2007. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program
*/
//-----------------------------------------------------------------
// Method openHelp()
// This function opens a window and requests context sensitive help.
//
// Parameters:
//   pageTopic - The Helpmarker to index into page with
//   directory - Directory Pages are under
//   langStr - The language To Use
// Returns:
//  nothing.
//-----------------------------------------------------------------

 var childWindow=null;

 function openHelp(pageTopic, directory, langStr) {

	 directory = directory.toLowerCase();

	 if ((childWindow == null) || (childWindow.closed))
	 {
		 var url = "../doc/" +  directory + "/" + langStr + "/wwhelp/js/html/frames.htm?context=" + directory + "&topic=" + pageTopic;
		 childWindow = window.open(url,"helpwin","location=no,menubar=no,titlebar=no,width=700,height=700,resizable=yes,scrollbars=yes");
		 childWindow.focus();
	 } else {

		 var url = "../doc/" +  directory + "/" + langStr + "/wwhelp/js/html/frames.htm?context=" + directory + "&topic=" + pageTopic;
		 childWindow.location.replace(url);
		 childWindow.focus();
	 }

	 return;
}

//This function is used to open the help from the pages of "infocentral/components" directory
function openComponentsHelp(pageTopic, directory, langStr) {

	 directory = directory.toLowerCase();

	 if ((childWindow == null) || (childWindow.closed))
	 {
		 var url = "../../doc/" +  directory + "/" + langStr + "/wwhelp/js/html/frames.htm?context=" + directory + "&topic=" + pageTopic;
		 childWindow = window.open(url,"helpwin","location=no,menubar=no,titlebar=no,width=700,height=700,resizable=yes,scrollbars=yes");
		 childWindow.focus();
	 } else {

		 var url = "../../doc/" +  directory + "/" + langStr + "/wwhelp/js/html/frames.htm?context=" + directory + "&topic=" + pageTopic;
		 childWindow.location.replace(url);
		 childWindow.focus();
	 }

	 return;
}

function openIEFHelp(pageTopic) 
{
	var url = "../integrations/IEFHelp.jsp?helpMarker=" + pageTopic;

	if ((childWindow == null) || (childWindow.closed))
	{
		childWindow = window.open(url,"helpwin","location=no,menubar=no,titlebar=no,width=700,height=700,resizable=yes,scrollbars=yes");
		childWindow.focus();
	} 
	else 
	{
		childWindow.location.replace(url);
		childWindow.focus();
	}
	return;
}
