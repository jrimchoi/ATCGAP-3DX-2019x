/*  emxInfoUIModal.js

   Copyright Dassault Systemes, 1992-2007. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program
*/
//=================================================================
// JavaScript Modal Dialog
// Version 1.5
//
//=================================================================
// History
//-----------------------------------------------------------------
// July 3, 2002 (Version 1.5)
// - Fully functional in IE 5.0+ and Netscape 4.x.
// April 5, 2002 (Version 1.5a)
// - Created emxModalDialog class and method wrappers.
// January 15, 2002 (Version 1.1)
// - Removed "popup" target functionality.
// - Added submitList() function for lists.
// June 4, 2001 (Version 1.0)
// - Works in Netscape 4.x and IE 4.0+
//=================================================================

//----------------------------------------------------------------
// 1: CLASS DEFINITION
//----------------------------------------------------------------

//-----------------------------------------------------------------
// Class emxModalDialog
//-----------------------------------------------------------------
// BROWSER(S)
//  Internet Explorer 5.0+
//  Netscape Navigator 4.x
//
// AUTHOR(S)
//  Nicholas C. Zakas (NCZ), 4/5/02
//
// EDITOR(S)
//
// DESCRIPTION
//  This class represents a modal dialog window.
//
// PARAMETERS
//  objParent (window) - the parent window for this dialog.
//  strURL (String) - the URL of the page to display.
//  iWidth (int) - the width of the window.
//  iHeight (int) - the height of the window.
//  bScrollbars (boolean) - do you want scrollbars? (optional)
//-----------------------------------------------------------------
function emxModalDialog(objParent, strURL, iWidth, iHeight, bScrollbars) {

    //---------------------------------------------------------------------------------
    // Properties
    //---------------------------------------------------------------------------------
    this.parentWindow = (isIE ? objParent : objParent.top);  //the parent window of the dialog (NCZ, 4/5/02)
    this.url = strURL;                  //the URL to load in the dialog (NCZ, 4/5/02)
    this.width = iWidth;                //the width of the dialog (NCZ, 4/5/02)
    this.height = iHeight;              //the height of the dialog (NCZ, 4/5/02)
    this.scrollbars = !!bScrollbars;    //if there are scrollbars or not (NCZ, 4/5/02)
    this.contentWindow = null;          //pointer to window once it's opened (NCZ, 4/5/02)
    //---------------------------------------------------------------------------------

    //---------------------------------------------------------------------------------
    // Common Methods
    //---------------------------------------------------------------------------------
    this.show = _emxModalDialog_show;

    if (isIE) {

    //---------------------------------------------------------------------------------
    // IE-Specific Methods
    //---------------------------------------------------------------------------------
    this.captureMouse = _emxModalDialog_captureMouse_IE;
    this.getFeatureString = _emxModalDialog_getFeatureString_IE;
    this.releaseMouse = _emxModalDialog_releaseMouse_IE;
    //---------------------------------------------------------------------------------

    } else {

    //---------------------------------------------------------------------------------
    // Netscape-Specific Methods
    //---------------------------------------------------------------------------------
    this.captureMouse = _emxModalDialog_captureMouse_NS;
    this.getFeatureString = _emxModalDialog_getFeatureString_NS;
    this.releaseMouse = _emxModalDialog_releaseMouse_NS;
    //---------------------------------------------------------------------------------

    }

}

//----------------------------------------------------------------
// 2: CROSS-BROWSER CLASS METHODS
//----------------------------------------------------------------

//-----------------------------------------------------------------
// Method emxModalDialog.show()
//-----------------------------------------------------------------
// BROWSER(S)
//  Internet Explorer 5.0+
//  Netscape Navigator 4.x
//
// AUTHOR(S)
//  Nicholas C. Zakas (NCZ), 4/5/02
//
// EDITOR(S)
//  Nicholas C. Zakas (NCZ), 7/3/02
//
// DESCRIPTION
//  This method shows the modal dialog.
//
// PARAMETERS
//  (none)
//
// RETURNS
//  (nothing)
//-----------------------------------------------------------------
function _emxModalDialog_show() {

    //check to see if there is already a window open (NCZ, 4/5/02)
    if (!this.contentWindow || this.contentWindow.closed) {

        //open the window (NCZ, 4/5/02)
        //this.contentWindow = window.open(this.url, "ModalDialog" + (new Date()).getTime(), this.getFeatureString());
		var windowName = getNewWindowName("ModalDialog" + (new Date()).getTime());
		this.contentWindow = window.open(this.url, windowName, this.getFeatureString());

        //asign this object to the parent window (NCZ, 7/3/02)
        this.parentWindow.top.modalDialog = this;

        //capture the mouse (NCZ, 4/5/02)
        this.captureMouse();

    } //End: if (!this.contentWindow || this.contentWindow.closed)

    //set the focus to the open window (NCZ, 7/3/02)
    this.contentWindow.focus();

}

//DSC Changes Start
function getNewWindowName(windowName)
{
	var integrationFrame = getIntegrationFrame(this);
	if(integrationFrame)
	{
		var isCommandActive = integrationFrame.isDSCCommandActive();
		if(isCommandActive=="true" || isCommandActive==true)
			windowName = "";
	}
	
	return windowName;
}

function getIntegrationFrame(win)
{
		var hldrIntegrationFrame = null;
		var obj = win.getTopWindow();
		if(obj.integrationsFrame != null && obj.integrationsFrame.eiepIntegration != null)
		{
			//Current window has Integration frame.
			hldrIntegrationFrame = obj.integrationsFrame.eiepIntegration;
		}
		else if(obj.opener != null && !obj.opener.closed)
		{
			//Looking in opener...
			hldrIntegrationFrame = getIntegrationFrame(obj.opener);
		}

		return hldrIntegrationFrame;		
}
//DSC Changes End

//----------------------------------------------------------------
// 3: IE-SPECIFIC CLASS METHODS
//----------------------------------------------------------------

//-----------------------------------------------------------------
// Method emxModalDialog.captureMouse()
//-----------------------------------------------------------------
// BROWSER(S)
//  Internet Explorer 5.0+
//
// AUTHOR(S)
//  Nicholas C. Zakas (NCZ), 4/5/02
//
// EDITOR(S)
//  Nicholas C. Zakas (NCZ), 7/3/02
//
// DESCRIPTION
//  This method captures mouse events from the parent window.
//
// PARAMETERS
//  (none)
//
// RETURNS
//  (nothing)
//-----------------------------------------------------------------
function _emxModalDialog_captureMouse_IE() {

    //capture the mouse to the top window (NCZ, 7/3/02)
    captureMouse(top);
}

//-----------------------------------------------------------------
// Method emxModalDialog.getFeatureString()
//-----------------------------------------------------------------
// BROWSER(S)
//  Internet Explorer 5.0+
//
// AUTHOR(S)
//  Nicholas C. Zakas (NCZ), 4/5/02
//
// EDITOR(S)
//
// DESCRIPTION
//  This method constructs the string necessary to use in the window.open() method.
//
// PARAMETERS
//  (none)
//
// RETURNS
//  A string representing the window features.
//-----------------------------------------------------------------
function _emxModalDialog_getFeatureString_IE() {

    //build up features string (NCZ, 4/5/02)
    var strFeatures = "width=" + this.width + ",height=" + this.height + ",resizable=yes";

    //calculate center of the screen (NCZ, 4/5/02)
    var iLeft = parseInt((screen.width - this.width) / 2);
    var iTop = parseInt((screen.height - this.height) / 2);

    //add it to the feature string  (NCZ, 4/5/02)
    strFeatures += ",left=" + iLeft + ",top=" + iTop;

    //are there scrollbars? (NCZ, 4/5/02)
    if (this.scrollbars) strFeatures += ",scrollbars=yes";

    //return the feature string (NCZ, 4/5/02)
    return strFeatures;
}

//-----------------------------------------------------------------
// Method emxModalDialog.releaseMouse()
//-----------------------------------------------------------------
// BROWSER(S)
//  Internet Explorer 5.0+
//
// AUTHOR(S)
//  Nicholas C. Zakas (NCZ), 4/5/02
//
// EDITOR(S)
//  Nicholas C. Zakas (NCZ), 7/3/02
//
// DESCRIPTION
//  This method releases the mouse capture from the parent window.
//
// PARAMETERS
//  (none)
//
// RETURNS
//  (nothing)
//-----------------------------------------------------------------
function _emxModalDialog_releaseMouse_IE() {

    //release the mouse (NCZ, 7/3/02)
    releaseMouse(top);
}

//----------------------------------------------------------------
// 4: NETSCAPE-SPECIFIC CLASS METHODS
//----------------------------------------------------------------

//-----------------------------------------------------------------
// Method emxModalDialog.captureMouse()
//-----------------------------------------------------------------
// BROWSER(S)
//  Netscape Navigator 4.x
//
// AUTHOR(S)
//  Nicholas C. Zakas (NCZ), 4/5/02
//
// EDITOR(S)
//
// DESCRIPTION
//  This method captures mouse events from the parent window.
//
// PARAMETERS
//  (none)
//
// RETURNS
//  (nothing)
//-----------------------------------------------------------------
function _emxModalDialog_captureMouse_NS() {

    //capture the events to the window (NCZ, 4/5/02)
    this.parentWindow.captureEvents(Event.CLICK | Event.MOUSEDOWN | Event.MOUSEUP | Event.FOCUS)

    //assign the event handlers (NCZ, 4/5/02)
    this.parentWindow.onclick = checkFocus;
    this.parentWindow.onmousedown = checkFocus;
    this.parentWindow.onmouseup = checkFocus;
    this.parentWindow.onfocus = checkFocus;
}

//-----------------------------------------------------------------
// Method emxModalDialog.getFeatureString()
//-----------------------------------------------------------------
// BROWSER(S)
//  Netscape Navigator 4.x
//
// AUTHOR(S)
//  Nicholas C. Zakas (NCZ), 4/5/02
//
// EDITOR(S)
//
// DESCRIPTION
//  This method constructs the string necessary to use in the window.open() method.
//
// PARAMETERS
//  (none)
//
// RETURNS
//  A string representing the window features.
//-----------------------------------------------------------------
function _emxModalDialog_getFeatureString_NS() {

    //build up features string (NCZ, 4/5/02)
    var strFeatures = "width=" + this.width + ",height=" + this.height + ",resizable=yes";

    //calculate center of the screen (NCZ, 4/5/02)
    var iLeft = parseInt((screen.width - this.width) / 2);
    var iTop = parseInt((screen.height - this.height) / 2);

    //add it to the feature string  (NCZ, 4/5/02)
    strFeatures += ",screenX=" + iLeft + ",screenY=" + iTop;

    //are there scrollbars? (NCZ, 4/5/02)
    if (this.scrollbars) strFeatures += ",scrollbars=yes";

    //return the feature string (NCZ, 4/5/02)
    return strFeatures;
}

//-----------------------------------------------------------------
// Method emxModalDialog.releaseMouse()
//-----------------------------------------------------------------
// BROWSER(S)
//  Netscape Navigator 4.x
//
// AUTHOR(S)
//  Nicholas C. Zakas (NCZ), 4/5/02
//
// EDITOR(S)
//
// DESCRIPTION
//  This method releases the mouse capture from the parent window.
//
// PARAMETERS
//  (none)
//
// RETURNS
//  (nothing)
//-----------------------------------------------------------------
function _emxModalDialog_releaseMouse_NS() {

    //capture the events to the window (NCZ, 4/5/02)
    this.parentWindow.releaseEvents(Event.CLICK | Event.MOUSEDOWN | Event.MOUSEUP | Event.FOCUS)

    //assign the event handlers (NCZ, 4/5/02)
    this.parentWindow.onclick = null;
    this.parentWindow.onmousedown = null;
    this.parentWindow.onmouseup = null;
    this.parentWindow.onfocus = null;
}

//----------------------------------------------------------------
// 5: FUNCTIONS EXTERNAL TO CLASS
//----------------------------------------------------------------

//-----------------------------------------------------------------
// Function showModalDialog()
//-----------------------------------------------------------------
// BROWSER(S)
//  Internet Explorer 5.0+
//  Netscape Navigator 4.x
//
// AUTHOR(S)
//  Nicholas C. Zakas (NCZ), 6/4/01
//
// EDITOR(S)
//
// DESCRIPTION
//  This function opens a modal dialog window and centers it.
//
// PARAMETERS
//  strURL (String) - the URL of the page to display.
//  iWidth (int) - the width of the window.
//  iHeight (int) - the height of the window.
//  bScrollbars (boolean) - do you want scrollbars?
//
// RETURNS
//  False to stop Netscape from doing anything else.
//-----------------------------------------------------------------
function showModalDialog(strURL, iWidth, iHeight, bScrollbars) {

    //make sure that there isn't a window already open (NCZ, 6/4/01)
	if (!top.modalDialog || top.modalDialog.contentWindow.closed) {

		//create the modal dialog object (NCZ, 7/3/02)
        var objModalDialog = new emxModalDialog(self, strURL, iWidth, iHeight, bScrollbars);

        //show the modal dialog (NCZ, 7/3/02)
        objModalDialog.show();
	} else {
        //if there is already a window open, just bring it to the forefront (NCZ, 6/4/01)
		if (top.modalDialog) top.modalDialog.show();
	}

}

//-----------------------------------------------------------------
// Function checkFocus()
//-----------------------------------------------------------------
// BROWSER(S)
//  Internet Explorer 5.0+
//  Netscape Navigator 4.x
//
// AUTHOR(S)
//  Nicholas C. Zakas (NCZ), 7/3/02
//
// EDITOR(S)
//
// DESCRIPTION
//  This function checks the focus of a modal dialog and ensures
//  that it remains in focus.
//
// PARAMETERS
//  (none)
//
// RETURNS
//  False to prevent Netscape from doing anything else.
//-----------------------------------------------------------------
function checkFocus() {

    //check to see if this window has an open modal dialog (NCZ, 7/3/02)
    if (top.modalDialog && top.modalDialog.contentWindow && !top.modalDialog.contentWindow.closed) {

        //check to see if this modal dialog has its own modal dialog opened (NCZ, 7/3/02)
        if (top.modalDialog.contentWindow.modalDialog && !top.modalDialog.contentWindow.modalDialog.contentWindow.closed) {

            //if this second modal dialog is still open, call checkFocus() on its window (NCZ, 7/3/02)
            top.modalDialog.contentWindow.modalDialog.contentWindow.opener.checkFocus();

        } else {

            //the second modal dialog is closed, so set the focus to the first (NCZ, 7/3/02)
            top.modalDialog.show();

        } //End: if (top.modalDialog.contentWindow.modalDialog && !top.modalDialog.contentWindow.modalDialog.closed)

	} else {

        //if the modal dialog is closed, then release the mouse capture (NCZ, 4/5/02)
        top.modalDialog.releaseMouse();

    }//End: if (top.modalDialog && top.modalDialog.contentWindow && !top.modalDialog.contentWindow.closed)

	//stop Netscape from doing anything else (NCZ, 4/5/02)
	return false;
}

//----------------------------------------------------------------
// 6: IE-SPECIFIC HELPER FUNCTIONS
//----------------------------------------------------------------

//-----------------------------------------------------------------
// Function captureMouse()
//-----------------------------------------------------------------
// BROWSER(S)
//  Internet Explorer 5.0+
//
// AUTHOR(S)
//  Nicholas C. Zakas (NCZ), 6/4/01
//
// EDITOR(S)
//
// DESCRIPTION
//  This function captures mouse actions to the window.
//
// PARAMETERS
//  objWindow (window) - the window to capture.
//
// RETURNS
//  (nothing)
//-----------------------------------------------------------------
function captureMouse(objWindow) {

    //check to see if the window has any frames (NCZ, 7/3/02)
    if (objWindow.frames.length > 0) {

        //if the window has frames, recursively call this function (NCZ, 7/3/02)
        for (var i=0; i < objWindow.frames.length; i++)
            captureMouse(objWindow.frames[i]);

    } else {

        //since the window doesn't have any frames, just capture (NCZ, 7/3/02)
        captureObject(objWindow.document.body);

    } //End: if (objWindow.frames.length > 0)
}

//-----------------------------------------------------------------
// Function captureObject()
//-----------------------------------------------------------------
// BROWSER(S)
//  Internet Explorer 5.0+
//
// AUTHOR(S)
//  Nicholas C. Zakas (NCZ), 6/4/01
//
// EDITOR(S)
//
// DESCRIPTION
//  This function captures mouse actions to the given object for IE.
//
// PARAMETERS
//  objCapture (HTMLElement) - the object to trap mouse actions to.
//
// RETURNS
//  (nothing)
//-----------------------------------------------------------------
function captureObject(objCapture) {

	//capture the events to the document body (NCZ, 6/4/01)
	objCapture.setCapture();

	//assign event handlers (NCZ, 6/4/01)
	objCapture.onclick = checkFocus;
	objCapture.ondblclick = checkFocus;
	objCapture.onmouseover = checkFocus;
	objCapture.onmouseout = checkFocus;
	objCapture.onmousemove = checkFocus;
	objCapture.onmousedown = checkFocus;
	objCapture.onmouseup = checkFocus;
	objCapture.onfocus = checkFocus;
}

//-----------------------------------------------------------------
// Function releaseMouse()
//-----------------------------------------------------------------
// BROWSER(S)
//  Internet Explorer 5.0+
//
// AUTHOR(S)
//  Nicholas C. Zakas (NCZ), 6/4/01
//
// EDITOR(S)
//
// DESCRIPTION
//  This function releases mouse actions from the window.
//
// PARAMETERS
//  objWindow (window) - the window to release capture on.
//
// RETURNS
//  (nothing)
//-----------------------------------------------------------------
function releaseMouse(objWindow) {

    //check to see if the window has any frames (NCZ, 7/3/02)
    if (objWindow.frames.length > 0) {

        //if the window has frames, recursively call this function (NCZ, 7/3/02)
        for (var i=0; i < objWindow.frames.length; i++)
            releaseMouse(objWindow.frames[i]);

    } else {

        //since the window doesn't have any frames, just release (NCZ, 7/3/02)
        releaseObject(objWindow.document.body);

    } //End: if (objWindow.frames.length > 0)
}

//-----------------------------------------------------------------
// Function releaseObject()
//-----------------------------------------------------------------
// BROWSER(S)
//  Internet Explorer 5.0+
//
// AUTHOR(S)
//  Nicholas C. Zakas (NCZ), 6/4/01
//
// EDITOR(S)
//
// DESCRIPTION
//  This function releases mouse actions to the given object for IE.
//
// PARAMETERS
//  objCapture (HTMLElement) - the object that currently has mouse capture.
//
// RETURNS
//  (nothing)
//-----------------------------------------------------------------
function releaseObject(objCapture) {
  if (objCapture != null) {
	  //capture the events to the document body (NCZ, 6/4/01)
	  objCapture.releaseCapture();

	  //assign event handlers (NCZ, 6/4/01)
	  objCapture.onclick = null;
	  objCapture.ondblclick = null;
	  objCapture.onmouseover = null;
	  objCapture.onmouseout = null;
	  objCapture.onmousemove = null;
	  objCapture.onmousedown = null;
	  objCapture.onmouseup = null;
	  objCapture.onfocus = null;
  }
}

//-----------------------------------------------------------------
// 7: COMMON POPUPS (used by all apps)
//-----------------------------------------------------------------

//-----------------------------------------------------------------
// Function showDialog()
//-----------------------------------------------------------------
// AUTHOR(S)
//  Nicholas C. Zakas (NCZ), 7/27/01
//
// EDITOR(S)
//  Nicholas C. Zakas (NCZ), 1/31/02
//
// DESCRIPTION
// This function shows a generic dialog.
//
// PARAMETERS
//  strURL (string) - the URL to display.
//
// RETURNS
//  (nothing)
//-----------------------------------------------------------------
function showDialog(strURL) {

	showModalDialog(strURL, 570, 520);
}

//-----------------------------------------------------------------
// Function showListDialog()
//-----------------------------------------------------------------
// AUTHOR(S)
//  Nicholas C. Zakas (NCZ), 7/27/01
//
// EDITOR(S)
//  Nicholas C. Zakas (NCZ), 1/31/02
//
// DESCRIPTION
// This function shows a generic list dialog.
//
// PARAMETERS
//  strURL (string) - the URL to display.
//
// RETURNS
//  (nothing)
//-----------------------------------------------------------------
function showListDialog(strURL) {
	showModalDialog(strURL, 730, 450);
}

//-----------------------------------------------------------------
// Function showTreeDialog()
//-----------------------------------------------------------------
// AUTHOR(S)
//  Nicholas C. Zakas (NCZ), 7/27/01
//
// EDITOR(S)
//  Nicholas C. Zakas (NCZ), 1/31/02
//
// DESCRIPTION
// This function shows a generic tree dialog.
//
// PARAMETERS
//  strURL (string) - the URL to display.
//
// RETURNS
//  (nothing)
//-----------------------------------------------------------------
function showTreeDialog(strURL) {
	showModalDialog(strURL, 400, 400);
}

//-----------------------------------------------------------------
// Function showWizard()
//-----------------------------------------------------------------
// AUTHOR(S)
//  Nicholas C. Zakas (NCZ), 7/27/01
//
// EDITOR(S)
//  Nicholas C. Zakas (NCZ), 1/31/02
//
// DESCRIPTION
// This function shows a wizard dialog.
//
// PARAMETERS
//  strURL (string) - the URL to display.
//
// RETURNS
//  (nothing)
//-----------------------------------------------------------------
function showWizard(strURL) {
    showModalDialog(strURL, 780, 500);
}

//-----------------------------------------------------------------
// Function showDetailsPopup()
//-----------------------------------------------------------------
// AUTHOR(S)
//  Nicholas C. Zakas (NCZ), 1/22/02
//
// EDITOR(S)
//  Nicholas C. Zakas (NCZ), 1/31/02
//
// DESCRIPTION
// This function shows a details tree in a popup window.
//
// PARAMETERS
//  strURL (string) - the URL to display.
//
// RETURNS
//  (nothing)
//-----------------------------------------------------------------
function showDetailsPopup(strURL) {
	showNonModalDialog(strURL, 875, 550);
}

//-----------------------------------------------------------------
// Function showSearch()
//-----------------------------------------------------------------
// AUTHOR(S)
//  Nicholas C. Zakas (NCZ), 1/22/02
//
// EDITOR(S)
//  Nicholas C. Zakas (NCZ), 1/31/02
//
// DESCRIPTION
// This function shows a search dialog.
//
// PARAMETERS
//  strURL (string) - the URL to display.
//
// RETURNS
//  (nothing)
//-----------------------------------------------------------------
function showSearch(strURL) {
    showNonModalDialog(strURL, 700, 500);
}

//-----------------------------------------------------------------
// Function showChooser()
//-----------------------------------------------------------------
// AUTHOR(S)
//  Nicholas C. Zakas (NCZ), 1/24/02
//
// EDITOR(S)
//  Nicholas C. Zakas (NCZ), 1/31/02
//
// DESCRIPTION
// This function shows a chooser dialog.
//
// PARAMETERS
//  strURL (string) - the URL to display.
//
// RETURNS
//  (nothing)
//-----------------------------------------------------------------
function showChooser(strURL) {
    showModalDialog(strURL, 700, 500);
}

//-----------------------------------------------------------------
// Function showPrinterFriendlyPage()
//-----------------------------------------------------------------
// AUTHOR(S)
//  Nicholas C. Zakas (NCZ), 2/5/02
//
// EDITOR(S)
//
// DESCRIPTION
// This function shows a printer-friendly page.
//
// PARAMETERS
//  strURL (string) - the URL to display.
//
// RETURNS
//  (nothing)
//-----------------------------------------------------------------
function showPrinterFriendlyPage(strURL) {

        // resizable 'fix' for Netscape (guy 06/14/02)
        var strFeatures = "scrollbars=yes,toolbar=yes,location=no";
	if (isIE)
		strFeatures += ",resizable=yes";
	else
		strFeatures += ",resizable=no";

	var winId = window.open(strURL, "PF" + (new Date()).getTime(), strFeatures).focus();

	//register the window in the childWindows array
       	registerChildWindows(winId, top)
}

//-----------------------------------------------------------------
// Function showPopupListPage()
//-----------------------------------------------------------------
// AUTHOR(S)
//  Nicholas C. Zakas (NCZ), 2/26/02
//
// EDITOR(S)
//
// DESCRIPTION
// This function shows a popup list page.
//
// PARAMETERS
//  strURL (string) - the URL to display.
//
// RETURNS
//  (nothing)
//-----------------------------------------------------------------
function showPopupListPage(strURL) {

        // resizable 'fix' for Netscape (guy 06/14/02)
        var strFeatures = "width=700,height=500";
	if (isIE)
		strFeatures += ",resizable=yes";
	else
		strFeatures += ",resizable=no";

	window.open(strURL, "PopupList" + (new Date()).getTime(), strFeatures).focus();
	showNonModalDialog(strURL, 700, 500)
}


//wrapper for showModalDialog
function showModalDetailsPopup(strURL) {
    showModalDialog(strURL, 760,600);
}

//Non-modal window
function showNonModalDialog(strURL, iWidth, iHeight) {
	var strFeatures = "width=" + iWidth + ",height=" + iHeight;

	var winleft = parseInt((screen.width - parseInt(iWidth)) / 2);
	var wintop = parseInt((screen.height - parseInt(iHeight)) / 2);

	// If the URL is using emxTree.jsp, then add the suite directory param
	strURL = addSuiteDirectory(strURL);

        // resizable 'fix' for Netscape (guy 06/14/02)
	if (isIE)
	  strFeatures += ",left=" + winleft + ",top=" + wintop + ",resizable=yes";
	else
	  strFeatures += ",screenX=" + winleft + ",screenY=" + wintop + ",resizable=no";

	var winNonModalDialog = window.open(strURL, "NonModalWindow" + (new Date()).getTime(), strFeatures);

       	//register the window in the childWindows array
       	registerChildWindows(winNonModalDialog, top)

       	//set focus to the dialog
	winNonModalDialog.focus();
}

//Register the child windows
function registerChildWindows(windowObj, topWindowObj)
{
  if ( (topWindowObj.childWindows != null) && (topWindowObj.childWindows != "undefined") )
	{
	       	//store the window in the childWindows array
       		topWindowObj.childWindows[topWindowObj.childWindows.length] = windowObj;

	} else if (topWindowObj.opener!=null && (topWindowObj.opener.top != null) && (topWindowObj.opener.top != "undefined")) {

		var parentTop = topWindowObj.opener.top;
		registerChildWindows(windowObj, parentTop)
	}
}


//Close the child windows
function closeAllChildWindows()
{
    //close all windows that are stored in childWindows

    if (top.childWindows)
    {
        for (var i=0; i < top.childWindows.length; i++)
        {
            if (top.childWindows[i] && !top.childWindows[i].closed)
               top.childWindows[i].close();
        }
    }
}

// Function to add the URL parameter "emxSuiteDirectory" to the URL, if it is "emxTree.jsp?.."
function addSuiteDirectory(url)
{
    var strNewURL = url;

	if (strNewURL.indexOf("emxTree.jsp?") > -1)
	{
  		var loc = document.location.href;
  		var strParam;

  		var sIndex = loc.lastIndexOf("/");
  		loc = loc.substring(0,sIndex);
      	sIndex = loc.lastIndexOf("/");
      	loc = loc.substring(sIndex+1,loc.length);

      	if (loc)
      	{
      	    strParam = "emxSuiteDirectory=" + loc;

        	//check to see if the parameter name is already in the URL, if not
        	//add it to the end
        	if (strNewURL.indexOf("emxSuiteDirectory=") == -1)
            	strNewURL += (strNewURL.indexOf('?') > -1 ? '&' : '?') + strParam;
        }
	}

	return strNewURL;
}


    
